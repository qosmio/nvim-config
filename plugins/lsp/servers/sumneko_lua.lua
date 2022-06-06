local utils = require "custom.plugins.lsp.utils"

local configs = {
  on_attach = utils.common.on_attach,
  flags = { debounce_text_changes = 250 },
  settings = {
    format = { enable = true },
    Lua = {
      diagnostics = {
        disable = {
          "lowercase-global",
          "undefined-global",
          "unused-local",
          "unused-vararg",
          "trailing-space",
        },
        globals = {
          "vim",
          "use",
          "lowercase-global",
          "undefined-global",
          "unused-local",
          "unused-vararg",
          "trailing-space",
        },
      },
      telemetry = { enable = false },
    },
  },
}

return configs
