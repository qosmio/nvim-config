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
  -- snippet = {
  --   expand = function(args)
  --     require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
  --   end,
  -- },
  sources = {
    { name = "nvim_lsp", keyword_length = 1, max_item_count = 5 },
    { name = "copilot", keyword_length = 1, max_item_count = 3 },
    { name = "buffer", max_item_count = 5, keyword_length = 2 },
    { name = "path", max_item_count = 5 },
    { name = "luasnip", max_item_count = 3 },
    { name = "nvim_lua" },
  },
  -- sources = sources({ name = "copilot", group_index = 1, priority = 902 }, {
  --   {
  --     name = "luasnip",
  --     keyword_length = 2,
  --     priority = 901,
  --   },
  --   { name = "nvim_lua", priority = 900 },
  --   { name = "nvim_lsp", keyword_length = 0, priority = 800 },
  --   { name = "path", priority = 700 },
  -- }, {
  --   { name = "buffer", priority = 800 },
  -- }),
  sorting = {
    priority_weight = 1,
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
