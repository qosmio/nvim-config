local M = {}
-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
-- map({ "n", "v" }, "d", '"_d')
M.disabled = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = "",
    ["<C-e>"] = "",
    -- navigate within insert mode
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },
}

M.misc = {
  n = {
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
      W = {
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
      l = {
        "<cmd>lua vim.lsp.buf.format() <CR>",
        "Format",
      },
    },
  },
}
local opts = { silent = true, nowait = true, expr = true }

M.copilot = {
  i = {
    ["<C-j>"] = {
      "copilot#Accept()",
      "Accept",
      opts = opts,
    },
    ["<C-k>"] = {
      "copilot#Next()",
      "Next",
      opts = opts,
    },
    ["<C-z>"] = {
      "Copilot#Previous()",
      "Previous",
      opts = opts,
    },
  },
}
M.toggle_alternate = {
  n = {
    ["<C-t>"] = {
      "<cmd>ToggleAlternate<cr>",
      "Toggle Alternate (true/false 0/1 etc)",
    },
  },
}

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
