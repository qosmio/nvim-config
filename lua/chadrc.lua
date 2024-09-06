---@class ChadrcConfig
local M = {}
local utils = require "utils"

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
  -- "helm_ls",
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
  "vtsls",
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
    "jsonls",
    -- "shellcheck",
    -- "shfmt",
    -- "yamlfix",
    "bashls",
    "yamlls",
    "vtsls",
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

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl_override = require("highlights.hlo").highlight,
  hl_add = require("highlights.hlo").highlight,
  theme_toggle = { "onedark-deep", "onedark-deep" },
  theme = "onedark-deep", -- default theme
  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default",             -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "darker_black", -- only applicable for "default" style, use color names from base30 variables
    -- selected_item_bg = "colored",  -- colored / simple
  },

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    -- order = nil,
    -- modules = nil,
  },

  -- tabufline = {
  --   enabled = true,
  --   lazyload = true,
  --   order = { "treeOffset", "buffers", "tabs", "btns" },
  --   modules = nil,
  -- },

  lsp = { signature = true },
  mason = { cmd = true, pkgs = servers },
}

return M
