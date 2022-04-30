local utils   = require('custom.plugins.lsp.utils')

local configs = {
  on_attach = function(client, bufnr)
    utils.common.on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
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
