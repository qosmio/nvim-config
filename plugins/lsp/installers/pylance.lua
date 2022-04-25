local util             = require('lspconfig.util')
local lsp_util         = require('vim.lsp.util')
local configs          = require('lspconfig.configs')
local servers          = require('nvim-lsp-installer.servers')
local server           = require('nvim-lsp-installer.server')
local path             = require('nvim-lsp-installer.path')
local handlers         = require('vim.lsp.handlers')

local server_name      = 'pylance'

local root_files       = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json'
}

local messages         = {}

local function ensure_init(id)
  require('lsp-status/util').ensure_init(messages, id, 'pylance')
end

local pylance_handlers = {
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
  end
}

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
    handlers            = {['workspace/executeCommand'] = on_workspace_executecommand}
  },
  commands       = {
    PylanceExtractMethod   = {extract_method, description = 'Extract Method'},
    PylanceExtractVarible  = {extract_variable, description = 'Extract Variable'},
    PylanceOrganizeImports = {organize_imports, description = 'Organize Imports'}
  }
}

local root_dir         = server.get_server_root_path(server_name)

local custom_server    = server.Server:new({
  name            = server_name,
  root_dir        = root_dir,
  languages       = {'python'},
  homepage        = 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance',
  async           = true,
  installer       = function(ctx)
    local cmd =
      [[version="$(curl -s -JL 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' | grep -Eo '"version":"[0-9\.]*"'|grep -Eo "([0-9.]+)"|head -1)"; 
         filename="ms-python.vscode-pylance-$version";
        curl -s -JL "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/$version/vspackage" --compressed --output "$filename";
        unzip "$filename";
        perl -pi.bk -e 's/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/' extension/dist/server.bundle.js;
        rm "$filename";]]
    ctx.spawn.bash({'-c', cmd})
  end,
  default_options = {
    cmd = {'node', path.concat({root_dir, 'extension/dist/server.bundle.js'}), '--stdio'}
  }
})
servers.register(custom_server)
