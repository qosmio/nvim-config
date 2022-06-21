local M = {}
M.setup = function()
  local present, path = pcall(require, "nvim-lsp-installer.path")
  if not present then
    return
  end
  print(vim.inspect(path))
  local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }
  local _present, go = pcall(require, "go")
  if not _present then
    return
  end
  go.setup {
    gopls_cmd = { install_root_dir .. "/gopls/gopls" },
    filstruct = "gopls",
    dap_debug = true,
    dap_debug_gui = true,
  }
end
return M
