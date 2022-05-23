local ensure_installed = {
  "dockerls",
  "vimls",
  "jsonls",
  "pylance",
  "bashls",
  "yamlls",
  "diagnosticls",
}

return {
  ensure_installed = (function()
    local out = vim.fn.system "which node"
    if vim.v.shell_error ~= 0 then
      return false
    else
      return ensure_installed -- only install if gcc is installed
    end
  end)(),
}
