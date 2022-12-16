local M = {}

M.base_30 = {
  white = "#6c7d9c",
  darker_black = "#141b28",
  black = "#1a212e", --  nvim bg
  black2 = "#202734",
  one_bg = "#242b38", -- real bg of onedark
  one_bg2 = "#2d3441",
  one_bg3 = "#353c49",
  grey = "#455574",
  grey_fg = "#4f5f7e",
  grey_fg2 = "#596988",
  light_grey = "#617190",
  red = "#f65866",
  baby_pink = "#e06c75",
  pink = "#ff75a0",
  line = "#29303d", -- for lines like vertsplit
  green = "#8bcd5b",
  vibrant_green = "#98c379",
  nord_blue = "#52a0e0",
  blue = "#41a7fc",
  yellow = "#ebc275",
  sun = "#e5c07b",
  purple = "#c678dd",
  dark_purple = "#c678dd",
  teal = "#34bfd0",
  orange = "#ea8912",
  cyan = "#56b6c2",
  statusline_bg = "#1e2532",
  lightbg = "#2f333b",
  pmenu_bg = "#98c379",
  lightbg2 = "#292d35",
  folder_bg = "#41a7fc",
}

local b = {
  baby_pink = "#f92782",
  black = "#050505",
  darker_black = "#111111",
  grey_bg = "#0b0f17",
  maroon = "#420E09",
  one_bg = "#142b38",
  one_bg2 = "#1d3441",
  pink = "#ca2168",
  purple = "#d56af5",
  vibrant_green = "#22ca6c",
  white = "#417d9c",
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
  base0E = "#c678dd",
  base0F = "#ff5864",
}

M.type = "dark"

local diff = { diff_add = "#27341c", diff_delete = "#331c1e", diff_change = "#102b40", diff_text = "#1c4a6e" }

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

M.base_30 = vim.tbl_deep_extend("force", vim.tbl_deep_extend("force", M.base_30, b), diff)

return M
