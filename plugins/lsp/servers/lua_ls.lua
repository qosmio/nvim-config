local M = {}
local has_neodev, neodev_config = pcall(require, "neodev.config")
if not has_neodev then
  return
end

M.name = "lua_ls"
M.settings = {
  Lua = {
    runtime = {
      version = "LuaJIT",
      special = {
        reload = "require",
      },
    },
    diagnostics = {
      disable = {
        "lowercase-global",
        "undefined-global",
      },
      globals = {
        "vim",
        "unpack",
        "use",
        "packer_plugins",
        "reload",
      },
    },
    completion = {
      keywordSnippet = "Replace",
      callSnippet = "Replace",
    },
    workspace = {
      checkThirdParty = false,
      library = {
        vim.fn.expand "$VIMRUNTIME",
        neodev_config.types(),
      },
      preloadFileSize = 10000,
      maxPreload = 5000,
    },
    telemetry = {
      enable = false,
    },
    single_file_support = true,
  },
}

return M
