local utils = require "utils"

local servers = {
  "bash-language-server",
  "shfmt",
}

local extra = {
  "shellcheck",
  "ruff",
  "yamlfmt",
  "yamllint",
  "usort",
  "taplo",
  "stylua-ng",
  "typescript-language-server",
  "basedpyright",
  "pyrefly",
}

local os_info = utils.get_os_info()
if os_info.id ~= "openwrt" then
  vim.list_extend(servers, extra)
end

local opts = {
  ensure_installed = servers,
  automatic_installation = true,
  auto_update = false,
  run_on_start = true,
  -- start_delay = 2,
}

return opts
