local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local ca = null_ls.builtins.code_actions
local cmp = null_ls.builtins.completion

local sources = {
  -- SQL
  -- diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres" } },
  formatting.sqlfluff.with { extra_args = { "--dialect", "sqlite" } },

  -- Javascript
  formatting.prettier,

  -- Lua
  -- wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.12.3/stylua-0.12.3-linux.zip
  formatting.stylua.with {
    extra_args = { "--config-path", vim.fn.stdpath "config" .. "/lua/custom/plugins/config/stylua.toml" },
  },
  cmp.luasnip,

  -- Python
  -- pip install reorder-python-imports black yapf
  formatting.reorder_python_imports,
  formatting.black,
  -- formatting.yapf,

  -- Nginx
  -- npm -g i nginxbeautifier
  formatting.nginx_beautifier.with { args = { "-s", 2, "-i", "-o", "$FILENAME" } },

  -- PHP
  -- composer global require "squizlabs/php_codesniffer=*"
  -- formatting.phpcbf,
  -- diagnostics.php,

  -- C/Clang
  -- formatting.clang_format,
  formatting.uncrustify,

  -- ZSH
  diagnostics.zsh,

  -- Bash
  diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  ca.shellcheck,
  -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
  formatting.shfmt.with {
    extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  },
  -- formatting.shellharden.with { extra_filetypes = { "zsh", "bash", "sh" }, },

  -- JSON
  formatting.jq,
}

local M = {}

M.setup = function()
  null_ls.setup {
    debug = false,
    sources = sources,
    debounce = 1250,
    default_timeout = 5000,
    diagnostics_format = "[#{c}] #{m} (#{s})",
    log = { enable = true, level = "info", use_console = "async" },
  }
end

return M
