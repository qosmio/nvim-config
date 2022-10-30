local servers = require "nvim-lsp-installer.servers"
local util = require "lspconfig.util"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local configs = require "lspconfig.configs"
local github_client = require "nvim-lsp-installer.core.managers.github.client"
local std = require "nvim-lsp-installer.core.managers.std"
local server_name = "vscode-home-assistant"
local handlers = require "vim.lsp.handlers"

local on_workspace_executecommand = function(err, actions, ctx)
  if err ~= nil then
    handlers[ctx.method](err, actions, ctx)
  end
  if ctx.params.command:match "WithRename" then
    ctx.params.command = ctx.params.command:gsub("WithRename", "")
    vim.lsp.buf.execute_command(ctx.params)
  end
  handlers[ctx.method](err, actions, ctx)
end

local hass_handlers = {
  ["workspace/diagnostic/refresh"] = on_workspace_executecommand,
}

local random = math.random
local function uuid()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
end

local root_files = { "configuration.y*ml", "~/.homeassistant/*.y*ml", "~/.homeassistant/**/*.y*ml" }
configs[server_name] = {
  default_config = {
    filetypes = { "yaml" },
    root_dir = util.root_pattern(unpack(root_files)),
    -- single_file_support = true,
    settings = {},
    handlers = hass_handlers,
  },
}

local root_dir = server.get_server_root_path(server_name)
local custom_server = server.Server:new {
  name = server_name,
  root_dir = root_dir,
  languages = { "yaml" },
  homepage = "https://github.com/keesschollaart81/vscode-home-assistant",
  async = true,
  installer = function(ctx)
    local repo = "keesschollaart81/vscode-home-assistant"
    local version = ctx.requested_version:or_else_get(function()
      return github_client
        .fetch_latest_tag(repo)
        :map(function(tag)
          return tag.name
        end)
        :get_or_throw()
    end)
    -- strip all alpha characters from version
    version = version:gsub("[^%d.]", "")
    local url = ("https://marketplace.visualstudio.com/_apis/public/gallery/publishers/keesschollaart/vsextensions/vscode-home-assistant/%s/vspackage"):format(
      version
    )
    local headers = { ["Cookie"] = ("Gallery-Service-UserIdentifier=%s"):format(uuid) }
    std.download_file(url, "archive.gz", headers)
    std.gunzip("archive.gz", ".")
    std.unzip("archive", ".")
    ctx.receipt:with_primary_source {
      type = "github_tag",
      repo = repo,
      tag = version,
    }
  end,
  default_options = {
    cmd = { "node", path.concat { root_dir, "extension", "out", "server", "server.js" }, "--stdio" },
    -- root_dir = util.root_pattern(unpack { "~/.homeassistant/*" }),
    root_dir = util.root_pattern(unpack(root_files)),
    settings = {},
  },
}
servers.register(custom_server)
