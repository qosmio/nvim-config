local M = {}

M.user = {
  ["max397574/better-escape.nvim"] = false,
  ["goolord/alpha-nvim"] = false,
  ["williamboman/mason"] = false,
  ["NvChad/nvim-colorizer.lua"] = { override_options = require "custom.plugins.config.colorizer" },
  ["lewis6991/gitsigns.nvim"] = { override_options = require "custom.plugins.config.gitsigns" },
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = require "custom.plugins.config.treesitter",
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
      vim.defer_fn(function()
        require "custom.plugins.config.treesitter_parsers"
      end, 0)
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    config = function()
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
  ["qosmio/nvim-lsp-installer"] = {
    setup = function()
      require("core.lazy_load").on_file_open "nvim-lsp-installer"
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd 'if &ft =="packer"| echo""| else | silent! e %'
      end, 0)
    end,
  },
  ["neovim/nvim-lspconfig"] = {
    setup = function()
      require("core.lazy_load").on_file_open "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.config.lsp_installer"
      require("custom.plugins.lsp").setup_lsp()
    end,
  },
  -- ["smjonas/snippet-converter.nvim"] = {
  --   after = { "LuaSnip" },
  --   config = function()
  --     local status_ok, snips = pcall(require, "luasnip.loaders.from_vscode")
  --     if status_ok then
  --       snips.load "opts"
  --       local template = {
  --         name = "Remove-License-Snippets",
  --         sources = {
  --           vscode_luasnip = { "./friendly-snippets" },
  --         },
  --         output = {
  --           vscode_luasnip = { vim.fn.stdpath "data" .. "/site/pack/packer/opt/friendly-snippets/snippets" },
  --         },
  --         transform_snippets = function(snippet, _)
  --           if snippet.path:find "python%"
  --               or (
  --               snippet.path:find "global%.json$" and snippet.trigger:find "[Ll]icense"
  --                   or (snippet.description and snippet.description:find "[Ll]icense")
  --               )
  --           then
  --             return false
  --           end
  --         end,
  --       }
  --       require("snippet_converter").setup {
  --         templates = { template },
  --       }
  --     end
  --   end,
  -- },
  --["hrsh7th/cmp-buffer"] = false,
  --["hrsh7th/cmp-nvim-lsp"] = false,
  --["hrsh7th/cmp-nvim-lua"] = false,
  ["L3MON4D3/LuaSnip"] = false,
  ["hrsh7th/cmp-nvim-lua"] = { after = { "nvim-lspconfig", "nvim-cmp" } },
  ["saadparwaiz1/cmp_luasnip"] = false,
  --   wants = "friendly-snippets",
  --   after = "nvim-cmp",
  --   config = function()
  --     require "custom.plugins.config.luasnip"
  --   end,
  -- },
  ["folke/neodev.nvim"] = {
    before = { "lspconfig" },
    -- requires = { "cmp-nvim-lsp" },
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
  ["lambdalisue/suda.vim"] = {},
  ["machakann/vim-sandwich"] = {
    event = "InsertEnter",
  },
  ["rcarriga/nvim-notify"] = {
    config = function()
      vim.notify = require "notify"
    end,
  },
  -- Switch between single-line and multiline forms of code
  -- <ESC>gS to split a one-liner into multiple lines
  -- <ESC>gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
  ["AndrewRadev/splitjoin.vim"] = {},
  ["lukas-reineke/cmp-under-comparator"] = { -- make the sorting of completion results smarter
    requires = { "hrsh7th/nvim-cmp" },
    after = { "null-ls.nvim" },
    config = function()
      require "custom.plugins.config.cmp.python"
    end,
  },
  ["reewr/vim-monokai-phoenix"] = {
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
  },
  ["hrsh7th/nvim-cmp"] = {
    override_options = function()
      require "custom.plugins.config.cmp"
    end,
  },
  ["anuvyklack/pretty-fold.nvim"] = {
    config = function()
      require "custom.plugins.config.pretty_fold"
    end,
  },
  -- ["f3fora/cmp-spell"] = {
  --   after = "null-ls.nvim",
  --   requires = {
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     vim.opt.spell = true
  --     vim.opt.spelllang = { "en_us" }
  --   end,
  -- },
  -- ["hrsh7th/cmp-calc"] = { after = "null-ls.nvim" }, --  math calculation
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = { after = "null-ls.nvim" }, --  function signature help
  -- ["hrsh7th/cmp-cmdline"] = { after = "null-ls.nvim" }, --  command completion
  -- ["github/copilot.vim"] = {
  --   requires = { "hrsh7th/nvim-cmp" },
  --   event = "InsertEnter",
  --   setup = function()
  --     vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#965f89" })
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.g.copilot_tab_fallback = ""
  --   end,
  -- },
}

return M.user
