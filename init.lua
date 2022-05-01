-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- This is an example init file in /lua/custom/
-- this init.lua can load stuffs etc too so treat it like your ~/.config/nvim/
-- vim.g.did_load_filetypes = 1
if vim.fn.has('mac') == 1 then
  vim.fn.setenv('CC', 'gcc-11')
end

-- MAPPINGS
require('custom.mappings')
-- OPTIONS
require('custom.options')
-- AUTOCMDS
require('custom.autocmds')
