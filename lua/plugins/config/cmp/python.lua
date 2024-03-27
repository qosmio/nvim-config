local ok_cmp, cmp
ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  return {
    sources = cmp.config.sources {
      -- { name = "nvim_lsp_signature_help", priority = 1001 },
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 950 },
      { name = "buffer", priority = 900 },
      { name = "path", priority = 800 },
    },
    sorting = {
      comparators = {
        cmp.config.compare.recently_used,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end
