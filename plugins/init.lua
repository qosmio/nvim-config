local M = {}
M.user = {
  ["max397574/better-escape.nvim"] = false,
  ["goolord/alpha-nvim"] = false,
  ["nvim-telescope/telescope.nvim"] = false,
  -- ["L3MON4D3/LuaSnip"] = false,
  -- ["saadparwaiz1/cmp_luasnip"] = false,
  ["hrsh7th/nvim-cmp"] = {
    override_options = require "custom.plugins.config.cmp",
  },
  ["NvChad/nvim-colorizer.lua"] = {
    override_options = require "custom.plugins.config.colorizer",
  },
  ["lewis6991/gitsigns.nvim"] = {
    override_options = require "custom.plugins.config.gitsigns",
  },
  ["nvim-treesitter/playground"] = {
    keys = { "gh" },
    event = "InsertEnter",
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    -- requires = { "nvim-treesitter/playground" },
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    override_options = require "custom.plugins.config.treesitter",
    config = function()
      require "custom.plugins.config.treesitter_parsers"
      require "plugins.configs.treesitter"
    end,
  },
  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("custom.plugins.config.comment").setup()
    end,
    setup = function()
      require("core.utils").load_mappings "comment"
    end,
  },
  ["folke/which-key.nvim"] = { disable = false },
  ["williamboman/mason-lspconfig.nvim"] = {
    after = { "mason.nvim", "nvim-lspconfig" },
    setup = function()
      require("core.lazy_load").on_file_open "mason.nvim"
    end,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lsp.installers.pylance"
      require "custom.plugins.lsp.servers"
      require("custom.plugins.lsp.settings")._setup()
      require("mason-lspconfig").setup(require "lsp.lspconfig")
    end,
  },
  ["hrsh7th/cmp-nvim-lua"] = { after = { "nvim-lspconfig", "nvim-cmp" } },
  ["folke/neodev.nvim"] = {
    ft = { "lua" },
  },
  ["rmagatti/alternate-toggler"] = {},
  ["chr4/nginx.vim"] = { ft = "nginx" },
  -- Native terminal copying using OCS52
  ["ojroques/vim-oscyank"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("custom.plugins.config.null_ls").setup()
    end,
  },
  ["lambdalisue/suda.vim"] = { event = {"CmdlineEnter"} },
  ["machakann/vim-sandwich"] = {
    event = "InsertEnter",
  },
  -- Switch between single-line and multiline forms of code
  -- <ESC>gS to split a one-liner into multiple lines
  -- <ESC>gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
  ["AndrewRadev/splitjoin.vim"] = {},
  ["lukas-reineke/cmp-under-comparator"] = { -- make the sorting of completion results smarter
    -- requires = { "hrsh7th/nvim-cmp" },
    after = { "null-ls.nvim", "nvim-cmp" },
    config = function()
      require "custom.plugins.config.cmp.python"
      -- require "custom.plugins.config.cmp.zsh"
    end,
  },
  ["reewr/vim-monokai-phoenix"] = {
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
  },
  ["anuvyklack/pretty-fold.nvim"] = {
    config = function()
      require "custom.plugins.config.pretty_fold"
    end,
  },
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = { after = "null-ls.nvim" }, --  function signature help
  ["tamago324/cmp-zsh"] = {
    ft = { "zsh" },
    setup = function()
      require("core.lazy_load").on_file_open "cmp-zsh"
    end,
    config = {
      filetypes = { "zsh" },
    },
  },
  ["lvimuser/lsp-inlayhints.nvim"] = {},
  ["microsoft/python-type-stubs"] = { opt = true, ft = "python" },
  ["jay-babu/mason-null-ls.nvim"] = {
    after = { "mason.nvim", "null-ls.nvim" },
    config = function()
      local mason_null_ls = require "mason-null-ls"
      mason_null_ls.setup {
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = true,
      }
    end,
  },
  ["ms-jpq/coq_nvim"] = {
    after = { "mason-lspconfig.nvim" },
    branch = "coq",
    requires = {
      "ms-jpq/coq.artifacts",
      "ms-jpq/coq.thirdparty",
    },
  },
  -- ["Maan2003/lsp_lines.nvim"] = {
  --   after = { "nvim-cmp", "nvim-lspconfig" },
  --   config = function()
  --     require("lsp_lines").setup {}
  --     require("lsp_lines").toggle {}
  --     -- require("lsp_lines").setup {}
  --     vim.diagnostic.config {
  --       virtual_text = false,
  --       virtual_lines = {
  --         only_current_line = true,
  --       },
  --     }
  --   end,
  -- },
  -- ["Yagua/nebulous.nvim"] = {
  --   after = { "ui" },
  --   disable = true,
  --   setup = function()
  --     require("core.lazy_load").on_file_open "nebulous.nvim"
  --   end,
  --   config = function()
  --     --Put this lines inside your vimrc to set the colorscheme
  --     require("nebulous").setup {
  --       variant = "twilight",
  --       -- disable = {
  --       --   background = true,
  --       --   endOfBuffer = false,
  --       --   terminal_colors = false,
  --       -- },
  --       italic = {
  --         comments = true,
  --         keywords = false,
  --         functions = false,
  --         variables = true,
  --       },
  --     }
  --   end,
  -- },
}
-- print(vim.inspect(M.user))
return M.user
