local u = require "custom.utils"

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

vim.g.python3_host_prog = u.get_python3_host_prog { exclude = "python3.12" } or vim.g.python3_host_prog
-- print(vim.inspect(base46.table_to_str(require "custom.highlights")))
require "custom.options"
-- AUTOCMDS
require "custom.autocmds"
