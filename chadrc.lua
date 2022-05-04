function _G.print_table(node)
  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = "{\n"

  while true do
    local size = 0
    for k, v in pairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k, v in pairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then
        if string.find(output_str, "}", output_str:len()) then
          output_str = output_str .. ",\n"
        elseif not (string.find(output_str, "\n", output_str:len())) then
          output_str = output_str .. "\n"
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = ""

        local key
        if type(k) == "number" or type(k) == "boolean" then
          key = "[" .. tostring(k) .. "]"
        else
          key = "['" .. tostring(k) .. "']"
        end

        if type(v) == "number" or type(v) == "boolean" then
          output_str = output_str .. string.rep("\t", depth) .. key .. " = " .. tostring(v)
        elseif type(v) == "table" then
          output_str = output_str .. string.rep("\t", depth) .. key .. " = {\n"
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
        else
          output_str = output_str .. string.rep("\t", depth) .. key .. " = '" .. tostring(v) .. "'"
        end

        if cur_index == size then
          output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
        else
          output_str = output_str .. ","
        end
      else
        -- close the table
        if cur_index == size then
          output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
        end
      end

      cur_index = cur_index + 1
    end

    if size == 0 then
      output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
    end

    if #stack > 0 then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output, output_str)
  output_str = table.concat(output)

  print(output_str)
end

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,

M.options = {

  user = function()
    require "custom.options"
  end,

  -- NvChad options
  nvChad = {
    -- updater
    update_url = "https://github.com/qosmio/NvChad",
    update_branch = "main",
  },
}

---- UI -----

M.ui = {
  italic_comments = true,
  theme = "onedark-deep",
  hl_override = require("custom.highlights").override,
  -- Change terminal bg to nvim theme's bg color so it'll match well
  -- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
  transparency = false,
}

---- PLUGIN OPTIONS ----

M.plugins = {
  options = {
    packer = { init_file = "plugins.packerInit" },
    autopairs = { loadAfter = "nvim-cmp" },
    cmp = { lazy_load = true },
    lspconfig = {
      lazy_load = true,
      setup_lspconf = "custom.plugins.lsp", -- path of file containing setups of different lsps
    },
    nvimtree = {
      -- packerCompile required after changing lazy_load
      lazy_load = true,
    },
    -- luasnip                = {snippet_path = {}},
    statusline = {
      -- hide, show on specific filetypes
      hidden = { "help", "NvimTree", "terminal", "alpha" },
      -- truncate statusline on small screens
      shortline = true,
      style = "arrow", -- default, round , slant , block , arrow
    },
    esc_insertmode_timeout = 300,
  },
  default_plugin_config_replace = {
    ["hrsh7th/nvim-cmp"] = require "custom.plugins.config.cmp",
    ["NvChad/nvim-colorizer.lua"] = require "custom.plugins.config.colorizer",
    ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.config.treesitter",
    ["windwp/nvim-autopairs"] = require "custom.plugins.config.autopairs",
    ["kyazdani42/nvim-tree.lua"] = require "custom.plugins.config.tree",
    ["numToStr/Comment.nvim"] = require("custom.plugins.config.comment").setup(),
  },
  user = require "custom.plugins",
}

-- non plugin only
M.mappings = {
  misc = function()
    require "custom.mappings"
  end,
}

return M
