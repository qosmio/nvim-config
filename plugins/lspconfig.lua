local set_contains = require('custom.utils.set_contains').set_contains

local M            = {}
M.set_default_formatter_for_filetypes = function(language_server_name, filetypes)
  if not set_contains(filetypes, vim.bo.filetype) then
    return
  end

  local active_servers = {}

  vim.lsp.for_each_buffer_client(0, function(client)
    table.insert(active_servers, client.config.name)
  end)

  if not set_contains(active_servers, language_server_name) then
    return
  end

  vim.lsp.for_each_buffer_client(0, function(client)
    if client.name ~= language_server_name then
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end)
end

-- inside on_attach function
M.setup_lsp = function(attach, capabilities)
  local lsp_installer = require('nvim-lsp-installer')
  local map           = vim.api.nvim_buf_set_keymap

  lsp_installer.settings({
    -- log_level = vim.log.levels.DEBUG,
    ui        = {
      icons = {server_installed   = '﫟', server_pending     = '', server_uninstalled = '✗'}
    }
  })

  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach    = attach,
      capabilities = capabilities,
      flags        = {debounce_text_changes = 250},
      settings     = {
        format = {enable = true},
        Lua    = {
          diagnostics = {
            disbale = {
              'lowercase-global',
              'undefined-global',
              'unused-local',
              'unused-vararg',
              'trailing-space'
            },
            globals = {
              'vim',
              'lowercase-global',
              'undefined-global',
              'unused-local',
              'unused-vararg',
              'trailing-space'
            }
          }
        }
      },
      handlers     = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
      }
    }
    opts.on_attach = function(client, bufnr)
      vim.cmd([[
      " highlight DiagnosticLineNrError guibg=#6b0f17 guifg=#993939 gui=bold
      " highlight DiagnosticLineNrWarn guibg=#49340e guifg=#93691d gui=bold
      " highlight DiagnosticLineNrInfo guibg=#15373b guifg=#2b6f77 gui=bold
      " highlight DiagnosticLineNrHint guibg=#441f4f guifg=#8a3fa0 gui=bold
      " sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
      " sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
      " sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
      " sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
      ]])
      vim.diagnostic.config({
        virtual_text = false,
        float        = {header = false, source = 'always', border = 'rounded'}
      })
      local mapopts = {noremap = true, silent  = true}

      M.set_default_formatter_for_filetypes('clangd', {'c'})

      -- if client.resolved_capabilities.document_formatting then
      map(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', mapopts)
      -- elseif client.resolved_capabilities.document_range_formatting then
      map(bufnr, 'v', '<space>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', mapopts)
      -- end
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      -- Defaults from https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
      map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', mapopts)
      map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', mapopts)
      map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', mapopts)
      map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', mapopts)
      map(bufnr, 'n', '<space>li', '<cmd>LspInfo<CR>', mapopts)
      map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', mapopts)
      map(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', mapopts)
      map(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', mapopts)
      map(bufnr, 'n', '<space>wl',
          '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', mapopts)
      map(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', mapopts)
      map(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', mapopts)
      map(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', mapopts)
      map(bufnr, 'v', '<space>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', mapopts)
      map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', mapopts)
      map(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
          mapopts)
      map(bufnr, 'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', mapopts)
      map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev {}<CR>', mapopts)
      map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next {}<CR>', mapopts)
      map(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', mapopts)
    end
    server:setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
    vim.cmd(
      [[ autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor", border=rounded})]])
  end)
end

return M
