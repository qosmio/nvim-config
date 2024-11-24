dofile(vim.g.base46_cache .. "cmp")

local M = {}
local cmp = require "cmp"
local compare = require "cmp.config.compare"

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function get_default_cmp_source()
  return cmp.config.sources({
    { name = "lazydev", group_index = 0 },
    { name = "nvim_lsp" },
    { name = "copilot" },
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "calc" },
    { name = "buffer" },
    { name = "path" },
    {
      name = "treesitter",
    },
  })
end

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local options = {
  enabled = function()
    return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
  end,
  window = {
    completion = {
      border = border "FloatBorder",
    },
    documentation = {
      border = border "FloatBorder",
      scrollbar = false,
    },
  },
  performance = { max_view_entries = 20 },
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = get_default_cmp_source(),
  sorting = {
    priority_weight = 2,
    comparators = {
      -- require "cmp_fuzzy_path.compare",
      -- require "cmp_fuzzy_buffer.compare",
      compare.offset,
      compare.exact,
      compare.score,
      require("cmp-under-comparator").under,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.snippet.active { direction = 1 } then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
}

M.opts = vim.tbl_deep_extend("force", require "nvchad.cmp", options)

M.setup = function()
  cmp.setup.filetype("lua", {
    sources = cmp.config.sources((function()
      local sources = get_default_cmp_source()
      sources[#sources + 1] = { name = "nvim_lua", group_index = 1 }
      return sources
    end)()),
  })

  cmp.setup.filetype("zsh", {
    sources = cmp.config.sources((function()
      local sources = get_default_cmp_source()
      sources[#sources + 1] = { name = "zsh", group_index = 1 }
      return sources
    end)()),
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "cmp_git" },
    }, {
      { name = "buffer" },
    }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "nvim_lsp_document_symbol" },
      { name = "cmdline_history" },
      { name = "buffer" },
      -- { name = "fuzzy_buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "cmdline" },
    }, {
      { name = "cmdline_history" },
      { name = "path" },
      -- { name = "fuzzy_path", option = { fd_timeout_msec = 100 } },
    }),
  })
end

return M
