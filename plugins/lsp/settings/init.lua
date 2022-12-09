local M = {}
local L = {}
-- UI
L.icons = require "lsp.settings.icons"
L.codes = require "lsp.settings.codes"
L.autocmds = require "lsp.utils.autocmds"
L.popup_border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local utils = require "core.utils"
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.definitionProvider then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
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

  if client.server_capabilities.signatureHelpProvider then
    require("base46").load_highlight "lsp"
    require "nvchad_ui.lsp"
    require("nvchad_ui.signature").setup(client)
  end
end

-- M.on_attach = function(client, bufnr)
--   client.server_capabilities.documentFormattingProvider = false
--   client.server_capabilities.documentRangeFormattingProvider = false
--
--   local utils = require "core.utils"
--   utils.load_mappings("lspconfig", { buffer = bufnr })
--
--   if client.server_capabilities.signatureHelpProvider then
--     require("base46").load_highlight "lsp"
--     require "nvchad_ui.lsp"
--     require("nvchad_ui.signature").setup(client)
--   end
-- end

M.handlers = {
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
  local ok_s, semantic_tokens = pcall(require, "nvim-semantic-tokens")
  local ok_c, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if not (ok_s and ok_c) then
    return
  end

  local caps = semantic_tokens.extend_capabilities(vim.lsp.protocol.make_client_capabilities())
  caps = cmp_nvim_lsp.default_capabilities(caps)
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
  caps.offsetEncoding = { "utf-16" }
  return vim.tbl_deep_extend("force", caps, lspconfig.capabilities)
end)()

local define_signs = function(signs)
  for type, _ in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
    -- without icon, but with number highlight
  end
end

local setup = function()
  define_signs {
    Error = L.icons.errorSlash,
    Warn = L.icons.warningTriangle,
    Hint = L.icons.lightbulbOutline,
    Info = L.icons.info,
  }

  -- Show diagnostics in popup window (using the border above)
  local group_name = "LspDiagnostics"
  vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = group_name,
    callback = function()
      vim.diagnostic.open_float {
        source = false,
        border = L.popup_border,
        focusable = false,
        show_header = false,
      }
    end,
  })
end
setup()

return M
