local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local FORMATTING = methods.internal.FORMATTING

local formatter = {
  name = "yamlfix",
  meta = {
    url = "https://github.com/lyz-code/yamlfix",
    description = "A simple opinionated yaml formatter that keeps your comments!",
  },
  method = FORMATTING,
  filetypes = {
    "yaml",
  },
  generator = null_ls.formatter {
    command = "yamlfix",
    args = {
      "--config-file",
      vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.yamlfix.toml",
      "-",
    },
    to_stdin = true,
  },
  factory = h.formatter_factory,
}

local M = {}

M.setup = function()
  null_ls.register(formatter)
  h.make_builtin(formatter)
end
return M
