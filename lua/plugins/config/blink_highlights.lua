pcall(function()
  dofile(vim.g.base46_cache .. "cmp")
end)

local M = {}

local function get_hl(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    return hl
  end
  return {}
end

local function hl_with_bg(group, bg, fallback)
  local hl = get_hl(group)
  if next(hl) == nil then
    hl = fallback or {}
  else
    hl = vim.deepcopy(hl)
  end

  hl.bg = bg or "NONE"
  return hl
end

function M.apply()
  local normal = get_hl "Normal"
  local normal_bg = normal.bg
  local normal_fg = normal.fg
  local pmenu = get_hl "Pmenu"
  local border = get_hl "FloatBorder"
  local match = get_hl "CmpItemAbbrMatch"

  local links = {
    BlinkCmpKind = "CmpItemKindText",
    BlinkCmpKindClass = "CmpItemKindClass",
    BlinkCmpKindConstructor = "CmpItemKindConstructor",
    BlinkCmpKindFunction = "CmpItemKindFunction",
    BlinkCmpKindInterface = "CmpItemKindInterface",
    BlinkCmpKindKeyword = "CmpItemKindKeyword",
    BlinkCmpKindMethod = "CmpItemKindMethod",
    BlinkCmpKindSnippet = "CmpItemKindSnippet",
    BlinkCmpKindText = "CmpItemKindText",
    BlinkCmpKindVariable = "CmpItemKindVariable",
    BlinkCmpMenuSelection = "PmenuSel",
    BlinkCmpScrollBarGutter = "PmenuSbar",
    BlinkCmpScrollBarThumb = "PmenuThumb",
  }

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target, default = false })
  end

  vim.api.nvim_set_hl(0, "BlinkCmpMenu", {
    bg = normal_bg or "NONE",
    fg = pmenu.fg or normal_fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
    bg = normal_bg or "NONE",
    fg = border.fg or pmenu.fg or normal_fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDoc", {
    bg = normal_bg or "NONE",
    fg = normal_fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", {
    bg = normal_bg or "NONE",
    fg = border.fg or normal_fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", {
    bg = normal_bg or "NONE",
    fg = border.fg or normal_fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpLabel", hl_with_bg("CmpItemAbbr", "NONE", { fg = normal_fg }))
  vim.api.nvim_set_hl(
    0,
    "BlinkCmpLabelDescription",
    hl_with_bg("CmpItemMenu", "NONE", { fg = normal_fg })
  )
  vim.api.nvim_set_hl(
    0,
    "BlinkCmpLabelDetail",
    hl_with_bg("CmpItemMenu", "NONE", { fg = normal_fg })
  )
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", hl_with_bg("CmpItemAbbrMatch", "NONE", match))
  vim.api.nvim_set_hl(0, "BlinkCmpSource", hl_with_bg("CmpItemMenu", "NONE", { fg = normal_fg }))
end

function M.setup()
  M.apply()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserBlinkCmpHighlights", { clear = true }),
    callback = function()
      M.apply()
    end,
  })
end

return M
