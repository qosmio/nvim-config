local cfg = function(mod)
  return require("plugins.config." .. mod)
end

local lang = function(mod)
  return "registry." .. mod
end

local plugins = {
  -- stylua: ignore start
  -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "williamboman/mason.nvim",             opts = cfg "mason" },
  { "williamboman/mason-lspconfig.nvim",   opts = cfg "mason_lspconfig" },
  { "NvChad/nvim-colorizer.lua",           opts = cfg "colorizer" },
  { "lewis6991/gitsigns.nvim",             opts = cfg "gitsigns" },
  -- stylua: ignore end
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    opts = cfg "treesitter",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function(_, opts)
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }
      opts.ignore = "^$"
      opts.pre_hook =
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end,
  },
  { "folke/which-key.nvim", enabled = true },
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
      -- require "nvchad.configs.lspconfig"
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
  -- {
  --   "tamago324/cmp-zsh",
  --   dependencies = {
  --     "Shougo/deol.nvim",
  --   },
  --   ft = { "zsh" },
  --   config = function()
  --     require("cmp").setup.filetype("zsh", cfg "cmp.zsh")
  --     require("cmp_zsh").setup {
  --       zshrc = false,
  --       filetypes = { "deoledit", "zsh" },
  --     }
  --   end,
  -- },
  -- { "lvimuser/lsp-inlayhints.nvim" },
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
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    enabled = true,
    -- event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
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
      "https://codeberg.org/FelipeLema/cmp-async-path",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-calc",
      "dmitmel/cmp-cmdline-history",
      "ray-x/cmp-treesitter",
      { "lukas-reineke/cmp-under-comparator" },
      { "onsails/lspkind-nvim" },
      {
        "tamago324/cmp-zsh",
        opts = {
          zshrc = true,
          filetypes = { "zsh" },
        },
      },
    },
    -- opts = (cfg "cmp").opts,
    config = function()
      require("cmp").setup((cfg "cmp").opts)
      require("plugins.config.cmp").setup()
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     -- autopairing of (){}[] etc
  --     {
  --       "windwp/nvim-autopairs",
  --       opts = cfg "autopairs",
  --       config = function(_, opts)
  --         require("nvim-autopairs").setup(opts)
  --         -- setup cmp for autopairs
  --         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  --         require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --       end,
  --     },

  --     -- cmp sources plugins
  --     {
  --       "hrsh7th/cmp-nvim-lua",
  --       "hrsh7th/cmp-nvim-lsp",
  --       "hrsh7th/cmp-buffer",
  --       "hrsh7th/cmp-path",
  --       "hrsh7th/cmp-cmdline",
  --       "hrsh7th/cmp-nvim-lsp-signature-help",
  --       "tamago324/cmp-zsh",
  --     },
  --   },
  --   config = function(_, opts)
  --     require("cmp").setup(opts)
  --   end,
  --   opts = function()
  --     return cfg "cmp"
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   event = "User FilePost",
  --   dependencies = { "saghen/blink.cmp" },
  --   config = function(_, opts)
  --     require("nvchad.configs.lspconfig").defaults()
  --     local lspconfig = require "lspconfig"
  --     for server, config in pairs(opts.servers or {}) do
  --       config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
  --       lspconfig[server].setup(config)
  --     end
  --   end,
  -- },
  {
    "tamago324/cmp-zsh",
    dependencies = {
      "Shougo/deol.nvim",
    },
    ft = { "zsh" },
    config = function()
      -- require("cmp").setup.filetype("zsh", cfg "cmp.zsh")
      require("cmp_zsh").setup {
        zshrc = false,
        filetypes = { "deoledit", "zsh" },
      }
    end,
  },
  -- { -- optional blink completion source for require statements and module annotations
  --   "saghen/blink.cmp",
  --   enabled = false,
  --   build = "cargo build --release",
  --   version = "*",
  --   lazy = false,
  --   dependencies = {
  --     {
  --       "saghen/blink.compat",
  --       opts = {
  --         -- some plugins lazily register their completion source when nvim-cmp is
  --         -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
  --         -- most plugins don't do this, so this option should rarely be needed
  --         -- NOTE: only has effect when using lazy.nvim plugin manager
  --         impersonate_nvim_cmp = true,
  --         -- some sources, like codeium.nvim, rely on nvim-cmp events to function properly
  --         -- when enabled, emit those events
  --         -- NOTE: somewhat hacky, may harm performance or break
  --         -- enable_events = true,
  --         -- print some debug information. Might be useful for troubleshooting
  --         debug = false,
  --       },
  --     },
  --     {
  --       "giuxtaposition/blink-cmp-copilot",
  --       enabled = vim.env.COPILOT_ENABLE == "true",
  --       dependencies = {
  --         {
  --           "zbirenbaum/copilot.lua",
  --           cmd = "Copilot",
  --           build = ":Copilot auth",
  --           opts = require "plugins.config.copilot",
  --         },
  --       },
  --       specs = {
  --         {
  --           "blink.cmp",
  --           optional = true,
  --           opts = {
  --             sources = {
  --               providers = {
  --                 copilot = { name = "copilot", module = "blink-cmp-copilot" },
  --               },
  --               completion = {
  --                 enabled_providers = { "copilot" },
  --               },
  --               opts = {
  --                 -- this table is passed directly to the proxied completion source
  --                 -- as the `option` field in nvim-cmp's source config

  --                 -- this is an option from cmp-digraphs
  --                 cache_digraphs_on_start = true,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --   opts = cfg "blink",
  -- },
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
        disable_diagnostics = false,
        debug = false,
        default_mappings = true, -- disable buffer local mapping created by this plugin
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
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
        -- See the configuration section for more details
        { path = "/usr/share/lua/5.1", words = { "ngx" } },
      },
    },
  },
  {
    "andymass/vim-matchup",
    -- event = { "CursorHold", "CursorHoldI", "VeryLazy" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "%", "[" }, -- {, '<Plug>(matchup-%)', '<Plug>(matchup-g%)' },
    cmd = { "MatchupWhereAmI" }, --
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_deferred_show_delay = 100
      vim.g.matchup_matchparen_deferred_hide_delay = 1000
    end,
    config = function()
      local fsize = vim.fn.getfsize(vim.fn.expand "%:p:f")
      if fsize == nil or fsize < 0 then
        fsize = 1
      end
      local enabled = 1
      if fsize > 500000 then
        enabled = 0
      end
      if not vim.tbl_contains({ "html" }, vim.bo.filetype) then
        enabled = 0
      end
      vim.g.matchup_enabled = enabled
      vim.g.matchup_surround_enabled = enabled
      vim.g.matchup_transmute_enabled = 0
      vim.g.matchup_matchparen_deferred = enabled
      vim.g.matchup_matchparen_hi_surround_always = enabled
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.cmd [[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]]
    end,
  },
}

return plugins
