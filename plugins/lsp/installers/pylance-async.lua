local util             = require('lspconfig.util')
local lsp_util         = require('vim.lsp.util')
local configs          = require('lspconfig.configs')
local servers          = require('nvim-lsp-installer.servers')
local server           = require('nvim-lsp-installer.server')
local path             = require('nvim-lsp-installer.path')
local handlers         = require('vim.lsp.handlers')
local std              = require('nvim-lsp-installer.core.managers.std')
local fetch            = require('nvim-lsp-installer.core.fetch')

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

-- local shell         = require "nvim-lsp-installer.installers.shell"

---@param output string @The `cargo install --list` output.
---@return table<string, string> @Key is the crate name, value is its version.
local function parse_versions(output)
  local versions = {}
  for _, line in ipairs(vim.split(result, '\n')) do
    for version in line:gmatch([["version":"([%S]+)",]]) do
      table.insert(versions, version)
    end
  end
  return versions[0] or versions[1]
end
---@async
---@param receipt InstallReceipt
---@param install_dir string
local function installer(ctx)
  _G.print_table(ctx)
  fetch('https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance'):map_catching(
    function(result)
      _G.print_table(result)
      local version = parse_versions(output)
      -- We can also, for example, make use of the async std functions in nvim-lsp-installer.core.managers.std
      local url     =
        'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/' ..
          version .. '/vspackage'
      local plugin  = 'ms-python.vscode-pylance-' .. version .. '.zip'
      std.download_file(url, plugin)
      std.unzip(plugin, '.')
    end)
  pcall(function()
    ctx.spawn.perl(
      [[ -pi.bk -e 's/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/' extension/dist/server.bundle.js ]])
  end)
end

-- local installer     = shell.bash [[
-- version=$(curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' | grep --extended-regexp '"version":"[0-9\.]*"' -o | head -1 | sed 's/"version":"\([0-9\.]*\)"/\1/');
-- curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/$version/vspackage" \
--     -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
--     -j -b cookies.txt --compressed --output "ms-python.vscode-pylance-${version}";
-- unzip "ms-python.vscode-pylance-$version";
-- perl -pi.bk -e 's/(if\s*?\(\s*?\!\s*?process\[.*?\]\s*?\[.*?\]\s*?\)\s*?return\s*?\!\s*?0)(x.)/\1x0/' extension/dist/server.bundle.js;
-- #sed -i.bk "s/\(if(\!process\[[^] ]*\]\[[^] ]*\])return\!0x\)1/\10/" extension/dist/server.bundle.js;
-- rm "ms-python.vscode-pylance-$version";
-- ]]
--
local custom_server    = server.Server:new({
  name            = server_name,
  root_dir        = root_dir,
  async           = true,
  languages       = {'python'},
  homepage        = 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance',
  installer       = installer,
  default_options = {
    cmd = {'node', path.concat({root_dir, 'extension/dist/server.bundle.js'}), '--stdio'}
  }
})
servers.register(custom_server)
