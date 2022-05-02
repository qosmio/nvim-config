return {
  ["max397574/better-escape.nvim"] = { disable = true },
  ["goolord/alpha-nvim"] = { disable = true },
  -- ["feline-nvim/feline.nvim"] = { disable = true },
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
  ["rmagatti/alternate-toggler"] = {
    setup = function()
      require("core.utils").packer_lazy_load "alternate-toggler"
    end,
  },
  ["reewr/vim-monokai-phoenix"] = {
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
  },
  ["nathom/filetype.nvim"] = {},
  ["github/copilot.vim"] = { requires = "hrsh7th/nvim-cmp" },
  -- ["folke/lua-dev.nvim"] = {
  --   setup = function()
  --     lspconfig = require "custom.plugins.lsp.servers.sumneko_lua"
  --   end,
  -- },
  ["chr4/nginx.vim"] = { ft = "nginx" },
  ["folke/which-key.nvim"] = { require "custom.plugins.config.whichkey" },
  -- Native terminal copying using OCS52
  ["ojroques/vim-oscyank"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
    setup = function()
      require("core.utils").packer_lazy_load "null-ls.nvim"
    end,
    config = function()
      require("custom.plugins.config.null_ls").setup()
    end,
  },
  ["qosmio/nvim-lsp-installer"] = {
    -- before = "null-ls.nvim",
    -- lazy_load = true
    config = function()
      require "custom.plugins.config.lsp_installer"
    end,
  },
  ["tbastos/vim-lua"] = { ft = "lua" },
  ["lambdalisue/suda.vim"] = {},
  ["NvChad/nvim-colorizer.lua"] = {
    event = "BufRead",
    cond = function()
      return vim.env.LC_TERMINAL ~= "shelly"
    end,
    setup = function()
      require("core.utils").packer_lazy_load "nvim-colorizer.lua"
    end,
    config = function()
      require("plugins.configs.others").colorizer()
    end,
  },
}
