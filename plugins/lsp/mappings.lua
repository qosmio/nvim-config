local keymap   = vim.keymap
local lsp      = vim.lsp
local mappings = {}

local opt      = {buffer = 0}

function mappings.setup(client)
  -- if client.resolved_capabilities.document_formatting then
  -- keymap.set("n", "<space>f", vim.lsp.buf.formatting, opt)
  -- elseif client.resolved_capabilities.document_range_formatting then
  -- keymap.set("v", "<space>f", vim.lsp.buf.range_formatting, opt)
  -- end
  -- vim.inspect(_G.print_table(client))
  -- vim.pretty_print(mappings)
  -- vim.pretty_print(client.name)
  keymap.set({'n'}, 'ga', vim.lsp.buf.code_action, opt)
  keymap.set({'v'}, 'ga', ':lua vim.lsp.buf.range_code_action()<cr>', opt)
  keymap.set('n', 'gD', lsp.buf.declaration, opt)
  keymap.set('n', 'gd', lsp.buf.definition, opt)
  keymap.set('n', 'gi', lsp.buf.implementation, opt)
  keymap.set('n', 'gr', lsp.buf.rename, opt)
  keymap.set('n', 'gt', lsp.buf.type_definition, opt)
  keymap.set('n', 'K', vim.lsp.buf.hover, opt)
  keymap.set('n', 'gR', lsp.buf.references, opt)
  keymap.set('n', '<space>ge', ':vim.diagnostic.open_float(0, {scope="line"})<cr>', opt)
  keymap.set('n', '<space>k', vim.lsp.diagnostic.show_line_diagnostics, opt)

  keymap.set('n', '<space>li', ':LspInfo<CR>', opt)
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opt)
  keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt)
  keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opt)
  keymap.set('n', '<space>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
             opt)
  keymap.set('n', '[d', vim.diagnostic.goto_prev, opt)
  keymap.set('n', ']d', vim.diagnostic.goto_next, opt)
  keymap.set('n', '<space>q', vim.diagnostic.setloclist, opt)

  if mappings[client.name] then
    mappings[client.name]()
  end
end

return mappings
