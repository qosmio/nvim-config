--[[ Utility functions for working with nvim configuaration.

The module is stored in the `core` package in order to minimize the chance of naming clashing
--]]
local M = {}

-----------------------------------------------------------
-- Checks if running under Windows.
-----------------------------------------------------------
function M.is_win()
  if vim.loop.os_uname().version:match "Windows" then
    return true
  else
    return false
  end
end

-----------------------------------------------------------
-- Function equivalent to basename in POSIX systems.
-- @param str the path string.
-----------------------------------------------------------
function M.basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

-----------------------------------------------------------
-- Contatenates given paths with correct separator.
-- @param: var args of string paths to joon.
-----------------------------------------------------------
function M.join_paths(...)
  local path_sep = M.is_win() and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

local _base_lua_path = M.join_paths(vim.fn.stdpath "config", "lua")

-----------------------------------------------------------
-- Loads all modules from the given package.
-- @param package: name of the package in lua folder.
-----------------------------------------------------------
function M.glob_require(package)
  local glob_path = M.join_paths(_base_lua_path, package, "*.lua")

  for _, path in pairs(vim.split(vim.fn.glob(glob_path), "\n")) do
    -- convert absolute filename to relative
    -- ~/.config/nvim/lua/<package>/<module>.lua => <package>/foo
    local relfilename = path:gsub(_base_lua_path, ""):gsub(".lua", "")
    local basename = M.basename(relfilename)
    -- skip `init` and files starting with underscore.
    if basename ~= "init" and basename:sub(1, 1) ~= "_" then
      require(relfilename)
    end
  end
end

-----------------------------------------------------------
-- Strips trailing whitespaces.
-----------------------------------------------------------
function M.strip_trailing_whitespace()
  if vim.bo.modifiable then
    local line = vim.fn.line "."
    local col = vim.fn.col "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.histdel("/", -1)
    vim.fn.cursor(line, col)
  end
end

-----------------------------------------------------------
-- Toggles windows zoom.
-----------------------------------------------------------
function M.zoom_toggle()
  if vim.t.zoomed and vim.t.zoom_winrestcmd then
    vim.cmd(vim.t.zoom_winrestcmd)
    vim.t.zoomed = false
  else
    vim.t.zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd "resize | vertical resize"
    vim.t.zoomed = true
  end
end

-- @param mod char: mapping mode (n, v, i, ..)
-- @param buffer num: buffer id
function M.dump(mod)
  vim.notify(vim.inspect((require("which-key.keys").get_mappings(mod, "", vim.api.nvim_get_current_buf()))))
end

function M.matches(str, list)
  return #vim.tbl_filter(function(item)
    return item == str or string.match(str, item)
  end, list) > 0
end

function M.not_matches(str, list)
  return #vim.tbl_filter(function(item)
    return item ~= str and not string.match(str, item)
  end, list) > 0
end

function M.tbl_filter_inplace(tbl, filter)
  local i = 1
  while i <= #tbl do
    local item_found = false
    if type(filter) == "table" then
      for j = 1, #filter do
        if tbl[i] == filter[j] then
          item_found = true
          break
        end
      end
    elseif tbl[i] == filter then
      item_found = true
    end
    if item_found then
      table.remove(tbl, i)
    else
      i = i + 1
    end
  end
end

function M.get_os_info()
  local os_info = {}
  local os_name = jit and jit.os or "Linux"
  if os_name == "Windows" then
    os_info["os"] = "Windows"
    os_info["version"] = "N/A"
    os_info["name"] = "Windows"
    os_info["id"] = "Windows"
    os_info["pretty_name"] = "Windows"
    os_info["architecture"] = "N/A"
    os_info["memory"] = "N/A"
    os_info["disk"] = "N/A"
  elseif os_name == "Linux" then
    local file = io.open("/etc/os-release", "r")
    if not file then
      os_info["os"] = "Linux"
      os_info["version"] = "N/A"
      os_info["name"] = "Linux (unknown version)"
      os_info["id"] = "Linux (unknown version)"
      os_info["pretty_name"] = "Linux (unknown version)"
      os_info["architecture"] = "N/A"
      os_info["memory"] = "N/A"
      os_info["disk"] = "N/A"
      return os_info
    end

    for line in file:lines() do
      local key, value = line:match '^([^=]+)="(.*)"$'
      if key == "NAME" then
        os_info["name"] = value
      elseif key == "VERSION_ID" then
        os_info["version"] = tonumber(value)/1.0
      elseif key == "ID" then
        os_info["id"] = value
      elseif key == "PRETTY_NAME" then
        os_info["pretty_name"] = value
      end
    end
    file:close()

    os_info["os"] = "Linux"
    local architecture = io.popen("uname -m"):read "*all"
    architecture = architecture:gsub("\n", "")
    os_info["architecture"] = architecture
    local memory = io.popen("free -m"):read "*all"
    memory = memory:match "Mem:%s+(%d+)%s"
    os_info["memory"] = memory .. " MB"
    local disk = io.popen("df -h / | awk 'NR==2 {print $4}'"):read "*all"
    disk = disk:gsub("\n", "")
    os_info["disk"] = disk
  elseif os_name == "OSX" then
    os_info["os"] = "macOS"
    os_info["version"] = "N/A"
    os_info["name"] = "macOS"
    os_info["id"] = "macOS"
    os_info["pretty_name"] = "macOS"
    os_info["architecture"] = "N/A"
    os_info["memory"] = "N/A"
    os_info["disk"] = "N/A"
  end
  return os_info
end

return M
