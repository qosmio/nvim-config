local map = require("core.utils").map

-- packer
map("n", "<space>pp", ":PackerSync <CR>")
map("n", "<space>pcc", ":PackerCompile <CR>")
map("n", "<space>pc", ":PackerClean <CR>")
map("n", "<space>ps", ":PackerStatus <CR>")
map("n", "<C-t>", ":ToggleAlternate<CR>")
-- map('i','<silent><script><expr> <C-e>','copilot#Accept("\\<CR>")') -- broken

-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
map({ "n", "v" }, "d", '"_d')

-- alternate-toggler (toggle boolean values)
map("n", "<C-t>", ":ToggleAlternate<CR>")

-- Copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

map("i", "<leader><Tab>", 'copilot#Accept("<CR>")', { expr = true })

-- treesitter
-- show highlight mapping for word under cursor
-- map('n', '<C-j>', ':TSHighlightCapturesUnderCursor <CR>')
