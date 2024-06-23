local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end
-- local command_resolver = require "null-ls.helpers.command_resolver"
-- local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
-- local code_actions = null_ls.builtins.code_actions

local sources = {
  -- code_actions.refactoring,
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
  -- diagnostics.eslint_d,
  -- formatting.prettier.with {
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "typescript",
  --     "typescriptreact",
  --     "vue",
  --     "css",
  --     "scss",
  --     "less",
  --     "html",
  --     "json",
  --     "jsonc",
  --     "markdown",
  --     "markdown.mdx",
  --     "graphql",
  --     "handlebars",
  --   },
  --   dynamic_command = command_resolver.from_node_modules(),
  --   command = "prettier",
  --   args = {
  --     "--config-path",
  --     vim.fn.stdpath "config" .. "/lua/plugins/config/.prettierrc.json",
  --     "--stdin",
  --     "$FILENAME",
  --   },
  -- },
  --
  -- Lua
  -- wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.12.3/stylua-0.12.3-linux.zip
  -- formatting.stylua.with {
  --   extra_args = {
  --     "--config-path",
  --     vim.fn.stdpath "config" .. "/lua/plugins/config/.stylua.toml",
  --   },
  -- },

  -- Python
  -- pip install reorder-python-imports black yapf
  -- require "plugins.lsp.diagnostics.pylance",
  -- formatting.reorder_python_imports.with { extra_args = { "--py310-plus" } },
  -- formatting.black,
  -- formatting.ruff,
  -- diagnostics.ruff,
  -- formatting.usort,

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
    extra_args = { "--rcfile", "/home/xbmc/.config/nvim/lua/plugins/config/.shellcheckrc" },
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
  -- -- JSON
  -- formatting.jq,
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
  -- -- Golang
  -- formatting.gofumpt,
  -- -- CMAKE
  -- -- diagnostics.cmake_lint,
  -- formatting.cmake_format,
  -- -- XML
  -- -- formatting.xmllint,
  -- -- Ruby
  -- -- diagnostics.rubocop,
  -- formatting.rubocop,
  -- HTML5
  -- diagnostics.tidy,
}

null_ls.setup {
  debug = false,
  sources = sources,
  log_level = "warn",
}
