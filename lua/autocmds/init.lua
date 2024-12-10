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
    local custom_after_path = vim.api.nvim_get_runtime_file("lua/after", false)[1]
    vim.opt.runtimepath:append(custom_after_path)
  end,
  once = false,
})

-- set helm filetype
aucmd({ "BufRead", "BufNewFile" }, {
  group = augroup "helm_syntax",
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
    vim.diagnostic.open_float {
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    }
  end,
})

local function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
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
    vim.opt.tabstop = 4 -- number of spaces a tab counts for
    vim.opt.softtabstop = 2 -- number of spaces a tab counts for when editing
    vim.opt.shiftwidth = 4 -- number of spaces to use for autoindent
    vim.opt.expandtab = true -- use spaces instead of tabs
    vim.opt.autoindent = true -- auto indents new lines
    vim.opt.smartindent = true -- smart indents new lines
    vim.opt.smarttab = true -- smartly use tabs for indenting
    -- vim.opt.cindent = true -- c style indenting, (i.e. '{' on same line as if/for/while)
    -- vim.opt.formatoptions = "croql" -- auto format comments, auto wrap lines, etc.
  end,
})
aucmd("FileType", {
  group = group_name,
  pattern = { "yaml", "json", "javascript" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
aucmd("FileType", {
  desc = "smart indent for yaml",
  group = group_name,
  pattern = { "lua", "sh", "zsh", "bash", "css" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
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
-- aucmd("BufWritePre", {
--   pattern = { "*.go", "*.rs", "*.lua" },
--   command = "lua vim.lsp.buf.format({ timeout_ms = 5000 })",
-- })
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
group_name = augroup "leading_whitespace"
aucmd({ "BufNewFile", "BufRead", "InsertLeave", "ColorScheme" }, {
  group = group_name,
  callback = function()
    vim.api.nvim_set_hl(0, "WhiteSpaceMol", { blend = 0 })
    vim.cmd [[match WhiteSpaceMol /[^ \t]\@<=\s\+/]]
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

-- check first and last 5 lines in current buffer for 'vim:.*ft=.*' and set filetype accordingly
-- set filetypes function
aucmd("BufWinEnter", {
  group = augroup "ft_modeline",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
    for _, line in ipairs(lines) do
      -- look for ft or syn
      local vim_cmd = line:match "vim:(.*)"
      if vim_cmd then
        vim.cmd(vim_cmd)
        return
      end
    end
  end,
  once = false,
})

-- Custom Commands
cmd("MasonUpdateAll", function()
  require("utils").mason.update_all()
end, { desc = "Update Mason Packages" })

cmd("MasonUpdate", function(opts)
  require("utils").mason.update(opts.args)
end, { nargs = 1, desc = "Update Mason Package" })

-- }}}
