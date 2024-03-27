-- YAML
local M = {}
M.builtin_matchers = {
  -- Detects Kubernetes files based on content
  kubernetes = { enabled = true },
  cloud_init = { enabled = false },
}
M.schemas = {
  {
    name = "Helmfile",
    url = "https://raw.githubusercontent.com/hiberbee/yamlschema/master/src/schemas/helm/helmfile.yaml.json",
  },
  {
    name = "Kubernetes 1.28.4",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.4-standalone-strict/all.json",
  },
}
M.filetypes = { "yaml", "yaml.dockerfile", "yaml.docker-compose" }

M.settings = {
  redhat = { telemetry = { enabled = false } },
  yaml = {
    validate = true,
    format = { enable = true },
    hover = true,
    schemaStore = {
      enable = true,
      url = "https://www.schemastore.org/api/json/catalog.json",
    },
    schemaDownload = { enable = true },
    schemas = {
      -- kubernetes = "*.yaml",
      ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
      ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
      ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
      ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
      ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
      ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
      ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
      ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
      ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      -- kubernetes = "*.yaml",
    },
    completion = true,
    trace = { server = "info" },
    customTags = {
      -- Home Assistant
      "!secret",
      "!include_dir_named",
      "!include_dir_list",
      "!include_dir_merge_named",
      "!include_dir_merge_list",
      "!lambda",
      "!input",
    },
  },
}

local cfg = require("yaml-companion").setup {
  builtin_matchers = M.builtin_matchers,
  schemas = M.schemas,
  lspconfig = {
    settings = M.settings,
  },
}

cfg.on_attach = function(client, bufnr)
  require("plugins.lsp.settings").on_attach(client, bufnr)
  require("yaml-companion.context").setup(bufnr, client)
  client.notify("yaml/supportSchemaSelection", { {} })
  vim.defer_fn(function()
    if client.config.name == "yamlls" and vim.bo.filetype == "helm" then
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
  end, 0)
end

cfg.filetypes = M.filetypes

require("utils").tbl_remove_key(cfg, "on_init")
-- vim.print(cfg)
return cfg
