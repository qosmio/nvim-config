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

local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  return
end

local compare = require "cmp.config.compare"

return {
  -- enabled = vim.bo.filetype ~= "python" and true or false,
  window = {
    completion = {
      side_padding = 1,
      border = border "FloatBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "FloatBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  experimental = {
    ghost_text = true,
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  sources = cmp.config.sources({ name = "codeium" }, {
    {
      name = "luasnip",
      keyword_length = 2,
      -- trigger_characters = { "s", "n" },
      -- Keyword_pattern = "sn",
      priority = 1000,
    },
    { name = "nvim_lua", priority = 900 },
    { name = "nvim_lsp", keyword_length = 0, priority = 800 },
    { name = "path", priority = 700 },
  }, {
    { name = "buffer", priority = 800 },
    { name = "rg", priority = 700 },
  }, {
    { name = "spell", priority = 600 },
    { name = "rime", priority = 600 },
  }),
  sorting = {
    priority_weight = 1,
    -- rime-ls
    comparators = {
      compare.sort_test,
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.length,
      compare.order,
    },
  },
}
