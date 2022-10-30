-- OPTIONS
local opt = vim.opt

opt.backupdir = "," .. os.getenv "HOME" .. "/.nvim/backup//" -- backup directory
opt.directory = os.getenv "HOME" .. "/.nvim/swap//" -- swap directory
opt.undodir = os.getenv "HOME" .. "/.nvim/undo//" -- for undo
opt.undolevels = 5000 -- default is 1000
opt.diffopt = opt.diffopt:append { "algorithm:patience" } -- algorithm for diff
opt.completeopt = "menu,menuone,preview,noselect" -- default is "menuone,preview"
opt.pumheight = 6 -- number of lines to display in the popup menu
-- opt.spell = true
-- opt.spelllang = { "en_us" } -- languages to use for spell checking
opt.foldmethod = "expr" -- use expression defined in `opt.foldexpr` for folding
-- opt.foldexpr = "nvim_treesitter#foldexpr()" -- fold expression (requires nvim_treesitter)
-- opt.breakindent = true -- indent lines after a break
-- opt.linebreak = true -- break lines after a character
opt.updatetime = 550 -- update the file info every 550ms
opt.timeoutlen = 400 -- timeout length for commands
opt.textwidth = 120 -- text width for the editor
opt.relativenumber = false -- true to show relative line numbers
opt.cursorlineopt = "both" -- number the lines from the cursor

--" Spaces & Tabs {{{
-- opt.expandtab = false
opt.softtabstop = 2 -- number of soft spaces in a tab
opt.tabstop = 4 -- number of spaces in a tab
opt.shiftwidth = 2 -- number of spaces to shift
opt.copyindent = true
--" }}} Spaces & Tabs

-- opt.conceallevel = 3 -- number of concealed characters
opt.switchbuf = "useopen" -- useopen, useall, useallfile, usealltabs
opt.viewoptions = "cursor,folds,slash,unix" -- options for the view
-- vim.cmd "set listchars=tab:╍╍,nbsp:_,trail:·"
opt.scrolloff = 10 -- number of lines to scroll
-- opt.wrap = true -- wrap lines, if possible (not on a terminal)
opt.fixendofline = true -- fix end of line characters
-- vim.opt.characters for after foldtext, eof, foldcolumn
opt.fillchars = "fold: ,foldclose:,foldopen:,foldsep: ,diff: ,eob: "

opt.list = true --> show whitespace characters
-- opt.listchars:append("eol:↲")
-- opt.listchars:append("extends:━━")
opt.listchars:append "nbsp:+"
-- opt.listchars:append("trail:●")
-- opt.listchars:append("extends:≫")
opt.listchars:append "precedes:≪"
opt.listchars:append "tab:»·"
opt.listchars:append "trail:·"
-- MatchUp
vim.g.matchup_matchparen_deferred = 1 -- defer the matchparen highlighting
vim.g.matchup_mappings_enabled = 1 -- enable the mappings
vim.g.matchup_override_vimtex = 1 -- override vimtex

-- Fix common typo commands
vim.cmd "command! -nargs=* W w"
vim.cmd "command! -nargs=* Wq wq"
vim.cmd "command! -nargs=* WQ wq"
vim.cmd "command! -nargs=* Q q"
vim.cmd "command! -nargs=* Qa qa"
vim.cmd "command! -nargs=* QA qa"
vim.cmd "command! -nargs=* Wqa wqa"
vim.cmd "command! -nargs=* WQa wqa"
vim.cmd "command! -nargs=* WQA wqa"

-- Misc
-- vim.g.redrawtime = 500 -- redraw the screen every 500ms

-- Text behaviour
-- opt.formatoptions = opt.formatoptions
--                    - 't'    -- auto-wrap text using textwidth
--                    + 'c'    -- auto-wrap comments using textwidth
--                    + 'r'    -- auto insert comment leader on pressing enter
--                    - 'o'    -- don't insert comment leader on pressing o
--                    + 'q'    -- format comments with gq
--                    - 'a'    -- don't autoformat the paragraphs (use some formatter instead)
--                    + 'n'    -- autoformat numbered list
--                    - '2'    -- I am a programmer and not a writer
--                    + 'j'    -- Join comments smartly
opt.formatoptions = "crqnj"
opt.joinspaces = false

-- Cleanup shadafile
vim.schedule(function()
  opt.shadafile = vim.fn.expand "$HOME" .. "/.local/share/nvim/shada/main.shada"
  vim.cmd [[ silent! rsh ]]
end)

if os.getenv "LC_TERMINAL" == "iTerm2" then
  vim.cmd [[
  let &t_ti.="\<Esc>]1337;HighlightCursorLine=true\x7"
  let &t_te.="\<Esc>]1337;HighlightCursorLine=false\x7"
]]
end
