local M = {}
local L = {}
-- UI
-- L.codes = require "lsp.settings.codes"
L.icons = require "plugins.lsp.settings.icons"
L.popup_border = require "plugins.lsp.settings.popup_border" "FloatBorder"
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
    vim.diagnostic.config {
      signs = {
        text = {
          [hl] = icon,
        },
        texthl = {
          [hl] = hl,
        },
        numhl = {},
      },
    }
  end
end

L.define_signs {
  Error = L.icons.error,
  Warn = L.icons.warningTriangle,
  Hint = L.icons.lightbulbOutline,
  Info = L.icons.info,
}

L.autocmds = require "plugins.lsp.utils.autocmds"

L.is_null_ls_formatting_enabled = function(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local generators =
      require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
  return #generators > 0
end

L.setup_handlers = function()
  vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    pcall(vim.diagnostic.reset, ns)
    return true
  end
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false, -- if using pop-up window
    signs = true,
    underline = true,
    update_in_insert = false, -- update diagnostics insert mode
    severity_sort = false,
  })
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = L.popup_border })
  vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = L.popup_border })
end

M.on_attach = function(client, bufnr)
  require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  -- require("plugins.lsp.settings").on_attach
  -- L.autocmds.lsp_diagnostics_popup(bufnr)
  vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    -- signs = { severity = { min = vim.diagnostic.severity.INFO } },
    update_in_insert = false,
  }
  L.autocmds.DiagPopup(bufnr)
  -- client.server_capabilities.documentFormattingProvider = false
  if client.server_capabilities.documentFormattingProvider then
    if client.name == "null-ls" and M.is_null_ls_formatting_enabled(bufnr) or client.name ~= "null-ls" then
      vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
    else
      vim.api.nvim_set_option_value("formatexpr", "", { buf = bufnr })
    end
  end

  -- setup signature popup
  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end

  if client.server_capabilities.codeLensProvider then
    L.autocmds.CodeLensAU(bufnr)
  end

  if client.server_capabilities.documentFormattingProvider then
    L.autocmds.DocumentFormattingAU(bufnr)
  end
end

M.capabilities = (function()
  local lspconfig = require "nvchad.configs.lspconfig"
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
  return vim.tbl_deep_extend("force", caps, lspconfig.capabilities)
end)()

L.setup_handlers()
return M
