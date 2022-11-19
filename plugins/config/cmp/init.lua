local _present, comparator = pcall(require, "cmp-under-comparator")

if not _present then
  return
end

local present, cmp = pcall(require, "cmp")
if present then
  return {
    style = {
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
    formatting = {
      format = function(entry, vim_item)
        local icons = require "custom.plugins.config.cmp.lspkind_icons"
        vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          buffer = "[BUF]",
        })[entry.source.name]

        return vim_item
      end,
      symbol_map = require "custom.plugins.config.cmp.lspkind_icons",
    },
    window = {
      completion = {
        winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None",
      },
      documentation = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
    experimental = {
      native_menu = false,
      ghost_text = true,
    },
    sources = cmp.config.sources {
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      -- {
      --   name = "spell",
      --   option = {
      --     keep_all_entries = false,
      --     enable_in_context = function()
      --       return true
      --     end,
      --   },
      -- },
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lua" },
      -- { name = "calc" },
      -- { name = "luasnip" },
    },
    sorting = {
      comparators = {
        cmp.config.compare.recently_used,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        comparator.under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    preselect = cmp.PreselectMode.Item,
  }
end
