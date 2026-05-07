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

local function select_first()
  require("blink.cmp.completion.list").select(
    1,
    { auto_insert = false, is_explicit_selection = true }
  )
end

local function select_last()
  local list = require "blink.cmp.completion.list"
  list.select(#list.items, { auto_insert = false, is_explicit_selection = true })
end

local function tab_select_next(cmp)
  if cmp.is_visible() then
    local list = require "blink.cmp.completion.list"
    if #list.items == 0 then
      return
    end

    if list.selected_item_idx == #list.items then
      vim.schedule(select_first)
      return true
    end

    return cmp.select_next { auto_insert = false }
  end

  if cmp.snippet_active { direction = 1 } then
    return
  end

  if has_shell_completion_context() then
    return cmp.show { providers = { "zsh" }, initial_selected_item_idx = 1 }
  end

  if zsh_syntax_completion_context() then
    return cmp.show { providers = { "zsh_syntax" }, initial_selected_item_idx = 1 }
  end

  if vim.bo.filetype == "zsh" and has_words_before() then
    return cmp.show { providers = { "zsh" }, initial_selected_item_idx = 1 }
  end

  if has_words_before() then
    return cmp.show { initial_selected_item_idx = 1 }
  end
end

local function tab_select_prev(cmp)
  if cmp.is_visible() then
    local list = require "blink.cmp.completion.list"
    if #list.items == 0 then
      return
    end

    if list.selected_item_idx == nil or list.selected_item_idx == 1 then
      vim.schedule(select_last)
      return true
    end

    return cmp.select_prev { auto_insert = false }
  end

  if cmp.snippet_active { direction = -1 } then
    return
  end
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
        treesitter = { "lsp" },
        columns = {
          { "kind_icon", "label", "label_description", gap = 1 },
          { "kind", "source_name", gap = 1 },
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
    keymap = { preset = "cmdline" },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
}
