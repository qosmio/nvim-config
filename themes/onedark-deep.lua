local M = {}

M.base_30 = {
  baby_pink = "#f92782",
  black = "#050505",
  black2 = "#202734",
  blue = "#41a7fc",
  cyan = "#5feeaf",
  dark_purple = "#a300d3",
  darker_black = "#111111",
  diff_add = "#27341c",
  diff_change = "#102b40",
  diff_delete = "#331c1e",
  diff_text = "#1c4a6e",
  folder_bg = "#41a7fc",
  green = "#8bcd5b",
  grey = "#455574",
  grey_bg = "#13151a",
  grey_fg = "#647cab",
  grey_fg2 = "#596988",
  light_grey = "#617190",
  lightbg = "#2f333b",
  lightbg2 = "#292d35",
  line = "#29303d",
  maroon = "#420E09",
  nord_blue = "#52a0e0",
  one_bg = "#142b38",
  one_bg2 = "#1d3441",
  one_bg3 = "#353c49",
  orange = "#ea8912",
  pink = "#ca2168",
  pmenu_bg = "#98c379",
  purple = "#ff00de",
  red = "#f65866",
  statusline_bg = "#1e2532",
  sun = "#e5c07b",
  teal = "#34bfd0",
  vibrant_green = "#22ca6c",
  white = "#c8ccd4",
  yellow = "#e6db74",
}

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
  base0E = "#ff00de",
  base0F = "#ff5864",
}

M.type = "dark"

M.polish_hl = {
  luaTSField = { fg = M.base_16.base0D },
  ["@variable"] = { fg = M.base_30.yellow },
  ["@tag.delimiter"] = { fg = M.base_30.cyan, bold = true },
  ["@function"] = { fg = M.base_30.blue },
  ["@parameter"] = { fg = M.base_16.base0F },
  ["@punctuation.bracket"] = { fg = M.base_30.purple, bold = true },
  ["@constructor"] = { fg = M.base_30.purple, bold = true },
  ["@tag.attribute"] = { fg = M.base_30.nord_blue },
  ["@operator"] = { fg = "#6c7d9c" },
  ["@constant"] = { fg = M.base_30.yellow, bold = true },
  ["@boolean"] = { fg = M.base_30.purple, bold = true },
}

return M
