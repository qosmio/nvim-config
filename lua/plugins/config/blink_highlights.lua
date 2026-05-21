pcall(function()
  dofile(vim.g.base46_cache .. "cmp")
end)

local M = {}

function M.apply()
  local palette = {
    bg = "#050505",
    border = "#5f555a",
    deprecated = "#747b86",
    detail = "#b7bdc8",
    fg = "#d7d7d7",
    kind = "#d7af00",
    match = "#268bd2",
    selection = "#3a3f45",
    selection_fg = "#ffffff",
  }

  local links = {
    BlinkCmpScrollBarGutter = "PmenuSbar",
    BlinkCmpScrollBarThumb = "PmenuThumb",
  }

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target, default = false })
  end

  vim.api.nvim_set_hl(0, "BlinkCmpMenu", {
    bg = palette.bg,
    fg = palette.fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
    bg = palette.bg,
    fg = palette.border,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
    bg = palette.selection,
    fg = palette.selection_fg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDoc", {
    bg = palette.bg,
    fg = palette.fg,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", {
    bg = palette.bg,
    fg = palette.border,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", {
    bg = palette.bg,
    fg = palette.border,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpLabel", { bg = "NONE", fg = palette.fg, bold = true })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", {
    bg = "NONE",
    fg = palette.deprecated,
    strikethrough = true,
  })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = palette.detail })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { bg = "NONE", fg = palette.detail })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = palette.match, bold = true })
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { bg = "NONE", fg = palette.detail })

  local kind_groups = {
    BlinkCmpKind = { fg = palette.kind, bold = true },
    BlinkCmpKindClass = { fg = palette.kind, bold = true },
    BlinkCmpKindColor = { fg = palette.kind, bold = true },
    BlinkCmpKindConstant = { fg = palette.kind, bold = true },
    BlinkCmpKindConstructor = { fg = palette.kind, bold = true },
    BlinkCmpKindEnum = { fg = palette.kind, bold = true },
    BlinkCmpKindEnumMember = { fg = palette.kind, bold = true },
    BlinkCmpKindEvent = { fg = palette.kind, bold = true },
    BlinkCmpKindField = { fg = palette.kind, bold = true },
    BlinkCmpKindFile = { fg = palette.kind, bold = true },
    BlinkCmpKindFolder = { fg = palette.kind, bold = true },
    BlinkCmpKindFunction = { fg = palette.kind, bold = true },
    BlinkCmpKindInterface = { fg = palette.kind, bold = true },
    BlinkCmpKindKeyword = { fg = palette.kind, bold = true },
    BlinkCmpKindMethod = { fg = palette.kind, bold = true },
    BlinkCmpKindModule = { fg = palette.kind, bold = true },
    BlinkCmpKindOperator = { fg = palette.kind, bold = true },
    BlinkCmpKindProperty = { fg = palette.kind, bold = true },
    BlinkCmpKindReference = { fg = palette.kind, bold = true },
    BlinkCmpKindSnippet = { fg = palette.kind, bold = true },
    BlinkCmpKindStruct = { fg = palette.kind, bold = true },
    BlinkCmpKindText = { fg = palette.kind, bold = true },
    BlinkCmpKindTypeParameter = { fg = palette.kind, bold = true },
    BlinkCmpKindUnit = { fg = palette.kind, bold = true },
    BlinkCmpKindValue = { fg = palette.kind, bold = true },
    BlinkCmpKindVariable = { fg = palette.kind, bold = true },
  }

  for group, hl in pairs(kind_groups) do
    hl.bg = "NONE"
    vim.api.nvim_set_hl(0, group, hl)
  end
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
