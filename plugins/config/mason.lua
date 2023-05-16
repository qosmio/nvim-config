local utils = require "custom.utils"

local servers = {
  "ansible-language-server",
  "bash-language-server",
  "beautysh",
  "black",
  "clangd",
  "clang-format",
  "css-lsp",
  "dockerfile-language-server",
  "eslint_d",
  "eslint-lsp",
  "flake8",
  "gh",
  "gopls",
  "html-lsp",
  "jq",
  "json-lsp",
  "lua-language-server",
  "nginx-language-server",
  "perlnavigator",
  "prettier",
  "pylance",
  "rust-analyzer",
  "rustfmt",
  "shellcheck",
  "shellharden",
  "shfmt",
  "sqlfluff",
  "sql-formatter",
  "stylua",
  "taplo",
  "typescript-language-server",
  "terraform-ls",
  "vim-language-server",
  "xmlformatter",
  "yamlfmt",
  "yamlfix",
  "yaml-language-server",
  "yamllint",
  "yapf",
}

if vim.loop.os_uname().machine == "aarch64" then
  servers = {
    "lua-language-server",
    "json-lsp",
    "shellcheck",
    "shfmt",
    "yamlfix",
    "bash-language-server",
    "yaml-language-server",
    "typescript-language-server",
    "pylance",
    "html-lsp",
  }
end

_ = vim.fn.system "which go"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "gopls")
end
_ = vim.fn.system "which cargo"
if vim.v.shell_error ~= 0 then
  utils.tbl_filter_inplace(servers, "shellharden")
end

return {
  log_level = vim.log.levels.WARN,
  ensure_installed = servers,
  automatic_installation = true,
  auto_update = true,
  run_on_start = true,
  -- start_delay = 2,
}
