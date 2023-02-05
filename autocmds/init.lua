local aucmd = vim.api.nvim_create_autocmd

local M = {}

-- set filetypes function
function M.ft_aucmd(pattern, ft)
  aucmd({ "BufRead", "BufNewFile", "BufWinEnter" }, { pattern = pattern, command = [[set ft=]] .. ft, once = false })
end

-- set syntax function
function M.syn_aucmd(pattern, syn)
  aucmd(
    { "BufRead", "BufNewFile", "BufWinEnter" },
    { pattern = pattern, command = [[set syntax=]] .. syn, once = false }
  )
end

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
}, "terraform")

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

-- Dockerfile filetype
M.ft_aucmd({
  "*nft*.conf",
}, "nftables")

-- PHP ini
M.ft_aucmd({
  "*etc/php/*",
  "php*conf",
}, "dosini")

--{{ FileType Indentation
vim.api.nvim_create_augroup("extension file", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "extension file",
  pattern = { "cpp", "c", "python" },
  callback = function()
    vim.opt.autoindent = true
    vim.opt.cindent = true
    vim.opt.softtabstop = 2
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "extension file",
  pattern = { "yaml", "json" },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  desc = "smart indent for yaml",
  group = "extension file",
  pattern = { "lua", "sh", "zsh", "bash" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "kill trailing whitespace",
  group = "extension file",
  pattern = "*",
  callback = function()
    vim.cmd [[%s/\s\+$//e]]
  end,
})

vim.api.nvim_create_augroup("highlight", { clear = true })
vim.api.nvim_create_autocmd("Syntax", {
  desc = "whitespace trailing display",
  group = "highlight",
  pattern = "*",
  callback = function()
    vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]
    -- TODO
    vim.cmd [[syn match ExtraWhitespace /\s\+$\| \+\ze\t/]]
  end,
})
--}}
local function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
end

local function process_yank()
  vim.highlight.on_yank { timeout = 200, on_visual = false }
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

local group_name = "init"
vim.api.nvim_create_augroup(group_name, { clear = true })
aucmd("FileType", { group = group_name, command = "set formatoptions-=o" })
aucmd("TermOpen", { group = group_name, callback = init_term })

aucmd("TextYankPost", {
  desc = "[osc52] Copy to clipboard/OSC52",
  group = group_name,
  callback = process_yank,
})

aucmd({ "BufEnter" }, {
  group = group_name,
  pattern = { "*" },
  callback = function()
    pcall(vim.cmd, [[lcd `=expand('%:p:h')`]])
  end,
})

-- Coding {{{
-- Auto-format *.files prior to saving them{{{
aucmd("BufWritePre", {
  pattern = { "*.go", "*.rs" },
  command = "lua vim.lsp.buf.formatting_sync(nil, 1000)",
})
-- }}}

-- Highlight whitespaces {{{
local extra_whitespace = vim.api.nvim_create_augroup("ExtraWhitespace", { clear = true })
aucmd(
  { "BufNewFile", "BufRead", "InsertLeave" },
  { command = "silent! match ExtraWhitespace /\\s\\+$/", group = extra_whitespace }
)
aucmd({ "InsertEnter" }, {
  command = "silent! match ExtraWhitespace /\\s\\+\\%#\\@<!$/",
  group = extra_whitespace,
})
-- }}}

-- }}}

-- Misc {{{

-- Unset paste on InsertLeave.{{{
-- aucmd("InsertLeave", { command = "silent! set nopaste" })
-- -- }}}

-- remember and go to last position when opening a buffer {{{
aucmd({ "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("LastPosition", { clear = true }),
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
local binary = vim.api.nvim_create_augroup("Binary", { clear = true })
aucmd("BufReadPre", { pattern = { "*.bin", "*.dat" }, command = "let &bin=1", group = binary })
aucmd("BufReadPost", { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd", group = binary })
aucmd("BufReadPost", { pattern = { "*.bin", "*.dat" }, command = "set ft=xxd | endif", group = binary })
aucmd("BufWritePre", { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd -r", group = binary })
aucmd("BufWritePre", { pattern = { "*.bin", "*.dat" }, command = "endif", group = binary })
aucmd("BufWritePost", { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd", group = binary })
aucmd("BufWritePost", { pattern = { "*.bin", "*.dat" }, command = "set nomod | endif", group = binary })
-- }}}

--- WinBar {{{
-- function _G.WinBar()
--   local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
--   local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p")
--   local cwd = string.gsub(vim.loop.cwd(), "([^%w])", "%%%1") -- escape non-word characters
--   path = path:gsub(cwd, ".")
--   path = path:gsub(os.getenv "HOME", "~")
--   local elems = vim.split(path, "/", { trimempty = true })
--   return "%#WinBarPath#" .. table.concat(elems, " %#WinBarSep# %#WinBarPath#") .. " %#WinBar#"
-- end
--
-- vim.opt.winbar = ""
--
-- aucmd("BufWinEnter", {
--   callback = function()
--     local buf = tonumber(vim.fn.expand "<abuf>")
--     local winbar = ""
--     if buf ~= nil then
--       if vim.api.nvim_buf_get_option(buf, "buftype") == "" then
--         winbar = "%!v:lua.WinBar()"
--       end
--       local win = vim.fn.bufwinid(buf)
--       vim.api.nvim_win_set_option(win, "winbar", winbar)
--     end
--   end,
-- })
-- }}}

-- Code Folding {{{
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
  for _group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. _group_name)
    vim.api.nvim_command "autocmd!"
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command "augroup END"
  end
end

local autoCommands = {
  -- other autocommands
  remember_folds = {
    { "BufWinLeave", "?*", "mkview 1" },
    { "BufWinEnter", "?*", "silent! loadview 1" },
  },
}
M.nvim_create_augroups(autoCommands)
-- InLayHints
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
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
-- }}}
