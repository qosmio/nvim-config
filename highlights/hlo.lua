local M = {}

M.cterm_base_30 = {
  baby_pink = 198, -- #ff0087
  black = 16, -- #000000
  black2 = 233, -- #121212
  cyan = 73, -- #5feeaf
  dark_purple = 176, -- #d787d7
  darker_black = 16, -- #000000
  diff_add = 22, -- #005f00
  diff_change = 6, -- #008080
  diff_delete = 52, -- #5f0000
  diff_text = 23, -- #005f5f
  blue = 75, -- #5fafff
  green = 113, -- #87d75f
  grey = 60, -- #5f5f87
  grey_bg = 102, -- #878787
  grey_fg = 60, -- #5f5f87
  grey_fg2 = 60, -- #5f5f87
  light_grey = 60, -- #5f5f87
  lightbg = 23, -- #005f5f
  lightbg2 = 234, -- #1c1c1c
  line = 23, -- #005f5f
  maroon = 52, -- #5f0000
  nord_blue = 74, -- #5fafd7
  one_bg = 233, -- #121212
  one_bg2 = 23, -- #005f5f
  one_bg3 = 59, -- #5f5f5f
  orange = 172, -- #d78700
  pink = 161, -- #d7005f
  pmenu_bg = 114, -- #87d787
  purple = 200, -- #ff00d7
  red = 203, -- #ff5f5f
  statusline_bg = 60, -- #5f5f87
  sun = 190, -- #d7ff00
  teal = 74, -- #5fafd7
  vibrant_green = 41, -- #00d75f
  white = 188, -- #d7d7d7
  yellow = 11, -- #ffff00
}

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

local c = M.base_30

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
  base0C = "#6499ff",
  base0D = "#28b1ff",
  base0E = "#dc14f4",
  base0F = "#ff6464",
}

local c16 = M.base_16

M.type = "dark"

M.polish_hl = {
  luaTSField = { fg = c16.base0D },
  ["@variable"] = { fg = "#F6DB74", bold = true },
  ["@tag.delimiter"] = { fg = c.cyan },
  ["@function"] = { fg = c16.base0D },
  ["@parameter"] = { fg = c16.base0F },
  ["@punctuation.bracket"] = { fg = c.purple, bold = true },
  ["@constructor"] = { fg = c.blue, bold = true },
  ["@tag.attribute"] = { fg = c.orange },
  ["@operator"] = { fg = "#6c7d9c" },
  ["@constant"] = { fg = c.yellow, bold = true },
  ["@boolean"] = { fg = c.purple, bold = true },
}

