local M = {}

M.setup_lsp = function(attach, capabilities)
  local runtime_path      = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')
  local lspconfig         = require('lspconfig')

  -- lspservers with default config
  local servers           = {'html', 'cssls', 'clangd'}

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      on_attach    = attach,
      capabilities = capabilities,
      flags        = {debounce_text_changes = 150}
    })
  end
  local HOME              = os.getenv('HOME')
  local sumneko_root_path = HOME .. '/.local/share/nvim/lsp_servers/sumneko_lua/extension/server'
  local sumneko_binary    = sumneko_root_path .. '/bin/lua-language-server'

  require('lspconfig').sumneko_lua.setup({
    cmd      = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
    settings = {
      Lua = {
        runtime     = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path    = vim.split(package.path, ';')
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace   = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
          }
        }
      }
    }
  })
end

return M
