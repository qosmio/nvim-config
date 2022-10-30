local capabilities = vim.lsp.protocol.make_client_capabilities()
local utils = require "custom.plugins.lsp.utils"

-- YAML
return {
  capabilities = capabilities,
  on_attach = utils.common.on_attach,
  settings = {
    yaml = {
      customTags = {
        -- Home Assistant
        "!secret",
        "!include_dir_named",
        "!include_dir_list",
        "!include_dir_merge_named",
        "!include_dir_merge_list",
        "!lambda",
        "!input",
      },
    },
  },
}
