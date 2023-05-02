local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

return h.make_builtin {
  name = "yamlfix",
  meta = {
    url = "https://github.com/lyz-code/yamlfix",
    description = "A simple opinionated yaml formatter that keeps your comments!",
  },
  method = methods.internal.FORMATTING,
  filetypes = {
    "yaml",
  },
  generator_opts = {
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

-- return null_ls.register(h.make_builtin(formatter))
