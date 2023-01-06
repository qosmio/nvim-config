local ok_cmp, cmp
ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  local config = {
    -- sources = {
    --   {
    --     name = "nvim_lsp",
    --     priority = 100,
    --     group_index = 1,
    --     -- keyword_length = 2,
    --     max_item_count = 10,
    --   },
    --   {
    --     name = "nvim_lsp_signature_help",
    --     priority = 70,
    --     group_index = 1,
    --   },
    --   {
    --     name = "buffer",
    --     priority = 50,
    --     group_index = 1,
    --     keyword_length = 2,
    --     max_item_count = 5,
    --   },
    -- },
    sorting = {
      comparators = {
        cmp.config.compare.locality,
        cmp.config.compare.score,
        cmp.config.compare.offset,
        cmp.config.compare.recently_used,
        cmp.config.compare.order,
      },
    },
  }
  cmp.setup.filetype("python", vim.tbl_deep_extend("force", require "custom.plugins.config.cmp", config))
end
