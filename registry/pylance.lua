local Pkg = require "mason-core.package"
local installer = require "mason-core.installer"
local lsputil = require "lspconfig.util"
local configs = require "lspconfig.configs"
local fetch = require "mason-core.fetch"
local path = require "mason-core.path"
local index = require "mason-registry.index"
local notify = require "mason-core.notify"
local platform = require "mason-core.platform"
local std = require "mason-core.managers.std"
local github = require "mason-core.managers.github"

local server_name = "pylance"
index[server_name] = "custom.registry.pylance"

local download_file = function(url, out_file)
  local headers = {
    ["Cookie"] = "Gallery-Service-UserIdentifier=31b2287d-bbf7-471c-a5aa-a25c931b1b71",
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

local bin_path = path.concat { "extension", "dist", "server.bundle.js" }

local pylance_installer = function(ctx)
  local repo = "microsoft/pylance-release"
  local source = github.tag { repo = repo }
  source.with_receipt()
  local version = "2023.10.40"
  local url = ("https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/%s/vspackage")
      :format(
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
  if ctx.fs:dir_exists(path.concat { "extension", "dist", "native", "onnxruntime", "napi-v3" }) then
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
  end
  ctx.receipt:with_primary_source {
    type = "github_tag",
    repo = repo,
    tag = source.tag,
  }
  ctx:link_bin(
    server_name,
    ctx:write_node_exec_wrapper(server_name, path.concat { "extension", "dist", "server.bundle.js" })
  )
end

if not configs[server_name] then
  configs[server_name] = {
    default_config = {
      filetypes = { "python" },
      root_dir = function(fname)
        local markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json",
        }
        return lsputil.root_pattern(unpack(markers))(fname)
            or lsputil.find_git_ancestor(fname)
            or lsputil.path.dirname(fname)
      end,
      docs = {
        package_json = path.concat { "extension", "package.json" },
        description =
        [[https://github.com/microsoft/pylance-release `pylance`, a Fast, feature-rich static type checker language support for Python ]],
      },
      cmd = { "pylance", "--stdio" },
      single_file_support = true,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        editor = { formatOnType = true },
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
            typeCheckingMode = "basic",
            completeFunctionParens = true,
            indexing = false,
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
              callArgumentNames = true,
              pytestParameters = true,
            },
          },
        },
      },
      handlers = require("custom.plugins.lsp.servers.pylance").handlers,
      before_init = function(_, config)
        local stub_path = require("lspconfig/util").path.join(vim.fn.stdpath "data", "lazy", "python-type-stubs")
        config.settings.python.analysis.stubPath = stub_path
      end,
    },
  }
end

-- print(vim.inspect(configs[server_name]))
local pkg = Pkg.new {
  name = server_name,
  desc = [[Fast, feature-rich language support for Python]],
  homepage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance",
  languages = { Pkg.Lang.Python },
  categories = { Pkg.Cat.LSP },
  install = pylance_installer,
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
