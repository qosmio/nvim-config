local M = {}

M.DocumentHighlightAU = function()
  local group = vim.api.nvim_create_augroup('DocumentHighlight', {clear = true})
  vim.api.nvim_create_autocmd('CursorHold',
                              {callback = vim.lsp.buf.document_highlight, group    = group})
  vim.api.nvim_create_autocmd('CursorMoved',
                              {callback = vim.lsp.buf.clear_references, group    = group})
end

M.CodeLensAU = function()
  local group = vim.api.nvim_create_augroup('CodeLens', {clear = true})
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = require('vim.lsp.codelens').refresh,
    group    = group,
    once     = true
  })

  vim.api.nvim_create_autocmd({'BufWritePost', 'CursorHold'},
                              {callback = require('vim.lsp.codelens').refresh, group    = group})
end

M.DocumentFormattingAU = function(use_lsp)
  local group = vim.api.nvim_create_augroup('Formatting', {clear = true})
  if use_lsp then
    vim.api.nvim_create_autocmd('BufWritePre',
                                {callback = vim.lsp.buf.formatting_sync, group    = group})
    -- else
    --    vim.api.nvim_create_autocmd("BufWritePost", {
    --       command = "FormatWrite",
    --       group = group,
    --    })
  end
end

M.SemanticTokensAU = function()
  local group = vim.api.nvim_create_augroup('SemanticTokens', {clear = true})
  vim.api.nvim_create_autocmd({'BufEnter', 'CursorHold', 'InsertLeave'}, {
    callback = vim.lsp.buf.semantic_tokens_full(),
    group    = group
    -- once = true,
  })
end

M.InlayHintsAU = function()
  local group = vim.api.nvim_create_augroup('InlayHints', {clear = true})
  vim.api.nvim_create_autocmd({'CursorMoved', 'InsertLeave'}, {
    callback = require('custom.plugins.lsp.inlay_hints').inlay_hints({
      enabled = {'TypeHint', 'ChainingHint', 'ParameterHint'}
    }),
    group    = group
    -- once = true,
  })
end

return M
