local M = {}

M.remove = {
  "max397574/better-escape.nvim",
  "goolord/alpha-nvim",
}

M.override = {
  ["hrsh7th/nvim-cmp"] = require "custom.plugins.config.cmp",
  ["NvChad/nvim-colorizer.lua"] = require "custom.plugins.config.colorizer",
  ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.config.treesitter",
  ["windwp/nvim-autopairs"] = require "custom.plugins.config.autopairs",
  ["kyazdani42/nvim-tree.lua"] = require "custom.plugins.config.tree",
  ["qosmio/nvim-lsp-installer"] = require "custom.plugins.config.lsp_installer",
}

M.user = {
  -- ['zbirenbaum/copilot.lua'] = {
  --   branch = 'dev',
  --   event  = {'VimEnter'},
  --   config = function()
  --     vim.defer_fn(function()
  --       require('copilot').setup()
  --     end, 100)
  --   end
  -- },
  -- ['zbirenbaum/copilot-cmp'] = {after = {'copilot.lua', 'nvim-cmp'}},
  ["nvim-treesitter/playground"] = { requires = "nvim-treesitter/nvim-treesitter" },
  ["rmagatti/alternate-toggler"] = { -- (toggle boolean values)
    setup = function()
      nvchad.packer_lazy_load "alternate-toggler"
    end,
    config = function()
      nvchad.map("n", "<C-t>", "<cmd>ToggleAlternate<CR>")
    end,
  },
  ["nathom/filetype.nvim"] = {},
  ["github/copilot.vim"] = {
    requires = "hrsh7th/nvim-cmp",
    after = { "which-key.nvim" },
    cmd = "Copilot",
    event = "InsertEnter",
    setup = function()
      vim.g.copilot_filetypes = {
        TelescopePrompt = false,
      }
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#565f89" })
    end,
    config = function()
      local opts = { script = true, silent = true, nowait = true, expr = true }
      local map = vim.api.nvim_set_keymap
      map("i", "<C-J>", "copilot#Accept('<CR>')", opts)
      map("i", "<C-S-z>", "copilot#Next()", opts)
      map("i", "<C-z>", "copilot#Previous()", opts)
      -- map("i", '<C-z>', "copilot#Browser()", opt)
    end,
  },
  ["folke/lua-dev.nvim"] = {
    setup = function()
      lspconfig = require "custom.plugins.lsp.servers.sumneko_lua"
    end,
  },
  ["chr4/nginx.vim"] = { ft = "nginx" },
  --["folke/which-key.nvim"] = require "custom.plugins.config.whichkey",
  -- Native terminal copying using OCS52
  ["ojroques/vim-oscyank"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
    setup = function()
      nvchad.packer_lazy_load "null-ls.nvim"
    end,
    config = function()
      require("custom.plugins.config.null_ls").setup()
    end,
  },
  ["tbastos/vim-lua"] = { ft = "lua" },
  ["lambdalisue/suda.vim"] = {},
  ["reewr/vim-monokai-phoenix"] = {
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
  },
}

return M
