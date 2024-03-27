return function(hl_group)
  if hl_group == nil then
    hl_group = "FloatBorder"
  end
  return {
    { "╭", hl_group },
    { "─", hl_group },
    { "╮", hl_group },
    { "│", hl_group },
    { "╯", hl_group },
    { "─", hl_group },
    { "╰", hl_group },
    { "│", hl_group },
  }
end
