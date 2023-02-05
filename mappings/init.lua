function _G.writee(fun, file)
  local m = assert(io.open(file, "wb"))
  if type(fun) == "function" then
    assert(m:write(string.dump(fun)))
  else
    assert(m:write(vim.inspect(fun)))
  end
  assert(m:close())
  vim.notify("wrote " .. type(fun) .. " to " .. file)
end

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
    ["<leader>ll"] = {
      function()
        vim.lsp.buf.format { timeout = 15000 }
      end,
      "Format Code",
    },
  },
  v = {
    ["<leader>ll"] = {
      function()
        vim.lsp.buf.format { timeout = 2000 }
      end,
      "Format Code Range",
    },
  },
}
-- local opts = { silent = true, nowait = true, expr = true }
M.neural = {
  n = {
    ["<leader>."] = {
      "<cmd>NeuralCode<cr>",
      "Run OpenAI Codex Code Completion",
    },
  },
}
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
    ["<leader>ps"] = { "<cmd>Lazy show<cr>", "Status" },
    ["<leader>pp"] = { "<cmd>Lazy sync<cr>", "Sync" },
    ["<leader>pc"] = { "<cmd>Lazy health<cr>", "Health" },
  },
}

M.comment = {
  v = {
    ["<leader>'"] = {
      function()
        require("Comment.api").toggle.blockwise(vim.fn.visualmode())
      end,
      "toggle comment",
    },
  },
}

local J = vim.tbl_deep_extend("force", require("core.mappings").lspconfig, M.lsp)
J.plugin = nil
M.lsp = J
return M
