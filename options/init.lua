local ft  = require('Comment.ft')
ft.set('txt', '#%s')

-- OPTIONS
local opt = vim.opt
opt.backupdir = ',' .. os.getenv('HOME') .. '/.vim/backup//'
opt.directory = os.getenv('HOME') .. '/.vim/swap//'
opt.undodir = os.getenv('HOME') .. '/.vim/undo//'
opt.undolevels = 5000
opt.diffopt = opt.diffopt:append({'algorithm:patience'})
opt.completeopt = 'menu,menuone,preview,noselect'
vim.cmd([[imap <silent><script><expr> <C-e> copilot#Accept('\<CR>')]])
vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
-- MatchUp
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_mappings_enabled = 0
vim.g.matchup_override_vimtex = 1
-- vim.g.redrawtime = 50
