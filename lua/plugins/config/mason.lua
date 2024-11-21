dofile(vim.g.base46_cache .. "mason")

return {
  log_level = vim.log.levels.ERROR,
  automatic_installation = true,
  auto_update = true,
  run_on_start = true,
  start_delay = 2,
}
