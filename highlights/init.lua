local M = {}
M.bcolor = {
  base00 = "#070a0f",
  base01 = "#1e2532",
  base02 = "#21283b",
  base03 = "#4f5f7e",
  base04 = "#596988",
  base05 = "#6c7d9c",
  base06 = "#b6bdca",
  base07 = "#c8ccd4",
  base08 = "#f65866",
  base09 = "#ea8912",
  base0A = "#ebc275",
  base0B = "#8bcd5b",
  base0C = "#52a0e0",
  base0D = "#41a7fc",
  base0E = "#c678dd",
  base0F = "#f92782",
}

M.color = {
  white = "#417d9c",
  darker_black = "#111111",
  black = "#050505", --  nvim bg
  black2 = "#202734",
  one_bg = "#142b38", -- real bg of onedark
  one_bg2 = "#1d3441",
  one_bg3 = "#353c49",
  grey = "#455574",
  grey_fg = "#4f5f7e",
  grey_fg2 = "#596988",
  grey_bg = "#0b0f17",
  light_grey = "#617190",
  red = "#f65866",
  maroon = "#420E09",
  baby_pink = "#f92782",
  pink = "#ca2168",
  line = "#29303d", -- for lines like vertsplit
  green = "#8bcd5b",
  vibrant_green = "#22ca6c",
  nord_blue = "#52a0e0",
  blue = "#41a7fc",
  yellow = "#e6db74",
  sun = "#e5c07b",
  purple = "#d56af5",
  dark_purple = "#c678dd",
  teal = "#34bfd0",
  orange = "#ea8912",
  cyan = "#56b6c2",
  statusline_bg = "#1e2532",
  lightbg = "#2f333b",
  lightbg2 = "#292d35",
  pmenu_bg = "#98c379",
  folder_bg = "#41a7fc",
}
-- if os.getenv "TERM" == "putty-256color" then
--    vim.opt.background = "dark"
--    bg("Normal", "NONE")
--    bg("Folded", "NONE")
--    fg("Folded", "NONE")
--    fg("Comment", M.color.grey)
--    vim.cmd [[colo monokai-phoenix]]
-- end

M.override = {
  Visual = { reverse = false, fg = M.color.teal },
  Normal = { bg = M.color.darker_black },
  Identifier = { fg = M.color.pink, bold = true },
  Constant = { fg = M.color.yellow, bold = true },
  -- String = { fg = M.color.green },
  Keyword = { fg = M.color.purple },
  Function = { fg = M.color.baby_pink },
  MatchParen = { fg = M.color.grey_bg, bg = M.color.red },
  jsonKeyword = { fg = M.color.blue },
  javaScriptBraces = { fg = M.color.blue },
  pythonInclude = { fg = "#F92782" },
  cTSVariable = { fg = "#2f6adb" },
  makeDefine = { fg = "#2f6adb" },
  makeInclude = { fg = M.color.pink },
  makeComment = { fg = M.color.light_grey },
  jsonTSLabel = { fg = "#0256f7" },
  jsonTSString = { fg = M.color.vibrant_green },
  CmpMenu = { bg = "#10171f" },
  CmpSelection = { bg = "#263341" },
  CmpItemKindClass = { fg = M.color.orange },
  CmpItemKindConstructor = { fg = "#ae43f0" },
  CmpItemKindFolder = { fg = "#2986cc" },
  CmpItemKindFunction = { fg = "#C586C0" },
  CmpItemKindKeyword = { fg = "#f90c71" },
  CmpItemKindMethod = { fg = "#C586C0" },
  CmpItemKindReference = { fg = "#922b21" },
  CmpItemKindSnippet = { fg = "#565c64" },
  CmpItemKindText = { fg = "LightGrey" },
  CmpMenuBorder = { fg = M.color.nord_blue },
  -- CmpItemAbbr = { fg = M.color.nord_blue, bg = "NONE" },
  CmpItemAbbrMatch = { fg = M.color.yellow, bg = "NONE" },
  CmpItemAbbrMatchFuzzy = { fg = M.color.yellow, bg = "NONE" },
  CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
  CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
  CmpItemMenu = { fg = "#9C5A56", bg = "#56989c" },
  DiffAdd = {
    fg = "#F8F8F8",
    bg = "#253B22",
  },
  DiffDelete = {
    fg = "#F92672",
    bg = "#420E09",
  },
  DiffChange = {
    fg = "#E6DB74",
    bg = "#420E09",
  },
  DiffText = {
    fg = "#75715E",
    bg = "NONE",
  },

  -- DiffChange = { bold = true, bg = M.color.maroon, fg = M.color.yellow },
  -- DiffText = { ctermbg = 9, bold = true, fg = M.color.white },
  -- DiffDelete = { bold = true, bg=M.color.maroon, fg = M.color.baby_pink },
  -- DiffAdd = { bold = true, bg=M.color.green },

  Delimiter = { bold = true },
  Boolean = { italic = true, fg = M.color.purple },
  jsonTSPunctBracket = { bold = true, fg = M.color.red },
  PMenu = { fg = M.bcolor.base0A, bg = M.bcolor.base01 },
}
return M
