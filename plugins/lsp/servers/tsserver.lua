local utils     = require('custom.plugins.lsp.utils')
local filetypes = {'javascript', 'css', 'less', 'html', 'json', 'yaml', 'markdown'}

local configs   = {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    utils.common.set_default_formatter_for_filetypes('null-ls', filetypes)
  end
}

return configs
