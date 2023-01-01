local M = {}
M.user = {
  ["kyazdani42/nvim-tree.lua"] = false,
  ["max397574/better-escape.nvim"] = false,
  ["goolord/alpha-nvim"] = false,
  -- ["nvim-telescope/telescope.nvim"] = false,
  -- ["hrsh7th/cmp-nvim-lsp"] = false,
  -- ["L3MON4D3/LuaSnip"] = false,
  -- ["windwp/nvim-autopairs"] = false,
  -- ["hrsh7th/cmp-nvim-lua"] = false,
  -- ["saadparwaiz1/cmp_luasnip"] = false,
  -- ["hrsh7th/nvim-cmp"] = false,
  -- ["hrsh7th/cmp-buffer"] = false,
  -- ["hrsh7th/cmp-path"] = false,
  ["hrsh7th/nvim-cmp"] = {
    override_options = require "custom.plugins.config.cmp",
  },
  ["NvChad/nvim-colorizer.lua"] = {
    override_options = require "custom.plugins.config.colorizer",
  },
  ["lewis6991/gitsigns.nvim"] = {
    override_options = require "custom.plugins.config.gitsigns",
  },
  -- ["nvim-treesitter/playground"] = {
  --   keys = { "gh" },
  --   event = "InsertEnter",
  -- },
  ["nvim-treesitter/nvim-treesitter"] = {
    requires = { "nvim-treesitter/playground" },
    module = "nvim-treesitter",
    setup = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
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
  ["neovim/nvim-lspconfig"] = {
    opt = true,
    setup = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lsp.installers.pylance"
      require "custom.plugins.lsp.servers"
      require("mason-lspconfig").setup(require "lsp.lspconfig")
    end,
    after = "mason-lspconfig.nvim",
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    after = { "mason.nvim" },
    -- setup = function()
    --   require("core.utils").lazy_load "mason.nvim"
    -- end,
    -- config = function()
    --   -- require "plugins.configs.lspconfig"
    --   -- require "custom.plugins.lsp.installers.pylance"
    --   -- require "custom.plugins.lsp.servers"
    --   -- require("custom.plugins.lsp.settings")
    --   require("mason-lspconfig").setup(require "lsp.lspconfig")
    -- end,
  },
  ["hrsh7th/cmp-nvim-lua"] = { after = { "nvim-lspconfig", "nvim-cmp" } },
  ["folke/neodev.nvim"] = {
    ft = { "lua" },
    -- config = function()
    --   local statusline = require "base46.integrations.statusline"
    --   write(statusline,"/tmp/out.txt")
    -- end,
  },
  ["rmagatti/alternate-toggler"] = {},
  ["chr4/nginx.vim"] = { ft = "nginx" },
  -- Native terminal copying using OCS52
  ["ojroques/nvim-osc52"] = {
    config = function()
      require("osc52").setup { trim = false }
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("custom.plugins.config.null_ls").setup()
    end,
  },
  ["lambdalisue/suda.vim"] = { event = { "CmdlineEnter" } },
  ["machakann/vim-sandwich"] = {
    event = "InsertEnter",
  },
  -- Switch between single-line and multiline forms of code
  -- <ESC>gS to split a one-liner into multiple lines
  -- <ESC>gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
  ["AndrewRadev/splitjoin.vim"] = {},
  -- ["lukas-reineke/cmp-under-comparator"] = { -- make the sorting of completion results smarter
  --   -- requires = { "hrsh7th/nvim-cmp" },
  --   after = { "null-ls.nvim", "nvim-cmp" },
  --   config = function()
  --     require "custom.plugins.config.cmp.python"
  --     -- require "custom.plugins.config.cmp.zsh"
  --   end,
  -- },
  ["reewr/vim-monokai-phoenix"] = {
    requires = { "jacoborus/tender.vim", "nielsmadan/harlequin", "patstockwell/vim-monokai-tasty" },
    after = { "ui", "indent-blankline.nvim" },
    cond = function()
      return vim.env.LC_TERMINAL == "shelly"
    end,
    event = { "VimEnter" },
    config = function()
      vim.opt.termguicolors = false
      local timer = vim.loop.new_timer()
      timer:start(
        10,
        0,
        vim.schedule_wrap(function()
          vim.cmd [[colo monokai-phoenix]]
          -- vim.cmd [[colo tender]]
          -- vim.cmd [[colorscheme vim-monokai-tasty]]
          vim.cmd [[hi Normal ctermbg=0]]
          local highlight = require("custom.highlights.hlo").highlight
          local statusline = require("custom.highlights.hlo").statusline
          -- local statusline = require "base46.integrations.statusline"
          -- pprint(statusline)
          local cterm = require("custom.highlights.utils").gui_syntax_to_cterm(highlight)
          require("custom.highlights.utils").nvim_set_hl(cterm)
          require("custom.highlights.utils").nvim_set_hl(statusline)
          vim.cmd [[hi IndentBlankLineChar ctermfg=237]]
        end)
      )
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
      require("core.utils").lazy_load "cmp-zsh"
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
  ["gelguy/wilder.nvim"] = {
    config = function()
      local wilder = require "wilder"
      -- wilder.setup { modes = { ":", "/", "?" } }

      wilder.set_option("pipeline", { wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()) })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(
          { highlighter = wilder.basic_highlighter() },
          wilder.popupmenu_border_theme {
            border = "rounded",
          }
        )
      )
    end,
  },
  ["jackMort/ChatGPT.nvim"] = {
    cmd = "ChatGPT",
    requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("chatgpt").setup {
        welcome_message = "",
        question_sign = "",
        answer_sign = "ﮧ",
        max_line_length = 80,
        keymaps = {
          close = "<Esc>", -- removes ability to use normal mode
          yank_last = "<D-c>",
          scroll_up = "<S-Up>",
          scroll_down = "<S-Down>",
        },
        chat_window = {
          border = { style = borderStyle },
        },
        chat_input = {
          prompt = " > ",
          border = { style = borderStyle },
        },
      }
    end,
  },
  ["dense-analysis/neural"] = {
    cmd = "NeuralCode",
    requires = { "MunifTanjim/nui.nvim", "ElPiloto/significant.nvim" },
    config = function()
      require("neural").setup {
        mappings = {
          swift = nil,
          -- prompt = nil,
        },
        open_ai = {
          api_key = vim.env.OPENAI_API_KEY, -- not committed, defined in config/private-settings.lua outside of repo
          max_tokens = 1000,
          temperature = 0.1,
          presence_penalty = 0.5,
          frequency_penalty = 0.5,
        },
        ui = { icon = "ﮧ" },
      }
    end,
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
}
-- print(vim.inspect(M.user))
return M.user
