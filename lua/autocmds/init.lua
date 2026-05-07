local M = {}
local perf = require("plugins.config.perf")

local aucmd = vim.api.nvim_create_autocmd
local augroup = function(group)
	vim.api.nvim_create_augroup(group, { clear = true })
end

local group_name

-- set filetypes function
function M.ft_aucmd(pattern, ft)
	aucmd({ "BufRead", "BufNewFile", "BufWinEnter" }, {
		pattern = pattern,
		command = [[set ft=]] .. ft,
		once = false,
	})
end

-- set syntax function
function M.syn_aucmd(pattern, syn)
	aucmd({ "BufRead", "BufNewFile", "BufWinEnter" }, {
		pattern = pattern,
		command = [[set syntax=]] .. syn,
		once = false,
	})
end

-- set helm filetype
aucmd({ "BufRead", "BufNewFile" }, {
	group = augroup("helm_syntax"),
	pattern = "*/templates/*.yaml,*/templates/*.tpl,helmfile*.yaml,*/templates/*/*.yaml,Chart.{yml,yaml}",
	callback = function()
		vim.bo.filetype = "helm"
		vim.bo.commentstring = "{{/* %s */}}"
	end,
})

aucmd({ "CursorHold" }, {
	pattern = "*",
	callback = function()
		for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_config(winid).zindex then
				return
			end
		end
		vim.diagnostic.open_float({
			scope = "cursor",
			focusable = false,
			close_events = {
				"CursorMoved",
				"CursorMovedI",
				"BufHidden",
				"InsertCharPre",
				"WinLeave",
			},
		})
	end,
})

local function init_term()
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.signcolumn = "no"
end

group_name = augroup("init")
aucmd("FileType", {
	group = group_name,
	command = "set formatoptions-=o",
})
aucmd("TermOpen", {
	group = group_name,
	callback = init_term,
})

aucmd({ "BufReadPost", "BufNewFile" }, {
	group = group_name,
	callback = function(args)
		perf.apply_buffer(args.buf)
	end,
})

aucmd("FileType", {
	group = group_name,
	callback = function(args)
		perf.apply_buffer(args.buf)
		perf.stop_builtin_treesitter(args.buf)
	end,
})

aucmd("FileType", {
	group = group_name,
	callback = function()
		if vim.bo.commentstring == nil or vim.bo.commentstring == "" then
			vim.bo.commentstring = "# %s"
			return
		end
	end,
})

-- Binary filetype
M.ft_aucmd({
	"*.bin",
	"*.exe",
	"*.dll",
	"*.so",
}, "xxd")

-- Plist
M.ft_aucmd({
	"*.xm",
}, "objc")

-- Plist
M.ft_aucmd({
	"*.plist",
}, "xml")

-- Terraform filetype
M.ft_aucmd({
	"*.tf",
	"*.tfvars",
}, "hcl")

-- nginx filetype
M.ft_aucmd({
	"*.nginx",
	"nginx*.conf",
	"*nginx.conf",
	"*/etc/nginx/*",
	"*/usr/local/nginx/conf/*",
	"*/nginx/*.conf",
	"*/angie/*.conf",
	"*/angie/**/*.conf",
}, "nginx")

-- go template filetype
M.ft_aucmd({
	"*.tmpl",
}, "gotexttmpl")

-- Dockerfile filetype
M.ft_aucmd({
	"Dockerfile*",
}, "dockerfile")

M.ft_aucmd({
	"*docker-compose*.{yml,yaml}",
}, "yaml.docker-compose")

-- Nessus/Tenable
M.ft_aucmd({
	"*.audit",
}, "audit")

-- Most .ini files are dosini like
M.ft_aucmd({
	"*.cnf",
}, "dosini")

-- nftables filetype
M.ft_aucmd({
	"*nft*.conf",
}, "nftables")

-- PHP ini
M.ft_aucmd({
	"*etc/php/*",
	"php*conf",
}, "dosini")

-- ansible
M.ft_aucmd({
	"playbook*",
	"role*/*.yml",
	"roles.yml",
}, "yaml.ansible")

-- Git
M.ft_aucmd({
	"*/git/config",
	"*.git/config",
}, "gitconfig")

