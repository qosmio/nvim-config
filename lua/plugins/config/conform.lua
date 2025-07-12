local M = {}

local formatters = {
  -- Javascript/CSS/JSON
  biome = {
    append_args = {
      "--config-path",
      vim.fn.stdpath "config" .. "/lua/plugins/config/.biome.json",
    },
  },
  -- SQL
  sqlfluff = {
    prepend_args = {
      "--dialect",
      "postgres",
      "--config",
      vim.fn.stdpath "config" .. "/lua/plugins/config/.sqlfluff",
    },
  },
  -- Lua
  stylua = {
    prepend_args = {
      "--config-path",
      vim.fn.stdpath "config" .. "/lua/plugins/config/.stylua.toml",
    },
  },

  -- C/Clang
  clang_format = { offsetEncoding = { "utf-32" } },
  -- formatting.uncrustify,

  -- Bash/Zsh
  beautysh = {
    prepend_args = { "--indent-size", 2, "--force-function-style", "paronly" },
  },
  shfmt = {
    filetypes = { "bash", "csh", "ksh", "sh" },
    prepend_args = { "--language-dialect", "bash", "-i", "2", "-bn", "-ci", "-sr" },
  },

  -- YAML
  yamlfmt = {
    timeout = 15000,
    prepend_args = { "-conf", vim.fn.stdpath "config" .. "/lua/plugins/config/.yamlfmt.yml" },
  },
  yamlfix = {
    timeout = 150,
    append_args = { "-c", vim.fn.stdpath "config" .. "/lua/plugins/config/.yamlfix.toml" },
  },

  -- Python
  ruff_format = {
    append_args = {
      "--config",
      vim.fn.stdpath "config" .. "/lua/plugins/config/.ruff.toml",
      "--preview",
    },
  },
  crossplane = {
    command = "crossplane",
    stdin = true,
    args = {
      "format",
      "--align",
      "--spacious",
      "-i",
      "2",
      "-",
    },
  },
  injected = {
    options = {
      ignore_errors = true,
      lang_to_ext = {
        json = "json",
        yaml = "yaml",
      },
    },
  },
}

M.config = {
  -- Map of filetype to formatters
  formatters_by_ft = {
    css = { "biome" },
    lua = { "stylua" },
    javascript = { "biome" },
    typescript = { "biome" },
    -- You can use a function here to determine the formatters dynamically
    python = { "ruff_format", "usort" },
    bash = { "beautysh", "shfmt" },
    zsh = { "beautysh", "shfmt" },
    sh = { "shfmt", "beautysh" },
    sql = { "sql_formatter", "sqlfluff" },
    json = { "biome" },
    toml = { "taplo" },
    yaml = { "yamlfmt", "yamlfix" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    nginx = { "crossplane", "injected" },
    ["*"] = { "injected" }, -- enables injected-lang formatting for all filetypes
    -- Use the "*" filetype to run formatters on all filetypes.
    -- ["*"] = { "codespell" },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },
  formatters = formatters,
  -- Set the log level. Use `:ConformInfo` to see the location of the log file.
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  format_on_save = function() end,
}
return M.config
