local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local utils = require "utils"
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
  code_actions.refactoring,

  -- ZSH
  diagnostics.zsh,
}

local extra = {
  -- Bash
  -- diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  require("none-ls-shellcheck.diagnostics").with {
    extra_args = { "--rcfile", vim.fn.stdpath "config" .. "/lua/plugins/config/.shellcheckrc" },
  },
  require "none-ls-shellcheck.code_actions",
}

local os_info = utils.get_os_info()
if os_info.id ~= "openwrt" then
  vim.list_extend(sources, extra)
end

return {
  debug = false,
  sources = sources,
  log_level = "warn",
}
