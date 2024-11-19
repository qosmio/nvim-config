local utils = require "utils"
local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

-- local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
  code_actions.refactoring,
  -- SQL
  -- formatting.sqlfluff.with {
  --   extra_args = {
  --     "--dialect",
  --     "postgres",
  --     "--config",
  --     vim.fn.stdpath "config" .. "/lua/plugins/config/.sqlfluff",
  --   },
  -- },

  -- Javascript

  -- Nginx
  -- npm -g i nginxbeautifier
  -- formatting.nginx_beautifier.with { args = { "-s", 2, "-i", "-o", "$FILENAME" } },
  require "plugins.lsp.formatters.crossplane",

  -- PHP
  -- composer global require "squizlabs/php_codesniffer=*"
  -- formatting.phpcbf,
  -- diagnostics.php,

  -- C/Clang
  -- formatting.clang_format.with { offsetEncoding = { "utf-32" } },
  -- formatting.uncrustify,

  -- ZSH
  diagnostics.zsh,

  -- Bash
  -- diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  require("none-ls-shellcheck.diagnostics").with {
    extra_args = { "--rcfile", vim.fn.stdpath "config" .. "/lua/plugins/config/.shellcheckrc" },
  },
  require "none-ls-shellcheck.code_actions",
  -- code_actions.shellcheck.with {
  --   filetypes = { "bash", "csh", "ksh", "sh" },
  -- },
  -- diagnostics.shellcheck.with {
  --   filetypes = { "bash", "csh", "ksh", "sh" },
  --   extra_args = {
  --     "-a",
  --     "-s",
  --     "bash",
  --     "-e",
  --     "SC2154,SC2169,SC2034,SC2086,SC2039,SC2166,SC2154,SC1091,SC2174,SC3043,SC3013,SC3045",
  --   },
  -- },
  -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
  -- formatting.beautysh.with {
  --   extra_args = { "--indent-size", 2, "--force-function-style", "paronly" },
  -- },
  -- formatting.shfmt.with {
  --   filetypes = { "bash", "csh", "ksh", "sh" },
  --   extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  -- },
  -- -- formatting.shellharden.with { extra_filetypes = { "zsh", "bash", "sh" }, },
  --
  -- -- TOML
  -- formatting.taplo,
  -- -- Ansible
  -- -- diagnostics.ansiblelint.with { filetypes = { "ansible" } },
  --
  -- -- YAML
  -- formatting.yamlfmt.with {
  --   timeout = 15000,
  --   extra_args = { "-conf", vim.fn.stdpath "config" .. "/lua/plugins/config/.yamlfmt.yml" },
  -- },
  -- require "plugins.lsp.formatters.yamlfix",
  -- diagnostics.yamllint.with {
  --   extra_args = { "-c", vim.fn.stdpath "config" .. "/lua/plugins/config/.yamllint.yml" },
  -- },
}

if vim.loop.os_uname().machine ~= "aarch64" then
  if utils.get_os_info().id ~= "rhel" and utils.get_os_info().version:match "^8" then
    local non_aarch64_sources = {
      diagnostics.selene.with {
        extra_args = { "--config", vim.fn.stdpath "config" .. "/lua/plugins/config/.selene.toml" },
      },
    }
    sources = vim.tbl_extend("force", sources, non_aarch64_sources)
  end
end

return {
  debug = false,
  sources = sources,
  log_level = "warn",
}
