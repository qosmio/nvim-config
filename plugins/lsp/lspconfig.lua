local servers = {
  "awk-language-server",
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
  "gopls",
  "html-lsp",
  "jq",
  "json-lsp",
  "nginx-language-server",
  "perlnavigator",
  "prettier",
  "pylance",
  "reorder-python-imports",
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
  "vim-language-server",
  "xmlformatter",
  "yamlfmt",
  "yaml-language-server",
  "yamllint",
  "yapf",
}

if vim.loop.os_uname().machine == "aarch64" then
  servers = {
    "json-lsp",
    "shellcheck",
    "shfmt",
    "bash-language-server",
    "yaml-language-server",
    "typescript-language-server",
    "pylance",
    "html-lsp",
  }
end

-- utils.tbl_filter_inplace(servers, delay)

return {
  ensure_installed = servers,
  automatic_installation = true,
  auto_update = true,
}
