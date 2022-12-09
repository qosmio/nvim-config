-- Quick note about this language server, it does not provide proper documentation
-- and i also think, though yest it is very fast, it does have issues.
vim.cmd [[packadd nvim-semantic-tokens]]

local utils = require "custom.plugins.lsp.utils"
-- local path = require("lspconfig/util").path
local path = require "mason-core.path"

local function organize_imports()
  local params = {
    command = "pyright.organizeimports",
    arguments = { vim.uri_from_bufnr(0) },
  }
  vim.lsp.buf.execute_command(params)
end

local function extract_variable()
  local pos_params = vim.lsp.util.make_given_range_params()
  local params = {
    command = "pylance.extractVariable",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      pos_params.range,
    },
  }
  vim.lsp.buf.execute_command(params)
  -- vim.lsp.buf.rename()
end

local function extract_method()
  local pos_params = vim.lsp.util.make_given_range_params()
  local params = {
    command = "pylance.extractMethod",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      pos_params.range,
    },
  }
  vim.lsp.buf.execute_command(params)
end

local M = {}
-- local Path = require "plenary.path"
-- local scan = require "plenary.scandir"

-- function pathFinder(hidden_file, filename, error)
--   hidden_file = hidden_file or false
--
--   local cwd = vim.fn.getcwd()
--   local current_path = vim.api.nvim_exec(":echo @%", true)
--   local parents = Path:new(current_path):parents()
--   for _, parent in pairs(parents) do
--     local files = scan.scan_dir(parent, { hidden = hidden_file, depth = 1 })
--     for _, file in pairs(files) do
--       if file == parent .. "/" .. filename then
--         return parent, file
--       end
--     end
--
--     if parent == cwd then
--       break
--     end
--   end
--
--   vim.notify(error, vim.log.levels.ERROR, { title = "py.nvim" })
-- end

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv via poetry in workspace directory.
  -- Change this to get it from the root file where git is
  local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
  -- local match = pathFinder(false, poetry.lock, "Poetry env not found")
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
    return path.join(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

require("nvim-semantic-tokens").setup {
  preset = "default",
  highlighters = { require "nvim-semantic-tokens.table-highlighter" },
}

M.attach_config = function(client, bufnr)
  local caps = client.server_capabilities
  if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
    vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.buf.semantic_tokens_full()]]
  end

  client.commands["pylance.extractVariableWithRename"] = function(command, _)
    command.command = "pylance.extractVariable"
    vim.lsp.buf.execute_command(command)
  end

  client.commands["pylance.extractMethodWithRename"] = function(command, _)
    command.command = "pylance.extractMethod"
    vim.lsp.buf.execute_command(command)
  end

  vim.api.nvim_buf_create_user_command(bufnr, "PylanceOrganizeImports", organize_imports, { desc = "Organize Imports" })

  vim.api.nvim_buf_create_user_command(
    bufnr,
    "PylanceExtractVariable",
    extract_variable,
    { range = true, desc = "Extract variable" }
  )

  vim.api.nvim_buf_create_user_command(
    bufnr,
    "PylanceExtractMethod",
    extract_method,
    { range = true, desc = "Extract methdod" }
  )

  utils.autocmds.InlayHintsAU()
  utils.autocmds.SemanticTokensAU()
end

M.settings = {
  python = {
    analysis = {
      completeFunctionParens = true,
      indexing = true,
      typeCheckingMode = "none",
      diagnosticMode = "openFilesOnly",
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
      },
      -- Honestly just shut this thing up , its actually very annoying
      -- when it just keeps giving pointless error messages.
      diagnosticSeverityOverrides = {
        --felse: this can get very anonying
        reportMissingTypeStubs = false,
        -- stuff from top
        reportGeneralTypeIssues = false,
        reportUnboundVariable = false,
        reportUndefinedVariable = "error",
        reportUntypedClassDecorator = "none",
        reportUntypedFunctionDecorator = "none",
        reportFunctionMemberAccess = false,
        --
        reportUnknownMemberType = false,
        reportUnknownVariableType = false,
        reportUnknownArgumentType = false,
        reportUnknownParameterType = false,
        reportUnknownLambdaType = false,
        strictParameterNoneValue = false,
        reportOptionalSubscript = false,
        reportOptionalMemberAccess = false,
        reportOptionalIterable = false,
        reportOptionalCall = "none",
      },
    },
  },
}
M.before_init = function(_, config)
  local stub_path =
    require("lspconfig/util").path.join(vim.fn.stdpath "data", "site", "pack", "packer", "opt", "python-type-stubs")
  config.settings.python.analysis.stubPath = stub_path
end

M.on_init = function(client)
  client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
end

return M
