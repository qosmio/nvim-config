local lspconfig = require "lspconfig"
local ok, res
-- local package_to_lspconfig = require("mason-lspconfig.mappings").get_mason_map().package_to_lspconfig
-- local installed_packages = require("mason-registry").get_installed_package_names()

local cfg = {
  -- "ansiblels",
  -- "basedpyright",
  -- "bashls",
  "biome",
  -- "ccls",
  "clangd",
  -- "cssls",
  -- "docker_compose_language_service",
  -- "graphql",
  -- "html",
  -- "jsonls",
  -- "lua_ls",
  -- "perlnavigator",
  -- "pylyzer",
  -- "rust_analyzer",
  -- "selene",
  -- "sourcekit",
  -- "tailwindcss",
  -- "vtsls",
  -- "vuels",
  -- "yamlls",
}

for _, server in ipairs(cfg) do
  -- local server = package_to_lspconfig[item] or nil
  -- if server ~= nil and vim.tbl_contains(installed_packages, server) then
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
      -- vim.print(server)
      --   local m = assert(io.open("/tmp/luac.out", "wb"))
      --   assert(m:write(string.dump(res.on_attach)))
      --   assert(m:close())
      -- end
    else
      lspconfig[server].setup {}
    end
  end
  -- end
end
