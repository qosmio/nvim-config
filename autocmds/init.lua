local aucmd = vim.api.nvim_create_autocmd

local ft_aucmd = function(pattern, ft)
  aucmd({ "BufRead", "BufNewFile", "BufWinEnter" }, { pattern = pattern, command = [[set ft=]] .. ft, once = false })
end

ft_aucmd({
  "*.nginx",
  "nginx*.conf",
  "*nginx.conf",
  "*/etc/nginx/*",
  "*/usr/local/nginx/conf/*",
  "*/nginx/*.conf",
}, "nginx")

local function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
end

local function process_yank()
  vim.highlight.on_yank { timeout = 200, on_visual = false }
  if vim.g.loaded_oscyank == 1 and vim.v.event.operator == "y" and vim.v.event.regname == "" then
    vim.cmd "OSCYankReg +"
  end
end

local group_name = "init"
vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd("FileType", { group = group_name, command = "set formatoptions-=o" })
vim.api.nvim_create_autocmd("TermOpen", { group = group_name, callback = init_term })
vim.api.nvim_create_autocmd("TextYankPost", { group = group_name, callback = process_yank })

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   command = [[ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif ]],
--   pattern = "*",
--   once = false,
-- })

-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--   group = group_name,
--   pattern = { '*' },
--   callback = function()
--     pcall(vim.cmd, [[lcd `=expand('%:p:h')`]])
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   group = group_name,
--   pattern = { "*" },
--   callback = function()
--     if os.getenv "LC_TERMINAL" == "shelly" then
--       vim.cmd [[
--       if has('termguicolors')
--         let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--         let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
--         set termguicolors
--       endif ]]
--       -- vim.opt.termguicolors = false
--       vim.cmd [[ colo monokai-phoenix ]]
--     end
--     -- opt.termguicolors = true
--     if vim.fn.bufname "%" ~= "" then
--       return
--     end
--     local byte = vim.fn.line2byte(vim.fn.line "$" + 1)
--     if byte ~= -1 or byte > 1 then
--       return
--     end
--     vim.bo.buftype = "nofile"
--     vim.bo.swapfile = false
--     vim.bo.fileformat = "unix"
--   end,
-- })

-- Coding {{{
-- Auto-format *.files prior to saving them{{{
-- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = "lua vim.lsp.buf.formatting_sync(nil, 1000)" })
-- }}}

-- Highlight whitespaces {{{
local extra_whitespace = vim.api.nvim_create_augroup("ExtraWhitespace", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead", "InsertLeave" },
  { command = "silent! match ExtraWhitespace /\\s\\+$/", group = extra_whitespace }
)
vim.api.nvim_create_autocmd(
  { "InsertEnter" },
  { command = "silent! match ExtraWhitespace /\\s\\+\\%#\\@<!$/", group = extra_whitespace }
)
-- }}}

-- }}}

-- Folds with marker in given file types {{{
local mark_fold = vim.api.nvim_create_augroup("FoldMaker", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "vim", "zsh" },
  command = [[setlocal foldmethod=marker foldlevel=0]],
  group = mark_fold,
})
-- }}}

-- Misc {{{

-- Unset paste on InsertLeave.{{{
vim.api.nvim_create_autocmd("InsertLeave", { command = "silent! set nopaste" })
-- }}}

-- go to last position when opening a buffer {{{
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
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
local function setupWrapping()
  vim.w.wrap = true
  vim.bo.wm = 2
  vim.bo.textwidth = 79
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt" },
  callback = function()
    vim.schedule(setupWrapping)
  end,
})
-- }}}

-- }}}

-- Additional File opens {{{

-- open images with nsxiv
vim.api.nvim_create_autocmd(
  "BufEnter",
  { pattern = { "*.png", "*.jpg", "*.gif" }, command = [[exec "!nsxiv ".expand("%") | :bw]] }
)

-- edit hex for bins - edit binary using xxd-format {{{
local binary = vim.api.nvim_create_augroup("Binary", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", { pattern = { "*.bin", "*.dat" }, command = "let &bin=1", group = binary })
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd", group = binary }
)
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { pattern = { "*.bin", "*.dat" }, command = "set ft=xxd | endif", group = binary }
)
vim.api.nvim_create_autocmd(
  "BufWritePre",
  { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd -r", group = binary }
)
vim.api.nvim_create_autocmd("BufWritePre", { pattern = { "*.bin", "*.dat" }, command = "endif", group = binary })
vim.api.nvim_create_autocmd(
  "BufWritePost",
  { pattern = { "*.bin", "*.dat" }, command = "if &bin | %!xxd", group = binary }
)
vim.api.nvim_create_autocmd(
  "BufWritePost",
  { pattern = { "*.bin", "*.dat" }, command = "set nomod | endif", group = binary }
)
-- }}}

-- }}}
