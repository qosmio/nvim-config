local M = {}

M.options = {
  nvChad = {
    update_branch = "v2.0",
  },
}
---- UI -----

M.ui = {
  -- hl_override = require "custom.highlights.monokai-phoenix",
  -- hl_add = require "custom.highlights.monokai-phoenix",
  -- hl_override = require("custom.highlights.hlo").highlight,
  hl_add = require("custom.highlights.hlo").highlight,
  theme = "onedark-deep", -- default theme
  changed_themes = {
    ["onedark-deep"] = require("custom.highlights.hlo").theme,
  },
  transparency = false,

  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "darker_black", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    overriden_modules = nil,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },
}

M.plugins = "custom.plugins"

-- non plugin only
M.mappings = require "custom.mappings"
return M
