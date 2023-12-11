local present, compare = pcall(require, "cmp.config.compare")
local M = {}

require("cmp_tabnine.config"):setup {
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
  ignored_file_types = { -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
  show_prediction_strength = true,
}
if not present then
  return
end
local G = require("cmp.config").global

local S = {
  sorting = {
    priority_weight = 2,
    comparators = {
      require "cmp_tabnine.compare",
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  sources = {
    { name = "cmp_tabnine" },
  },
  formatting = {
    format = function(entry, item)
      local cmp_ui = require("core.utils").load_config().ui.cmp
      local icons = require "nvchad.icons.lspkind"
      local cmp_style = cmp_ui.style
      if entry.source.name == "cmp_tabnine" then
        item.kind = "Tabnine"
        local detail = (entry.completion_item.data or {}).detail
        if detail and detail:find ".*%%.*" then
          item.menu = " " .. detail
        end

        if (entry.completion_item.data or {}).multiline then
          item.menu = " " .. "[ML]"
        end
      end

      local icon = (cmp_ui.icons and icons[item.kind]) or ""

      if cmp_style == "atom" or cmp_style == "atom_colored" then
        icon = " " .. icon .. " "
        item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
        item.kind = icon
      else
        icon = cmp_ui.lspkind_text and (" " .. icon .. "") or icon
        item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
      end
      return item
    end,
  },
}

S.sources = vim.tbl_deep_extend("force", G.sources, S.sources)

local config = vim.tbl_deep_extend("force", G, S)

M.setup = function()
  require("cmp").setup(config)
end
return M
