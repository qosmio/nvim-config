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
  --["numToStr/Comment.nvim"] = require "custom.plugins.config.comment",
}

M.user = {
  -- ["feline-nvim/feline.nvim"] = {
  --   requires = { "nvim-lua/lsp-status.nvim", "nvim-web-devicons" },
  --   config = function()
  --     require "custom.plugins.config.feline"
  --   end,
  -- },
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
  -- ["nvim-lua/lsp-status.nvim"] = { before = { "feline" } },
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
    config = function()
      local map = vim.api.nvim_set_keymap
      -- map("i", "<C-ee>", "copilot#Accept('<CR>')", { expr = true, script = true, silent = true })

      -- map("i", '<C-z>', "copilot#Browser()", { expr = true, script = true, silent = true })

      map("i", "<C-S-z>", "copilot#Next()", { expr = true, script = true, silent = true })
      map("i", "<C-z>", "copilot#Previous()", { expr = true, script = true, silent = true })

      -- nvchad.map("i", "<C-o>", 'copilot#Accept("<CR>")', { expr = true })
      -- Copilot
      map("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      -- vim.g.copilot_no_tab_map = true
      -- vim.g.copilot_assume_mapped = true
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
