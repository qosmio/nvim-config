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

-- bootstrap lazy.nvim!
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(vim.g.base46_cache .. "defaults") then
  require("core.bootstrap").lazy(lazypath)
  require "plugins"
  dofile(vim.g.base46_cache .. "defaults")
end

local os_info = u.get_os_info()
if os_info.id == "rhel" then
  if os_info.version >= 8.0 then
    vim.g.python3_host_prog = "/usr/bin/python3.9"
  else
    vim.g.python3_host_prog = "/usr/bin/python3.8"
  end
end

-- local M = require "custom.plugins.lsp.servers"
-- print(vim.inspect(base46.table_to_str(require "custom.highlights")))
require "custom.options"
-- AUTOCMDS
require "custom.autocmds"
