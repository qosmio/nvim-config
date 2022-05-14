local M = {}
-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
-- map({ "n", "v" }, "d", '"_d')
M.misc = {
  -- toggle comment in both modes
  n = {
    ["d"] = { '"_d', "蘒  delete" },
    ["<C-o>"] = { "<cmd> TSHighlightCapturesUnderCursor <CR>", " Show Highlight Group" },
  },
  v = {
    ["d"] = { '"_d', "蘒  delete" },
  },
}

M.lsp = {
  n = {
    ["<leader>l"] = {
      name = "LSP",
      w = {
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        "Add Workspace",
      },
      -- r={'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',"Remove Workspace"},
      l = {
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        "List Workspaces",
      },
      t = {
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        "Type Definition",
      },
      r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
      o = {
        "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
        "Loc List",
      },
      f = {
        "<cmd>lua vim.lsp.buf.format()<CR>",
        "Format",
      },
    },
  },
}
-- M.copilot = {
--   i = {
--     ["<C-,>"] = {
--       '<cmd> copilot#Accept("<CR>")',
--       { expr = true },
--     },
--   },
-- }

M.packer = {
  n = {
    ["<leader>p"] = {
      name = "Packer",
      s = { "<cmd>PackerStatus<cr>", "Status" },
      p = { "<cmd>PackerSync<cr>", "Sync" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      l = { "<cmd>PackerClean<cr>", "Clean" },
    },
  },
}

return M
-- treesitter
-- show highlight mapping for word under cursor
-- map('n', '<C-j>', ':TSHighlightCapturesUnderCursor <CR>')
