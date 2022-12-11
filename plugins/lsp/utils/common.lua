-- local autocmds = require "custom.plugins.lsp.utils.autocmds"

local M = {}

M.set_contains = function(set, val)
  for _, value in pairs(set) do
    if value == val then
      return true
    end
  end
  return false
end

M.set_default_formatter_for_filetypes = function(language_server_name, filetypes)
  if not M.set_contains(filetypes, vim.bo.filetype) then
    return
  end

  local active_servers = {}

  vim.lsp.for_each_buffer_client(0, function(client)
    table.insert(active_servers, client.config.name)
  end)

  if not M.set_contains(active_servers, language_server_name) then
    return
  end

  vim.lsp.for_each_buffer_client(0, function(client)
    if client.name ~= language_server_name then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end)
end

M.has_exec = function(filename)
  return function(_)
    return vim.fn.executable(filename) == 1
  end
end

-- M.on_attach = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--
--   local utils = require "core.utils"
--   utils.load_mappings("lspconfig", { buffer = bufnr })
--
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
--
--   if client.server_capabilities.definitionProvider then
--     vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
--   end
--
--   if client.server_capabilities.documentHighlightProvider then
--     autocmds.DocumentHighlightAU(bufnr)
--   end
--
--   if client.server_capabilities.codeLensProvider then
--     autocmds.CodeLensAU(bufnr)
--   end
--
--   if client.server_capabilities.documentFormattingProvider then
--     autocmds.DocumentFormattingAU(bufnr)
--   end
--
--   if client.server_capabilities.signatureHelpProvider then
--     require("base46").load_highlight "lsp"
--     require "nvchad_ui.lsp"
--     require("nvchad_ui.signature").setup(client)
--   end
-- end

return M
