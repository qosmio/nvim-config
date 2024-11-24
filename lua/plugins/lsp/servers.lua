local lspconfig = require "lspconfig"
local ok, res
for _, item in ipairs(require("mason-registry").get_installed_package_names()) do
  local server = require("mason-lspconfig").get_mappings().mason_to_lspconfig[item] or nil
  if server ~= nil then
    ok, res = pcall(require, "plugins.lsp.servers." .. server)
    if res then
      if ok and res ~= true then
        -- res.capabilities = caps
        -- if res.on_attach == nil then
        --   vim.print("No on_attach function for " .. server)
        --   res.on_attach = require("plugins.lsp.settings").on_attach
        -- end
        lspconfig[server].setup(res)
        -- if server == "clangd" then
        --   vim.print(lspconfig[server])
        --   local m = assert(io.open("/tmp/luac.out", "wb"))
        --   assert(m:write(string.dump(res.on_attach)))
        --   assert(m:close())
        -- end
      else
        lspconfig[server].setup {}
      end
    end
  end
end
