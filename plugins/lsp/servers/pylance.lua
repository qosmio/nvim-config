-- local index = require "mason-registry.index"
local utils = require "custom.plugins.lsp.utils"

local server_name = "pylance"

local function extract_method()
  local range_params = vim.lsp.util.make_given_range_params()
  local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
  local params = {
    command = "pylance.extractMethod",
    arguments = arguments,
  }
  vim.lsp.buf.execute_command(params)
end

local function extract_variable()
  local range_params = vim.lsp.util.make_given_range_params()
  local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
  local params = {
    command = "pylance.extractVarible",
    arguments = arguments,
  }
  vim.lsp.buf.execute_command(params)
end

local function organize_imports()
  local params = {
    command = "pyright.organizeimports",
    arguments = { vim.uri_from_bufnr(0) },
  }
  vim.lsp.buf.execute_command(params)
end

local function on_workspace_executecommand(_, result, ctx)
  if ctx.params.command:match "WithRename" then
    ctx.params.command = ctx.params.command:gsub("WithRename", "")
    vim.lsp.buf.execute_command(ctx.params)
  end
  if result then
    if result.label == "Extract Method" then
      local old_value = result.data.newSymbolName
      local file = vim.tbl_keys(result.edits.changes)[1]
      local range = result.edits.changes[file][1].range.start
      local params = { textDocument = { uri = file }, position = range }
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local bufnr = ctx.bufnr
      local prompt_opts = {
        prompt = "New Method Name: ",
        default = old_value,
      }
      if not old_value:find "new_var" then
        range.character = range.character + 5
      end
      vim.ui.input(prompt_opts, function(input)
        if not input or #input == 0 then
          return
        end
        params.newName = input
        local handler = client.handlers["textDocument/rename"] or vim.lsp.handlers["textDocument/rename"]
        client.request("textDocument/rename", params, handler, bufnr)
      end)
    end
  end
end

local messages = {}

local M = {}

M.handlers = {
  ["client/registerCapability"] = false,
  ["pyright/beginProgress"] = function(_, _, _, client_id)
    require("lsp-status/util").ensure_init(messages, client_id, server_name)
    if not messages[client_id].progress[1] then
      messages[client_id].progress[1] = { spinner = 1, title = "Pylance" }
    end
  end,
  ["pyright/reportProgress"] = function(_, _, message, client_id)
    messages[client_id].progress[1].spinner = messages[client_id].progress[1].spinner + 1
    messages[client_id].progress[1].title = message[1]
    vim.api.nvim_command "doautocmd User LspMessageUpdate"
  end,
  ["pyright/endProgress"] = function(_, _, _, client_id)
    messages[client_id].progress[1] = nil
    vim.api.nvim_command "doautocmd User LspMessageUpdate"
  end,
  ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      -- Allow kwargs to be unused
      if diagnostic.message == '"kwargs" is not accessed' then
        return false
      end

      -- Prefix variables with an underscore to ignore
      if string.match(diagnostic.message, "Unused local `_.+`.") then
        return false
      end

      return true
    end, result.diagnostics)

    vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
  end,
  ["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    pcall(vim.diagnostic.reset, ns)
    return true
  end,
  ["workspace/executeCommand"] = on_workspace_executecommand,
}

M.settings = {
  editor = { {
    formatOnType = true,
    insertSpaces = true,
    tabSize = 2,
  } },
  ["[python]"] = {
    editor = {
      formatOnType = true,
      insertSpaces = true,
      tabSize = 2,
    }
  },
  python = {
    formatting = { provider = "black" },
    analysis = {
      autoImportUserSymbols = true,
      disableLanguageServices = false,
      openFilesOnly = true,
      useLibraryCodeForTypes = true,
      watchForSourceChanges = true,
      watchForLibraryChanges = false,
      watchForConfigChanges = false,
      autoImportCompletions = true,
      includeUserSymbolsInAutoImport = false,
      enableExtractCodeAction = true,
      variableInlayTypeHints = true,
      functionReturnInlayTypeHints = true,
      importFormat = "relative",
      completeFunctionParens = true,
      indexing = false,
      typeCheckingMode = "basic",
      diagnosticMode = "openFilesOnly",
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
        callArgumentNames = true,
        pytestParameters = true,
      },
      autoSearchPaths = true,
      -- Honestly just shut this thing up , its actually very annoying
      -- when it just keeps giving pointless error messages.
      diagnosticSeverityOverrides = {
        --felse: this can get very anonying
        reportMissingTypeStubs = false,
        -- stuff from top
        reportUnusedImport = "information",
        reportUnusedFunction = "none",
        reportUnusedVariable = "information",
        reportGeneralTypeIssues = "none",
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

M.commands = {
  PylanceExtractVariableWithRename = {
    extract_variable,
    description = "Extract Variable w/Rename",
  },
  PylanceExtractMethodWithRename = {
    extract_method,
    description = "Extract Method w/Rename",
  },
  PylanceExtractMethod = {
    extract_method,
    description = "Extract Method",
  },
  PylanceExtractVariable = {
    extract_variable,
    description = "Extract Variable",
  },
  PylanceOrganizeImports = {
    organize_imports,
    description = "Organize Imports",
  },
}

-- M.capabilities.textDocument.semanticTokensProvider = false

M.on_attach = function(client, bufnr)
  -- vim.lsp.set_log_level "info"
  -- if client.server_capabilities.semanticTokensProvider and client.server_capabilities.semanticTokensProvider.full then
  --   client.server_capabilities.semanticTokensProvider = false
  -- end
  require("custom.plugins.lsp.settings").on_attach(client, bufnr)
  client.commands["PylanceExtractVariableWithRename"] = function(command, _)
    command.command = "pylance.extractVariable"
    vim.lsp.buf.execute_command(command)
  end

  client.commands["PylanceExtractMethodWithRename"] = function(command, _)
    command.command = "pylance.extractMethod"
    vim.lsp.buf.execute_command(command)
  end

  vim.api.nvim_buf_create_user_command(
    bufnr,
    "PylanceOrganizeImports",
    organize_imports,
    { range = false, desc = "Organize Imports" }
  )

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
    { range = true, desc = "Extract method" }
  )
  utils.autocmds.InlayHintsAU()
end

return M
