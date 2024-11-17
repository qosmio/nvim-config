return {
  name = "biome",
  cmd = {
    "biome",
    "lsp-proxy",
    "--config-path",
    vim.fn.stdpath "config" .. "/lua/plugins/config/.biome.json",
  },
}
