-- local removePlugins = require "custom.plugins.remove"

local M           = {}

-- make sure you maintain the structure of `core/default_config.lua` here,

M.options = {
  -- general nvim/vim options , check :h optionname to know more about an option

  user = function() require('custom.options') end,

  -- NvChad options
  nvChad         = {
    copy_cut         = true, -- copy cut text ( x key ), visual and normal mode
    copy_del         = false, -- copy deleted text ( dd key ), visual and normal mode
    insert_nav       = true, -- navigation in insertmode
    window_nav       = true,
    terminal_numbers = false,

    -- updater
    update_url       = 'https://github.com/qosmio/NvChad',
    update_branch    = 'main'
  }
}

---- UI -----

M.ui = {
  italic_comments = true,
  theme           = 'onedark-deep',
  hl_override     = require('custom.highlights').override,
  -- Change terminal bg to nvim theme's bg color so it'll match well
  -- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
  transparency    = false
}

---- PLUGIN OPTIONS ----

M.plugins = {
  options                       = {
    packer                 = {init_file = 'plugins.packerInit'},
    autopairs              = {loadAfter = 'nvim-cmp'},
    cmp                    = {lazy_load = true},
    lspconfig              = {
      lazy_load     = true,
      setup_lspconf = 'custom.plugins.lsp' -- path of file containing setups of different lsps
    },
    nvimtree               = {
      -- packerCompile required after changing lazy_load
      lazy_load = true
    },
    -- luasnip                = {snippet_path = {}},
    statusline             = {
      -- hide, show on specific filetypes
      hidden    = {'help', 'NvimTree', 'terminal', 'alpha'},
      -- shown     = {},

      -- truncate statusline on small screens
      shortline = true,
      style     = 'arrow' -- default, round , slant , block , arrow
    },
    esc_insertmode_timeout = 300
  },
  default_plugin_config_replace = {
    ['hrsh7th/nvim-cmp'] =  require('custom.plugins.config.cmp'),
    ['NvChad/nvim-colorizer.lua'] = require('custom.plugins.config.colorizer'),
    ['nvim-treesitter/nvim-treesitter'] = require('custom.plugins.config.treesitter'),
    ['windwp/nvim-autopairs'] = require('custom.plugins.config.autopairs'),
    ['kyazdani42/nvim-tree.lua'] = require('custom.plugins.config.tree')
  },
  user                          = require('custom.plugins')
}

-- Don't use a single keymap twice

return M
