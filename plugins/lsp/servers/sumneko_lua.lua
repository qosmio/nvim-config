local M = {}
local has_neodev, neodev_config = pcall(require, "neodev.config")
if not has_neodev then
  return
end

local add_packages_to_workspace = function(packages, config)
  -- config.settings.Lua = config.settings.Lua or { workspace = default_workspace }
  local runtimedirs = vim.api.nvim__get_runtime({ "lua" }, true, { is_lua = true })
  local workspace = config.settings.Lua.workspace
  if type(runtimedirs) ~= "nil" then
    for _, v in pairs(runtimedirs) do
      for _, pack in ipairs(packages) do
        if v:match(pack) and not vim.tbl_contains(workspace.library, v) then
          table.insert(workspace.library, v)
        end
      end
    end
  end
end

local lspconfig = require "lspconfig"

local make_on_new_config = function(on_new_config, _)
  return lspconfig.util.add_hook_before(on_new_config, function(new_config, _)
    local server_name = new_config.name

    if server_name ~= "sumneko_lua" then
      return
    end
    local plugins = { "nvim-cmp", "plenary.nvim", "nvim-treesitter" }
    add_packages_to_workspace(plugins, new_config)
  end)
end

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_new_config = make_on_new_config(lspconfig.util.default_config.on_new_config),
})

M.name = "sumneko_lua"
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
