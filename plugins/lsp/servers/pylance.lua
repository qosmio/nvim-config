local index = require "mason-registry.index"
local utils = require "custom.plugins.lsp.utils"

local server_name = "pylance"
index[server_name] = "custom.plugins.lsp.installers.pylance"

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
  -- vim.lsp.buf.rename()
end

local organize_imports = function()
  local params = { command = "pyright.organizeimports", arguments = { vim.uri_from_bufnr(0) } }
  vim.lsp.buf.execute_command(params)
end

local on_workspace_executecommand = function(_, result, ctx)
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
        local _handler = client.handlers["textDocument/rename"] or vim.lsp.handlers["textDocument/rename"]
        client.request("textDocument/rename", params, _handler, bufnr)
      end)
    end
  end
end

local messages = {}

local M = {}

M.handlers = {
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
  ["workspace/executeCommand"] = on_workspace_executecommand,
}

M.settings = {
  editor = { {
    formatOnType = true,
    insertSpaces = true,
    tabSize = 2,
  } },
  ["[python]"] = { editor = {
    formatOnType = true,
    insertSpaces = true,
    tabSize = 2,
  } },
  python = {
    formatting = { provider = "black" },
    analysis = {
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
      indexing = true,
      typeCheckingMode = "basic",
      diagnosticMode = "openFilesOnly",
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
      },
      autoSearchPaths = true,
      -- Honestly just shut this thing up , its actually very annoying
      -- when it just keeps giving pointless error messages.
      diagnosticSeverityOverrides = {
        --felse: this can get very anonying
        reportMissingTypeStubs = false,
        -- stuff from top
        reportUnusedImport = "information",
        reportUnusedFunction = "information",
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
    -- experiments = { optInto = { "Experiment1", "Experiment13", "Experiment56", "Experiment106" } },
  },
}

M.commands = {
  PylanceExtractVariableWithRename = {
    extract_variable,
    description = "Extract Variable",
  },
  PylanceExtractMethodWithRename = {
    extract_method,
    description = "Extract Method",
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

-- M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.on_attach = function(client, bufnr)
  -- local caps = client.server_capabilities
  -- caps.semanticTokensProvider = {
  --   legend = {
  --     tokenTypes = {
  --       "comment",
  --       "keyword",
  --       "string",
  --       "number",
  --       "regexp",
  --       "type",
  --       "class",
  --       "interface",
  --       "enum",
  --       "enumMember",
  --       "typeParameter",
  --       "function",
  --       "method",
  --       "property",
  --       "variable",
  --       "parameter",
  --       "module",
  --       "intrinsic",
  --       "selfParameter",
  --       "clsParameter",
  --       "magicFunction",
  --       "builtinConstant",
  --     },
  --     tokenModifiers = {
  --       "declaration",
  --       "static",
  --       "abstract",
  --       "async",
  --       "documentation",
  --       "typeHint",
  --       "typeHintComment",
  --       "readonly",
  --       "decorator",
  --       "builtin",
  --     },
  --   },
  --   range = true,
  --   -- full = {
  --   --   delta = true,
  --   -- },
  -- }
  -- client.server_capabilities = caps
  client.server_capabilities.semanticTokensProvider = false
  -- require("lsp.settings").on_attach(client, bufnr)

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
  vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    pcall(vim.diagnostic.reset, ns)
    return true
  end
  utils.autocmds.InlayHintsAU()
  require("lsp.settings").on_attach(client, bufnr)
end

return M
