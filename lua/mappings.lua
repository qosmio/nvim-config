require "nvchad.mappings"

local map = vim.keymap.set

local M = {}

local pos_equal = function(p1, p2)
  local r1, c1 = unpack(p1)
  local r2, c2 = unpack(p2)
  return r1 == r2 and c1 == c2
end

-- `direction` can be "next" or "prev", defaults to "next"
-- be able to call vim.diagnostic.get_prev  or vim.diagnostic.get_next dynamically
-- don't duplicate the code
local goto_error_then_hint = function(direction)
  local pos = vim.api.nvim_win_get_cursor(0)
  local opts = { severity = vim.diagnostic.severity.ERROR, wrap = true, count = 1 }

  if direction == "prev" then
    opts.count = -1
  end

  vim.diagnostic.jump(opts)

  local pos2 = vim.api.nvim_win_get_cursor(0)
  if pos_equal(pos, pos2) then
    vim.diagnostic.jump { wrap = true, count = opts.count }
  end
end

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

M.lsp_debug = {
  n = {
    ["]d"] = {
      function()
        goto_error_then_hint "next"
      end,
      "Next Diagnostic",
    },
    ["[d"] = {
      function()
        goto_error_then_hint "prev"
      end,
      "Previous Diagnostic",
    },
    ["ga"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "Code Action",
    },
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "Go to Declaration",
    },
    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "Go to Definition",
    },
    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "Go to Implementation",
    },
    ["gt"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "Type Definition",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "Hover Documentation",
    },
    ["gR"] = {
      function()
        vim.lsp.buf.references()
      end,
      "Show References",
    },
    ["<leader>li"] = { ":LspInfo<CR>", "LSP Info" },
    ["<C-k>"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "Signature Help",
    },
    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add Workspace Folder",
    },
    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove Workspace Folder",
    },
    ["<leader>wl"] = {
      function()
        vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List Workspace Folders",
    },
    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "Set Location List",
    },
  },
  v = {
    ["ga"] = { ":lua vim.lsp.buf.range_code_action()<cr>", "Range Code Action" },
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
    ["<leader>pp"] = { "<cmd>Lazy update<cr>", "Update" },
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

M.diffview = {
  n = {
    ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>", "Open DiffView" },
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

M.copilot_chat = {
  -- lazy.nvim keys

  -- Quick chat with Copilot
  n = {
    ["<leader>ccq"] = {
      function()
        local input = vim.fn.input "Quick Chat: "
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
    },
  },
  v = {
    ["<leader>ccq"] = {
      function()
        local input = vim.fn.input "Quick Chat: "
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
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
