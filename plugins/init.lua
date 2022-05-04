return {
  ["max397574/better-escape.nvim"] = { disable = true },
  ["goolord/alpha-nvim"] = { disable = true },
  ["hrsh7th/nvim-cmp"] = {
      requires = {
        { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
        { "hrsh7th/cmp-buffer", after = "cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp", after = "cmp-buffer" },
        { "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
        { "hrsh7th/cmp-path", after = "cmp-nvim-lua" },
        { "f3fora/cmp-spell", after = "cmp-path" },
      },
  },
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
  -- ["qosmio/nvim-lsp-installer"] = {},
  -- before = "null-ls.nvim",
  -- lazy_load = true
  -- setup = function()
  --   require "custom.plugins.config.lsp_installer"
  -- end,
  ["tbastos/vim-lua"] = { ft = "lua" },
  ["lambdalisue/suda.vim"] = {},
  -- ["f3fora/cmp-spell"] = { after = 'cmp-path', setup = function() sources = { { name = "spell" }, } end },
}
