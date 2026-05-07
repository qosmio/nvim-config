local M = {}

--- Filters a list in place by removing matching values.
---@param tbl table
---@param filter any
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

local function read_os_release()
  local info = {}
  local file = io.open("/etc/os-release", "r")
  if not file then
    return info
  end

  for line in file:lines() do
    local key, value = line:match "^(%S+)%s*=%s*(.*)"
    if key and value then
      info[key] = value:match "^[\"']?(.-)[\"']?$"
    end
  end
  file:close()

  return info
end

--- Gets the small OS surface used by config conditionals.
---@return table
function M.get_os_info()
  local uname = vim.uv.os_uname()
  local os_name = jit and jit.os or uname.sysname

  if os_name == "Windows" then
    return {
      os = "Windows",
      name = "Windows",
      id = "windows",
      pretty_name = "Windows",
      version = uname.release,
      architecture = uname.machine,
    }
  end

  if os_name == "OSX" then
    return {
      os = uname.sysname,
      name = "macOS",
      id = "macos",
      pretty_name = "macOS",
      version = uname.release,
      architecture = uname.machine,
    }
  end

  local release = read_os_release()
  return {
    os = "Linux",
    name = release.NAME or "Linux",
    id = release.ID or "linux",
    pretty_name = release.PRETTY_NAME or release.NAME or "Linux",
    version = release.VERSION_ID or uname.release,
    architecture = uname.machine,
  }
end

return M
