local cfg = function(mod)
  return "custom.plugins.config." .. mod
end

local lang = function(mod)
  return "custom.plugins.lsp.installers." .. mod
end

local plugins = {
  { "williamboman/mason.nvim", opts = require(cfg "mason") },
  { "hrsh7th/nvim-cmp", opts = require(cfg "cmp") },
  { "NvChad/nvim-colorizer.lua", opts = require(cfg "colorizer") },
  { "lewis6991/gitsigns.nvim", opts = require(cfg "gitsigns") },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require(cfg "treesitter"),
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "numToStr/Comment.nvim" },
    keys = { "gbc", "gcc" },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  { "folke/which-key.nvim", enabled = true },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      -- require("mason-tool-installer").setup { require(cfg "mason_tool_installer") }
      require "plugins.configs.lspconfig"
      local sources = require "mason-registry.sources"
      require(lang "crossplane")
      require(lang "pylance")
      require("cmp").setup.filetype("python", require(cfg "cmp.python"))
      require(lang "yamlfix")
      -- require(lang "nginx_beautifier")
      sources.set_registries { "lua:mason-registry.index" }
      require("mason-tool-installer").setup { require(cfg "mason_tool_installer") }
      require "custom.plugins.lsp.servers"
      vim.lsp.set_log_level "warn"
    end,
  },
  { "folke/neodev.nvim", ft = { "lua" } },
  {
    "rmagatti/alternate-toggler",
    event = { "VimEnter" },
    config = function()
      require("alternate-toggler").setup {
        alternates = {
          ["yes"] = "no",
          ["no"] = "yes",
        },
      }
    end,
  },
  { "chr4/nginx.vim", ft = "nginx" },
  -- Native terminal copying using OCS52
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup { trim = false }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require(cfg "null_ls")
    end,
  },
  { "lambdalisue/suda.vim", event = { "VeryLazy" } },
  -- { "machakann/vim-sandwich", event = { "InsertEnter" } },
  -- Switch between single-line and multiline forms of code
  -- <ESC>gS to split a one-liner into multiple lines
  -- <ESC>gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
  { "AndrewRadev/splitjoin.vim" },
  {
    "reewr/vim-monokai-phoenix",
    dependencies = {
      "jacoborus/tender.vim",
      "nielsmadan/harlequin",
      "patstockwell/vim-monokai-tasty",
    },
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
  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require(cfg "pretty_fold")
    end,
  },
  { "lukas-reineke/cmp-rg" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lua", dependencies = { "neovim/nvim-lspconfig", "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { "jose-elias-alvarez/null-ls.nvim" } },
  {
    "tamago324/cmp-zsh",
    dependencies = {
      "Shougo/deol.nvim",
    },
    ft = { "zsh" },
    config = function()
      require("cmp").setup.filetype("zsh", require(cfg "cmp.zsh"))
      require("cmp_zsh").setup {
        zshrc = false,
        filetypes = { "deoledit", "zsh" },
      }
    end,
  },
  { "lvimuser/lsp-inlayhints.nvim" },
  { "microsoft/python-type-stubs", ft = "python" },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      local mason_null_ls = require "mason-null-ls"
      mason_null_ls.setup {
        automatic_installation = {
          exclude = {
            "zsh",
            "eslint",
            "nginx_beautifier",
            "crossplane",
            "prettier_d_slim",
            "ansiblelint",
            "jq",
            "clang_format",
            "gofumpt",
          },
        },
        automatic_setup = true,
      }
    end,
  },
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require "wilder"
      -- wilder.setup { modes = { ":", "/", "?" } }

      wilder.set_option("pipeline", {
        wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(
          { highlighter = wilder.basic_highlighter() },
          wilder.popupmenu_border_theme { border = "rounded" }
        )
      )
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
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
          border = { style = require "custom.plugins.lsp.settings.popup_border" "FloatBorder" },
        },
        chat_input = {
          prompt = " > ",
          border = { style = require "custom.plugins.lsp.settings.popup_border" "FloatBorder" },
        },
      }
    end,
  },
  {
    "dense-analysis/neural",
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
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require(cfg "cmp.tabnine").setup()
    end,
  },
  { "cfdrake/vim-pbxproj", ft = { "pbxproj" } },
  { "jvirtanen/vim-hcl", ft = { "hcl" } },
  { "egberts/vim-nftables" },
  -- {"jcdickinson/codeium.nvim",
  --   enabled = false,
  --   event = "InsertEnter",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup {}
  --   end,
  -- },
  -- {"Exafunction/codeium.vim",
  --   dependencies = { "nyngwang/cmp-codeium" },
  --   event = "InsertEnter",
  -- },
}
return plugins
