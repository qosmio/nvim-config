local cfg = function(mod)
  return "plugins.config." .. mod
end

local lang = function(mod)
  return "registry." .. mod
end

local plugins = {
  -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "williamboman/mason.nvim",           opts = require(cfg "mason") },
  { "williamboman/mason-lspconfig.nvim", opts = require(cfg "mason_lspconfig") },
  { "hrsh7th/nvim-cmp",                  opts = require(cfg "cmp") },
  { "NvChad/nvim-colorizer.lua",         opts = require(cfg "colorizer") },
  { "lewis6991/gitsigns.nvim",           opts = require(cfg "gitsigns") },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require(cfg "treesitter"),
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "numToStr/Comment.nvim" },
    -- event = { "VimEnter" },
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
      require "nvchad.configs.lspconfig"
      local sources = require "mason-registry.sources"
      require(lang "crossplane")
      require(lang "pylance")
      require("cmp").setup.filetype("python", require(cfg "cmp.python"))
      require(lang "yamlfix")
      sources.set_registries { "lua:registry", "lua:mason-registry.index", "github:mason-org/mason-registry" }
      require("mason-tool-installer").setup { require(cfg "mason_tool_installer") }
      require "plugins.lsp.servers"
      vim.lsp.set_log_level "warn"
    end,
  },
  { "folke/neodev.nvim",    ft = { "lua" } },
  {
    "qosmio/alternate-toggler",
    branch = "fix-tbl_add_reverse_lookup",
    event = { "VimEnter" },
    config = function()
      require("alternate-toggler").setup {
        alternates = {
          -- ["no"] = "yes",
        },
      }
    end,
  },
  { "chr4/nginx.vim",           ft = "nginx" },
  -- Native terminal copying using OCS52
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup { trim = false }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "nvim-lua/plenary.nvim",
      "gbprod/none-ls-shellcheck.nvim"
    },
    config = function()
      require(cfg "null_ls")
    end,
  },
  { "lambdalisue/suda.vim",     event = { "VeryLazy" } },
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
      if timer ~= nil then
        timer:start(
          10,
          0,
          vim.schedule_wrap(function()
            vim.cmd [[colo monokai-phoenix]]
            vim.cmd [[hi Normal ctermbg=0]]
            local highlight = require("highlights.hlo").highlight
            local statusline = require("highlights.hlo").statusline
            local cterm = require("highlights.utils").gui_syntax_to_cterm(highlight)
            require("highlights.utils").nvim_set_hl(cterm)
            require("highlights.utils").nvim_set_hl(statusline)
            vim.cmd [[hi IndentBlankLineChar ctermfg=237]]
          end)
        )
      end
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
  { "hrsh7th/cmp-nvim-lua",                dependencies = { "neovim/nvim-lspconfig", "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { "nvimtools/none-ls.nvim" } },
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
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local mason_null_ls = require "mason-null-ls"
      mason_null_ls.setup {
        automatic_installation = {
          exclude = {
            "zsh",
            "refactoring",
            "clangd",
            "rubocop",
            "eslint",
            "crossplane-ng",
            "prettier_d_slim",
            "ansiblelint",
            "jq",
            "clang_format",
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
  -- copilot
  {
    "tris203/copilot-cmp",
    branch = "0.11_compat",
    enabled = vim.env.COPILOT_ENABLE == "true",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup()
      require("plugins.lsp.utils").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter()
        end
      end)
    end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      build = ":Copilot auth",
      opts = require "plugins.config.copilot",
    },
  },
  -- { "cfdrake/vim-pbxproj", ft = { "pbxproj" } },
  -- { "jvirtanen/vim-hcl",   ft = { "hcl" } },
  -- { "egberts/vim-nftables" },
  { "cmcaine/vim-uci", ft = { "uci" } },
  -- {
  --   url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     local lsp_lines = require "lsp_lines"
  --     lsp_lines.setup()
  --     vim.keymap.set("n", "g?", function()
  --       local lines_enabled = not vim.diagnostic.config().virtual_lines
  --       vim.diagnostic.config {
  --         virtual_lines = lines_enabled,
  --         virtual_text = not lines_enabled,
  --       }
  --     end, { noremap = true, silent = true })
  --
  --     vim.diagnostic.config {
  --       virtual_text = true,
  --       virtual_lines = false,
  --     }
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- lazy = false,
    config = function()
      require("treesitter-context").setup {
        enable = true,
        max_lines = 1,
        trim_scope = "outer",
        -- patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        --   -- For all filetypes
        --   -- Note that setting an entry here replaces all other patterns for this entry.
        --   -- By setting the 'default' entry below, you can control which nodes you want to
        --   -- appear in the context window.
        --   default = {
        --     "class",
        --     "function",
        --     "method",
        --     "for", -- These won't appear in the context
        --     "while",
        --     "if",
        --     "switch",
        --     "case",
        --     "element",
        --     "call",
        --   },
        -- },
        -- exact_patterns = {},
        --
        zindex = 20,     -- The Z-index of the context window
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- lazy = false,
    event = { "VimEnter" },
    cmd = { "ConformInfo" },
    opts = require "plugins.config.conform",
  },
}

return plugins
