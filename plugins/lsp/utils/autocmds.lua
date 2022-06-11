local M = {}

M.DocumentHighlightAU = function(bufnr)
  local group = vim.api.nvim_create_augroup("DocumentHighlight", {})
  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

M.DocumentFormattingAU = function(bufnr, use_lsp)
  local group = vim.api.nvim_create_augroup("Formatting", { clear = true })
  if use_lsp then
    if not bufnr then
      bufnr = vim.api.nvim_get_current_buf()
    end
    vim.api.nvim_create_autocmd(
      "BufWritePre",
      { buffer = bufnr, callback = vim.lsp.buf.format, group = group }
    )
  end
end

M.InlayHintsAU = function(bufnr)
  local group = vim.api.nvim_create_augroup("InlayHints", {})
  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      local opts = { enabled = { "TypeHint", "ChainingHint", "ParameterHint" } }
      require("custom.plugins.lsp.inlay_hints").inlay_hints(opts)
    end,
  })
end

M.CodeLensAU = function(bufnr)
  local group = vim.api.nvim_create_augroup(("_lsp_codelens_%d"):format(bufnr), { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
    group = group,
  })
end

return M
