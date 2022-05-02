local bcolor = {
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

local colors = {
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
--    fg("Comment", colors.grey)
--    vim.cmd [[colo monokai-phoenix]]
-- end

return {
   Identifier = { fg = colors.vibrant_green },
   Function = { fg = colors.baby_pink },
   MatchParen = { fg = colors.grey_bg, bg = colors.red },
   jsonKeyword = { fg = colors.blue },
   javaScriptBraces = { fg = colors.blue },
   pythonInclude = { fg = "#F92782" },
   semshiimported = { fg = colors.blue },
   cTSVariable = { fg = "#2f6adb" },
   makeDefine = { fg = "#2f6adb" },
   makeInclude = { fg = colors.pink },
   makeComment = { fg = colors.light_grey },
   jsonTSLabel = { fg = "#0256f7" },
   jsonTSString = { fg = colors.vibrant_green },
   CmpMenu = { bg = "#10171f" },
   CmpSelection = { bg = "#263341" },
   CmpItemKindClass = { fg = colors.orange },
   CmpItemKindConstructor = { fg = "#ae43f0" },
   CmpItemKindFolder = { fg = "#2986cc" },
   CmpItemKindFunction = { fg = "#C586C0" },
   CmpItemKindKeyword = { fg = "#f90c71" },
   CmpItemKindMethod = { fg = "#C586C0" },
   CmpItemKindReference = { fg = "#922b21" },
   CmpItemKindSnippet = { fg = "#565c64" },
   CmpItemKindText = { fg = "LightGrey" },
   CmpMenuBorder = { fg = colors.nord_blue },
   -- CmpItemAbbr = { fg = colors.nord_blue, bg = "NONE" },
   CmpItemAbbrMatch = { fg = colors.yellow, bg = "NONE" },
   CmpItemAbbrMatchFuzzy = { fg = colors.yellow, bg = "NONE" },
   CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
   CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
   CmpItemMenu = { fg = "#9C5A56", bg = "#56989c" },

   DiffChange = { bold = true, bg = colors.maroon, fg = colors.yellow },
   DiffText = { ctermbg = 9, bold = true, bg = "#41a7fc", fg = "#1e2532" },
   Boolean = { italic = true, fg = colors.purple },
   jsonTSPunctBracket = { bold = true, fg = colors.red },
   PMenu = { fg = bcolor.base0A, bg = bcolor.base01 },
}
