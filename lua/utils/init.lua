local M = {}
local uv = vim.loop

--- Notify function to handle messages in fast events.
-- @param msg string: The message to display.
-- @param level number: The level of the message.
local function notify(msg, level)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level)
    end)
  else
    vim.notify(msg, level)
  end
end

--- Checks if running under Windows.
-- @return boolean: True if running on Windows, false otherwise.
function M.is_win()
  if uv.os_uname().version:match "Windows" then
    return true
  else
    return false
  end
end

--- Function equivalent to basename in POSIX systems.
-- @param str string: The path string.
-- @return string: The basename of the path.
function M.basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

--- Concatenates given paths with correct separator.
-- @param ... string: Variable arguments of string paths to join.
-- @return string: The concatenated path.
function M.join_paths(...)
  local path_sep = M.is_win() and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

local _base_lua_path = M.join_paths(vim.fn.stdpath "config", "lua")

--- Loads all modules from the given package.
-- @param package string: Name of the package in lua folder.
function M.glob_require(package)
  local glob_path = M.join_paths(_base_lua_path, package, "*.lua")

  for _, path in pairs(vim.split(vim.fn.glob(glob_path), "\n")) do
    local relfilename = path:gsub(_base_lua_path, ""):gsub(".lua", "")
    local basename = M.basename(relfilename)
    if basename ~= "init" and basename:sub(1, 1) ~= "_" then
      require(relfilename)
    end
  end
end

--- Strips trailing whitespaces.
function M.strip_trailing_whitespace()
  if vim.bo.modifiable then
    local line = vim.fn.line "."
    local col = vim.fn.col "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.histdel("/", -1)
    vim.fn.cursor(line, col)
  end
end

--- Toggles windows zoom.
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

--- Dumps the current mappings.
-- @param mod char: Mapping mode (n, v, i, ..)
function M.dump(mod)
  notify(
    vim.inspect((require("which-key.keys").get_mappings(mod, "", vim.api.nvim_get_current_buf())))
  )
end

--- Checks if a string matches any item in a list.
-- @param str string: The string to check.
-- @param list table: The list of items to match against.
-- @return boolean: True if a match is found, false otherwise.
function M.matches(str, list)
  return #vim.tbl_filter(function(item)
    return item == str or string.match(str, item)
  end, list) > 0
end

--- Checks if a string does not match any item in a list.
-- @param str string: The string to check.
-- @param list table: The list of items to match against.
-- @return boolean: True if no match is found, false otherwise.
function M.not_matches(str, list)
  return #vim.tbl_filter(function(item)
    return item ~= str and not string.match(str, item)
  end, list) > 0
end

--- Removes a key from a table.
-- @param table table: The table to remove the key from.
-- @param key any: The key to remove.
-- @return any: The removed element.
function M.tbl_remove_key(table, key)
  local element = table[key]
  table[key] = nil
  return element
end

--- Filters a table in place.
-- @param tbl table: The table to filter.
-- @param filter any: The filter to apply.
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

--- Converts bytes to a human-readable format.
-- @param size number: The size in bytes.
-- @return string: The size in a human-readable format.
function M.bytes_to_human(size)
  local sizes = { "B", "KB", "MB", "GB", "TB" }
  if size == 0 then
    return "0B"
  end
  local i = math.floor(math.log(size) / math.log(1024))
  return string.format("%.1f%s", size / math.pow(1024, i), sizes[i + 1])
end

--- Gets OS information.
-- @return table: A table containing OS information.
function M.get_os_info()
  local os_info = {}
  local os_name = jit and jit.os or "Linux"
  if os_name == "Windows" then
    os_info["os"] = "Windows"
    os_info["version"] = io.popen("ver"):read("*all"):gsub("\n", "")
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
      os_info["version"] = 0
      os_info["name"] = "Linux (unknown version)"
      os_info["id"] = "Linux (unknown version)"
      os_info["pretty_name"] = "Linux (unknown version)"
      os_info["architecture"] = "N/A"
      os_info["memory"] = "N/A"
      os_info["disk"] = "N/A"
      return os_info
    end

    for line in file:lines() do
      local key, value = line:match "^(%S+)%s*=%s*(.*)"
      if key and value then
        value = value:match "^[\"']?(.-)[\"']?$"
        if key == "NAME" then
          os_info["name"] = value
        elseif key == "VERSION_ID" then
          os_info["version"] = value
        elseif key == "ID" then
          os_info["id"] = value
        elseif key == "PRETTY_NAME" then
          os_info["pretty_name"] = value
        end
      end
    end
    file:close()

    os_info["os"] = "Linux"
    local architecture = io.popen("uname -m"):read "*all" or "N/A"
    architecture = architecture:gsub("\n", "")
    os_info["architecture"] = architecture
    local memory = io.popen("free -m"):read "*all" or "N/A"
    memory = memory:match "Mem:%s+(%d+)%s"
    os_info["memory"] = memory .. " MB"
    local disk = io.popen("df -h / | awk 'NR==2 {print $4}'"):read("*all"):gsub("\n", "") or "N/A"
    os_info["disk"] = disk
  elseif os_name == "OSX" then
    os_info["os"] = vim.loop.os_uname().sysname
    os_info["version"] = vim.loop.os_uname().release
    os_info["name"] = "macOS"
    os_info["id"] = "macos"
    local os_version = io.popen("sw_vers -productVersion"):read("*all"):gsub("\n", "") or "N/A"
    os_info["pretty_name"] = "macOS " .. os_version
    os_info["architecture"] = vim.loop.os_uname().machine
    local memsize = tonumber(io.popen("sysctl -n hw.memsize"):read("*all"):gsub("\n", "") or 0)
    os_info["memory"] = M.bytes_to_human(memsize)
    os_info["disk"] = io.popen("df -h / | awk 'NR==2 {print $4}'"):read("*all"):gsub("\n", "")
      or "N/A"
  end
  return os_info
