local status_ok, helpers = pcall(require, "null-ls.helpers")
if not status_ok then
  return
end

local methods = require "null-ls.methods"

return helpers.make_builtin {
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
      vim.fn.stdpath "config" .. "/lua/plugins/config/.yamlfix.toml",
      "-",
    },
    to_stdin = true,
  },
  factory = helpers.formatter_factory,
}
