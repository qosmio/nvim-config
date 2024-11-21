local cfg = function(mod)
  return require("plugins.config." .. mod)
end

local lang = function(mod)
  return "registry." .. mod
end

local plugins = {
  -- stylua: ignore start
  -- { "L3MON4D3/LuaSnip",                    build = "make install_jsregexp"},
  -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "williamboman/mason.nvim",             opts = cfg "mason" },
  { "williamboman/mason-lspconfig.nvim",   opts = cfg "mason_lspconfig" },
  { "NvChad/nvim-colorizer.lua",           opts = cfg "colorizer" },
  { "lewis6991/gitsigns.nvim",             opts = cfg "gitsigns" },
  -- stylua: ignore end
  {
    "nvim-treesitter/nvim-treesitter",
    opts = cfg "treesitter",
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
  { "folke/neodev.nvim", ft = { "lua" } },
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
  { "chr4/nginx.vim", ft = "nginx" },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-lua/plenary.nvim",
      "gbprod/none-ls-shellcheck.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "nvchad.configs.lspconfig"
      local sources = require "mason-registry.sources"
      require(lang "crossplane")
      -- require(lang "pylance")
      -- require("cmp").setup.filetype("python", cfg "cmp.python")
      sources.set_registries {
        "lua:registry",
        "lua:mason-registry.index",
        "github:mason-org/mason-registry",
      }
      local mason_tool_installer = require "mason-tool-installer"
      mason_tool_installer.setup(cfg "mason_tool_installer")
      mason_tool_installer.run_on_start()
      require "plugins.lsp.servers"
      vim.lsp.set_log_level "warn"
      require("null-ls").setup(cfg "null_ls")
    end,
  },
  { "lambdalisue/suda.vim", event = { "VeryLazy" } },
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
    "tamago324/cmp-zsh",
    dependencies = {
      "Shougo/deol.nvim",
    },
    ft = { "zsh" },
    config = function()
      require("cmp").setup.filetype("zsh", cfg "cmp.zsh")
      require("cmp_zsh").setup {
        zshrc = false,
        filetypes = { "deoledit", "zsh" },
      }
    end,
  },
  { "lvimuser/lsp-inlayhints.nvim" },
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require "wilder"

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
    "zbirenbaum/copilot-cmp",
    enabled = vim.env.COPILOT_ENABLE == "true",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      local copilot_cmp = require "copilot_cmp"
      copilot_cmp.setup(opts)
      require("plugins.lsp.utils").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter {}
        end
      end)
    end,
    dependencies = {
      "copilot.lua",
      cmd = "Copilot",
      build = ":Copilot auth",
      opts = require "plugins.config.copilot",
    },
  },
  { "cmcaine/vim-uci", ft = { "uci" } },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = vim.env.COPILOT_ENABLE == "true",
    event = { "BufReadPost", "BufNewFile" },
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 1,
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
    },
  },
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    opts = cfg "conform",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    event = { "VeryLazy" },
    config = function()
      cfg("diffview").post()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = cfg "autopairs",
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
      },
    },
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
    opts = function()
      return cfg "cmp"
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    -- lazy = false,
    event = "BufRead",
    version = "*",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
        end,
      })
      require("git-conflict").setup {
        default_mappings = true, -- disable buffer local mapping created by this plugin
        -- default_commands = true, -- disable commands created by this plugin
        -- disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = "copen", -- command or function to open the conflicts list
        highlights = {
          current = "DiffAdd",
          incoming = "DiffText",
          -- ancestor = "GitConflictAncestor",
        },
      }
      vim.api.nvim_set_hl(0, "GitConflictCurrent", {})
      vim.api.nvim_set_hl(0, "GitConflictAncestor", {})
      vim.api.nvim_set_hl(0, "GitConflictIncoming", {})
    end,
    keys = {
      { "<Leader>gcb", "<cmd>GitConflictChooseBoth<CR>", desc = "choose both" },
      { "<Leader>gcn", "<cmd>GitConflictNextConflict<CR>", desc = "move to next conflict" },
      { "<Leader>gcc", "<cmd>GitConflictChooseOurs<CR>", desc = "choose current" },
      { "<Leader>gcp", "<cmd>GitConflictPrevConflict<CR>", desc = "move to prev conflict" },
      { "<Leader>gci", "<cmd>GitConflictChooseTheirs<CR>", desc = "choose incoming" },
    },
  },
  {
    "echasnovski/mini.align",
    event = { "CursorHold", "CursorHoldI" },
    config = function(_, opts)
      require("mini.align").setup(opts)
    end,
    opts = {
      mappings = {
        start = "gb",
        start_with_preview = "gB",
      },
    },
    keys = {
      { "gb", mode = { "n", "x" } },
      { "gB", mode = { "n", "x" } },
    },
  },
}

return plugins
