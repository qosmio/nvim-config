local ok_cmp, cmp
ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  return {
    sources = cmp.config.sources({
      { name = "luasnip",  priority = 1000 },
      { name = "zsh",      priority = 900 },
      { name = "nvim_lsp", priority = 850 },
      { name = "path",     priority = 800 },
      { name = "buffer",   priority = 700 },
    }, {
      { name = "rg", priority = 600 },
    }),
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        cmp.config.compare.kind,
      },
    },
  }
end
