return {
  ['max397574/better-escape.nvim'] = {disable = true},
  ['goolord/alpha-nvim'] = {disable = true},
  -- ['onsails/lspkind-nvim'] = {},
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
  ["qosmio/filetype.nvim"] = {},
  ['github/copilot.vim'] = {requires = 'hrsh7th/nvim-cmp'},
  -- {'folke/lua-dev.nvim', lspconfig = 'custom.plugins.lsp.servers.sumneko_lua'},
  ['chr4/nginx.vim'] = {ft = 'nginx'},
  ['folke/which-key.nvim'] = {require('custom.plugins.config.whichkey')},
  -- Native terminal copying using OCS52
  ['ojroques/vim-oscyank'] = {},
  ['jose-elias-alvarez/null-ls.nvim'] = {
    setup  = function()
      require('core.utils').packer_lazy_load('null-ls.nvim')
    end,
    config = function()
      require('custom.plugins.config.null_ls').setup()
    end
  },
  ['williamboman/nvim-lsp-installer'] = {
    -- before = "null-ls.nvim",
    -- lazy_load = true
    config = function()
      require('custom.plugins.config.lsp_installer')
    end
  },
  ['tbastos/vim-lua'] = {ft = 'lua'},
  ['lambdalisue/suda.vim'] = {}
}
