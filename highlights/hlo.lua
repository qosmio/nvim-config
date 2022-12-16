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
  grey_bg = "#0a0f16",
  maroon = "#420E09",
  one_bg = "#142b38",
  one_bg2 = "#1d3441",
  pink = "#ca2168",
  purple = "#d56af5",
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
  base0E = "#c678dd",
  base0F = "#f65866",
}

M.type = "dark"

local deep = { diff_add = "#27341c", diff_delete = "#331c1e", diff_change = "#102b40", diff_text = "#1c4a6e" }

M.base_30 = vim.tbl_deep_extend("force", vim.tbl_deep_extend("force", M.base_30, b), deep)

M.polish_hl = {
  luaTSField = { fg = M.base_16.base0D },
  ["@variable"] = { fg = "#F6DB74", bold = true },
  ["@tag.delimiter"] = { fg = M.base_30.cyan },
  ["@function"] = { fg = M.base_16.base0D },
  ["@parameter"] = { fg = M.base_16.base0F },
  ["@punctuation.bracket"] = { fg = M.base_30.purple, bold = true },
  ["@constructor"] = { fg = M.base_30.folder_bg, bold = true },
  ["@tag.attribute"] = { fg = M.base_30.orange },
  ["@operator"] = { fg = "#6c7d9c" },
  ["@constant"] = { fg = M.base_30.yellow, bold = true },
  ["@boolean"] = { fg = M.base_30.purple, bold = true },
}

