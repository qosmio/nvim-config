local M = {}
local u = require "custom.utils"
local api = {
  set = vim.api.nvim_set_hl,
  get = vim.api.nvim_get_hl_by_name,
  defs = vim.api.nvim__get_hl_defs,
}
local plugins = u.join_paths(vim.fn.stdpath "config", "lua", "custom", "lmburns", "lua")
package.path = u.join_paths(plugins, "?.lua") .. ";" .. package.path
package.path = u.join_paths(plugins, "?", "init.lua") .. ";" .. package.path
-- package.path = u.join_paths(plugins, "lsp", "?.lua") .. ";" .. package.path
--
-- M.color = require("custom.lmburns.lua.common.color")

M.clearEmptyTables = function(t)
  for k, v in pairs(t) do
    if type(v) == "table" then
      M.clearEmptyTables(v)
      if next(v) == nil then
        t[k] = nil
      end
    end
  end
  return t
end

M.get_hl = function(hl)
  local hl_group = vim.api.nvim_get_hl_by_name(hl, true)
  for k, color in pairs(hl_group) do
    if type(color) ~= "boolean" then
      hl_group[k] = string.format("#%06x", color)
    end
  end
  return hl_group
end

M.get_treesitter_hl = function()
  local utils = require "nvim-treesitter-playground.utils"
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local results = utils.get_hl_groups_at_position(bufnr, row, col)
  local line = { capture = {}, priority = {} }
  for _, hl in pairs(results) do
    for group, _ in pairs(hl) do
      table.insert(line[group], { ["@" .. hl[group]] = M.get_hl("@" .. hl[group]) })
    end
  end
  return M.clearEmptyTables(line)
end

M.get_syntax_hl = function()
  local line = vim.fn.line "."
  local col = vim.fn.col "."
  local matches = {}

  for _, i1 in ipairs(vim.fn.synstack(line, col)) do
    local i2 = vim.fn.synIDtrans(i1)
    local n1 = vim.fn.synIDattr(i1, "name")
    local n2 = vim.fn.synIDattr(i2, "name")
    matches[n1] = n2
  end
  return matches
end

M.show_hl_captures = function()
  local buf = vim.api.nvim_get_current_buf()
  local result = {}

  local highlighter = require "vim.treesitter.highlighter"
  if highlighter.active[buf] then
    local matches = M.get_treesitter_hl()
    result["Treesitter"] = matches
  end

  if vim.b.current_syntax ~= nil or #result == 0 then
    local matches = M.get_syntax_hl()
    result["Syntax"] = matches
  end
  print(vim.inspect(result))
end

