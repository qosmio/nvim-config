---@class ChadrcConfig
local M = {}

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl_override = require("highlights.hlo").highlight,
  hl_add = require("highlights.hlo").highlight,
  theme_toggle = { "yoru", "onedark-deep" },
  theme = "yoru", -- default theme
  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default",             -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "darker_black", -- only applicable for "default" style, use color names from base30 variables
    -- selected_item_bg = "colored",  -- colored / simple
  },

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    -- order = nil,
    -- modules = nil,
  },

  -- tabufline = {
  --   enabled = true,
  --   lazyload = true,
  --   order = { "treeOffset", "buffers", "tabs", "btns" },
  --   modules = nil,
  -- },

  -- lsp = { signature = true },
}

return M
