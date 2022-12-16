local lspconfig = require "lspconfig"
local base = require "plugins.configs.lspconfig"
local custom = require "custom.plugins.lsp.settings"
local ok_coq, ok, coq, res
ok_coq, coq = pcall(require, "coq")

---@private
--- Sends an async request to all active clients attached to the current
--- buffer.
---
---@param merged (table|nil) Parameters to send to the server
---@param _ok (boolean)
--
---@returns table
local function opts(merged, _ok)
  if _ok then
    return coq.lsp_ensure_capabilities(merged)
  else
    return merged
  end
end

-- local v = vim.cmd[[hi]]
-- local v = require("base46.integrations.statusline")
-- local v = vim.bo.filetype ~= "python" and true or false
-- print("V IS", v)
local servers = vim.tbl_deep_extend("force", require("mason-lspconfig").get_installed_servers(), { "pylance" })
-- local v = require("custom.highlights.utils").gui_syntax_to_cterm(require "custom.highlights.hl")
-- print(vim.inspect(require("custom.highlights.utils").color.colors "Diff"))
-- local servers = require("mason-lspconfig").get_installed_servers()
for _, server in ipairs(servers) do
  ok, res = pcall(require, "custom.plugins.lsp.servers." .. server)
  -- print(vim.inspect(require "custom.plugins.config.cmp"))
  if ok and res ~= true then
    local merged = opts(vim.tbl_deep_extend("force", base, res), ok_coq)
    merged.on_attach = custom.on_attach
    -- if server == "sumneko_lua" then
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
