local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end
local command_resolver = require "null-ls.helpers.command_resolver"
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local sources = {
  -- SQL
  -- diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres" } },
  formatting.sqlfluff.with { extra_args = { "--dialect", "sqlite" } },

  -- Javascript
  diagnostics.eslint_d,
  formatting.prettier_d_slim.with {
    {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "markdown",
      "markdown.mdx",
      "graphql",
      "handlebars",
    },
    dynamic_command = command_resolver.from_node_modules(),
    command = "prettier_d",
    args = {
      "--config-path",
      vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.prettierrc.json",
      "--stdin",
      "$FILENAME",
    },
  },
  --
  -- Lua
  -- wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.12.3/stylua-0.12.3-linux.zip
  formatting.stylua.with {
    extra_args = {
      "--config-path",
      vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.stylua.toml",
    },
  },

  -- Python
  -- pip install reorder-python-imports black yapf
  formatting.reorder_python_imports.with { extra_args = { "--py310-plus" } },
  formatting.black.with { timeout = 20000 },
  -- diagnostics.pylama,
  -- formatting.yapf,

  -- Nginx
  -- npm -g i nginxbeautifier
  formatting.nginx_beautifier.with { args = { "-s", 2, "-i", "-o", "$FILENAME" } },

  -- PHP
  -- composer global require "squizlabs/php_codesniffer=*"
  -- formatting.phpcbf,
  -- diagnostics.php,

  -- C/Clang
  formatting.clang_format.with { offsetEncoding = { "utf-32" } },
  -- formatting.uncrustify,

  -- ZSH
  diagnostics.zsh,

  -- Bash
  -- diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  code_actions.shellcheck,
  diagnostics.shellcheck.with {
    extra_args = {
      "-a",
      "-s",
      "bash",
      "-e",
      "SC2154,SC2169,SC2034,SC2086,SC2039,SC2166,SC2154,SC1091,SC2174,SC3043,SC3013,SC3045",
    },
  },
  -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
  formatting.beautysh.with {
    extra_args = { "--indent-size", 2, "--force-function-style", "paronly" },
  },
  formatting.shfmt.with {
    filetypes = { "bash", "csh", "ksh", "sh" },
    extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  },
  -- formatting.shellharden.with { extra_filetypes = { "zsh", "bash", "sh" }, },

  -- JSON
  formatting.jq,
  -- TOML
  formatting.taplo,
  -- YAML
  formatting.yamlfmt.with {
    timeout = 15000,
    extra_args = { "-conf", vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.yamlfmt.yml" },
  },
  diagnostics.yamllint.with {
    extra_args = { "-c", vim.fn.stdpath "config" .. "/lua/custom/plugins/config/.yamllint.yml" },
  },
  -- Golang
  formatting.gofumpt,
}

local M = {}

M.setup = function()
  null_ls.setup {
    debug = false,
    sources = sources,
    -- debounce = 250,
    default_timeout = 15000,
    -- diagnostics_format = "[#{c}] #{m} (#{s})",
    log_level = "warn",
    -- log = { enable = true, level = "info", use_console = "async" },
  }
end

return M
