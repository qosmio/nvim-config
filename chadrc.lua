function _G.print_table(node)
  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = "{\n"

  while true do
    local size = 0
    for _, _ in pairs(node) do
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
  -- hl_override = require("custom.highlights").override,
  hl_override = require "custom.highlights.monokai-phoenix",
  changed_themes = {
    onedark = require "custom.themes.onedark-deep",
  },
  theme = "onedark", -- default theme
  -- theme = "rxyhn", --onedark-deep", -- default theme
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
