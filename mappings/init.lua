local map = require('core.utils').map

-- telescope
map('n', '<space>pp', ':PackerSync <CR>')
map('n', '<space>pcc', ':PackerCompile <CR>')
map('n', '<space>pc', ':PackerClean <CR>')
map('n', '<space>ps', ':PackerStatus <CR>')
-- map('n', '<C-t>', ':TSHighlightCapturesUnderCursor <CR>')
-- map('i','<silent><script><expr> <C-e>','copilot#Accept("\\<CR>")')

vim.cmd([[
let &t_ti.="\<Esc>]1337;HighlightCursorLine=true\x7"
let &t_te.="\<Esc>]1337;HighlightCursorLine=false\x7"
]])

map('n', '<C-t>', ':ToggleAlternate<CR>')
