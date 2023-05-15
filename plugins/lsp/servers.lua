local lspconfig = require "lspconfig"
local base = require "custom.plugins.config.mason"
local custom = require "custom.plugins.lsp.settings"
local ok_coq, ok, coq, res
local cmp_nvim_lsp = require "cmp_nvim_lsp"
ok_coq, coq = pcall(require, "coq")
local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.default_capabilities(caps)

caps.textDocument.completion.completionItem.snippetSupport = true
caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
caps.offsetEncoding = "utf-16"
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

-- vim.pretty_print(require("mason-lspconfig").get_installed_servers())
local servers = vim.tbl_deep_extend(
  "force",
  require("mason-lspconfig").get_installed_servers(),
  { "pylance", "clangd", "gopls", "ansiblels" }
)
for _, server in ipairs(servers) do
  ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  if res.exist == nil then
    if ok and res ~= true then
      local merged = opts(vim.tbl_deep_extend("force", base, res), ok_coq)
      merged.on_attach = custom.on_attach
      merged.capabilities = caps
      if server == "pylance" and merged ~= nil then
        -- vim.print(merged)
        -- vim.lsp.set_log_level "info"
        -- merged.capabilities.textDocument.semanticTokens = nil
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
    else
      lspconfig[server].setup(base)
    end
  end
end
