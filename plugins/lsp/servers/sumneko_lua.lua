local capabilities = vim.lsp.protocol.make_client_capabilities()
local utils = require "custom.plugins.lsp.utils"

return require("lua-dev").setup {
  flags = {
    debounce_text_changes = 250,
  },
  library = { vimruntime = true, plugins = { "nvim-cmp", "plenary.nvim" }, types = true },
  lspconfig = {
    on_attach = utils.common.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
    settings = {
      format = { enable = false },
      init_options = { documentFormatting = true, codeAction = false },
      Lua = {
        runtime = {
          version = "LuaJIT",
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
            "packer_plugins",
          },
        },
        completion = {
          keywordSnippet = "Replace",
          callSnippet = "Replace",
        },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file("", true),
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
          preloadFileSize = 100000,
          maxPreload = 10000,
        },
        telemetry = {
          enable = false,
        },
        single_file_support = true,
      },
    },
  },
}
