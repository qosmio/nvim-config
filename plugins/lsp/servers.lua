local utils = require "custom.plugins.lsp.utils"
local lspinstaller = require "nvim-lsp-installer"
local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspsettings = require "custom.plugins.lsp.settings"

local base = {
  on_attach = utils.common.on_attach,
  flags = {
    debounce_text_changes = 250,
  },
  capabilities = capabilities,
  handlers = lspsettings.handlers,
}

-- lspinstaller.setup {}

for _, server in ipairs(lspinstaller.get_installed_servers()) do
  local ok, res = pcall(require, "custom.plugins.lsp.servers." .. server.name)
  -- if not ok then
  --   print(res)
  -- end
  if ok and res ~= true then
    lspconfig[server.name].setup(vim.tbl_deep_extend("force", base, res))
  else
    lspconfig[server.name].setup(base)
  end
end
