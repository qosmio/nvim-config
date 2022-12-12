local M = {}

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
  -- print(vim.inspect(hl))
  local hl_group = vim.api.nvim_get_hl_by_name(hl, true)
  for k, color in pairs(hl_group) do
    hl_group[k] = string.format("#%06x", color)
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

M.hex_to_rgb = function(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

M.hex_to_8bit = function(color)
  local r, g, b = M.hex_to_rgb(color)
  local bit = require "bit"
  -- local safe = math.floor(r * 6 / 256) * 36 + math.floor(g * 6 / 256) * 6 + math.floor(b * 6 / 256)
  -- local encodedData = bit.lshift(math.floor((r / 32)), 5) + bit.lshift(math.floor((g / 32)), 2) + math.floor((b / 64))
  local encodedData = bit.lshift(math.floor(r * 7 / 255), 5)
      + bit.lshift(math.floor(g * 7 / 255), 2)
      + math.floor((b * 3 / 255))
  return encodedData
end

M.gui_syntax_to_cterm = function(syntax)
  for i, x in pairs(syntax) do
    if x.bg ~= "NONE" then
      syntax[i].ctermbg = M.hex_to_8bit(x.bg)
    else
      syntax[i].ctermbg = "NONE"
    end
    if x.fg ~= "NONE" then
      syntax[i].ctermfg = M.hex_to_8bit(x.fg)
    else
      syntax[i].ctermfg = "NONE"
    end
  end
  return syntax
end

return M
