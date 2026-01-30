local config = {
  -- autostart = true,
  settings = {
    pyrefly = {
      disableLanguageServices = false,
      disableTypeErrors = true,
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.codeActionProvider = false -- basedpyright has more kinds
    client.server_capabilities.documentSymbolProvider = false -- basedpyright has more kinds
    client.server_capabilities.hoverProvider = false -- basedpyright has more kinds
    client.server_capabilities.inlayHintProvider = false -- basedpyright has more kinds
    client.server_capabilities.referenceProvider = false -- basedpyright has more kinds
    client.server_capabilities.signatureHelpProvider = false -- basedpyright has more kinds
    client.handlers["textDocument/publishDiagnostics"] = function() end
  end,
  -- automatically identify virtualenvs set with pyenv
  -- on_new_config = function(_config, _)
  --   local python_path
  --   local virtual_env = vim.env.VIRTUAL_ENV or vim.env.PYENV_VIRTUAL_ENV
  --   if virtual_env then
  --     python_path = vim.fs.joinpath(virtual_env, "bin", "python")
  --   else
  --     python_path = "python"
  --   end
  --   vim.print(python_path)
  --   _config.settings.python.pythonPath = python_path
  -- end,
  -- root_markers = (function()
  --   local patterns = {
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "poetry.lock",
    "pyrightconfig.json",
    "pyproject.toml",
    "pyrefly.toml",
    ".git",
  },
  --   return patterns
  --   -- return util.root_pattern(patterns)(fname) or vim.fs.dirname(fname)
  -- end)(),
}
-- local json = require "utils.json"
-- vim.print(json:pretty_print(config.settings.pyrefly))
-- vim.print(config)
return config
