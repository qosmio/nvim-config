local use  = function(config)
  if config.ext then
    config = vim.tbl_deep_extend('force', config, config.ext)
    config.ext = nil
  end
  return config
end

local load = function(path)
  require('custom.plugins.config.' .. path)
  local ok, res = pcall(require, 'custom.plugins.config.' .. path)
  if ok then
    return res
  else
    vim.notify('Could not load ' .. path)
    return {}
  end
end

return {
  --  {"zbirenbaum/copilot.lua",
  --   branch = "dev",
  --   event = {"VimEnter"},
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup()
  --     end, 100)
  --   end,
  -- },
  -- {"zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua", "nvim-cmp" },
  -- },
  {'github/copilot.vim', requires = 'hrsh7th/nvim-cmp'},
  -- {'folke/lua-dev.nvim', lspconfig = 'custom.plugins.lsp.servers.sumneko_lua'},
  {'chr4/nginx.vim', ft = 'nginx' },
  use({'folke/which-key.nvim', ext = load('whichkey')}),
  -- { -- stabilize buffer content on window open/close events.
  --    "luukvbaal/stabilize.nvim",
  --    config = function()
  --       local stabilize = require "stabilize"
  --       stabilize.setup {
  --          force = true, -- stabilize window even when current cursor position will be hidden behind new window
  --          forcemark = nil, -- set context mark to register on force event which can be jumped to with '<forcemark>
  --          -- ignore = { -- do not manage windows matching these file/buftypes
  --          --    filetype = { "help", "list", "Trouble" },
  --          --    buftype = { "terminal", "quickfix", "loclist" },
  --          -- },
  --          -- Comma-separated list of autocmds that wil trigger the plugins window restore function
  --          nested = "QuickFixCmdPost,DiagnosticChanged *",
  --       }
  --    end,
  -- },
  { -- Native terminal copying using OCS52
    'ojroques/vim-oscyank'
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    setup  = function()
      require('core.utils').packer_lazy_load('null-ls.nvim')
    end,
    config = function()
      require('custom.plugins.null-ls').setup()
    end
  },
  {
    'williamboman/nvim-lsp-installer',
    -- before = "null-ls.nvim",
    -- lazy_load = true
    config = function()
      require('custom.plugins.lspconfig')
    end
  },
  {'tbastos/vim-lua', ft = 'lua'},
  {'lambdalisue/suda.vim'}
}
