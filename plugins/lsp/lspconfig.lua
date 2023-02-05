local utils = require "custom.utils"
local servers = {
  "jsonls",
  "bashls",
  "yamlls",
  "sumneko_lua",
  "tsserver",
  "html",
}

local delay = {
  "pylance",
  "nginx-language-server",
  "eslint_d",
}

return {
  ensure_installed = vim.tbl_filter(function(d)
    return utils.not_matches(d, delay) and d
  end, servers),
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
