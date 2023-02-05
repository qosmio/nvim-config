local lspconfig = require "lspconfig"
local base = require "plugins.configs.lspconfig"
local custom = require "custom.plugins.lsp.settings"
local ok_coq, ok, coq, res
ok_coq, coq = pcall(require, "coq")

---@public
--- Sends an async request to all active clients attached to the current
--- buffer.
---
---@param merged (table|nil) Parameters to send to the server
---@param isok (boolean)
--
---@returns table
local function opts(merged, isok)
  if isok then
    return coq.lsp_ensure_capabilities(merged)
  else
    return merged
  end
end

-- local syntax = vim.tbl_extend("keep", require("custom.highlights.hlo").highlight, require "custom.highlights.lsp_hi")
local servers = vim.tbl_deep_extend(
  "force",
  require("mason-lspconfig").get_installed_servers(),
  { "pylance", "ccls", "clangd", "sourcekit", "gopls" }
)
for _, server in ipairs(servers) do
  ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  -- if server == "sourcekit" then
  --   pprint(res)
  -- end
  if res.exist == nil then
    if ok and res ~= true then
      local merged = opts(vim.tbl_deep_extend("force", base, res), ok_coq)
      merged.on_attach = custom.on_attach
      if server == "pylance" and merged ~= nil and merged.capabilities.textDocument.semanticTokens == true then
        vim.lsp.set_log_level "info"
        merged.capabilities.textDocument.semanticTokens = nil
      end
      --   local diff = ltdiff.diff(merged, opts)
      --   -- print("this = " .. vim.inspect(merged))
      --   -- print("other = " .. vim.inspect(opts))
      --   print("diff = " .. vim.inspect(diff))
      -- local m = assert(io.open("/tmp/luac.out", "wb"))
      -- assert(m:write(string.dump(merged.on_attach)))
      -- assert(m:close())
      -- end
      -- local patched = ltdiff.patch(merged, diff)
      -- print("patched = " .. vim.inspect(patched))
      lspconfig[server].setup(merged)
      -- if server == "sourcekit" then
      --   write(merged, "/tmp/clangd.lua")
      -- end
    else
      lspconfig[server].setup(base)
    end
  end
end
