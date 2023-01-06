local M = {}
local L = {}
-- UI
-- L.codes = require "lsp.settings.codes"
L.icons = require "lsp.settings.icons"
L.popup_border = require "lsp.settings.popup_border" "FloatBorder"
require("lspconfig.ui.windows").default_options = {
  border = L.popup_border,
  -- col = 9,
  -- height = 43,
  -- relative = "editor",
  -- row = 2,
  -- style = "minimal",
  -- width = 165,
}
L.define_signs = function(signs)
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
      text = icon,
      texthl = hl,
      numhl = "",
    })
  end
end

L.define_signs {
  Error = L.icons.error,
  Warn = L.icons.warningTriangle,
  Hint = L.icons.lightbulbOutline,
  Info = L.icons.info,
}

L.autocmds = require "lsp.utils.autocmds"

L.is_null_ls_formatting_enabed = function(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local generators =
  require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
  return #generators > 0
end

M.on_attach = function(client, bufnr)
  -- L.autocmds.lsp_diagnostics_popup(bufnr)
  vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    -- signs = { severity = { min = vim.diagnostic.severity.INFO } },
    update_in_insert = false,
  }
  vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    pcall(vim.diagnostic.reset, ns)
    return true
  end
  L.autocmds.DiagPopup(bufnr)
  -- client.server_capabilities.documentFormattingProvider = false
  if client.server_capabilities.documentFormattingProvider then
    if client.name == "null-ls" and M.is_null_ls_formatting_enabed(bufnr) or client.name ~= "null-ls" then
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    else
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
    end
  end
  -- client.server_capabilities.documentRangeFormattingProvider = false

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  if client.server_capabilities.documentHighlightProvider then
    L.autocmds.DocumentHighlightAU(bufnr)
  end

  if client.server_capabilities.codeLensProvider then
    L.autocmds.CodeLensAU(bufnr)
  end

  if client.server_capabilities.documentFormattingProvider then
    L.autocmds.DocumentFormattingAU(bufnr)
  end
end

M.handlers = {
  ["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    pcall(vim.diagnostic.reset, ns)
    return true
  end,
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false, -- if using pop-up window
    signs = true,
    underline = true,
    update_in_insert = false, -- update diagnostics insert mode
    severity_sort = false,
  }),
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = L.popup_border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = L.popup_border }),
}

M.capabilities = (function()
  local lspconfig = require "plugins.configs.lspconfig"
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
  caps.offsetEncoding = { "utf-16" }
  return vim.tbl_deep_extend("force", caps, lspconfig.capabilities)
end)()

return M
