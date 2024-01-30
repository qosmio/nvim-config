local utils = require "custom.utils"

local servers = {
  "ansiblels",
  "bashls",
  -- "beautysh",
  -- "black",
  "clangd",
  -- "clang-format",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  -- "eslint_d",
  "eslint",
  -- "flake8",
  -- "gh",
  "gopls",
  "html",
  "helm_ls",
  -- "jq",
  "jsonls",
  "lua_ls",
  -- "nginx-language-server",
  -- "prettier",
  -- "pylance",
  "ruff_lsp",
  "rust_analyzer",
  -- "shellcheck",
  -- "shellharden",
  -- "shfmt",
  -- "sqlfluff",
  -- "rubocop",
  "sqlls",
  -- "sql-formatter",
  -- "stylua",
  "taplo",
  "tsserver",
  "terraformls",
  "vimls",
  -- "xmlformatter",
  -- "yamlfmt",
  -- "yamlfix",
  "yamlls",
  -- "yamllint",
  -- "yapf"
}

-- vim.print(vim.loop)
if vim.loop.os_uname().machine == "aarch64" then
  servers = {
    "lua_ls",
    "jsonls",
    -- "shellcheck",
    -- "shfmt",
    -- "yamlfix",
    "bashls",
    "yamlls",
    "tsserver",
    -- "pylance",
    "html",
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
  automatic_installation = {
    exclude = { "clangd" },
  },
  auto_update = true,
  run_on_start = true,
  -- start_delay = 2,
}
