local utils   = require('custom.plugins.lsp.utils')

local configs = {
  on_attach = function(client, bufnr)
    utils.common.on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
  settings  = {
    Lua = {
      diagnostics = {globals = {'vim', 'use'}},
      workspace   = {
        library    = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        },
        maxPreload = 10000
      },
      telemetry   = {enable = false}
    }
  }
}

return configs
