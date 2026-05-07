vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "plugins.config._lazy"

---@generic T
---@param key string
---@param val T
---@return T
_G.OPT = function(key, val)
  return vim.g[key] and vim.g[key] or val
end

---@type LazyConfig
local lazy_defaults = {
  change_detection = {
    enabled = false,
    notify = false,
  },
  dev = {
    -- path = vim.fn.stdpath "config" .. "/dev", -- ~/.config/nvim/dev
    fallback = true, -- // if local not found, use github
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

lazy_config = vim.tbl_deep_extend("force", lazy_defaults, lazy_config)

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "plugins.nvchad_plugins",
    config = function()
      require "nvchad.options"
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"
require "autocmds"

-- print(vim.inspect(base46.table_to_str(require "highlights")))

vim.schedule(function()
  require "mappings"
end)
