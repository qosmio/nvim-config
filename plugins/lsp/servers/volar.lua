local utils        = require('custom.plugins.lsp.utils')
local filetypes    = {'javascriptreact', 'typescriptreact', 'vue'}
local init_options = {
  documentFeatures = {
    documentColor      = false,
    documentFormatting = {defaultPrintWidth = 100},
    documentSymbol     = true,
    foldingRange       = true,
    linkedEditingRange = true,
    selectionRange     = true
  },
  languageFeatures = {
    callHierarchy         = true,
    codeAction            = true,
    codeLens              = true,
    completion            = {defaultAttrNameCase = 'kebabCase', defaultTagNameCase  = 'both'},
    definition            = true,
    diagnostics           = true,
    documentHighlight     = true,
    documentLink          = true,
    hover                 = true,
    implementation        = true,
    references            = true,
    rename                = true,
    renameFileRefactoring = true,
    schemaRequestService  = true,
    semanticTokens        = false,
    signatureHelp         = true,
    typeDefinition        = true
  },
  typescript       = {serverPath = ''}
}
local configs      = {
  init_options = init_options,
  on_attach    = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.document_range_formatting = true
    utils.common.set_default_formatter_for_filetypes('volar', filetypes)
  end
}

return configs
