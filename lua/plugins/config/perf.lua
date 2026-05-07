local M = {}

local slow_arches = {
  aarch64 = true,
  arm64 = true,
  armv6l = true,
  armv7l = true,
  armv8l = true,
}

local js_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local js_extensions = {
  js = true,
  jsx = true,
  mjs = true,
  cjs = true,
  ts = true,
  tsx = true,
}

local js_langs = {
  javascript = true,
  jsdoc = true,
  jsx = true,
  tsx = true,
  typescript = true,
}

local function bufname(bufnr)
  bufnr = bufnr or 0
  return vim.api.nvim_buf_get_name(bufnr)
end

local function fs_stat(path)
  local ok, stat = pcall(vim.uv.fs_stat, path)
  if ok then
    return stat
  end
end

function M.host_profile()
  local env_profile = vim.env.NVIM_PERF_PROFILE
  if env_profile and env_profile ~= "" then
    return env_profile
  end

  local ok, utils = pcall(require, "utils")
  local os_info = ok and utils.get_os_info() or nil
  if os_info and os_info.id == "openwrt" then
    return "slow"
  end

  local uname = vim.uv.os_uname()
  if uname.sysname == "Linux" and slow_arches[uname.machine] then
    return "slow"
  end

  return "normal"
end

function M.is_slow_host()
  local profile = M.host_profile()
  return profile == "slow" or profile == "lite" or profile == "minimal"
end

function M.env_enabled(name, default)
  local value = vim.env[name]
  if value == nil or value == "" then
    return default
  end

  value = value:lower()
  return value == "1" or value == "true" or value == "yes" or value == "on"
end

function M.lua_dev_enabled()
  return M.env_enabled("NVIM_LAZYDEV", not M.is_slow_host())
end

function M.file_size(bufnr)
  local name = bufname(bufnr)
  if name == "" then
    return 0
  end

  local stat = fs_stat(name)
  return stat and stat.size or 0
end

function M.is_js_like(bufnr)
  bufnr = bufnr or 0
  if js_filetypes[vim.bo[bufnr].filetype] then
    return true
  end

  local ext = bufname(bufnr):match "%.([^.]+)$"
  return ext and js_extensions[ext] or false
end

function M.project_root(bufnr)
  local name = bufname(bufnr)
  if name == "" then
    return nil
  end

  return vim.fs.root(name, { "biome.json", "biome.jsonc", "package.json", ".git" })
end

function M.biome_config_root(bufnr)
  local name = bufname(bufnr)
  if name == "" then
    return nil
  end

  return vim.fs.root(name, { "biome.json", "biome.jsonc" })
end

function M.is_large_js_project(bufnr)
  if not M.is_js_like(bufnr) then
    return false
  end

  local root = M.project_root(bufnr)
  if not root then
    return false
  end

  local package_stat = fs_stat(root .. "/package.json")
  if package_stat and package_stat.size > 65536 then
    return true
  end

  local node_modules_stat = fs_stat(root .. "/node_modules")
  return package_stat
    and package_stat.size > 32768
    and node_modules_stat
    and node_modules_stat.type == "directory"
end

function M.is_guarded_buffer(bufnr)
  bufnr = bufnr or 0
  return M.file_size(bufnr) > 500000 or M.is_large_js_project(bufnr)
end

function M.disable_treesitter(lang, bufnr)
  if M.file_size(bufnr) > 500000 then
    return true
  end

  return js_langs[lang] and M.is_large_js_project(bufnr)
end

function M.apply_buffer(bufnr)
  bufnr = bufnr or 0
  if not M.is_slow_host() and not M.is_guarded_buffer(bufnr) then
    return
  end

  if M.is_guarded_buffer(bufnr) then
    vim.b[bufnr].nvim_perf_guard = true
    vim.b[bufnr].completion = true

    if M.is_js_like(bufnr) then
      vim.b[bufnr].nvim_large_js_project = M.is_large_js_project(bufnr)
    end
  end

  pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.wo.foldmethod = "manual"
    vim.cmd "syntax sync minlines=128 maxlines=256"
  end)
end

function M.stop_builtin_treesitter(bufnr)
  bufnr = bufnr or 0
  if not M.is_slow_host() and not M.is_guarded_buffer(bufnr) then
    return
  end

  pcall(vim.treesitter.stop, bufnr)
  vim.wo.foldexpr = "0"
end

function M.should_enable_lua_dev(root)
  if not M.lua_dev_enabled() then
    return false
  end

  if not root or root == "" then
    return false
  end

  local config_root = vim.fn.stdpath "config"
  return (root .. "/"):sub(1, #config_root + 1) == config_root .. "/"
end

function M.biome_root_dir(bufnr, on_dir)
  local root = M.biome_config_root(bufnr)
  if not root then
    return
  end

  on_dir(root)
end

return M
