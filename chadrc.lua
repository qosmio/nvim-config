local M = {}

M.options = {
  nvchad_branch = "v2.0",
}

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl = highlights
  -- hl_override = require "custom.highlights.monokai-phoenix",
  -- hl_add = require "custom.highlights.monokai-phoenix",
  -- hl_override = require("custom.highlights.hlo").highlight,
  hl_add = require("custom.highlights.hlo").highlight,
  theme_toggle = { "onedark-deep", "onedark" },
  theme = "onedark-deep", -- default theme
  changed_themes = {
    ["onedark-deep"] = require("custom.highlights.hlo").theme,
  },
  transparency = false,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  -- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
  extended_integrations = { "notify", "bufferline" }, -- these aren't compiled by default, ex: "alpha", "notify"

  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "darker_black", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    overriden_modules = nil,
  },

  -- lazyload it when there are 1+ buffers
  -- tabufline = {
  --   show_numbers = false,
  --   enabled = true,
  --   lazyload = true,
  --   overriden_modules = nil,
  -- },

  -- nvdash (dashboard)
  -- nvdash = {
  --   load_on_startup = true,
  -- },

  cheatsheet = { theme = "grid" }, -- simple/grid

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
}

M.plugins = "custom.plugins"

-- M.lazy_nvim = require "plugins.configs.lazy_nvim" -- config for lazy.nvim startup options

M.mappings = require "custom.mappings"

return M
