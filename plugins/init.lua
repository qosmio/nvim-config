local M = {}

M.remove = {
  "max397574/better-escape.nvim",
  "goolord/alpha-nvim",
  "williamboman/mason",
}
M.override = {
  ["NvChad/nvim-colorizer.lua"] = require "custom.plugins.config.colorizer",
  ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.config.treesitter",
  ["lewis6991/gitsigns.nvim"] = require "custom.plugins.config.gitsigns",
  -- ["lukas-reineke/indent-blankline.nvim"] = require "custom.plugins.config.indent_blankline",
}

local present, _ = pcall(require, "cmp-under-comparator")
if present then
  table.insert(M.override, { ["hrsh7th/nvim-cmp"] = require "custom.plugins.config.cmp" })
end

M.user = {
  ["folke/which-key.nvim"] = { disable = false },
  ["qosmio/nvim-lsp-installer"] = {
    setup = function()
      require("core.lazy_load").on_file_open "nvim-lsp-installer"
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
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
      require "custom.plugins.lsp".setup_lsp()
    end,
  },
  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require "custom.plugins.config.luasnip"
    end,
  },
  ["folke/lua-dev.nvim"] = {
    requires = { "cmp-nvim-lsp" },
    ft = { "lua" },
  },
  ["rmagatti/alternate-toggler"] = {},
  ["nathom/filetype.nvim"] = {},
  ["chr4/nginx.vim"] = { ft = "nginx" },
  -- Native terminal copying using OCS52
  ["ojroques/vim-oscyank"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
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
  ["lukas-reineke/cmp-under-comparator"] = { before = { "nvim-cmp" } },
  -- ["sindrets/diffview.nvim"] = {
  --   requires = { "lewis6991/gitsigns.nvim" },
  --   after = { "plenary.nvim" },
  --   config = function()
  --     require("custom.plugins.config.diffview").post()
  --   end,
  -- },
  ["reewr/vim-monokai-phoenix"] = {
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
  },
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
  -- ["hashivim/vim-terraform"] = { ft = { "tf", "terraform" } },
  -- ["anuvyklack/pretty-fold.nvim"] = {
  --   config = function()
  --     -- require("pretty-fold").setup(function()
  --     require "custom.plugins.config.pretty_fold"
  --     -- end)
  --   end,
  --   --config = require "custom.plugins.config.pretty_fold",
  -- },
}

return M
