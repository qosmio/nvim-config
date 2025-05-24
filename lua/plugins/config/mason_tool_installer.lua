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
  auto_update = false,
  run_on_start = true,
  -- start_delay = 2,
}

return opts
