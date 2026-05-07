dofile(vim.g.base46_cache .. "mason")

return {
  log_level = vim.log.levels.ERROR,
  registries = {
    "file:" .. vim.fs.joinpath(vim.fn.stdpath "config", "lua", "registry"),
    "github:mason-org/mason-registry",
  },
}
