local map = nvchad.map

-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
map({ "n", "v" }, "d", '"_d')

-- treesitter
-- show highlight mapping for word under cursor
-- map('n', '<C-j>', ':TSHighlightCapturesUnderCursor <CR>')
