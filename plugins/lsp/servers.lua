local utils = require "custom.plugins.lsp.utils"
-- local registry = require "mason-registry"
local lspinstaller = require "nvim-lsp-installer"
local lspconfig = require "lspconfig"

local capabilities = vim.lsp.protocol.make_client_capabilities()

lspinstaller.setup {}

-- for _, server in ipairs(registry.get_installed_packages()) do
for _, server in ipairs(lspinstaller.get_installed_servers()) do
  local ok, res = pcall(require, "custom.plugins.lsp.servers." .. server.name)
  if ok then
    lspconfig[server.name].setup(res)
  else
    lspconfig[server.name].setup {
      on_attach = utils.common.on_attach,
      flags = {
        debounce_text_changes = 250,
      },
      capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
      },
    }
  end
end
