local Pkg = require "mason-core.package"
local npm = require "mason-core.managers.npm"
local _ = require "mason-core.functional"
local index = require "mason-registry.index"
local notify = require "mason-core.notify"

local server_name = "nginx_beautifier"
index[server_name] = "custom.registry.nginx_beautifier"

local pkg = Pkg.new {
  name = server_name,
  desc = _.dedent [[
    Format and beautify nginx config files
    ]],
  homepage = "https://github.com/vasilevich/nginxbeautifier",
  languages = { Pkg.Lang.Nginx },
  categories = { Pkg.Cat.Formatter },
  install = npm.packages {
    "nginxbeautifier",
    bin = { "nginxbeautifier" },
  },
}

pkg:get_installed_version(function(success, _)
  if not success then
    vim.defer_fn(function()
      notify(("[mason-lspconfig.nvim] Installing %s"):format(pkg.name))
    end, 0)
    pkg:install()
  end
end)

return pkg
