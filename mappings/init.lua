local map = require("core.utils").map

-- telescope
map("n", "<space>pp", ":PackerSync <CR>")
map("n", "<space>pcc", ":PackerCompile <CR>")
map("n", "<space>pc", ":PackerClean <CR>")
map("n", "<space>ps", ":PackerStatus <CR>")
map("n", "<C-t>", ":ToggleAlternate<CR>")
-- map('n', '<C-t>', ':TSHighlightCapturesUnderCursor <CR>')
-- map('i','<silent><script><expr> <C-e>','copilot#Accept("\\<CR>")')

-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
map({ "n", "v" }, "d", '"_d')

map("n", "<C-t>", ":ToggleAlternate<CR>")
