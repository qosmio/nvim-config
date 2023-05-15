local lspconfig = require "lspconfig"
local base = require "custom.plugins.config.mason"
local custom = require "custom.plugins.lsp.settings"
local ok, res
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.default_capabilities(caps)

caps.textDocument.completion.completionItem.snippetSupport = true
caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
caps.offsetEncoding = "utf-16"

local servers = vim.tbl_deep_extend(
  "force",
  require("mason-lspconfig").get_installed_servers(),
  { "pylance", "clangd", "gopls", "ansiblels" }
)
for _, server in ipairs(servers) do
  ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  if res.exist == nil then
    if ok and res ~= true then
      local merged = vim.tbl_deep_extend("force", base, res)
      merged.capabilities = caps
      if server ~= "pylance" and merged ~= nil then
        merged.on_attach = custom.on_attach
        -- vim.print(merged)
      end
      -- local m = assert(io.open("/tmp/luac.out", "wb"))
      -- assert(m:write(string.dump(merged.on_attach)))
      -- assert(m:close())
      lspconfig[server].setup(merged)
    else
      lspconfig[server].setup(base)
    end
  end
end
