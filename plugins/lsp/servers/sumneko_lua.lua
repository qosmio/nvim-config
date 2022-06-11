local configs = {
  -- on_attach = utils.common.on_attach,
  flags = { debounce_text_changes = 250 },
  -- root_dir = function(fname)
  --   local util = require "lspconfig.util"
  --   local root_files = {
  --     '.luarc.json',
  --     '.luacheckrc',
  --     '.stylua.toml',
  --     '.',
  --   }
  --   return util.root_pattern(unpack(root_files))(fname)
  -- end,
  settings = {
    format = { enable = false },
    init_options = { documentFormatting = true, codeAction = false },
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        enable = true,
        disable = {
          "lowercase-global",
          "undefined-global",
          "unused-local",
          "unused-vararg",
          "trailing-space",
        },
        globals = {
          "vim",
          "use",
          "lowercase-global",
          "undefined-global",
          "unused-local",
          "unused-vararg",
          "trailing-space",
          "packer_plugins"
        },
      },
      completion = {
        keywordSnippet = "Replace",
        callSnippet = "Replace",
      },
      workspace = {
        -- ibrary = vim.api.nvim_get_runtime_file("", true),
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true },
        preloadFileSize = 100000,
        maxPreload = 10000
      },
      telemetry = {
        enable = false,
      },
      single_file_support = true,
    },
  },
}

return configs
