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
local status_ok, compare = pcall(require, "cmp.config.compare")
if not status_ok then
  return
end
local options = {
  -- enabled = vim.bo.filetype ~= "python" and true or false,
  window = {
    completion = {
      -- side_padding = 1,
      border = border "FloatBorder",
      -- winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "FloatBorder",
      scrollbar = false,
      -- winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  completion = { keyword_length = 0 },
  performance = { max_view_entries = 20 },
  -- experimental = {
  --   ghost_text = false,
  -- },
  -- matching = {
  --   disallow_fuzzy_matching = false,
  --   disallow_partial_fuzzy_matching = false,
  --   disallow_partial_matching = false,
  --   disallow_prefix_unmatching = true,
  -- },
  -- snippet = {
  --   expand = function(args)
  --     require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
  --   end,
  -- },
  -- sources = {
  --   { name = "nvim_lsp", keyword_length = 0, max_item_count = 5 },
  --   { name = "copilot", keyword_length = 1, max_item_count = 3 },
  --   { name = "buffer", max_item_count = 5, keyword_length = 2 },
  --   { name = "path", max_item_count = 5 },
  --   { name = "luasnip", max_item_count = 3 },
  --   { name = "nvim_lua" },
  -- },
  sources = require("cmp").config.sources({ name = "copilot", group_index = 1, priority = 902 }, {
    {
      name = "luasnip",
      keyword_length = 2,
      priority = 901,
    },
    { name = "nvim_lua", priority = 900 },
    { name = "nvim_lsp", keyword_length = 0, priority = 800 },
    { name = "path", priority = 700 },
  }, {
    { name = "buffer", priority = 800 },
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.length,
      compare.order,
    },
  },
}
local extend = vim.tbl_deep_extend("force", require "nvchad.cmp", options)
-- vim.print(extend)
return extend
