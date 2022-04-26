local lsp_installer = require('nvim-lsp-installer')
local utils         = require('custom.plugins.lsp.utils')

local configs       = {}
local mt            = {}
function mt:__index(k)
  local ok, res = pcall(require, 'custom.plugins.lsp.servers.' .. k)

  if k == 'efm' then
    require('custom.plugins.lsp.servers.efm')
  end
  if ok then
    self[k] = res
    return res
  end
  return {on_attach = utils.common.on_attach}
end
configs = setmetatable(configs, mt)

-- local exclude       = {'ltex'}

lsp_installer.on_server_ready(function(server)
  -- if vim.tbl_contains(exclude, server.name) then
  --   return
  -- end
  local opts = configs[server.name]
  server:setup(opts)
end)
