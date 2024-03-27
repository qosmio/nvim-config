local status_ok, helpers = pcall(require, "null-ls.helpers")
if not status_ok then
  return
end

local methods = require "null-ls.methods"

return helpers.make_builtin {
  name = "crossplane-ng",
  meta = {
    url = "https://github.com/qosmio/crossplane",
    description = "Quick and reliable way to convert NGINX configurations into JSON and back",
  },
  method = methods.internal.FORMATTING,
  filetypes = {
    "nginx",
  },
  generator_opts = {
    command = "crossplane",
    args = {
      "format",
      "--align",
      "--spacious",
      "-w",
      "$FILENAME",
    },
    -- to_stdin = true,
    to_temp_file = true,
    from_temp_file = true,
  },
  factory = helpers.formatter_factory,
}
