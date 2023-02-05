local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end
local h = require "null-ls.helpers"
local cmd_resolver = require "null-ls.helpers.command_resolver"
local methods = require "null-ls.methods"
local u = require "null-ls.utils"

local FORMATTING = methods.internal.FORMATTING

local formatter = {
  name = "prettier_d",
  meta = {
    url = "https://www.npmjs.com/package/@cjting/prettier_d",
    description = "prettier, as a daemon, for ludicrous formatting speed.",
  },
  method = FORMATTING,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "css",
    "scss",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "markdown.mdx",
    "graphql",
    "handlebars",
  },
  generator = null_ls.formatter {
    command = "prettier_d",
    args = {
      "--config-path",
      vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.prettierrc.json",
      "--stdin",
      "$FILENAME",
    },
    dynamic_command = cmd_resolver.from_node_modules(),
    to_stdin = true,
    cwd = h.cache.by_bufnr(function(params)
      return u.root_pattern(
        -- https://prettier.io/docs/en/configuration.html
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.toml",
        "prettier.config.js",
        "prettier.config.cjs",
        "package.json"
      )(params.bufname)
    end),
  },
}
-- h.make_builtin(formatter)
local M = {}
M.setup = function()
  _G.write(formatter, "/tmp/l.lua")
  -- local f = null_ls.validate_and_transform(formatter)
  -- write(f, "/tmp/f.lua")
  -- null_ls.register(f)
  null_ls.register(formatter)
  -- write(null_ls.get_all(), "/tmp/null.lua")
end
return M
