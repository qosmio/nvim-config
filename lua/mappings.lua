require "nvchad.mappings"

local map = vim.keymap.set

local M = {}

local keymaps_table = {}
local modes = { "v", "n", "i", "c" }

local mapExists = function(mode, key, keymaps)
  for _, t in ipairs(keymaps) do
    if t["lhs"] == key and t["mode"] == mode then
      return true
    end
  end

  return false
end

for _, mode in pairs(modes) do
  local global = vim.api.nvim_get_keymap(mode)
  for _, keymap in pairs(global) do
    table.insert(keymaps_table, keymap)
  end
  local buf_local = vim.api.nvim_buf_get_keymap(0, mode)
  for _, keymap in pairs(buf_local) do
    table.insert(keymaps_table, keymap)
  end
end

local disabled = {
  n = { ["sr"] = "", ["sd"] = "" },
  i = {
    -- go to  beginning and end
    ["<C-B>"] = "Move Beginning of line",
    ["<C-E>"] = "Move End of line",
    ["<C-H>"] = "Move Left",
    ["<C-L>"] = "Move Right",
    ["<C-J>"] = "Move Down",
    ["<C-K>"] = "Nove Up",
  },
}

for mode, mappings in pairs(disabled) do
  for key, _ in pairs(mappings) do
    if mapExists(mode, key, keymaps_table) == true then
      -- vim.print(key)
      vim.keymap.del(mode, key)
    end
  end
end

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
          vim.notify(vim.inspect(require("highlights.utils").colors(condition, true)))
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
        vim.lsp.buf.add_workspace_folder()
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

M.copilot = {
  i = {
    ["<C-j>"] = {
      function()
        require("copilot.suggestion").accept()
      end,
      "[copilot] accept suggestion",
    },
    ["<C-k>"] = {
      function()
        require("copilot.suggestion").next()
      end,
      "[copilot] next suggestion",
    },
  },
}

for _, section in pairs(M) do
  for mode, maps in pairs(section) do
    for key, val in pairs(maps) do
      -- if val[1] is a function stringify it and show it as the command
      -- local call = "<cmd>lua"
      -- local desc = val[2] or ""
      -- if type(val[1]) ~= "function" then
      --   call = val[1]
      -- end
      -- vim.print('map("' .. mode .. '", "' .. key .. '", "' .. call .. '", { desc = "' .. desc .. '" })')
      map(mode, key, val[1], { desc = val[2] })
    end
  end
end

-- -- map("v", "<leader>'", "<cmd>lua", { desc = "toggle comment" })
-- -- map("n", "<leader>.", "<cmd>lua", { desc = "toggle blockcomment" })
-- map("n", "<C-t>", "<cmd>ToggleAlternate<cr>", { desc = "Toggle Alternate (true/false 0/1 etc)" })
-- map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer <CR>", { desc = "" })
-- map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk <CR>", { desc = "" })
-- map("n", "<leader>hb", "<cmd>Gitsigns blame_line(true) <CR>", { desc = "" })
-- map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk <CR>", { desc = "" })
-- map("n", "]h", "&diff ? ']h' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", { desc = "" })
-- map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk <CR>", { desc = "" })
-- map("n", "[h", "&diff ? '[h' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", { desc = "" })
-- map("n", "<leader>hU", "<cmd>Gitsigns reset_buffer_index <CR>", { desc = "" })
-- map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer <CR>", { desc = "" })
-- map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk <CR>", { desc = "" })
-- map("v", "<leader>hr", '<cmd>Gitsigns reset_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>', { desc = "" })
-- map("v", "<leader>hs", '<cmd>Gitsigns stage_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>', { desc = "" })
-- -- map("v", "<leader>ll", "<cmd>lua", { desc = "Format Code Range" })
-- -- map("n", "<leader>lt", "<cmd>lua", { desc = "Type Definition" })
-- -- map("n", "<leader>lr", "<cmd>lua", { desc = "Rename" })
-- -- map("n", "<leader>lo", "<cmd>lua", { desc = "Loc List" })
-- -- map("n", "<leader>lw", "<cmd>lua", { desc = "Add Workspace" })
-- -- map("n", "<leader>lk", "<cmd>lua", { desc = "Fix Code" })
-- -- map("n", "<leader>lW", "<cmd>lua", { desc = "List Workspaces" })
-- -- map("n", "<leader>ll", "<cmd>lua", { desc = "Format Code" })
-- map("n", "<leader>kk", "<cmd>MasonUpdateAll<cr>", { desc = "Mason update all installed servers" })
-- map("n", "<leader>uu", "<cmd>NvChadUpdate<cr>", { desc = "Update NvChad" })
-- map("n", "<leader>ps", "<cmd>Lazy show<cr>", { desc = "Status" })
-- map("n", "<leader>pc", "<cmd>Lazy health<cr>", { desc = "Health" })
-- map("n", "<leader>pp", "<cmd>Lazy sync<cr>", { desc = "Sync" })
-- map("v", "x", '"_x', { desc = "" })
-- map("v", "d", '"_d', { desc = "" })
-- map("v", "c", '"_dP', { desc = "" })
-- -- map("n", "<C-x>", "<cmd>lua", { desc = "" })
-- map("n", "x", '"_x', { desc = "" })
-- map("n", "d", '"_d', { desc = "" })
-- map("n", "<C-o>", "<cmd>Inspect<CR>", { desc = " Show Highlight Group" })
-- -- map("i", "<C-j>", "<cmd>lua", { desc = "[copilot] accept suggestion" })
-- -- map("i", "<C-k>", "<cmd>lua", { desc = "[copilot] next suggestion" })
