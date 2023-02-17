local M = {}
M.user = {
  ["williamboman/mason.nvim"] = {
    override_options = { log_level = vim.log.levels.WARN },
  },
  ["kyazdani42/nvim-tree.lua"] = false,
  ["hrsh7th/nvim-cmp"] = {
    override_options = require "custom.plugins.config.cmp",
  },
  ["NvChad/nvim-colorizer.lua"] = {
    override_options = require "custom.plugins.config.colorizer",
  },
  ["lewis6991/gitsigns.nvim"] = { override_options = require "custom.plugins.config.gitsigns" },
  ["nvim-treesitter/nvim-treesitter"] = {
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    module = "nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    override_options = require "custom.plugins.config.treesitter",
    config = function()
      require "custom.plugins.config.treesitter_parsers"
      require "plugins.configs.treesitter"
    end,
  },
  ["numToStr/Comment.nvim"] = {
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { "gbc", "gcc" },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    init = function()
      require("core.utils").load_mappings "comment"
    end,
  },
  ["folke/which-key.nvim"] = { enabled = true },
  ["neovim/nvim-lspconfig"] = {
    event = { "VimEnter" },
    dependencies = { "mason-tool-installer.nvim" },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lsp.installers.pylance"
      require "custom.plugins.lsp.servers"
      vim.lsp.set_log_level "warn"
    end,
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    dependencies = {
      "mason.nvim",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        config = function()
          require("mason-tool-installer").setup(require "lsp.lspconfig")
        end,
      },
    },
  },
  ["hrsh7th/cmp-nvim-lua"] = { dependencies = { "nvim-lspconfig", "nvim-cmp" } },
  ["folke/neodev.nvim"] = {
    ft = { "lua" },
  },
  ["rmagatti/alternate-toggler"] = { event = "VimEnter" },
  ["chr4/nginx.vim"] = { ft = "nginx" },
  -- Native terminal copying using OCS52
  ["ojroques/nvim-osc52"] = {
    config = function()
      require("osc52").setup { trim = false }
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    lazy = false,
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
  ["reewr/vim-monokai-phoenix"] = {
    dependencies = { "jacoborus/tender.vim", "nielsmadan/harlequin", "patstockwell/vim-monokai-tasty" },
    -- dependencies = { "ui", "indent-blankline.nvim" },
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
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = { dependencies = "null-ls.nvim" }, --  function signature help
  ["tamago324/cmp-zsh"] = {
    ft = { "zsh" },
    init = function()
      require("core.utils").lazy_load "cmp-zsh"
    end,
    config = {
      filetypes = { "zsh" },
    },
  },
  ["lvimuser/lsp-inlayhints.nvim"] = {},
  ["microsoft/python-type-stubs"] = { ft = "python" },
  ["jay-babu/mason-null-ls.nvim"] = {
    lazy = false,
    dependencies = { "mason.nvim", "null-ls.nvim" },
    config = function()
      local mason_null_ls = require "mason-null-ls"
      mason_null_ls.setup {
        automatic_installation = { exclude = { "jq", "clang-format", "gofumpt" } },
        automatic_setup = true,
      }
      mason_null_ls.setup_handlers()
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
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
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
          border = { style = require "lsp.settings.popup_border" "FloatBorder" },
        },
        chat_input = {
          prompt = " > ",
          border = { style = require "lsp.settings.popup_border" "FloatBorder" },
        },
      }
    end,
  },
  ["dense-analysis/neural"] = {
    keys = { "<leader>..", "<leader>." },
    cmd = "NeuralCode",
    dependencies = { "MunifTanjim/nui.nvim", "ElPiloto/significant.nvim" },
    config = function()
      require("neural").setup {
        mappings = {
          swift = "<C-n>", -- Context completion
          prompt = "<C-space>", -- Open prompt
        },
        open_ai = {
          api_key = vim.env.OPENAI_API_KEY, -- not committed, defined in config/private-settings.lua outside of repo
          max_tokens = 10000,
          temperature = 0.1,
          presence_penalty = 0.5,
          frequency_penalty = 0.5,
        },
        ui = { icon = "ﮧ" },
      }
    end,
  },
  ["tzachar/cmp-tabnine"] = {
    dependencies = "cmp-path",
    config = function()
      require("custom.plugins.config.cmp.tabnine").setup()
    end,
  },
  ["cfdrake/vim-pbxproj"] = {
    event = { "VimEnter" },
  },
  ["nfnty/vim-nftables"] = {},
  -- ["tanvirtin/vgit.nvim"] = {
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   ft = "gitcommit",
  --   init = function()
  --     -- load gitsigns only when a git file is opened
  --     vim.api.nvim_create_autocmd({ "BufRead" }, {
  --       group = vim.api.nvim_create_augroup("vgitLazyLoad", { clear = true }),
  --       callback = function()
  --         vim.fn.system("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse")
  --         if vim.v.shell_error == 0 then
  --           vim.api.nvim_del_augroup_by_name "vgitLazyLoad"
  --           vim.schedule(function()
  --             require("lazy").load { plugins = "vgit.nvim" }
  --           end)
  --         end
  --       end,
  --     })
  --   end,
  --   config = function()
  --     require("vgit").setup()
  --   end,
  -- },
}
-- print(vim.inspect(M.user))
return M.user
