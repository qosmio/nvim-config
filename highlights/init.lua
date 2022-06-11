local M = {}

M.base_16 = {
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

M.base_30 = {
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
  pmenu_bg = "#98c379",
  folder_bg = "#41a7fc",
}

return {
  Visual = { reverse = false, fg = M.base_30.teal },
  Normal = { bg = M.base_30.darker_black },
  Identifier = { fg = M.base_30.pink, bold = true },
  Constant = { fg = M.base_30.yellow, bold = true },
  -- String = { fg = M.base_30.green },
  Keyword = { fg = M.base_30.purple },
  Function = { fg = M.base_30.baby_pink },
  MatchParen = { fg = M.base_30.grey_bg, bg = M.base_30.red },
  jsonKeyword = { fg = M.base_30.blue },
  javaScriptBraces = { fg = M.base_30.blue },
  pythonInclude = { fg = "#F92782" },
  cTSVariable = { fg = "#2f6adb" },
  makeDefine = { fg = "#2f6adb" },
  makeInclude = { fg = M.base_30.pink },
  makeComment = { fg = M.base_30.light_grey },
  jsonTSLabel = { fg = "#0256f7" },
  jsonTSString = { fg = M.base_30.vibrant_green },
  CmpMenu = { bg = "#10171f" },
  CmpSelection = { bg = "#263341" },
  CmpItemKindClass = { fg = M.base_30.orange },
  CmpItemKindConstructor = { fg = "#ae43f0" },
  CmpItemKindFolder = { fg = "#2986cc" },
  CmpItemKindFunction = { fg = "#C586C0" },
  CmpItemKindKeyword = { fg = "#f90c71" },
  CmpItemKindMethod = { fg = "#C586C0" },
  CmpItemKindReference = { fg = "#922b21" },
  CmpItemKindSnippet = { fg = "#565c64" },
  CmpItemKindText = { fg = "LightGrey" },
  CmpMenuBorder = { fg = M.base_30.nord_blue },
  -- CmpItemAbbr = { fg = M.base_30.nord_blue, bg = "NONE" },
  CmpItemAbbrMatch = { fg = M.base_30.yellow, bg = "NONE" },
  CmpItemAbbrMatchFuzzy = { fg = M.base_30.yellow, bg = "NONE" },
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

  -- DiffChange = { bold = true, bg = M.base_30.maroon, fg = M.base_30.yellow },
  -- DiffText = { ctermbg = 9, bold = true, fg = M.base_30.white },
  -- DiffDelete = { bold = true, bg=M.base_30.maroon, fg = M.base_30.baby_pink },
  -- DiffAdd = { bold = true, bg=M.base_30.green },

  Delimiter = { bold = true },
  Boolean = { italic = true, fg = M.base_30.purple },
  jsonTSPunctBracket = { bold = true, fg = M.base_30.red },
  PMenu = { fg = M.base_16.base0A, bg = M.base_16.base01 },
}
