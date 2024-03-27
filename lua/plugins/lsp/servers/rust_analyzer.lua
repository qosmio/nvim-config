local settings = require "plugins.lsp.settings"
local utils = require "plugins.lsp.utils"

local configs = {
  on_attach = function(client, bufnr)
    settings.on_attach(client, bufnr)
    utils.autocmds.InlayHintsAU()
  end,
}

return configs
