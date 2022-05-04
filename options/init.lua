-- OPTIONS
local opt = vim.opt

opt.backupdir = "," .. os.getenv "HOME" .. "/.vim/backup//"
opt.directory = os.getenv "HOME" .. "/.vim/swap//"
opt.undodir = os.getenv "HOME" .. "/.vim/undo//"
opt.undolevels = 5000
opt.diffopt = opt.diffopt:append { "algorithm:patience" }
opt.completeopt = "menu,menuone,preview,noselect"
opt.pumheight = 6

-- opt.spell = true
opt.spelllang = { "en_us" }

-- MatchUp
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_mappings_enabled = 1
vim.g.matchup_override_vimtex = 1

-- Fix common typo commands
--
vim.cmd "command! -nargs=* W w"
vim.cmd "command! -nargs=* Wq wq"
vim.cmd "command! -nargs=* WQ wq"
vim.cmd "command! -nargs=* Q q"
vim.cmd "command! -nargs=* Qa qa"
vim.cmd "command! -nargs=* QA qa"
-- vim.g.redrawtime = 50

if os.getenv "LC_TERMINAL" == "iTerm2" then
  vim.cmd [[
  let &t_ti.="\<Esc>]1337;HighlightCursorLine=true\x7"
  let &t_te.="\<Esc>]1337;HighlightCursorLine=false\x7"
]]
end
