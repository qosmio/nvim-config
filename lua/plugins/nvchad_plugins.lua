local M = {}

local remove_plugins = {
  "lukas-reineke/indent-blankline.nvim",
  "hrsh7th/nvim-cmp",
}

M.nvchad_plugins = require "nvchad.plugins"

for i, plugin in pairs(M.nvchad_plugins) do
  -- if any of the plugins in remove_plugins are found, remove them
  for _, remove_plugin in pairs(remove_plugins) do
    if plugin[1] == remove_plugin then
      table.remove(M.nvchad_plugins, i)
    end
  end
end

return M.nvchad_plugins
