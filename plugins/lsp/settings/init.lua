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
-- Show diagnostics in a pop-up window on hover
L.lsp_diagnostics_popup_handler = function(client)
  local current_cursor = vim.api.nvim_win_get_cursor(0)
  local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
  -- Show the popup diagnostics window,
  -- but only once for the current cursor location (unless moved afterwards).
  if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
    vim.w.lsp_diagnostics_last_cursor = current_cursor
    vim.diagnostic.open_float(client.buf, {
      border = L.popup_border,
      scope = "cursor",
      focusable = false,
      source = "always",
      header = "",
      prefix = "",
    })
  end
end

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr, opts)
  -- local function buf_set_option(...)
  --   vim.api.nvim_buf_set_option(bufnr, ...)
  -- end
  --
  -- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local caps = client.server_capabilities
  local utils = require "core.utils"
  utils.load_mappings("lspconfig", { buffer = bufnr })

  -- if caps.definitionProvider then
  --   vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
  -- end

  if caps.documentHighlightProvider then
    L.autocmds.DocumentHighlightAU(bufnr)
  end

  if caps.codeLensProvider then
    L.autocmds.CodeLensAU(bufnr)
  end

  if caps.documentFormattingProvider then
    L.autocmds.DocumentFormattingAU(bufnr)
  end
  -- Enable semantic tokens if it's available (from the fork at jdrouhard/neovim#lsp_semantic_tokens)
  if vim.lsp.semantic_tokens ~= nil and caps.semanticTokensProvider then
    if client.name ~= "pylance" then
      vim.lsp.semantic_tokens.start(bufnr, client.id, opts)
    end
  end

  if caps.signatureHelpProvider then
    require("base46").load_highlight "lsp"
    require "nvchad_ui.lsp"
    require("nvchad_ui.signature").setup(client)
  end
end

-- M.on_attach = function(client, bufnr)
--   caps.documentFormattingProvider = false
--   caps.documentRangeFormattingProvider = false
--
--   local utils = require "core.utils"
--   utils.load_mappings("lspconfig", { buffer = bufnr })
--
--   if caps.signatureHelpProvider then
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
  local cmp_nvim_lsp = require "cmp_nvim_lsp"

  local caps = vim.lsp.protocol.make_client_capabilities()
  caps = cmp_nvim_lsp.default_capabilities(caps)
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
  caps.offsetEncoding = { "utf-16" }
  return vim.tbl_deep_extend("force", caps, lspconfig.capabilities)
end)()

local define_signs = function(signs)
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
      text = icon,
      texthl = hl,
      numhl = "",
    })
    -- without icon, but with number highlight
  end
end

M._setup = function()
  define_signs {
    Error = L.icons.error,
    Warn = L.icons.warningTriangle,
    Hint = L.icons.lightbulbOutline,
    Info = L.icons.info,
  }
  -- Show diagnostics in popup window (using the border above)
  local group_name = "LspDiagnostics"
  vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = group_name,
    callback = function(client)
      L.lsp_diagnostics_popup_handler(client)
    end,
  })
end

return M
