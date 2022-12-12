-- print(require("path").path)
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
-- print(vim.inspect(vim.diagnostic.config()))
-- print(vim.inspect(require "custom.plugins.config.cmp"()))

-- local servers = require("mason-lspconfig").get_installed_servers()
for _, server in ipairs(servers) do
  local ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  -- print(vim.inspect(require "custom.plugins.config.cmp"))
  if ok and res ~= true then
    -- lspconfig[server].setup(vim.tbl_deep_extend("force", res, base))
    lspconfig[server].setup(vim.tbl_deep_extend("force", base, res))
    -- if server == "pylance" then
    -- print(vim.inspect(lspconfig[server]))
    -- print(vim.inspect(vim.tbl_deep_extend("force", base, res)))
    -- f = assert(io.open("/tmp/luac.out", "wb"))
    -- assert(f:write(vim.inspect(vim.tbl_deep_extend("force", base, res))))
    -- assert(f:close())
    -- end
  else
    lspconfig[server].setup(base)
  end
end
