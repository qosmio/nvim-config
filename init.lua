local utils = require "custom.utils"
package.path = utils.join_paths(vim.fn.stdpath "config", "lua", "custom", "plugins", "?.lua") .. ";" .. package.path
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
