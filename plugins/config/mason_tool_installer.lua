local utils = require "custom.utils"

local servers = {
  "pylance",
  "ansiblelint",
  "shellcheck",
  "yamllint",
  "eslint_d",
  "perlimports",
  "sqlfluff",
  "cmakelang",
  "yamlfmt",
  "usort",
  "taplo",
  "ruff",
  "beautysh",
  "shfmt",
  "black",
  "stylua",
}

_ = vim.fn.system "which go"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "gopls")
end
_ = vim.fn.system "which cargo"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "shellharden")
end

return {
  ensure_installed = servers,
  automatic_installation = true,
  auto_update = true,
  run_on_start = true,
  start_delay = 2,
}
