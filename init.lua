local utils = require "custom.utils"
package.path = utils.join_paths(vim.fn.stdpath "config", "lua", "custom", "plugins", "?.lua") .. ";" .. package.path
-- print(utils.join_paths(vim.fn.stdpath "config", "lua", "custom", "plugins", "?.lua"))
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- This is an example init file in /lua/custom/
-- this init.lua can load stuffs etc too so treat it like your ~/.config/nvim/
-- vim.g.did_load_filetypes = 1
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
-- local M = require "custom.plugins.lsp.servers"
require "custom.options"
-- AUTOCMDS
require "custom.autocmds"
