local lspconfig = require "lspconfig"
-- local base = require "custom.plugins.config.mason"
local custom = require "custom.plugins.lsp.settings"
local ok, res
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.default_capabilities(caps)

caps.textDocument.completion.completionItem.snippetSupport = true
caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
-- caps.workspace.didChangeWorkspaceFolders = false
caps.offsetEncoding = { "utf-16" }
-- vim.print(require("mason-registry").get_installed_packages())
-- vim.print(require("mason-lspconfig").get_mappings())
-- for _, item in ipairs(require("mason-registry").get_installed_package_names()) do
--   local server = require("mason-lspconfig").get_mappings().mason_to_lspconfig[item] or item
--   vim.print(server)
-- end

-- local servers = vim.tbl_deep_extend(
--   "force",
--   require("mason-lspconfig").get_installed_servers(),
--   { "pylance", "clangd", "gopls", "ansiblels", "ruff_lsp" }
-- )
-- for _, server in ipairs(servers) do
for _, item in ipairs(require("mason-registry").get_installed_package_names()) do
  local server = require("mason-lspconfig").get_mappings().mason_to_lspconfig[item] or nil
  if item == "pylance" then
    server = item
  end
  if server ~= nil then
    ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
    if res.exist == nil then
      if ok and res ~= true then
        res.capabilities = caps
        if res.on_attach == nil then
          res.on_attach = custom.on_attach
          -- vim.print(res)
        end
        lspconfig[server].setup(res)
        if server == "yamlls" then
          -- vim.print(lspconfig[server])
          -- local m = assert(io.open("/tmp/luac.out", "wb"))
          -- assert(m:write(string.dump(res.on_attach)))
          -- assert(m:close())
        end
      else
        lspconfig[server].setup {}
      end
    end
  end
end