M._hex_to_rgb = function(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

M._hex_to_8bit = function(color)
  local r, g, b = M.hex_to_rgb(color)
  local bit = require "bit"
  -- local safe = math.floor(r * 6 / 256) * 36 + math.floor(g * 6 / 256) * 6 + math.floor(b * 6 / 256)
  -- local encodedData = bit.lshift(math.floor((r / 32)), 5) + bit.lshift(math.floor((g / 32)), 2) + math.floor((b / 64))
  local encodedData = bit.lshift(math.floor(r * 7 / 255), 5)
    + bit.lshift(math.floor(g * 7 / 255), 2)
    + math.floor((b * 3 / 255))
  return encodedData
end

M.turn_str_to_color = function(tb_in)
  local tb = vim.deepcopy(tb_in)
  local colors = M.get_theme_tb "base_30"

  for _, groups in pairs(tb) do
    for k, v in pairs(groups) do
      if k == "fg" or k == "bg" then
        if v:sub(1, 1) == "#" then
          tb_in["cterm" .. k] = M.hex_to_8bit(v)
        else
          groups[k] = colors[v]
        end
      end
    end
  end

  return tb
end

M.gui_syntax_to_cterm = function(syntax)
  local tb = vim.deepcopy(syntax)
  for syn, groups in pairs(tb) do
    for k, v in pairs(groups) do
      if k == "fg" or k == "bg" then
        if v:sub(1, 1) == "#" then
          v = M.hex_to_8bit(v)
        end
        if syntax[syn]["cterm" .. k] == nil then
          syntax[syn]["cterm" .. k] = v
        end
      end
    end
    -- if syn == "St_ConfirmMode" then
    --   print(vim.inspect(syntax[syn]))
    -- end
  end
  return syntax
end

-- convert table into string
M.nvim_set_hl = function(tb)
  for hlgroupName, hlgroup_vals in pairs(tb) do
    vim.api.nvim_set_hl(0, hlgroupName, hlgroup_vals)
  end
end

M.get_component = function(comp)
  if comp > 125 then
    return (comp - 138) / 40 + 2
  elseif comp > 46 then
    return 1
  else
    return 0
  end
end

---Convert RGB decimal (RGB) to hexadecimal (#RRGGBB)
---@param dec integer
---@return string color @#RRGGBB
local function rgb_to_hex(dec)
  -- return ("#%06x"):format(dec)
  return ("#%s"):format(bit.tohex(dec, 6))
end

M.hex_to_rgb = function(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

M._hex_to_8bit = function(color)
  local r, g, b = M.hex_to_rgb(color)
  local bit = require "bit"
  -- local safe = math.floor(r * 6 / 256) * 36 + math.floor(g * 6 / 256) * 6 + math.floor(b * 6 / 256)
  -- local encodedData = bit.lshift(math.floor((r / 32)), 5) + bit.lshift(math.floor((g / 32)), 2) + math.floor((b / 64))
  local encodedData = bit.lshift(math.floor(r * 7 / 255), 5)
    + bit.lshift(math.floor(g * 7 / 255), 2)
    + math.floor((b * 3 / 255))
  return encodedData
end

M.turn_str_to_color = function(tb_in)
  local tb = vim.deepcopy(tb_in)
  local colors = M.get_theme_tb "base_30"

  for _, groups in pairs(tb) do
    for k, v in pairs(groups) do
      if k == "fg" or k == "bg" then
        if v:sub(1, 1) == "#" then
          tb_in["cterm" .. k] = M.hex_to_8bit(v)
        else
          groups[k] = colors[v]
        end
      end
    end
  end

  return tb
end

M.gui_syntax_to_cterm = function(syntax)
  local tb = vim.deepcopy(syntax)
  for syn, groups in pairs(tb) do
    for k, v in pairs(groups) do
      if k == "fg" or k == "bg" then
        if v:sub(1, 1) == "#" then
          v = M.hex_to_8bit(v)
        end
        if syntax[syn]["cterm" .. k] == nil then
          syntax[syn]["cterm" .. k] = v
        end
      end
    end
    -- if syn == "St_ConfirmMode" then
    --   print(vim.inspect(syntax[syn]))
    -- end
  end
  return syntax
end

-- convert table into string
M.nvim_set_hl = function(tb)
  for hlgroupName, hlgroup_vals in pairs(tb) do
    vim.api.nvim_set_hl(0, hlgroupName, hlgroup_vals)
  end
end

M.get_component = function(comp)
  if comp > 125 then
    return (comp - 138) / 40 + 2
  elseif comp > 46 then
    return 1
  else
    return 0
  end
end

M.hex_to_8bit = function(color)
  local rterm, bterm, gterm
  -- print(M.hex_to_rgb(color))
  local r, g, b = M.hex_to_rgb(color)
  rterm = M.get_component(r)
  gterm = M.get_component(g)
  bterm = M.get_component(b)
  return math.floor((16 + 36 * rterm + 31 * gterm + bterm))
  -- local bit = require "bit"
  -- -- local safe = math.floor(r * 6 / 256) * 36 + math.floor(g * 6 / 256) * 6 + math.floor(b * 6 / 256)
  -- -- local encodedData = bit.lshift(math.floor((r / 32)), 5) + bit.lshift(math.floor((g / 32)), 2) + math.floor((b / 64))
  -- local encodedData = bit.lshift(math.floor(r * 7 / 255), 5)
  --   + bit.lshift(math.floor(g * 7 / 255), 2)
  --   + math.floor((b * 6 / 255))
  -- return encodedData
end

---List all highlight groups, or ones matching `filter`
---@param filter string
---@param exact boolean whether filter should be exact
M.colors = function(filter, exact)
  local defs = {}
  local hl_defs = api.defs(0) or {}
  for hl_name, hl in pairs(hl_defs) do
    if filter then
      if hl_name:find(filter) then
        if exact and hl_name ~= filter then
          goto continue
        end
        local def = {}
        if hl.link then
          def.link = hl.link
        end
        for key, def_key in pairs { foreground = "fg", background = "bg", special = "sp" } do
          if type(hl[key]) == "number" then
            local hex = rgb_to_hex(hl[key])
            def[def_key] = hex
          end
        end
        for _, style in pairs {
          "bold",
          "standout",
          "italic",
          "underline",
          "undercurl",
          "reverse",
          "strikethrough",
        } do
          if hl[style] then
            def.style = (def.style and (def.style .. ",") or "") .. style
          end
        end
        defs[hl_name] = def
      end
    else
      defs = hl_defs
    end
    ::continue::
  end
  -- utils.dump(defs)
  return defs
end
return M
