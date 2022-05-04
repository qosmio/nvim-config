local utils = require('custom.plugins.lsp.utils')
local capabilities = vim.lsp.protocol.make_client_capabilities()

local configs = {
  on_attach = utils.common.on_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities),
  flags = { debounce_text_changes = 250 },
  settings = {
    format = { enable = true },
    Lua = {
      diagnostics = {
        disable = {
          'lowercase-global',
          'undefined-global',
          'unused-local',
          'unused-vararg',
          'trailing-space',
        },
        globals = {
          'vim',
          'use',
          'lowercase-global',
          'undefined-global',
          'unused-local',
          'unused-vararg',
          'trailing-space',
        },
      },
      -- workspace = {
      --   library = vim.api.nvim_get_runtime_file('', true),
      --   -- library = { [vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,},
      --   maxPreload = 10000,
      -- },
      telemetry = { enable = false },
    },
  },
  -- handlers = {
  --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
  -- },
}

return configs
