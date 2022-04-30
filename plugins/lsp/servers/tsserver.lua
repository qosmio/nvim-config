local utils     = require('custom.plugins.lsp.utils')
local filetypes = {'javascript', 'css', 'less', 'html', 'json', 'yaml', 'markdown'}

local configs   = {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    utils.common.set_default_formatter_for_filetypes('null-ls', filetypes)
  end
}

return configs
