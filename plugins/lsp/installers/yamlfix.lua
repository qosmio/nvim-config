local Pkg = require "mason-core.package"
local pip3 = require "mason-core.managers.pip3"
local _ = require "mason-core.functional"
local index = require "mason-registry.index"
local notify = require "mason-core.notify"

local server_name = "yamlfix"
index[server_name] = "custom.plugins.lsp.installers.yamlfix"

local pkg = Pkg.new {
  name = "yamlfix",
  desc = _.dedent [[
     A simple opinionated yaml formatter that keeps your comments!
    ]],
  homepage = "https://github.com/lyz-code/yamlfix",
  languages = { Pkg.Lang.YAML },
  categories = { Pkg.Cat.Linter },
  install = pip3.packages {
    "yamlfix",
    bin = { "yamlfix" },
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
