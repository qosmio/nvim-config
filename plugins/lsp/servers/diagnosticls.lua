local configs = {
  on_attach    = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes    = {'tex', 'markdown'},
  init_options = {
    linters   = {
      textidote = {
        command       = 'textidote',
        debounce      = 500,
        args          = {
          '--type',
          'tex',
          '--check',
          'pt_BR',
          '--output',
          'singleline',
          '--no-color'
        },
        offsetLine    = 0,
        offsetColumn  = 0,
        sourceName    = 'textidote',
        formatLines   = 1,
        formatPattern = {
          '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
          {line      = 1, column    = 2, endLine   = 3, endColumn = 4, message   = 5}
        }
      }
    },
    filetypes = {markdown = 'textidote', tex      = 'textidote'}
  }
}

return configs
