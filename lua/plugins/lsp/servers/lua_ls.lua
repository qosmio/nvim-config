local M = {}

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
        "ngx",
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
        -- vim.fn.expand "$HOME" .. "/.local/share/nvim/lazy",
      },
      -- preloadFileSize = 10,
      maxPreload = 200,
    },
    telemetry = {
      enable = false,
    },
    single_file_support = true,
  },
}

return M
