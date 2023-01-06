local u = require "custom.utils"
local plugins = u.join_paths(vim.fn.stdpath "config", "lua", "custom", "plugins")
package.path = u.join_paths(plugins, "?.lua") .. ";" .. package.path
package.path = u.join_paths(plugins, "?", "init.lua") .. ";" .. package.path
package.path = u.join_paths(plugins, "lsp", "?.lua") .. ";" .. package.path
-- local base46 = require "base46"
-- print(vim.inspect(base46))

function _G.pprint(data)
  vim.pretty_print(data)
end

function _G.write(fun, file)
  local m = assert(io.open(file, "wb"))
  if type(fun) == "function" then
    assert(m:write(string.dump(fun)))
  else
    assert(m:write(vim.inspect(fun)))
  end
  assert(m:close())
  vim.notify("wrote " .. type(fun) .. " to " .. file)
end

function _G.check_vim_option(option, value)
  if vim.opt[option] ~= nil then
    -- if M.clean(_value) == M.clean(value) then
    if value ~= vim.opt[option]._value then
      print("opt." .. option .. " = " .. tostring(vim.opt[option]._value) .. " -- " .. tostring(value))
    end
    -- print(string.format("%s=%s -- %s", option, opt[option]._value, value))
  end
  -- vim.cmd("set " .. option)
  -- end
end

-- local M = require "custom.plugins.lsp.servers"
-- print(vim.inspect(base46.table_to_str(require "custom.highlights")))
require "custom.options"
-- AUTOCMDS
require "custom.autocmds"
