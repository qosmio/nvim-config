local ok_cmp, cmp, comp
ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  ok_cmp, comp = pcall(require, "cmp-under-comparator")
  if ok_cmp then
    local config = {
      sources = cmp.config.sources {
        { name = "zsh" },
        { name = "path" },
        { name = "buffer" },
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          comp.under,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
          cmp.config.compare.kind,
        },
      },
    }
    cmp.setup.filetype("zsh", vim.tbl_deep_extend("force", require "config.cmp", config))
  end
end
