local Pkg = require "mason-core.package"
local installer = require "mason-core.installer"
local fetch = require "mason-core.fetch"
local lsp_util = require "vim.lsp.util"
local lsputil = require "lspconfig.util"
local configs = require "lspconfig.configs"
local path = require "mason-core.path"
local index = require "mason-registry.index"

local platform = require "mason-core.platform"
local std = require "mason-core.managers.std"
local github = require "mason-core.managers.github"

local server_name = "pylance"
index[server_name] = "custom.plugins.lsp.installers.pylance"

local markers = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
}

local download_file = function(url, out_file)
  local headers = {
    ["Cookie"] = "Gallery-Service-UserIdentifier=31b2287d-bbf7-471c-a5aa-a25c931b1b71",
    -- ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.68.1 Chrome/98.0.4758.141 Electron/17.4.7 Safari/537.36",
  }
  local ctx = installer.context()
  ctx.stdio_sink.stdout(("Downloading file %q...\n"):format(url))
  fetch(url, {
      headers = headers,
      out_file = path.concat { ctx.cwd:get(), out_file },
    })
    :map_err(function(err)
      return ("Failed to download file %q.\n%s"):format(url, err)
    end)
    :get_or_throw()
end

local restart_server = function()
  local params = { command = "pyright.restartserver", arguments = { vim.uri_from_bufnr(0) } }
  vim.lsp.buf.execute_command(params)
end

local extract_method = function()
  local range_params = lsp_util.make_given_range_params(nil, nil)
  local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
  local params = { command = "pylance.extractMethod", arguments = arguments }
  vim.lsp.buf.execute_command(params)
end

local extract_variable = function()
  local range_params = lsp_util.make_given_range_params(nil, nil)
  local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
  local params = { command = "pylance.extractVarible", arguments = arguments }
  vim.lsp.buf.execute_command(params)
end

local organize_imports = function()
  local params = { command = "pyright.organizeimports", arguments = { vim.uri_from_bufnr(0) } }
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
local handlers = {
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
  ["textDocument/completion/dynamicRegistration"] = true,
  ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      -- Allow kwargs to be unused
      if diagnostic.message == '"kwargs" is not accessed' then
        return false
      end

      -- Prefix variables with an underscore to ignore
      if string.match(diagnostic.message, '"_.+" is not accessed') then
        return false
      end

      -- Prevent pyright from reporting & unused "undefined" variables; flake8 can handle that.
      if diagnostic.code == "reportUndefinedVariable" then
        return false
      end

      return true
    end, result.diagnostics)

    vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
  end,
  ["workspace/executeCommand"] = on_workspace_executecommand,
}
if not configs[server_name] then
  configs[server_name] = {
    default_config = {
      filetypes = { "python" },
      root_dir = function(fname)
        -- return markers
        return lsputil.root_pattern(unpack(markers))(fname)
          or lsputil.find_git_ancestor(fname)
          or lsputil.path.dirname(fname)
      end,
      docs = {
        package_json = path.concat { "extension", "package.json" },
        description = [[
         https://github.com/microsoft/pylance-release
         `pylance`, a Fast, feature-rich static type checker language support for Python
         ]],
      },
      cmd = { "pylance", "--stdio" },
      single_file_support = true,
      settings = {
        -- editor = { formatOnType = true },
        python = {
          analysis = {
            autoImportCompletions = true,
            typeCheckingMode = "basic",
            completeFunctionParens = true,
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
            indexing = false,
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
            },
            diagnosticSeverityOverrides = {
              reportGeneralTypeIssues = "none",
            },
          },
          -- experiments = { optInto = { "Experiment1", "Experiment13", "Experiment56", "Experiment106" } },
        },
      },
      handlers = handlers,
    },
    commands = {
      LspPyrightRestartServer = { restart_server, description = "Restart Server" },
      PylanceExtractMethod = { extract_method, description = "Extract Method" },
      PylanceExtractVarible = { extract_variable, description = "Extract Variable" },
      PylanceOrganizeImports = { organize_imports, description = "Organize Imports" },
    },
  }
end

local bin_path = path.concat { "extension", "dist", "server.bundle.js" }

local pylance_installer = function(ctx)
  local repo = "microsoft/pylance-release"
  local source = github.tag { repo = repo }
  source.with_receipt()
  local version = source.tag
  local url = ("https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/%s/vspackage"):format(
    version
  )
  download_file(url, "archive.gz")
  std.gunzip("archive.gz", ".")
  std.unzip("archive", ".")
  -- some platforms might not have sed/perl, use built nvim instead
  -- ctx.spawn.perl { "-p", "-i.bk", "-e", [['s/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/']], bin_path }
  ctx.spawn.nvim {
    "--headless",
    "--noplugin",
    "-c",
    [[silent %s/\(if\s*(\s*!\s*process\[.\{-}\]\s*)\s*return\s*\!\s*0\)x\(.\)/\1x0/g|silent wq]],
    bin_path,
  }
  -- cleanup unnecessary files for other platforms
  if platform.is_linux then
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "win32" })
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "darwin" })
  elseif platform.is_mac then
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "linux" })
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "win32" })
  else -- assume windows
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "linux" })
    ctx.fs:rmrf(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3", "darwin" })
  end
  ctx.receipt:with_primary_source {
    type = "github_tag",
    repo = repo,
    tag = version,
  }
  ctx:link_bin(
    server_name,
    ctx:write_node_exec_wrapper(server_name, path.concat { "extension", "dist", "server.bundle.js" })
  )
end

return Pkg.new {
  name = server_name,
  desc = [[Fast, feature-rich language support for Python]],
  homepage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance",
  languages = { Pkg.Lang.Python },
  categories = { Pkg.Cat.LSP },
  install = pylance_installer,
}
