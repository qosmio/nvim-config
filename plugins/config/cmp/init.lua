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

return {
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  experimental = {
    ghost_text = true,
  },
  sources = {
    {
      name = "nvim_lsp",
      priority = 100,
      group_index = 1,
      -- entry_filter = entry_filter_function,
      -- keyword_length = 2,
      -- max_item_count = 5,
    },
    { name = "nvim_lua", priority = 5, group_index = 1, max_item_count = 5 },
    {
      name = "buffer",
      priority = 50,
      group_index = 1,
      -- entry_filter = entry_filter_function,
      -- keyword_length = 2,
      max_item_count = 5,
    },
    -- { name = "spell", priority = 5, group_index = 1, keyword_length = 3, keyword_pattern = [[\w\+]] },
    -- { name = "calc", priority = 3, group_index = 1, keyword_pattern = [[\d\+\W\{-\}\d]] },
    { name = "path", priority = 10, group_index = 1 },
    { name = "zsh" },
    { name = "luasnip", priority = 30, group_index = 1, max_item_count = 5 },
  },
}
