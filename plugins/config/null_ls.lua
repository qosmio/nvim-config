local utils = require "custom.plugins.lsp.utils"
local null_ls = require "null-ls"
local b = null_ls.builtins

local map = vim.keymap.set

local sources = {
  -- Javascript
  b.formatting.prettierd,

  -- Lua
  -- wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.12.3/stylua-0.12.3-linux.zip
  b.formatting.stylua,

  -- Python
  -- pip install reorder-python-imports
  b.formatting.reorder_python_imports,
  -- pip install black
  b.formatting.black,
  -- pip install yapf
  -- b.formatting.yapf,

  -- Nginx
  -- npm -g i nginxbeautifier
  b.formatting.nginx_beautifier.with { args = { "-s", 2, "-i", "-o", "$FILENAME" } },

  -- PHP
  -- composer global require "squizlabs/php_codesniffer=*"
  -- b.formatting.phpcbf,
  -- b.diagnostics.php,

  -- C/Clang
  -- b.formatting.clang_format,

  -- ZSH
  b.diagnostics.zsh,

  -- Bash
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
  b.formatting.shfmt.with {
    runtime_condition = utils.common.has_exec "shfmt",
    extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  },
  -- b.formatting.shellharden.with {
  --   runtime_condition = utils.common.has_exec "shellharden",
  --   extra_filetypes = { "zsh", "bash", "sh" },
  -- },
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
