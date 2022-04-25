local aucmd      = vim.api.nvim_create_autocmd

local ft_aucmd   = function(pattern, ft)
  aucmd({'BufRead', 'BufNewFile', 'BufWinEnter'},
        {pattern = pattern, command = [[set ft=]] .. ft, once    = false})
end

ft_aucmd({
  '*.nginx',
  'nginx*.conf',
  '*nginx.conf',
  '*/etc/nginx/*',
  '*/usr/local/nginx/conf/*',
  '*/nginx/*.conf'
}, 'nginx')

local function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'
end

local function process_yank()
  vim.highlight.on_yank({timeout   = 200, on_visual = false})
  if vim.g.loaded_oscyank == 1 and vim.v.event.operator == 'y' and vim.v.event.regname == '' then
    vim.cmd('OSCYankReg +')
  end
end

local group_name = 'init'
vim.api.nvim_create_augroup(group_name, {clear = true})
vim.api.nvim_create_autocmd('FileType', {group   = group_name, command = 'set formatoptions-=o'})
vim.api.nvim_create_autocmd('TermOpen', {group    = group_name, callback = init_term})
vim.api.nvim_create_autocmd('TextYankPost', {group    = group_name, callback = process_yank})

vim.api.nvim_create_autocmd('BufReadPost', {
  command = [[ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif ]],
  pattern = '*',
  once    = false
})

vim.api.nvim_create_autocmd({'BufEnter'}, {
  group    = group_name,
  pattern  = {'*'},
  callback = function()
    pcall(vim.cmd, [[lcd `=expand('%:p:h')`]])
  end
})

vim.api.nvim_create_autocmd({'VimEnter'}, {
  group    = group_name,
  pattern  = {'*'},
  callback = function()
    if vim.fn.bufname('%') ~= '' then
      return
    end
    local byte = vim.fn.line2byte(vim.fn.line('$') + 1)
    if byte ~= -1 or byte > 1 then
      return
    end
    vim.bo.buftype = 'nofile'
    vim.bo.swapfile = false
    vim.bo.fileformat = 'unix'
  end
})
