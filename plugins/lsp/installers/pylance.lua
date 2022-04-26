local util              = require('lspconfig.util')
local lsp_util          = require('vim.lsp.util')
local configs           = require('lspconfig.configs')
local servers           = require('nvim-lsp-installer.servers')
local server            = require('nvim-lsp-installer.server')
local path              = require('nvim-lsp-installer.path')
local handlers          = require('vim.lsp.handlers')
local std               = require('nvim-lsp-installer.core.managers.std')
local fetch             = require('nvim-lsp-installer.core.fetch')

local server_name       = 'pylance'

local root_files        = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json'
}

local messages          = {}

local function ensure_init(id)
  require('lsp-status/util').ensure_init(messages, id, 'pylance')
end

local function restart_server()
  local params = {command   = 'pyright.restartserver', arguments = {vim.uri_from_bufnr(0)}}
  vim.lsp.buf.execute_command(params)
end

-- table.insert(handlers,pylance_handlers)

local function extract_method()
  local range_params = lsp_util.make_given_range_params(nil, nil)
  local arguments    = {vim.uri_from_bufnr(0):gsub('file://', ''), range_params.range}
  local params       = {command   = 'pylance.extractMethod', arguments = arguments}
  vim.lsp.buf.execute_command(params)
end

local function extract_variable()
  local range_params = lsp_util.make_given_range_params(nil, nil)
  local arguments    = {vim.uri_from_bufnr(0):gsub('file://', ''), range_params.range}
  local params       = {command   = 'pylance.extractVarible', arguments = arguments}
  vim.lsp.buf.execute_command(params)
end

local function organize_imports()
  local params = {command   = 'pyright.organizeimports', arguments = {vim.uri_from_bufnr(0)}}
  vim.lsp.buf.execute_command(params)
end

local function on_workspace_executecommand(err, actions, ctx)
  if err ~= nil then
    handlers[ctx.method](err, actions, ctx)
  end
  if ctx.params.command:match('WithRename') then
    ctx.params.command = ctx.params.command:gsub('WithRename', '')
    vim.lsp.buf.execute_command(ctx.params)
  end
  handlers[ctx.method](err, actions, ctx)
end

local pylance_handlers  = {
  ['pyright/beginProgress'] = function(_, _, _, client_id)
    ensure_init(client_id)
    if not messages[client_id].progress[1] then
      messages[client_id].progress[1] = {spinner = 1, title   = 'Pylance'}
    end
  end,
  ['pyright/reportProgress'] = function(_, _, message, client_id)
    messages[client_id].progress[1].spinner = messages[client_id].progress[1].spinner + 1
    messages[client_id].progress[1].title = message[1]
    vim.api.nvim_command('doautocmd User LspMessageUpdate')
  end,
  ['pyright/endProgress'] = function(_, _, _, client_id)
    messages[client_id].progress[1] = nil
    vim.api.nvim_command('doautocmd User LspMessageUpdate')
  end,
  ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
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
      if diagnostic.code == 'reportUndefinedVariable' then
        return false
      end

      return true
    end, result.diagnostics)

    vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
  end,
  ['workspace/executeCommand'] = on_workspace_executecommand
}
configs[server_name] = {
  default_config = {
    filetypes           = {'python'},
    root_dir            = util.root_pattern(unpack(root_files)),
    -- cmd                 = {"py"},
    single_file_support = true,
    settings            = {
      python = {
        analysis    = {
          autoSearchPaths        = true,
          useLibraryCodeForTypes = true,
          diagnosticMode         = 'workspace'
        },
        experiments = {optInto = {'Experiment1', 'Experiment13', 'Experiment56', 'Experiment106'}}
      }
    },
    handlers            = pylance_handlers
  },
  commands       = {
    LspPyrightRestartServer = {restart_server, description = 'Restart Server'},
    PylanceExtractMethod    = {extract_method, description = 'Extract Method'},
    PylanceExtractVarible   = {extract_variable, description = 'Extract Variable'},
    PylanceOrganizeImports  = {organize_imports, description = 'Organize Imports'}
  }
}

local root_dir          = server.get_server_root_path(server_name)

---@param response string @The `raw html from marketplace output.
---@return table<string> @Key is the version, value is its version.
local function parse_versions(response)
  for line in response:gmatch('([^\r\n]*)\r?\n?') do
    for version in line:gmatch([["version":"([%S]+)",]]) do
      return version
    end
  end
  -- return versions[0] or versions[1]
end

local pylance_installer = function(ctx)
  local version = fetch(
                    'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance'):map(
                    parse_versions).value
  local url     =
    ('https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/%s/vspackage'):format(
      version)
  std.download_file(url, 'archive.gz')
  std.gunzip('archive.gz', '.')
  std.unzip('archive', '.')
  ctx.spawn.bash({
    '-c',
    [[ perl -pi -e 's/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/' extension/dist/server.bundle.js ]]
  })
  ctx.receipt:with_primary_source({type    = 'npm', package = 'vscode-pylance'})
end

local custom_server     = server.Server:new({
  name            = server_name,
  root_dir        = root_dir,
  languages       = {'python'},
  homepage        = 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance',
  async           = true,
  installer       = pylance_installer,
  default_options = {
    cmd = {'node', path.concat({root_dir, 'extension/dist/server.bundle.js'}), '--stdio'}
  }
})
servers.register(custom_server)
