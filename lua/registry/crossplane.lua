local Pkg = require "mason-core.package"
local pypi = require "mason-core.installer.managers.pypi"
local _ = require "mason-core.functional"
local index = require "mason-registry.index"
local notify = require "mason-core.notify"

local server_name = "crossplane-ng"
index[server_name] = "registry.crossplane"

local spec = Pkg.spec {
  name = server_name,
  desc = _.dedent [[
    Quick and reliable way to convert NGINX configurations into JSON and back.
    ]],
  license = "MIT",
  homepage = "https://github.com/qosmio/crossplane",
  languages = { Pkg.Lang.Nginx },
  categories = { Pkg.Cat.Formatter },
  install = pypi.packages {
    server_name,
    bin = { "crossplane" },
  },
}

local pkg = Pkg.new {
  spec = spec,
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
