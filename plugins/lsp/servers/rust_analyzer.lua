local utils   = require('custom.plugins.lsp.utils')

local configs = {
  on_attach = function(client, bufnr)
    utils.common.on_attach(client, bufnr)
    utils.autocmds.InlayHintsAU()
  end
}

return configs
