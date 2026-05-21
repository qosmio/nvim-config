require("plugins.config.blink_highlights").setup()
local completion = require "plugins.config.completion"
local perf = require "plugins.config.perf"

local function default_sources(ctx)
  local sources = {}
  local filetype = (ctx and ctx.filetype) or vim.bo.filetype
  if perf.lua_dev_enabled() then
    sources[#sources + 1] = "lazydev"
  end

  vim.list_extend(sources, { "lsp", "path", "snippets", "buffer" })
  if completion.copilot_completion_enabled() then
    sources[#sources + 1] = "copilot"
  end

  if filetype == "zsh" then
    sources[#sources + 1] = "zsh_syntax"
    sources[#sources + 1] = "zsh"
  end
  return sources
end

local function fuzzy_config()
  if perf.is_slow_host() then
    return {
      implementation = "lua",
      frecency = { enabled = false },
      prebuilt_binaries = { download = false },
    }
  end

  return {
    implementation = "prefer_rust_with_warning",
  }
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function has_shell_completion_context()
  if vim.bo.filetype ~= "zsh" then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end

  local before = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(1, col)
  return before:match "%S" ~= nil and before:match "%s$" ~= nil
end

local function zsh_syntax_completion_context()
  if vim.bo.filetype ~= "zsh" then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end

  local prefix = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(1, col):match "[%w_]+$"
  return prefix and require("plugins.config.zsh_syntax_source").has_prefix(prefix)
end

local function select_item(index, auto_insert)
  require("blink.cmp.completion.list").select(
    index,
    { auto_insert = auto_insert, is_explicit_selection = true }
  )
end

local function select_first(auto_insert)
  select_item(1, auto_insert)
end

local function select_last(auto_insert)
  local list = require "blink.cmp.completion.list"
  select_item(#list.items, auto_insert)
end

local function show_with_preview(cmp, opts)
  opts = opts or {}
  opts.initial_selected_item_idx = opts.initial_selected_item_idx or 1
  local callback = opts.callback
  opts.callback = function()
    select_item(opts.initial_selected_item_idx, true)
    if callback then
      callback()
    end
  end
  return cmp.show(opts)
end

local function select_next_with_preview(cmp)
  local list = require "blink.cmp.completion.list"
  if #list.items == 0 then
    return
  end

  if list.selected_item_idx == #list.items then
    vim.schedule(function()
      select_first(true)
    end)
    return true
  end

  return cmp.select_next { auto_insert = true }
end

local function select_prev_with_preview(cmp)
  local list = require "blink.cmp.completion.list"
  if #list.items == 0 then
    return
  end

  if list.selected_item_idx == nil or list.selected_item_idx == 1 then
    vim.schedule(function()
      select_last(true)
    end)
    return true
  end

  return cmp.select_prev { auto_insert = true }
end

local function tab_select_next(cmp)
  if cmp.is_visible() then
    return select_next_with_preview(cmp)
  end

  if cmp.snippet_active { direction = 1 } then
    return
  end

  if has_shell_completion_context() then
    return show_with_preview(cmp, { providers = { "zsh" } })
  end

  if zsh_syntax_completion_context() then
    return show_with_preview(cmp, { providers = { "zsh_syntax" } })
  end

  if vim.bo.filetype == "zsh" and has_words_before() then
    return show_with_preview(cmp, { providers = { "zsh" } })
  end

  if has_words_before() then
    return show_with_preview(cmp)
  end
end

local function tab_select_prev(cmp)
  if cmp.is_visible() then
    return select_prev_with_preview(cmp)
  end

  if cmp.snippet_active { direction = -1 } then
    return
  end
end

local function cmdline_tab_select_next(cmp)
  if cmp.is_visible() then
    return select_next_with_preview(cmp)
  end

  return show_with_preview(cmp)
end

local function cmdline_tab_select_prev(cmp)
  if cmp.is_visible() then
    return select_prev_with_preview(cmp)
  end

  return show_with_preview(cmp, { initial_selected_item_idx = -1 })
end

return {
  keymap = {
    preset = "enter",
    ["<Tab>"] = { tab_select_next, "snippet_forward", "fallback" },
    ["<S-Tab>"] = { tab_select_prev, "snippet_backward", "fallback" },
    ["<C-d>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  fuzzy = fuzzy_config(),
  completion = {
    accept = {
      auto_brackets = { enabled = false },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "rounded",
        scrollbar = false,
      },
    },
    ghost_text = { enabled = false },
    list = {
      max_items = 20,
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      border = "rounded",
      draw = {
        treesitter = {},
        columns = {
          { "label" },
          { "kind_icon", "kind_without_snippet", gap = 1 },
        },
        components = {
          label = {
            width = { max = 36 },
            text = function(ctx)
              return ctx.label .. ctx.label_detail
            end,
            highlight = function(ctx)
              local label = ctx.label
              local highlights = {
                {
                  0,
                  #label,
                  group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                },
              }
              if ctx.label_detail then
                table.insert(
                  highlights,
                  { #label, #label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                )
              end
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
              end
              return highlights
            end,
          },
          kind_without_snippet = {
            ellipsis = false,
            width = { max = 12 },
            text = function(ctx)
              return ctx.kind == "Snippet" and "" or ctx.kind
            end,
            highlight = function(ctx)
              return ctx.kind_hl
            end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      border = "rounded",
    },
  },
  sources = {
    default = default_sources,
    providers = {
      buffer = {
        max_items = 8,
        min_keyword_length = 3,
        score_offset = -1,
        enabled = function()
          return not perf.is_guarded_buffer(0)
        end,
      },
      copilot = {
        name = "Copilot",
        module = "blink.compat.source",
        min_keyword_length = 0,
        score_offset = 80,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      lsp = {
        fallbacks = {},
      },
      zsh_syntax = {
        name = "zsh syntax",
        module = "plugins.config.zsh_syntax_source",
        score_offset = 35,
      },
      zsh = {
        name = "zsh",
        module = "blink.compat.source",
        score_offset = 30,
        opts = {
          zshrc = false,
          filetypes = { "deoledit", "zsh" },
        },
      },
    },
  },
  cmdline = {
    enabled = true,
    keymap = {
      preset = "cmdline",
      ["<Tab>"] = { cmdline_tab_select_next, "fallback" },
      ["<S-Tab>"] = { cmdline_tab_select_prev, "fallback" },
      ["<CR>"] = { "accept_and_enter", "fallback" },
      ["<C-y>"] = false,
    },
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        auto_show = true,
      },
    },
  },
}
