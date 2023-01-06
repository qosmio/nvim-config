local servers = {
  "jsonls",
  "pylance",
  "bashls",
  "yamlls",
  "sumneko_lua",
  "tsserver",
  -- "eslint",
  "html",
}

return {
  ensure_installed = vim.tbl_filter(function(d)
    return d ~= "pylance"
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
