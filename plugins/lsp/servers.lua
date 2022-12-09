local lspconfig = require "lspconfig"
local config = require "custom.plugins.lsp.settings"
local base = {
  on_attach = config.on_attach,
  flags = {
    debounce_text_changes = 250,
  },
  capabilities = config.capabilities,
  handlers = config.handlers,
}

local servers = vim.tbl_deep_extend("force", require("mason-lspconfig").get_installed_servers(), { "pylance" })
for _, server in ipairs(servers) do
  local ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  if ok and res ~= true then
    -- print(vim.inspect(server))
    lspconfig[server].setup(vim.tbl_deep_extend("force", base, res))
  else
    lspconfig[server].setup(base)
  end
end