local syntax = { -- LSP References
  Boolean = { fg = "#c75ae8", bold = true },
  Number = { fg = M.base_30.blue },
  MasonNormal = { bg = M.base_30.darker_black },

  LspReferenceText = { fg = M.base_30.darker_black, bg = "#6c7d9c" },
  LspReferenceRead = { fg = M.base_30.darker_black, bg = "#6c7d9c" },
  LspReferenceWrite = { fg = M.base_30.darker_black, bg = "#6c7d9c" },

  -- Lsp Diagnostics
  DiagnosticHint = { fg = M.base_30.purple },
  DiagnosticError = { fg = M.base_30.red },
  DiagnosticWarn = { fg = M.base_30.yellow },
  DiagnosticInformation = { fg = M.base_30.green },
  DiagnosticUnderlineError = { undercurl = true, sp = M.base_30.red },
  DiagnosticUnderlineHint = { undercurl = true, sp = M.base_30.purple },
  DiagnosticUnderlineInfo = { undercurl = true, sp = M.base_30.blue },
  DiagnosticUnderlineWarn = { undercurl = true, sp = M.base_30.yellow },
  LspSignatureActiveParameter = { fg = M.base_30.black, bg = M.base_30.green },

  RenamerTitle = { fg = M.base_30.black, bg = M.base_30.red },
  RenamerBorder = { fg = M.base_30.red },
  DevIconDiff = { fg = "#41535b" },
  DiffAdd = { bg = "#1F2A17" },
  DiffAdded = { fg = "#8bcd5b" },
  -- DiffChange = { bg = "#102b40", },
  -- DiffChangeDelete = {},
  DiffDelete = { bg = "#331c1e" },
  DiffFile = { fg = "#34bfd0" },
  DiffIndexLine = { fg = "#455574" },
  -- DiffModified = {},
  DiffRemoved = { fg = "#f65866" },
  DiffText = { ctermbg = 23, bg = "#1c4a6e" },
  DiffviewCursorLine = { bg = "#21283b" },
  DiffviewEndOfBuffer = { bg = "#1a212e", fg = "#1a212e" },
  DiffviewFilePanelCounter = { fg = "#c75ae8", bold = true },
  DiffviewFilePanelDeletions = { fg = "#f65866" },
  DiffviewFilePanelFileName = { fg = "#93a4c3" },
  DiffviewFilePanelInsertions = { fg = "#8bcd5b" },
  DiffviewFilePanelPath = { fg = "#455574" },
  DiffviewFilePanelRootPath = { fg = "#455574" },
  DiffviewFilePanelTitle = { fg = "#41a7fc", bold = true },
  DiffviewNormal = { bg = "#1a212e", fg = "#93a4c3" },
  DiffviewSignColumn = { bg = "#1a212e", fg = "#93a4c3" },
  DiffviewStatusAdded = { fg = "#8bcd5b" },
  DiffviewStatusBroken = { fg = "#f65866" },
  DiffviewStatusCopied = { fg = "#41a7fc" },
  DiffviewStatusDeleted = { fg = "#f65866" },
  DiffviewStatusLine = { bg = "#283347", fg = "#93a4c3" },
  DiffviewStatusLineNC = { bg = "#21283b", fg = "#455574" },
  DiffviewStatusModified = { fg = "#41a7fc" },
  DiffviewStatusRenamed = { fg = "#41a7fc" },
  DiffviewStatusTypeChange = { fg = "#41a7fc" },
  DiffviewStatusUnknown = { fg = "#f65866" },
  DiffviewStatusUnmerged = { fg = "#41a7fc" },
  DiffviewStatusUntracked = { fg = "#41a7fc" },
  DiffviewVertSplit = { fg = "#2a324a" },

  FloatBorder = { fg = M.base_30.blue, bg = M.base_30.grey_bg, bold = true },
  NormalFloat = { bg = M.base_30.grey_bg },

  Pmenu = { bg = M.base_30.black, fg = M.base_30.nord_blue },
  PmenuSbar = { bg = M.base_30.black },
  PmenuSel = { bg = M.base_30.green, fg = M.base_30.black },
  PmenuThumb = { bg = M.base_30.grey },
  CmpMenuBorder = { bg = "NONE", fg = M.base_30.nord_blue },
  CmpPmenu = { bg = M.base_30.black },
  CmpMenu = { bg = M.base_30.black, fg = M.base_16.green },
  CmpSelection = { bg = "#263341" },
  CmpItemKindClass = { fg = M.base_30.orange },
  CmpItemKindConstructor = { fg = "#ae43f0" },
  CmpItemKindFolder = { fg = "#2986cc" },
  CmpItemKindFunction = { fg = "#f90c71", bold = true },
  CmpItemKindKeyword = { fg = "#f90c71" },
  CmpItemKindMethod = { fg = "#C586C0" },
  CmpItemKindReference = { fg = "#922b21" },
  CmpItemKindSnippet = { fg = "#565c64" },
  CmpItemKindText = { fg = "LightGrey" },
  CmpItemAbbr = { fg = M.base_30.nord_blue, bg = "NONE" },
  CmpItemAbbrMatch = { fg = M.base_30.yellow, bold = true, bg = "NONE" },
  CmpItemAbbrMatchFuzzy = { fg = "White", bg = "NONE" },
  CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
  CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
  CmpItemMenu = { fg = "#9C5A56", bg = "#56989c" },
  IndentBlankLineChar = { ctermfg = 237 },
}
local statusline = {
  IndentBlankLineChar = { ctermfg = 237 },
  DiffText = { ctermbg = 23 },
  -- Statusline
  StText = {
    ctermbg = 234,
    ctermfg = 252,
  },
  St_CommandMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 154,
  },
  St_ConfirmMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 156,
  },
  St_InsertMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 171,
  },
  St_LspHints = {
    ctermbg = 234,
    bold = true,
    ctermfg = 171,
  },
  St_LspInfo = {
    ctermbg = 234,
    bold = true,
    ctermfg = 154,
  },
  St_LspProgress = {
    ctermbg = 234,
    ctermfg = 162,
  },
  St_LspStatus = {
    ctermbg = 234,
    ctermfg = 154,
  },
  St_NTerminalMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 11,
  },
  St_NormalMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 147,
  },
  St_ReplaceMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 208,
  },
  St_SelectMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 147,
  },
  St_TerminalMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 154,
  },
  St_VisualMode = {
    ctermbg = 232,
    bold = true,
    ctermfg = 45,
  },
  St_cwd = {
    ctermbg = 232,
    ctermfg = 162,
  },
  St_encode = {
    ctermbg = 234,
    ctermfg = 214,
  },
  St_ft = {
    ctermbg = 234,
    ctermfg = 147,
  },
  St_lspError = {
    ctermbg = 234,
    bold = true,
    ctermfg = 162,
  },
  St_lspWarning = {
    ctermbg = 234,
    bold = true,
    ctermfg = 11,
  },
  StatusLine = {
    ctermbg = 234,
    ctermfg = 252,
  },
}
--echo $HOME/.config/nvim/lua/?.lua;/usr/share/nvim/runtime/lua/?.lua; .. package.path
local highlight = require("custom.highlights.utils").gui_syntax_to_cterm(syntax)
-- print(vim.inspect(highlight))
-- require("custom.highlights.utils").nvim_set_hl(highlight)
for k, _ in pairs(highlight) do
  -- local cterm = {}
  -- if highlight[k].ctermbg ~= nil then
  --   cterm["ctermbg"] = highlight[k].ctermbg
  -- end
  -- if highlight[k].ctermfg ~= nil then
  --   cterm["ctermfg"] = highlight[k].ctermfg
  -- end
  -- -- return require("custom.highlights.utils").nvim_set_hl(syntax)
  -- vim.api.nvim_set_hl(0, k, { cterm })
  -- ("hi " .. k .. " ctermbg=" .. highlight[k].ctermbg .. " ctermfg=" .. highlight[k].ctermfg)
  highlight[k].ctermbg = nil
  highlight[k].ctermfg = nil
end
-- print(vim.inspect(M))
-- M.highlight = highlight
local hl = {}
hl.statusline = statusline
hl.theme = M
hl.highlight = highlight
-- M.theme.highlight = nil
-- print(vim.inspect(hl))
return hl