-- Groovy (Jenkins)
M.ft_aucmd({
	"*/jenkinsLibraries/*",
	"*/jenkinsPipeline/*",
}, "groovy")

-- UCI (OpenWRT Unified Configuration Interface)
M.ft_aucmd({
	"*etc/config*",
}, "uci")

-- Diff/Patch
M.ft_aucmd({
	"*.patch",
}, "diff")

M.syn_aucmd({
	"*.zsh",
	"*.zshrc",
	"*.zshenv",
	"*.zsh-theme",
}, "bash")

-- Jinja2
M.ft_aucmd({
	"*.j2",
}, "jinja")

-- ucode
M.ft_aucmd({
	"*.uc",
}, "typescript")

--{{ FileType Indentation
group_name = augroup("filetype_indentation")

local set_indent = function(opts)
	vim.bo.autoindent = opts.autoindent ~= false
	vim.bo.cindent = opts.cindent or false
	vim.bo.expandtab = opts.expandtab
	vim.bo.shiftwidth = opts.shiftwidth
	vim.bo.softtabstop = opts.softtabstop or opts.shiftwidth
	vim.bo.tabstop = opts.tabstop or opts.shiftwidth
	vim.bo.smartindent = opts.smartindent or false
end

aucmd("FileType", {
	group = group_name,
	pattern = { "cpp", "c", "sshconfig", "dts", "kconfig" },
	callback = function()
		set_indent({ expandtab = false, shiftwidth = 2, softtabstop = 4, tabstop = 2, cindent = true })
	end,
})
aucmd("FileType", {
	group = group_name,
	pattern = { "python" },
	callback = function()
		set_indent({ expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4, smartindent = true })
	end,
})
aucmd("FileType", {
	group = group_name,
	pattern = { "css", "javascript", "json", "lua", "typescript", "yaml" },
	callback = function()
		set_indent({ expandtab = true, shiftwidth = 2, softtabstop = 2, tabstop = 2, smartindent = true })
	end,
})
aucmd("FileType", {
	desc = "Use tab indentation for shfmt-managed shell buffers",
	group = group_name,
	pattern = { "bash", "sh", "zsh" },
	callback = function()
		set_indent({ expandtab = false, shiftwidth = 4, softtabstop = 4, tabstop = 4, smartindent = true })
	end,
})
-- aucmd("BufWritePre", {
--   desc = "kill trailing whitespace",
--   group = group_name,
--   pattern = "*",
--   callback = function()
--     vim.cmd [[%s/\s\+$//e]]
--   end,
-- })

group_name = augroup("highlight")
aucmd("Syntax", {
	desc = "whitespace trailing display",
	group = group_name,
	pattern = "*",
	callback = function()
		vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
		-- TODO
		vim.cmd([[syn match ExtraWhitespace /\s\+$\| \+\ze\t/]])
	end,
})
--}}

-- Coding {{{
-- Auto-format *.files prior to saving them{{{
-- aucmd("BufWritePre", {
--   pattern = { "*.go", "*.rs", "*.lua" },
--   command = "lua vim.lsp.buf.format({ timeout_ms = 5000 })",
-- })
-- }}}

-- Highlight whitespaces {{{
group_name = augroup("extra_whitespace")
aucmd(
	{ "BufNewFile", "BufRead", "InsertLeave" },
	{ command = "silent! match ExtraWhitespace /\\s\\+$/", group = group_name }
)
aucmd({ "InsertEnter" }, {
	command = "silent! match ExtraWhitespace /\\s\\+\\%#\\@<!$/",
	group = group_name,
})
-- }}}

-- }}}

-- Misc {{{

-- remember and go to last position when opening a buffer {{{
group_name = augroup("remember_position")
aucmd({ "BufReadPost" }, {
	group = group_name,
	callback = function()
		local test_line_data = vim.api.nvim_buf_get_mark(0, '"')
		local test_line = test_line_data[1]
		local last_line = vim.api.nvim_buf_line_count(0)

		if test_line > 0 and test_line <= last_line then
			vim.api.nvim_win_set_cursor(0, test_line_data)
		end
	end,
})

-- }}}
group_name = augroup("leading_whitespace")
aucmd({ "BufNewFile", "BufRead", "InsertLeave", "ColorScheme" }, {
	group = group_name,
	callback = function()
		vim.api.nvim_set_hl(0, "WhiteSpaceMol", { blend = 0 })
		vim.cmd([[match WhiteSpaceMol /[^ \t]\@<=\s\+/]])
	end,
})
-- wrapping for txt {{{
M.setupWrapping = function()
	vim.wo.wrap = true
	vim.bo.wm = 2
	vim.bo.textwidth = 79
end

aucmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt" },
	callback = function()
		vim.schedule(M.setupWrapping)
	end,
})
-- }}}

-- }}}

