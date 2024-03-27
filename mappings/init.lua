local M = {}
-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
-- map({ "n", "v" }, "d", '"_d')
M.disabled = {
  n = { ["sr"] = "", ["sd"] = "" },
  i = {
    -- go to  beginning and end
    ["<C-b>"] = "Move Beginning of line",
    ["<C-e>"] = "Move End of line",
    ["<C-h>"] = "Move Left",
    ["<C-l>"] = "Move Right",
    ["<C-j>"] = "Move Down",
    ["<C-k>"] = "Nove Up",
  },
}

M.misc = {
  n = {
    ["d"] = { '"_d' },
    ["x"] = { '"_x' },
    ["<C-o>"] = {
      "<cmd>Inspect<CR>",
      " Show Highlight Group",
    },
    ["<C-x>"] = {
      function()
        vim.ui.input({ prompt = "Highlight (pattern): " }, function(condition)
          vim.notify(vim.inspect(require("custom.highlights.utils").colors(condition)))
          -- vim.cmd [[messages]]
        end)
      end,
    },
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
        vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
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
        vim.lsp.buf.rename()
      end,
      "Rename",
    },
    ["<leader>lo"] = {
      function()
        vim.lsp.diagnostic.setloclist {}
      end,
      "Loc List",
    },
    ["<leader>lk"] = {
      function()
        vim.lsp.buf.code_action { apply = true }
      end,
      "Fix Code",
    },
    ["<leader>ll"] = {
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      "Format Code",
    },
  },
  v = {
    ["<leader>ll"] = {
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      "Format Code Range",
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

M.lazy = {
  n = {
    ["<leader>ps"] = { "<cmd>Lazy show<cr>", "Status" },
    ["<leader>pp"] = { "<cmd>Lazy sync<cr>", "Sync" },
    ["<leader>pc"] = { "<cmd>Lazy health<cr>", "Health" },
  },
}

M.comment = {
  n = {
    ["<leader>."] = {
      function()
        require("Comment.api").toggle.blockwise.current()
      end,
      "toggle blockcomment",
    },
  },
  v = {
    ["<leader>'"] = {
      function()
        require("Comment.api").toggle.blockwise(vim.fn.visualmode())
      end,
      "toggle comment",
    },
  },
}

M.mason = {
  n = {
    ["<leader>kk"] = { "<cmd>MasonUpdateAll<cr>", "Mason update all installed servers" },
  },
}

M.nvchad = {
  n = {
    ["<leader>uu"] = { "<cmd>NvChadUpdate<cr>", "Update NvChad" },
  },
}

M.gitsigns = {
  -- Default keymap options
  v = {
    ["<leader>hr"] = { '<cmd>Gitsigns reset_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>' },
    ["<leader>hs"] = { '<cmd>Gitsigns stage_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>' },
  },
  n = {
    ["]h"] = {
      -- expr = true,
      "&diff ? ']h' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
    },
    ["[h"] = {
      -- expr = true,
      "&diff ? '[h' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
    },
    ["<leader>hs"] = { "<cmd>Gitsigns stage_hunk <CR>" },
    ["<leader>hu"] = { "<cmd>Gitsigns undo_stage_hunk <CR>" },
    ["<leader>hr"] = { "<cmd>Gitsigns reset_hunk <CR>" },
    ["<leader>hR"] = { "<cmd>Gitsigns reset_buffer <CR>" },
    ["<leader>hp"] = { "<cmd>Gitsigns preview_hunk <CR>" },
    ["<leader>hb"] = { "<cmd>Gitsigns blame_line(true) <CR>" },
    ["<leader>hS"] = { "<cmd>Gitsigns stage_buffer <CR>" },
    ["<leader>hU"] = { "<cmd>Gitsigns reset_buffer_index <CR>" },
  },
}

local J = vim.tbl_deep_extend("force", require("core.mappings").lspconfig, M.lsp)
J.plugin = nil
M.lsp = J
return M
