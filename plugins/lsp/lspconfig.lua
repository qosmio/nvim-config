local utils = require "custom.utils"
local servers = {
  "jsonls",
  "bashls",
  "yamlls",
  "sumneko_lua",
  "tsserver",
  "pylance",
  "html",
}

local delay = {
  "pylance",
  "nginx-language-server",
  "eslint_d",
}
utils.tbl_filter_inplace(servers, delay)

return {
  ensure_installed = servers,
  automatic_installation = true,

  ui = {
    icons = {
      server_installed = "",
      server_pending = "",
      server_uninstalled = "ﮊ",
    },
  },
  max_concurrent_installers = 20,
}
