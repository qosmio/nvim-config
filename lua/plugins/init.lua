local cfg = function(mod)
	return require("plugins.config." .. mod)
end

local completion = require "plugins.config.completion"
local perf = require "plugins.config.perf"

-- local lang = function(mod)
--   return "registry." .. mod
-- end

local plugins = {
  -- stylua: ignore start
  -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "windwp/nvim-autopairs",               enabled = false },
  { "mason-org/mason.nvim",                opts = cfg "mason" },
  { "lewis6991/gitsigns.nvim",             opts = cfg "gitsigns" },
	-- stylua: ignore end
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		opts = cfg "treesitter",
		build = ":TSUpdate",
		branch = "master",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.opt.runtimepath:append(opts.parser_install_dir)
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
					["no"] = "yes",
				},
			}
		end,
	},
	{ "chr4/nginx.vim", ft = "nginx" },
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("null-ls").setup(cfg "null_ls")
		end,
	},
	{ "lambdalisue/suda.vim", event = { "VeryLazy" } },
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		enabled = completion.copilot_node_available,
		cmd = "Copilot",
		build = ":Copilot auth",
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
		opts = require "plugins.config.copilot",
	},
	{
		"andrewwillette/copilot-cmp",
		-- "zbirenbaum/copilot-cmp",
		enabled = (completion.is "cmp" or completion.is "blink")
			and completion.copilot_completion_enabled(),
		event = { "BufReadPost", "BufNewFile", "InsertEnter" },
		config = function(_, opts)
			local copilot_cmp = require "copilot_cmp"
			copilot_cmp.setup(opts)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "copilot" then
						copilot_cmp._on_insert_enter {}
					end
				end,
			})
		end,
		dependencies = {
			"zbirenbaum/copilot.lua",
			"saghen/blink.compat",
		},
	},
	{ "cmcaine/vim-uci", ft = { "uci" } },
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = not perf.is_slow_host(),
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
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		enabled = not perf.is_slow_host(),
		event = "VeryLazy",
		opts = cfg "mason_tool_installer",
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
		"saghen/blink.compat",
		enabled = completion.is "blink",
		version = "2.*",
		lazy = true,
		opts = {
			impersonate_nvim_cmp = true,
		},
	},
	{
		"saghen/blink.cmp",
		enabled = completion.is "blink",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saghen/blink.compat",
			"Shougo/deol.nvim",
			{
				"tamago324/cmp-zsh",
				config = function()
					require("cmp_zsh").setup {
						zshrc = false,
						filetypes = { "deoledit", "zsh" },
					}
				end,
			},
		},
		opts = cfg "blink",
		config = function(_, opts)
			require("blink.cmp").setup(opts)
			require("plugins.config.blink_highlights").apply()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = completion.is "cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
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
				config = function()
					require("cmp_zsh").setup {
						zshrc = false,
						filetypes = { "deoledit", "zsh" },
					}
				end,
			},
		},
		config = function()
			require("cmp").setup((cfg "cmp").opts)
			require("plugins.config.cmp").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("plugins.lsp.servers").setup()
		end,
	},
	{
		-- "akinsho/git-conflict.nvim",
		"NeilGirdhar/git-conflict.nvim",
		-- lazy = false,
		event = "BufRead",
		-- version = "*",
		branch = "patch-1",
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
		enabled = perf.lua_dev_enabled(),
		ft = "lua", -- only load on lua files
		opts = {
			enabled = function(root)
				return perf.should_enable_lua_dev(root)
			end,
			library = {
				vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
				-- See the configuration section for more details
				{ path = "/usr/share/lua/5.1", words = { "ngx" } },
			},
		},
	},
	{
		"andymass/vim-matchup",
		enabled = not perf.is_slow_host(),
		event = { "CursorHold", "CursorHoldI", "VeryLazy" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = { "%", "[" },
		cmd = { "MatchupWhereAmI" },
		init = function()
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_hi_surround_always = 1
			vim.g.matchup_matchparen_deferred_show_delay = 100
			vim.g.matchup_matchparen_deferred_hide_delay = 1000
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_transmute_enabled = 0
		end,
		config = function()
			vim.cmd [[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]]
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
				group = vim.api.nvim_create_augroup("MatchupBufferLimits", { clear = true }),
				callback = function(args)
					local buf = args.buf
					if not vim.api.nvim_buf_is_valid(buf) then
						return
					end
					local filetype = vim.bo[buf].filetype
					local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
					if fsize > 500000 or filetype ~= "html" then
						vim.b[buf].matchup_matchparen_enabled = 0
						vim.b[buf].matchup_enabled = 0
					else
						vim.b[buf].matchup_matchparen_enabled = 1
						vim.b[buf].matchup_enabled = 1
					end
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-ansible",
		init = function()
			cfg "ansible"
		end,
		config = function()
			require "ansible"
		end,
	},
}

return plugins
