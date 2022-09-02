local M = {}
-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
-- map({ "n", "v" }, "d", '"_d')
M.disabled = {
  n = { ["sr"] = "", ["sd"] = "" },
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
    ["d"] = { '"_d' },
    ["x"] = { '"_x' },
    ["<C-o>"] = { "<cmd> TSHighlightCapturesUnderCursor <CR>", " Show Highlight Group" },
  },
  v = {
    ["d"] = { '"_d' },
    ["x"] = { '"_x' },
    ["c"] = { '"_dP' },
  },
}

M.lsp = {
  n = {
    ["<leader>lw"] = {
      function()
        vim.lsp.buf.add_workspace_folder {}
      end,
      "Add Workspace",
    },
    ["<leader>lW"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List Workspaces",
    },
    ["<leader>lt"] = {
      function()
        vim.lsp.buf.type_definition {}
      end,
      "Type Definition",
    },
    ["<leader>lr"] = {
      function()
        vim.lsp.buf.rename {}
      end,
      "Rename",
    },
    ["<leader>lo"] = {
      function()
        vim.lsp.diagnostic.setloclist {}
      end,
      "Loc List",
    },
    ["<leader>ll"] = {
      function()
        vim.lsp.buf.format {}
      end,
      "Format code",
    },
    ["<leader>lk"] = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
      end,
      "Format code",
    },
  },
}
local opts = { silent = true, nowait = true, expr = true }

-- M.copilot = {
--   i = {
--     ["<C-j>"] = {
--       "copilot#Accept()",
--       "Accept",
--       opts = opts,
--     },
--     ["<C-k>"] = {
--       "copilot#Next()",
--       "Next",
--       opts = opts,
--     },
--     ["<C-z>"] = {
--       "Copilot#Previous()",
--       "Previous",
--       opts = opts,
--     },
--   },
-- }

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
    ["<leader>ps"] = { "<cmd>PackerStatus<cr>", "Status" },
    ["<leader>pp"] = { "<cmd>PackerSync<cr>", "Sync" },
    ["<leader>pi"] = { "<cmd>PackerInstall<cr>", "Install" },
    ["<leader>pc"] = { "<cmd>PackerCompile<cr>", "Compile" },
    ["<leader>pl"] = { "<cmd>PackerClean<cr>", "Clean" },
  },
}
return M
