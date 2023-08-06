local M = {}
local uv = vim.loop
local function notify(msg, level)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level)
    end)
  else
    vim.notify(msg, level)
  end
end

-----------------------------------------------------------
-- Checks if running under Windows.
-----------------------------------------------------------
function M.is_win()
  if uv.os_uname().version:match "Windows" then
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
  notify(vim.inspect((require("which-key.keys").get_mappings(mod, "", vim.api.nvim_get_current_buf()))))
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

function M.tbl_remove_key(table, key)
  local element = table[key]
  table[key] = nil
  return element
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
      local key, value = line:match "^(%S+)%s*=%s*(.*)"
      if key and value then
        value = value:match "^[\"']?(.-)[\"']?$"
        if key == "NAME" then
          os_info["name"] = value
        elseif key == "VERSION_ID" then
          os_info["version"] = tonumber(value) / 1.0
        elseif key == "ID" then
          os_info["id"] = value
        elseif key == "PRETTY_NAME" then
          os_info["pretty_name"] = value
        end
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

function M.file_exists(file)
  local stat = uv.fs_stat(file)
  return stat ~= nil and stat.type == "file"
end

function M.dir_exists(dir)
  local stat = uv.fs_stat(dir)
  return stat ~= nil and stat.type == "directory"
end

function M.dirlist(dir)
  local items = {}
  if M.dir_exists(dir) then
    local handle = uv.fs_scandir(dir)
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

function M.get_python3_host_prog()
  -- Get the environment path
  local path = vim.env.PATH

  -- Split the path into individual directories
  local path_dirs = vim.split(path, ":")

  -- Find all python3.x executables in the path
  local python3_executables = {}
  for _, dir in ipairs(path_dirs) do
    for _, file in ipairs(M.dirlist(dir)) do
      if file:match "^python3%.%d+$" then
        table.insert(python3_executables, vim.fn.fnamemodify(M.join_paths(dir, file), ":p"))
      end
    end
  end
  -- Sort the list of executables by version number (using a custom comparison function)
  table.sort(python3_executables, function(a, b)
    local a_version = a:match "python3%.(%d+)"
    local b_version = b:match "python3%.(%d+)"
    return tonumber(a_version) > tonumber(b_version)
  end)

  -- Set the "python3_host_prog" global variable to the path to the latest executable
  -- vim.g.python3_host_prog = python3_executables[1]
  return python3_executables[1]
end

--- Update a mason package
-- @param pkg_name string of the name of the package as defined in Mason (Not mason-lspconfig or mason-null-ls)
-- @param auto_install boolean of whether or not to install a package that is not currently installed (default: True)
M.mason = {}

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
      pkg:check_new_version(function(update_available, version)
        if update_available then
          notify(("Mason: Updating %s to %s"):format(pkg.name, version.latest_version))
          pkg:install():on("closed", function()
            notify(("Mason: Updated %s"):format(pkg.name))
          end)
        else
          notify(("Mason: No updates available for %s"):format(pkg.name))
        end
      end)
    end
  end
end

--- Update all packages in Mason
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
    local updated = false
    for _, pkg in ipairs(installed_pkgs) do
      pkg:check_new_version(function(update_available, version)
        if update_available then
          updated = true
          notify(("Mason: Updating %s to %s"):format(pkg.name, version.latest_version))
          pkg:install():on("closed", function()
            running = running - 1
            if running == 0 then
              notify "Mason: Update Complete"
            end
          end)
        else
          running = running - 1
          if running == 0 then
            if updated then
              notify "Mason: Update Complete"
            else
              notify "Mason: No updates available"
            end
          end
        end
      end)
    end
  end
end

return M
