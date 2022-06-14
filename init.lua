-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- This is an example init file in /lua/custom/
-- this init.lua can load stuffs etc too so treat it like your ~/.config/nvim/
-- vim.g.did_load_filetypes = 1
if vim.fn.has "mac" == 1 then
  vim.fn.setenv("CC", "gcc-11")
end
-- local M = {}
--
-- function M.clean(s)
--   ---if s it not nil, strip leading and trailing whitespace
--   if s == nil then
--     return s
--   end
--   return s:match "^%s*(.-)%s*$"
-- end
--
-- function M.check_vim_option(option, value)
--   if opt[option] ~= nil then
--     -- if M.clean(_value) == M.clean(value) then
--     if value ~= opt[option]._value then
--       print("opt." .. option .. " = " .. tostring(opt[option]._value) .. " -- " .. tostring(value))
--     end
--     -- print(string.format("%s=%s -- %s", option, opt[option]._value, value))
--   end
--   -- vim.cmd("set " .. option)
--   -- end
-- end
-- require('custom.options')
-- AUTOCMDS
require "custom.autocmds"
local present, ft = pcall(require, "Comment.ft")

if not present then
  return
end
-- set the default comment char to be '#'
ft.set("", "#%s")
ft.set("txt", "#%s")
ft.set("samba", "#%s")
