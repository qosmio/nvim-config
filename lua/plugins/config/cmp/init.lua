dofile(vim.g.base46_cache .. "cmp")

local status_ok, compare = pcall(require, "cmp.config.compare")
if not status_ok then
  return
end

local cmp = require "cmp"

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local options = {
  -- enabled = vim.bo.filetype ~= "python" and true or false,
  window = {
    completion = {
      -- side_padding = 1,
      border = border "FloatBorder",
      -- winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "FloatBorder",
      scrollbar = false,
      -- winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  performance = { max_view_entries = 20 },
  experimental = {
    ghost_text = true,
  },
  -- matching = {
  --   disallow_fuzzy_matching = false,
  --   disallow_partial_fuzzy_matching = false,
  --   disallow_partial_matching = false,
  --   disallow_prefix_unmatching = true,
  -- },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp", keyword_length = 0, max_item_count = 5 },
    { name = "copilot", keyword_length = 1, max_item_count = 3 },
    { name = "buffer", max_item_count = 5, keyword_length = 2 },
    { name = "path", max_item_count = 5 },
    { name = "nvim_lua" },
  },
  -- sources = require("cmp").config.sources({ name = "copilot", group_index = 1, priority = 902 }, {
  --   {
  --     name = "luasnip",
  --     keyword_length = 2,
  --     priority = 901,
  --   },
  --   { name = "nvim_lua", priority = 900 },
  --   { name = "nvim_lsp", keyword_length = 0, priority = 800 },
  --   { name = "path", priority = 700 },
  -- }, {
  --   { name = "buffer", priority = 800 },
  -- }),
  sorting = {
    priority_weight = 1,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.length,
      compare.order,
    },
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.snippet.active { direction = 1 } then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
}

local extend = vim.tbl_deep_extend("force", require "nvchad.cmp", options)

return extend
