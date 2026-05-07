local remove_plugins = {
  "lukas-reineke/indent-blankline.nvim",
  "hrsh7th/nvim-cmp",
  "nvim-treesitter/nvim-treesitter",
}

local removed = {}
for _, name in ipairs(remove_plugins) do
  removed[name] = true
end

local plugins = {}
for _, plugin in ipairs(require "nvchad.plugins") do
  if not removed[plugin[1]] then
    table.insert(plugins, plugin)
  end
end

return plugins
