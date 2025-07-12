local utils = require "utils"

local servers = {
  "ansiblels",
  "basedpyright",
  -- "pyright",
  "bashls",
  -- "beautysh",
  -- "black",
  -- "clangd",
  -- "clang-format",
  -- "cssls",
  "dockerls",
  "docker_compose_language_service",
  -- "eslint_d",
  "biome",
  -- "flake8",
  -- "gh",
  "gopls",
  -- "html",
  -- "helm_ls",
  -- "jq",
  "lua_ls",
  -- "nginx-language-server",
  -- "prettier",
  -- "pylance",
  "ruff",
  -- "shellcheck",
  -- "shellharden",
  -- "shfmt",
  -- "sqlfluff",
  -- "rubocop",
  -- "selene",
  "sqlls",
  -- "sql-formatter",
  -- "stylua",
  "taplo",
  -- "terraformls",
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
    -- "shellcheck",
    -- "shfmt",
    -- "yamlfix",
    "bashls",
    "yamlls",
    -- "pylance",
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
  automatic_enable = {
    exclude = { "clangd", "basedpyright" },
  },
  automatic_installation = {
    exclude = { "clangd" },
  },
  auto_update = true,
  run_on_start = true,
  -- ensure_installed = servers,
  registries = {
    "file:" .. vim.fs.joinpath(vim.fn.stdpath "config", "lua", "registry"),
  },
  -- start_delay = 2,
}
