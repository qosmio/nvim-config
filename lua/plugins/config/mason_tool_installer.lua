local utils = require "utils"

local servers = {
  -- "pylance",
  "shellcheck",
  "shfmt",
}

local extra = {
  "ruff",
  "yamlfmt",
  "yamllint",
  "usort",
  "taplo",
  "stylua",
}

local os_info = utils.get_os_info()
if os_info.id ~= "openwrt" then
  vim.list_extend(servers, extra)
  if (os_info.id == "rhel" and not tonumber(os_info.version) < 9) or os_info.id ~= "rhel" then
    table.insert(servers, "selene")
  end
end

_ = vim.fn.system "which go"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "gopls")
end
_ = vim.fn.system "which cargo"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "shellharden")
end

local opts = {
  ensure_installed = servers,
  automatic_installation = true,
  auto_update = true,
  run_on_start = true,
  start_delay = 2,
}

return opts
