local util = require "lspconfig.util"
-- highlight self and cls as a builtin variables
local function ts_highlight_self(args)
  local token = args.data.token
  -- vim.print(token)
  if token.type ~= "parameter" then
    return
  end

  -- TODO: check performance impact of getting text so frequently
  local text = vim.api.nvim_buf_get_text(
    args.buf,
    token.line,
    token.start_col,
    token.line,
    token.end_col,
    {}
  )[1]

  if text ~= "self" and text ~= "cls" then
    return
  end
  vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "@variable.builtin")
end

-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--   callback = ts_highlight_self,
-- })
local config = {
  autostart = true,
  settings = {
    basedpyright = {
      analysis = {
        -- autoImportCompletions = true,
        -- autoSearchPaths = true,
        -- useLibraryCodeForTypes = true,
        -- diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        extraPaths = require("utils").get_current_python_package_paths(),
        diagnosticSeverityOverrides = {
          reportMissingTypeStubs = false,
          reportPrivateImportUsage = false,
          reportMissingParameterType = false,
          reportUnusedImport = "warning",
          reportUnusedFunction = "information",
          reportUnusedVariable = "information",
          reportGeneralTypeIssues = "information",
          reportUnboundVariable = false,
          reportUndefinedVariable = "error",
          reportUntypedClassDecorator = false,
          reportUntypedFunctionDecorator = false,
          reportFunctionMemberAccess = false,
          reportUnknownMemberType = false,
          reportUnknownVariableType = false,
          reportUnknownArgumentType = false,
          reportUnknownParameterType = false,
          reportUnknownLambdaType = false,
          strictParameterNoneValue = false,
          reportOptionalSubscript = false,
          reportOptionalMemberAccess = false,
          reportOptionalIterable = false,
          reportOptionalCall = false,
          reportAttributeAccessIssue = false,
        },
        -- inlayHints = {
        --   variableTypes = true,
        --   functionReturnTypes = true,
        --   callArgumentNames = true,
        --   pytestParameters = true,
        -- },
        -- -- autoImportUserSymbols = true,
        -- -- disableLanguageServices = false,
        -- -- watchForSourceChanges = true,
        -- -- watchForLibraryChanges = true,
        -- -- watchForConfigChanges = false,
        -- -- includeUserSymbolsInAutoImport = false,
        -- enableExtractCodeAction = true,
        -- variableInlayTypeHints = true,
        -- functionReturnInlayTypeHints = true,
        -- -- importFormat = "relative",
        -- completeFunctionParens = true,
        -- -- indexing = false,
      },
    },
  },
  -- automatically identify virtualenvs set with pyenv
  -- on_new_config = function(_config, _)
  --   local python_path
  --   local virtual_env = vim.env.VIRTUAL_ENV or vim.env.PYENV_VIRTUAL_ENV
  --   if virtual_env then
  --     python_path = util.path.join(virtual_env, "bin", "python")
  --   else
  --     python_path = "python"
  --   end
  --   vim.print(python_path)
  --   _config.settings.python.pythonPath = python_path
  -- end,
  root_dir = function(fname)
    local patterns = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "poetry.lock",
      "pyrightconfig.json",
    }
    return util.root_pattern(patterns)(fname) or vim.fs.dirname(fname)
  end,
}
-- vim.print(config)
return config
