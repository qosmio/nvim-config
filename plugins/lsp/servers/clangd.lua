local M = {}
M.cmd = {
  "/usr/bin/clangd",
  "--malloc-trim",
  "--log=error",
  "--header-insertion=iwyu",
  "--background-index",
  "-j=40",
  -- "--pch-storage=memory",
}
M.capabilities = {
  offsetEncoding = { "utf-16" },
}
_ = vim.fn.system "which clangd"
if vim.v.shell_error ~= 0 then
  M.exist = { false }
end
return M
