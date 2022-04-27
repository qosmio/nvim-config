local cmd    = vim.cmd
-- local colors = require("colors").get()
local fg     = require('core.utils').fg
local fg_bg  = require('core.utils').fg_bg
local bg     = require('core.utils').bg
local ui     = require('core.utils').load_config().ui
-- local base = require("nvim-base16.lua/lua/themes/onedark-deep-base16.lua)
local bcolor = {
  base00 = '#070a0f',
  base01 = '#1e2532',
  base02 = '#21283b',
  base03 = '#4f5f7e',
  base04 = '#596988',
  base05 = '#6c7d9c',
  base06 = '#b6bdca',
  base07 = '#c8ccd4',
  base08 = '#f65866',
  base09 = '#ea8912',
  base0A = '#ebc275',
  base0B = '#8bcd5b',
  base0C = '#52a0e0',
  base0D = '#41a7fc',
  base0E = '#c678dd',
  base0F = '#f65866'
}

local colors = {
  white         = '#417d9c',
  darker_black  = '#111111',
  black         = '#050505', --  nvim bg
  black2        = '#202734',
  one_bg        = '#142b38', -- real bg of onedark
  one_bg2       = '#1d3441',
  one_bg3       = '#353c49',
  grey          = '#455574',
  grey_fg       = '#4f5f7e',
  grey_fg2      = '#596988',
  grey_bg       = '#0b0f17',
  light_grey    = '#617190',
  red           = '#f65866',
  maroon        = '#420E09',
  baby_pink     = '#e752a6',
  pink          = '#ca2168',
  line          = '#29303d', -- for lines like vertsplit
  green         = '#8bcd5b',
  vibrant_green = '#22ca6c',
  nord_blue     = '#52a0e0',
  blue          = '#41a7fc',
  yellow        = '#e6db74',
  sun           = '#e5c07b',
  purple        = '#d56af5',
  dark_purple   = '#c678dd',
  teal          = '#34bfd0',
  orange        = '#ea8912',
  cyan          = '#56b6c2',
  statusline_bg = '#1e2532',
  lightbg       = '#2f333b',
  lightbg2      = '#292d35',
  pmenu_bg      = '#98c379',
  folder_bg     = '#41a7fc'
}

if ui.transparency then
  fg('TelescopeBorder', '#ABB2BF')
  fg('TelescopePromptBorder', '#ABB2BF')
  fg('TelescopeBorder', '#ABB2BF')
end
cmd('hi DiffChange ctermfg=185 ctermbg=52 guifg=' .. colors.yellow .. ' guibg=' .. colors.maroon)
cmd('hi DiffText cterm=bold ctermbg=9 gui=bold guibg=#41a7fc guifg=#1e2532')
-- fg_bg("Normal", colors.white, colors.grey_bg)
fg('Identifier', colors.vibrant_green)
fg('Function', '#F92782')
fg_bg('MatchParen', colors.grey_bg, colors.red)
fg('jsonKeyword', colors.blue)
fg('javaScriptBraces', colors.blue)
fg('javaScriptBraces', colors.blue)
fg('pythonInclude', '#F92782')
fg('semshiimported', colors.blue)
fg('cTSVariable', '#2f6adb')
fg('makeDefine', '#2f6adb')
fg('makeInclude', colors.pink)
fg('makeComment', colors.light_grey)
cmd('hi PMenu ctermfg=0 ctermbg=11 guifg=' .. bcolor.base0A .. ' guibg=' .. bcolor.base01)
-- fg("Boolean", colors.purple)
fg('jsonTSLabel', '#0256f7')
fg('jsonTSString', colors.vibrant_green)
cmd('hi jsonTSPunctBracket guifg=' .. colors.red .. ' gui=bold cterm=bold')
cmd('hi Boolean guifg=' .. colors.purple .. ' gui=italic cterm=italic')

bg("CmpMenu","#10171f")
bg("CmpSelection","#263341")
fg("CmpItemKindClass","Orange")
fg("CmpItemKindConstructor","#ae43f0")
fg("CmpItemKindFolder","#2986cc")
fg("CmpItemKindFunction","#C586C0")
fg("CmpItemKindKeyword","#f90c71")
fg("CmpItemKindMethod","#C586C0")
fg("CmpItemKindReference","#922b21")
fg("CmpItemKindSnippet","#565c64")
fg("CmpItemKindText","LightGrey")
fg("CmpMenuBorder","#263341")
fg_bg("CmpItemAbbr","#565c64","NONE")
fg_bg("CmpItemAbbrMatch","#569CD6","NONE")
fg_bg("CmpItemAbbrMatchFuzzy","#569CD6","NONE")
fg_bg("CmpItemKindInterface","#f90c71","NONE")
fg_bg("CmpItemKindVariable","#9CDCFE","NONE")
fg_bg("CmpItemMenu","#9C5A56","#56989c")

-- cmd("hi Constant guifg=#AE81FF guibg=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE")
-- cmd("hi Number guifg=#AE81FF guibg=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE")
-- cmd("hi Float guifg=#AE81FF guibg=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE")
-- cmd("hi Boolean guifg=#AE81FF guibg=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE")
-- cmd("hi Type guifg=#66D9EF guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi Structure guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi StorageClass guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi TypeDef guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Identifier guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi Function guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi Statement guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Operator guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Label guifg=#30b2cf guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Quote guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Keyword guifg=#ff00ff guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi Preproc guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi Include guifg=#66D9EF guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi Define guifg=#66D9EF guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi Macro guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi PreCondit guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi Special guifg=#66D9EF guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi SpecialChar guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Delimiter guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Comment guifg=#5F87AF guibg=NONE gui=italic ctermfg=67 ctermbg=NONE cterm=italic")
-- cmd("hi SpecialComment guifg=#66D9EF guibg=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE")
-- cmd("hi Tag guifg=#F92782 guibg=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE")
-- cmd("hi Underlined guifg=#A6E22E guibg=NONE gui=NONE ctermfg=112 ctermbg=NONE cterm=NONE")
-- cmd("hi Ignore guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE")
-- cmd("hi Todo guifg=#F8F8F2 guibg=#000000 gui=bold ctermfg=15 ctermbg=233 cterm=bold")
-- cmd("hi Error fgguifg=#F8F8F2 guibg=#960020 gui=NONE ctermfg=15 ctermbg=88 cterm=NONE")
