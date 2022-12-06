local util = require "lspconfig.util"
local lsp_util = require "vim.lsp.util"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local platform = require "nvim-lsp-installer.platform"
local std = require "nvim-lsp-installer.core.managers.std"
local github_client = require "nvim-lsp-installer.core.managers.github.client"

local server_name = "pylance"

local root_files = {
  "pyproject.toml",
}

local messages = {}

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

local handlers = {
  ["pyright/beginProgress"] = function(_, _, _, client_id)
    require("lsp-status/util").ensure_init(messages, client_id, "pylance")
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
configs[server_name] = {
  default_config = {
    filetypes = { "python" },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          completeFunctionParens = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
          indexing = true,
        },
        experiments = { optInto = { "Experiment1", "Experiment13", "Experiment56", "Experiment106" } },
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

local bin_path = path.concat { "extension", "dist", "server.bundle.js" }

local pylance_installer = function(ctx)
  local repo = "microsoft/pylance-release"
  -- local version = fetch("https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance"):map(parse_versions).value
  local version = ctx.requested_version:or_else_get(function()
    return github_client
        .fetch_latest_tag(repo)
        :map(function(tag)
          return tag.name
        end)
        :get_or_throw()
  end)
  local url = (
      "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/%s/vspackage"
      ):format(
        version
      )
  local headers = {
    ["Cookie"] = "Gallery-Service-UserIdentifier=31b2287d-bbf7-471c-a5aa-a25c931b1b71",
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.68.1 Chrome/98.0.4758.141 Electron/17.4.7 Safari/537.36",
  }
  std.download_file(url, "archive.gz", headers)
  std.gunzip("archive.gz", ".")
  std.unzip("archive", ".")
  ctx.spawn.nvim {
    "--headless",
    "--noplugin",
    "-c",
    [[silent %s/\(if\s*(\s*!\s*process\[.\{-}\]\s*)\s*return\s*\!\s*0\)x\(.\)/\1x0/g|silent wq]],
    bin_path,
  }
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
  -- ctx.spawn.perl { "-p", "-i.bk", "-e", [['s/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/']], "extension/dist/server.bundle.js" }
  -- ctx.receipt:with_primary_source { type = "github_tag", tag = version }
  ctx.receipt:with_primary_source {
    type = "github_tag",
    repo = repo,
    tag = version,
  }
end

local root_dir = server.get_server_root_path(server_name)
local custom_server = server.Server:new {
  name = server_name,
  root_dir = root_dir,
  languages = { "python" },
  homepage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance",
  async = true,
  installer = pylance_installer,
  default_options = {
    cmd = { "node", path.concat { root_dir, bin_path }, "--stdio" },
  },
}
servers.register(custom_server)