end

--- Checks if a file exists.
-- @param file string: The file path.
-- @return boolean: True if the file exists, false otherwise.
function M.file_exists(file)
  local stat = uv.fs_stat(file)
  return stat ~= nil and stat.type == "file"
end

--- Checks if a directory exists.
-- @param dir string: The directory path.
-- @return boolean: True if the directory exists, false otherwise.
function M.dir_exists(dir)
  local stat = uv.fs_stat(dir)
  return stat ~= nil and stat.type == "directory"
end

--- Lists the contents of a directory.
-- @param dir string: The directory path.
-- @return table: A table containing the directory contents.
function M.dirlist(dir)
  local items = {}
  if M.dir_exists(dir) then
    local handle = uv.fs_scandir(dir)
    if not handle then
      return items
    end
    while true do
      local item = uv.fs_scandir_next(handle)
      if item ~= nil then
        table.insert(items, item)
      else
        goto last
      end
    end
    ::last::
  end
  return items
end

--- Gets the path to the Python 3 host program.
-- @param opts table: Options to exclude certain paths.
-- @return string: The path to the Python 3 host program.
function M.get_python3_host_prog(opts)
  local path = vim.env.PATH
  local path_dirs = vim.split(path, ":")
  local python3_executables = {}
  for _, dir in ipairs(path_dirs) do
    for _, file in ipairs(M.dirlist(dir)) do
      if
        file:match "^python3%.%d+$"
        and (not opts or not opts.exclude or not file:match(opts.exclude))
      then
        table.insert(python3_executables, vim.fn.fnamemodify(M.join_paths(dir, file), ":p"))
      end
    end
  end
  table.sort(python3_executables, function(a, b)
    local a_version = a:match "python3%.(%d+)"
    local b_version = b:match "python3%.(%d+)"
    return tonumber(a_version) > tonumber(b_version)
  end)
  return python3_executables[1]
end

--- Gets the current Python package paths.
-- @return table: A table containing the current Python package paths.
function M.get_current_python_package_paths()
  local python_bin = M.get_python3_host_prog()
  if not python_bin then
    return {}
  end
  local current_python_path =
    vim.fn.system { python_bin, "-c", "import sys; print(':'.join(sys.path), end='')" }
  local split_paths = vim.fn.split(current_python_path, ":")
  local paths = {}
  for _, path in ipairs(split_paths) do
    if not vim.tbl_contains(paths, path) and "" ~= path then
      table.insert(paths, path)
    end
  end
  return paths
end

M.mason = {}

--- Installs a Mason package.
--- @param pkg Package
--- @param is_update boolean: Whether the package is being updated.
function M.install_package(pkg, is_update)
  vim.notify(("Mason: %s '%s'"):format(is_update and "updating" or "installing", pkg.name))
  pkg:once(
    "install:success",
    vim.schedule_wrap(function()
      vim.notify(("Mason: %s '%s'"):format(is_update and "updated" or "installed", pkg.name))
    end)
  )
  pkg:once(
    "install:failed",
    vim.schedule_wrap(function()
      vim.notify(
        ("Mason: failed to %s '%s'"):format(is_update and "update" or "install", pkg.name),
        vim.log.levels.ERROR
      )
    end)
  )

  pkg:install()
end

--- Updates a Mason package.
-- @param pkg_name string: The name of the package as defined in Mason.
-- @param auto_install boolean: Whether to install a package that is not currently installed (default: true).
function M.mason.update(pkg_name, auto_install)
  if auto_install == nil then
    auto_install = true
  end
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    vim.api.nvim_err_writeln "Unable to access mason registry"
    return
  end

  local pkg_avail, pkg = pcall(registry.get_package, pkg_name)
  if not pkg_avail then
    notify(("Mason: %s is not available"):format(pkg_name), "error")
  else
    if not pkg:is_installed() then
      if auto_install then
        notify(("Mason: Installing %s"):format(pkg.name))
        pkg:install()
      else
        notify(("Mason: %s not installed"):format(pkg.name), "warn")
      end
    else
      local latest = pkg:get_latest_version()
      if latest ~= pkg:get_installed_version() then
        M.install_package(pkg_name, true)
      end
    end
  end
end

--- Updates all packages in Mason.
function M.mason.update_all()
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    vim.api.nvim_err_writeln "Unable to access mason registry"
    return
  end

  local installed_pkgs = registry.get_installed_packages()
  local running = #installed_pkgs
  local no_pkgs = running == 0
  notify "Mason: Checking for package updates..."

  if no_pkgs then
    notify "Mason: No updates available"
  else
    for _, pkg in ipairs(installed_pkgs) do
      local latest = pkg:get_latest_version()
      if latest ~= pkg:get_installed_version() then
        M.install_package(pkg, true)
      end
    end
  end
end

return M
