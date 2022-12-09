local M = {}

M.options = {}

---- UI -----

M.ui = {
  hl_override = require "custom.highlights.monokai-phoenix",
  hl_add = require "custom.highlights.monokai-phoenix",
  -- hl_override = require "custom.highlights.hl_override",
  -- hl_add = require "custom.highlights.hl_add",
  changed_themes = {
    onedark = require "custom.themes.onedark-deep",
  },
  theme = "onedark", -- default theme
  transparency = false,
}

M.plugins = require "custom.plugins"

-- non plugin only
M.mappings = require "custom.mappings"

return M
