local M = {}

local cmd = vim.api.nvim_create_user_command
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

aucmd("VimEnter", {
  group = augroup "set_syntax",
  callback = function()
    local custom_after_path = vim.api.nvim_get_runtime_file("lua/custom/after", false)[1]
    vim.opt.runtimepath:append(custom_after_path)
  end,
  once = false,
})

-- set helm filetype
aucmd("BufRead,BufNewFile", {
  group = augroup "helm_syntax",
  pattern = "*/templates/*.yaml,*/templates/*.tpl,helmfile*.yaml,*/templates/*/*.yaml,Chart.{yml,yaml}",
  callback = function()
    vim.bo.filetype = "helm"
    vim.bo.commentstring = "{{/* %s */}}"
  end,
})

local function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
end

local function process_yank()
  vim.highlight.on_yank { timeout_ms = 2000, on_visual = false }
  local ok, osc52, yank_data
  ok, osc52 = pcall(require, "osc52")
  if not ok then
    return
  end
  if vim.v.event.operator ~= "y" then
    return
  else
    ok, yank_data = pcall(vim.fn.getreg, "")
    if ok then
      if vim.fn.has "clipboard" == 1 then
        pcall(vim.fn.setreg, "+", yank_data)
      end
      if vim.env.SSH_CONNECTION then
        osc52.copy(yank_data)
      end
    end
  end
  if vim.tbl_contains({ "", "+", "*" }, vim.v.event.regname) then
    osc52.copy_register ""
  end
  if vim.v.event.regname == "c" then
    osc52.copy_register "c"
  end
end

group_name = augroup "init"
aucmd("FileType", {
  group = group_name,
  command = "set formatoptions-=o",
})
aucmd("TermOpen", {
  group = group_name,
  callback = init_term,
})

aucmd("TextYankPost", {
  desc = "[osc52] Copy to clipboard/OSC52",
  group = group_name,
  callback = process_yank,
})

aucmd({ "BufEnter" }, {
  group = group_name,
  pattern = { "*" },
  command = [[lcd `=expand('%:p:h')`]],
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
}, "nginx")

-- go template filetype
M.ft_aucmd({
  "*.tmpl",
}, "gotexttmpl")

-- Dockerfile filetype
M.ft_aucmd({
  "Dockerfile*",
}, "dockerfile")

M.ft_aucmd({ "*docker-compose*.{yml,yaml}" }, "yaml.docker-compose")

-- Nessus/Tenable filetypes
M.ft_aucmd({
  "*.audit",
}, "audit")

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

M.ft_aucmd({
  "playbook*",
  "role*/*.yml",
  "roles.yml",
}, "yaml.ansible")

M.ft_aucmd({
  "*/git/config",
  "*.git/config",
}, "gitconfig")

--{{ FileType Indentation
group_name = augroup "filetype_indentation"

aucmd("FileType", {
  group = group_name,
  pattern = { "cpp", "c" },
  callback = function()
    vim.opt.autoindent = true
    vim.opt.cindent = true
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.formatoptions = "croql"
  end,
})
aucmd("FileType", {
  group = group_name,
  pattern = { "python" },
  callback = function()
    vim.opt.autoindent = true
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
  end,
})
aucmd("FileType", {
  group = group_name,
  pattern = { "yaml", "json" },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
aucmd("FileType", {
  desc = "smart indent for yaml",
  group = group_name,
  pattern = { "lua", "sh", "zsh", "bash" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
aucmd("BufWritePre", {
  desc = "kill trailing whitespace",
  group = group_name,
  pattern = "*",
  callback = function()
    vim.cmd [[%s/\s\+$//e]]
  end,
})

group_name = augroup "highlight"
aucmd("Syntax", {
  desc = "whitespace trailing display",
  group = group_name,
  pattern = "*",
  callback = function()
    vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]
    -- TODO
    vim.cmd [[syn match ExtraWhitespace /\s\+$\| \+\ze\t/]]
  end,
})
--}}

-- Coding {{{
-- Auto-format *.files prior to saving them{{{
aucmd("BufWritePre", {
  pattern = { "*.go", "*.rs", "*.lua" },
  command = "lua vim.lsp.buf.format({ timeout_ms = 5000 })",
})
-- }}}

-- Highlight whitespaces {{{
group_name = augroup "extra_whitespace"
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
group_name = augroup "remember_position"
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

-- wrapping for txt {{{
M.setupWrapping = function()
  vim.w.wrap = true
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

-- edit hex for bins - edit binary using xxd-format {{{
group_name = augroup "binary_files"

aucmd("BufReadPre", {
  pattern = { "*.bin", "*.dat" },
  command = "let &bin=1",
  group = group_name,
})
aucmd("BufReadPost", {
  pattern = { "*.bin", "*.dat" },
  command = "if &bin | %!xxd",
  group = group_name,
})
aucmd("BufReadPost", {
  pattern = { "*.bin", "*.dat" },
  command = "set ft=xxd | endif",
  group = group_name,
})
aucmd("BufWritePre", {
  pattern = { "*.bin", "*.dat" },
  command = "if &bin | %!xxd -r",
  group = group_name,
})
aucmd("BufWritePre", {
  pattern = { "*.bin", "*.dat" },
  command = "endif",
  group = group_name,
})
aucmd("BufWritePost", {
  pattern = { "*.bin", "*.dat" },
  command = "if &bin | %!xxd",
  group = group_name,
})
aucmd("BufWritePost", {
  pattern = { "*.bin", "*.dat" },
  command = "set nomod | endif",
  group = group_name,
})
-- }}}

-- Code Folding {{{
-- function to create a list of commands and convert them to autocommands
group_name = augroup "remember_folds"

aucmd("BufWinLeave", {
  pattern = { "*" },
  command = ":silent! mkview",
  group = group_name,
})

aucmd("BufWinEnter", {
  pattern = { "*" },
  command = ":silent! loadview",
  group = group_name,
})

-- InLayHints
group_name = augroup "LspAttach_inlayhints"
aucmd("LspAttach", {
  group = group_name,
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local ok, inlayhints = pcall(require, "lsp-inlayhints")
    if ok then
      inlayhints.on_attach(client, bufnr)
    end
  end,
})

-- Custom Commands
cmd("MasonUpdateAll", function()
  require("custom.utils").mason.update_all()
end, { desc = "Update Mason Packages" })

cmd("MasonUpdate", function(opts)
  require("custom.utils").mason.update(opts.args)
end, { nargs = 1, desc = "Update Mason Package" })

-- vim.api.nvim_command 'command! -bang -nargs=* TmuxJumpFile call v:lua.require("custom.autocmds.jump_to_ln").capture_and_list_file(<q-args>, <bang>0)'
-- vim.api.nvim_command 'command! -bang -nargs=* TmuxJumpFirst call v:lua.require("custom.autocmds.jump_to_ln").capture_and_jump(<q-args>, <bang>0)'

-- vim.api.nvim_command 'autocmd FileType * lua require("custom.autocmds.jump_to_ln").capture_and_list_file("*", 0)'

-- vim.g.tmuxjump_loaded = true

-- }}}