local syntax = { -- LSP References
  Boolean = { fg = "#c75ae8", bold = true },
  Number = { fg = c16.base06 },
  MasonNormal = { bg = c.darker_black },

  LspReferenceText = { fg = c.darker_black, bg = c.blue },
  LspReferenceRead = { fg = c.darker_black, bg = c.blue },
  LspReferenceWrite = { fg = c.darker_black, bg = c.blue },

  -- Lsp Diagnostics
  DiagnosticHint = { fg = c.purple },
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInformation = { fg = c.green },
  -- DiagnosticUnderlineError = { undercurl = true, sp = c.red },
  -- DiagnosticUnderlineHint = { undercurl = true, sp = c.purple },
  -- DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
  -- DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
  LspSignatureActiveParameter = { fg = c.black, bg = c.green },

  RenamerTitle = { fg = c.black, bg = c.red },
  RenamerBorder = { fg = c.red },
  DevIconDiff = { fg = "#41535b" },

  DiffAdd = { bg = c.diff_add, fg = "#D2EBBE" },
  DiffAdded = { fg = c.vibrant_green },
  DiffRemoved = { fg = c.red },
  DiffChange = { fg = c.diff_change, underline = true, bold = true },
  GitSignsChange = { fg = c.yellow, underline = false, bold = true },
  DiffDelete = { bg = c.diff_delete, fg = "#54292e" },
  DiffText = { bg = c.diff_text, fg = "#8fbfdc" },

  -- DiffChange = { bg = "#102b40", },
  DiffFile = { fg = "#34bfd0" },
  DiffIndexLine = { fg = "#455574" },
  -- DiffText = { ctermbg = 23, bg = "#1c4a6e" },
  -- DiffMdified = {},
  -- DiffChangeDelete = {},
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

  DiagnosticUnderlineError = { bg = "NONE", fg = c.red, sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { bg = "NONE", fg = c.yellow, sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { bg = "NONE", fg = c.yellow, sp = c.yellow, undercurl = true },
  DiagnosticUnderlineHint = { bg = "NONE", fg = c.blue, sp = c.blue, undercurl = true },
  DiagnosticSignError = { fg = c.red },
  DiagnosticSignWarn = { fg = c.yellow },
  DiagnosticSignInfo = { fg = c.yellow },
  DiagnosticSignHint = { fg = c.blue },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.statusline_bg },
  DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.diff_delete },
  DiagnosticVirtualTextInfo = { fg = c.yellow, bg = c.diff_change },
  DiagnosticVirtualTextHint = { fg = c.blue, bg = c.diff_text },
  LspDiagnosticsUnderlineError = { bg = "NONE", fg = c.red, sp = c.red, undercurl = true },
  LspDiagnosticsUnderlineWarning = { bg = "NONE", fg = c.yellow, sp = c.yellow, undercurl = true },
  LspDiagnosticsUnderlineInformation = { bg = "NONE", fg = c.yellow, sp = c.yellow, undercurl = true },
  LspDiagnosticsUnderlineHint = { bg = "NONE", fg = c.blue, sp = c.blue, undercurl = true },
  LspDiagnosticsSignError = { fg = c.red },
  LspDiagnosticsSignWarning = { fg = c.yellow },
  LspDiagnosticsSignInformation = { fg = c.yellow },
  LspDiagnosticsSignHint = { fg = c.blue },
  LspDiagnosticsVirtualTextError = { fg = c.red },
  LspDiagnosticsVirtualTextWarning = { fg = c.yellow },
  LspDiagnosticsVirtualTextInformation = { fg = c.yellow },
  LspDiagnosticsVirtualTextHint = { fg = c.blue },

  FloatBorder = { fg = c.blue, bg = c.grey_bg, bold = true },
  NormalFloat = { bg = c.grey_bg },

  Pmenu = { bg = c.black, fg = c.nord_blue },
  PmenuSbar = { bg = c.black },
  PmenuSel = { bg = c.green, fg = c.black },
  PmenuThumb = { bg = c.grey },
  CmpMenuBorder = { bg = "NONE", fg = c.nord_blue },
  CmpPmenu = { bg = c.black },
  CmpMenu = { bg = c.black, fg = c16.green },
  CmpSelection = { bg = "#263341" },
  CmpItemKindClass = { fg = c.orange },
  CmpItemKindConstructor = { fg = "#ae43f0" },
  CmpItemKindFolder = { fg = "#2986cc" },
  CmpItemKindFunction = { fg = "#f90c71", bold = true },
  CmpItemKindKeyword = { fg = "#f90c71" },
  CmpItemKindMethod = { fg = "#C586C0" },
  CmpItemKindReference = { fg = "#922b21" },
  CmpItemKindSnippet = { fg = "#565c64" },
  CmpItemKindText = { fg = "LightGrey" },
  CmpItemAbbr = { fg = c.nord_blue, bg = "NONE" },
  CmpItemAbbrMatch = { fg = c.yellow, bold = true, bg = "NONE" },
  CmpItemAbbrMatchFuzzy = { fg = "White", bg = "NONE" },
  CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
  CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
  CmpItemMenu = { fg = "#ffffff" },
  IndentBlankLineChar = { ctermfg = 237 },

  gitconfigSection = { fg = c.green, bold = true, ctermfg = 181 },

  Keyword = { fg = "#dd1df4", bold = true },
  Define = { bold = true },
  -- Search = { bg = c.yellow, reverse = true },
  -- CurSearch = { bg = c.nord_blue, fg = c.white },
  Conditional = { bold = true },
  zshOptStart = { fg = c.cyan, bold = false, nocombine = true },
  zshCasePattern = { fg = c.orange },
  zshParentheses = { nocombine = true, fg = c.yellow },
  zshFunction = { fg = c.vibrant_green, bold = true },
  zshDeref = { fg = c.red },
  zshCase = { fg = "#294cfd" },
  zshVariableDef = { fg = c.nord_blue, bold = true },
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
_G.colors = hl.theme.base_30

return hl
