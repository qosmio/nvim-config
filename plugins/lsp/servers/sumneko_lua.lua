local M = {}
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local utils = require "custom.plugins.lsp.utils"
local has_neodev, neodev = pcall(require, "neodev")
if not has_neodev then
  return
end
neodev.setup {
  library = { plugins = { "nvim-cmp", "plenary.nvim" } },
}

M.setup = {
  settings = {
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
        checkThirdParty = false,
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
  on_attach = utils.common.on_attach,
  capabilities = capabilities,
}

return M
