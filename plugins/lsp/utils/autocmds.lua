local M = {}
local L = {}

M.augroup = function(name, commands)
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  -- assert(#commands > 0, print("You must specify at least one autocommand for", name ))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

M.DocumentHighlightAU = function(bufnr)
  M.augroup("DocumentHighlight", {
    {
      event = { "CursorHold", "CursorHoldI" },
      buffer = bufnr,
      command = vim.lsp.buf.document_highlight,
    },
    {
      event = "CursorMoved",
      buffer = bufnr,
      command = vim.lsp.buf.clear_references,
    },
  })
end

-- M.SemanticTokensAU = function(bufnr)
--   M.augroup("SemanticTokens", {
--     {
--       event = { "BufEnter", "CursorHold", "InsertLeave" },
--       buffer = bufnr,
--       command = vim.lsp.semantic_tokens.start,
--     },
--   })
-- end

M.DocumentFormattingAU = function(bufnr)
  M.augroup("Formatting", {
    event = { "BufWritePre" },
    buffer = (function()
      if bufnr == nil then
        return vim.api.nvim_get_current_buf()
      else
        return bufnr
      end
    end)(),
    callback = vim.lsp.buf.format,
  })
end

M.InlayHintsAU = function(bufnr)
  M.augroup("InlayHints", {
    event = { "CursorMoved", "InsertLeave" },
    buffer = bufnr,
    callback = function()
      local opts = { enabled = { "TypeHint", "ChainingHint", "ParameterHint" } }
      require("custom.plugins.lsp.inlay_hints").inlay_hints(opts)
    end,
  })
end

M.CodeLensAU = function(bufnr)
  M.augroup(("_lsp_codelens_%d"):format(bufnr), {
    event = { "BufEnter", "CursorHold", "InsertLeave" },
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

M.DiagPopup = function(bufnr)
  L.lsp_diagnostics_popup = function(client)
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
    -- Show the popup diagnostics window,
    -- but only once for the current cursor location (unless moved afterwards).
    if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
      vim.w.lsp_diagnostics_last_cursor = current_cursor
      vim.diagnostic.open_float(client.buf, {
        border = require "custom.plugins.lsp.settings.popup_border" "LspInfoBorder",
        scope = "cursor",
        focusable = false,
        source = "always",
        header = "",
        prefix = "",
      })
    end
  end

  M.augroup("LspDiagnostics", {
    {
      event = { "CursorHold" },
      buffer = bufnr,
      command = L.lsp_diagnostics_popup,
    },
  })
end

return M
