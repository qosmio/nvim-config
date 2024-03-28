---@class ChadrcConfig
local M = {}

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl = highlights
  -- hl_add = require "highlights.monokai-phoenix",
  -- hl_override = require "highlights.monokai-phoenix",
  -- hl_override = require("highlights.hlo").highlight,
  hl_add = require("highlights.hlo").highlight,
  theme_toggle = { "ashes", "onedark-deep" },
  theme = "onedark-deep", -- default theme
  changed_themes = {
    ["ashes"] = require("highlights.hlo").theme,
  },
  transparency = false,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    order = nil,
    modules = nil,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },

  nvdash = {
    load_on_startup = false,
    header = nil,
  },

  -- cheatsheet = { theme = "grid" }, -- simple/grid

  -- lsp = { signature = true },

  term = {
    hl = "Normal:term,WinSeparator:WinSeparator",
    sizes = { sp = 0.3, vsp = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },
}

-- M.base46 = {
--   integrations = {},
-- }

return M
