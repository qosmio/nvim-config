local M = {}

M.options = {

  -- NvChad options
  nvChad = {
    -- updater
    update_url = "https://github.com/qosmio/NvChad",
    update_branch = "main",
  },
}

---- UI -----

M.ui = {
  -- hl_override = require "custom.highlights.monokai-phoenix",
  hl_add = require "custom.highlights.monokai-phoenix",
  hl_override = require "custom.highlights.hl_override",
  -- hl_add = require "custom.highlights.hl_add",
  changed_themes = {
    onedark = require "custom.themes.onedark-deep",
  },
  theme = "onedark", -- default theme
  transparency = false,
}

local plugins = require "custom.plugins"

M.plugins = {

  remove = plugins.remove,
  override = plugins.override,
  user = plugins.user,

  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lsp", -- path of file containing setups of different lsps
    },
    statusline = {
      separator_style = "default", -- default/round/block
    },
  },
}
-- non plugin only
M.mappings = require "custom.mappings"

return M