-- Additional File opens {{{

-- open images with nsxiv
aucmd("BufEnter", {
	pattern = { "*.png", "*.jpg", "*.gif" },
	command = [[exec "!nsxiv ".expand("%") | :bw]],
})

-- Code Folding {{{
-- function to create a list of commands and convert them to autocommands
group_name = augroup("remember_folds")

local function should_persist_view(bufnr)
	if perf.is_slow_host() or perf.is_guarded_buffer(bufnr) then
		return false
	end

	return vim.api.nvim_buf_get_name(bufnr) ~= ""
end

aucmd("BufWinLeave", {
	pattern = { "*" },
	group = group_name,
	callback = function(args)
		if should_persist_view(args.buf) then
			vim.cmd("silent! mkview")
		end
	end,
})

aucmd("BufWinEnter", {
	pattern = { "*" },
	group = group_name,
	callback = function(args)
		if should_persist_view(args.buf) then
			vim.cmd("silent! loadview")
		end
	end,
})

group_name = augroup("LspAttach_inlayhints")
aucmd("LspAttach", {
	group = group_name,
	callback = function(args)
		if perf.is_slow_host() then
			return
		end

		if not (args.data and args.data.client_id) then
			return
		end
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint", bufnr) then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end
	end,
})

-- check first and last 5 lines in current buffer for 'vim:.*ft=.*' and set filetype accordingly
-- set filetypes function
-- aucmd("BufWinEnter", {
--   group = augroup "ft_modeline",
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local line_count = vim.api.nvim_buf_line_count(bufnr)
--     local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(5, line_count), false)
--     local last_lines =
--       vim.api.nvim_buf_get_lines(bufnr, math.max(0, line_count - 5), line_count, false)
--     local all_lines = {}
--     for _, line in ipairs(lines) do
--       table.insert(all_lines, line)
--     end
--     for _, line in ipairs(last_lines) do
--       table.insert(all_lines, line)
--     end
--     for _, line in ipairs(all_lines) do
--       -- look for ft or syn
--       local vim_cmd = line:match "vim:(.*)"
--       if vim_cmd then
--         vim_cmd = vim_cmd:match "^%s*(.-)%s*$" -- trim whitespace
--         if vim_cmd ~= "" then
--           pcall(vim.cmd, vim_cmd)
--         end
--         return
--       end
--     end
--   end,
--   once = false,
-- })

-- after/autoload/openwrt
-- Autocommand to set OpenWrt environment variables only for relevant files
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*/target-aarch64_cortex-a53_musl/*",
--   callback = function()
--     local openwrt = require "after.autoload.openwrt"
--     -- openwrt.print_openwrt_vars()
--     openwrt.set_openwrt_vars()
--   end,
-- })

-- Detect ini files based on CONFIG_ or TARGET_ prefixes
aucmd("BufReadPost", {
	group = augroup("ini_detect"),
	pattern = { "*.config", "*.conf", ".config", "config" }, -- Only check likely config files
	callback = function()
		-- Skip if filetype is already set
		if vim.bo.filetype ~= "" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local max_lines = 6 -- Check fewer lines
		local line_count = math.min(max_lines, vim.api.nvim_buf_line_count(bufnr))
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)

		for _, line in ipairs(lines) do
			if line:match("^CONFIG_") or line:match("^TARGET_") then
				vim.bo.filetype = "dosini"
				vim.bo.commentstring = "# %s"
				break
			end
		end
	end,
	once = true,
})
