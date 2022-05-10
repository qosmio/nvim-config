local null_ls  = require('null-ls')
local b        = null_ls.builtins
local map      = require('core.utils').map
-- local platform = require('nvim-lsp-installer.platform')

local sources  = {

  -- Javascript
  -- b.diagnostics.eslint,
  b.formatting.prettier_d_slim.with({
    extra_args = {'--no-semi', '--single-quote', '--jsx-single-quote'},
    filetypes  = {'javascript', 'css', 'less', 'html', 'json', 'yaml', 'markdown'}
  }),
  -- Lua
  -- wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.12.3/stylua-0.12.3-linux.zip
  b.formatting.stylua,
  -- b.formatting.lua_format.with {
  --   -- args    = { "-c", os.getenv("HOME") .. "/.config/luaformatter/config.yaml", "-i" },
  --   command = function()
  --     local ostype = "-linux-gnu"
  --     if platform.is_linux then
  --       if platform.is_arm64 then
  --         return "lua-format_" .. platform.arch .. ostype
  --       end
  --       return "lua-format_" .. platform.arch .. ostype
  --     else
  --       return "lua-format_x64-darwin"
  --     end
  --   end
  -- },
  -- b.diagnostics.luacheck.with {
  --   args = {
  --     "--globals",
  --     "vim",
  --     "--formatter",
  --     "plain",
  --     "--codes",
  --     "--ranges",
  --     "--filename",
  --     "$FILENAME",
  --     "-"
  --   }
  -- },
  --
  -- Bash
  -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
  b.formatting.shfmt,
  --
  -- Python
  -- pip install reorder-python-imports
  b.formatting.reorder_python_imports,
  -- pip install black
  -- b.formatting.black,
  b.formatting.yapf,
  -- pip install -U git+git://github.com/python/mypy.git
  -- b.diagnostics.mypy.with {
  --    args = function(params)
  --       return {
  --          "--hide-error-codes",
  --          "--hide-error-context",
  --          "--no-color-output",
  --          "--show-column-numbers",
  --          "--show-error-codes",
  --          "--no-error-summary",
  --          "--no-pretty",
  --          "--cache-dir",
  --          join_paths(stdpath "cache", "mypy"),
  --          "--shadow-file",
  --          params.bufname,
  --          params.temp_path,
  --          params.bufname,
  --       }
  --    end,
  -- },
  -- pip install flake8
  -- b.diagnostics.flake8,

  -- Nginx
  -- npm -g i nginxbeautifier
  b.formatting.nginx_beautifier,
  -- PHP
  -- composer global require "squizlabs/php_codesniffer=*"
  -- b.formatting.phpcbf,
  -- b.formatting.clang_format,
  -- b.diagnostics.php,
  b.diagnostics.zsh,
  b.diagnostics.shellcheck.with {diagnostics_format = "#{m} [#{c}]"}
}

local M        = {}

M.setup = function()
  null_ls.setup({
    debug              = false,
    sources            = sources,
    debounce           = 1250,
    default_timeout    = 5000,
    diagnostics_format = '[#{c}] #{m} (#{s})',
    fallback_severity  = vim.diagnostic.severity.ERROR,
    log                = {enable      = true, level       = 'warn', use_console = 'async'},
    on_attach          = function(client)
      if client.server_capabilities.documentFormattingProvider then
        map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')
      elseif client.server_capabilities.documentRangeFormattingProvider then
        map('n', '<leader>F', '<cmd>lua vim.lsp.buf.range_formatting()<CR>')
      end
    end
  })
end

return M
