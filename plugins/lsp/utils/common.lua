local autocmds = require('custom.plugins.lsp.utils.autocmds')
local mappings = require('custom.plugins.lsp.mappings')

M = {}

M.set_contains = function(set, val)
  for _, value in pairs(set) do
    if value == val then
      return true
    end
  end
  return false
end

M.set_default_formatter_for_filetypes = function(language_server_name, filetypes)
  if not M.set_contains(filetypes, vim.bo.filetype) then
    return
  end

  local active_servers = {}

  vim.lsp.for_each_buffer_client(0, function(client)
    table.insert(active_servers, client.config.name)
  end)

  if not M.set_contains(active_servers, language_server_name) then
    return
  end

  vim.lsp.for_each_buffer_client(0, function(client)
    if client.name ~= language_server_name then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end)
end

M.on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  mappings.setup(client)

  if client.server_capabilities.definitionProvider then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
  end

  if client.server_capabilities.documentHighlightProvider then
    autocmds.DocumentHighlightAU()
  end

  if client.server_capabilities.documentFormattingProvider then
    autocmds.DocumentFormattingAU()
  end
end

return M
