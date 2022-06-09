-- local utils        = require('custom.plugins.lsp.utils')

local function define_signs(signs)
  for type, _ in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
    -- without icon, but with number highlight
  end
end

define_signs({ Error = '', Warn = '', Hint = '', Info = '' })

local popup_border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' }
}

local group_name = 'LspDiagnostics'

-- -- Show diagnostics in popup window (using the border above)
-- vim.api.nvim_command( "autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border=" .. vim.inspect(popup_border) .. ", focusable=false, show_header=false})")

vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group    = group_name,
  callback = function()
    vim.diagnostic.open_float({ border = popup_border, focusable = false, show_header = false })
  end
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text     = false, -- if using pop-up window
  signs            = true,
  underline        = true,
  update_in_insert = false, -- update diagnostics insert mode
  severity_sort    = false
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
  { border = popup_border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
  { border = popup_border })
vim.diagnostic.config({
  -- virtual_text = { prefix = "", },
  signs            = true,
  underline        = true,
  update_in_insert = false,
  virtual_text     = false,
  float            = {
    header = false,
    source = 'always'
    -- border = "round",
  }
})
