local configs = {
  init_options = {
    cache = {
      directory = vim.env.HOME .. "/.ccls-cache",
      cacheFormat = "json",
      rootPatterns = { "compile_commands.json", ".prettierrc.json", ".ccls", ".git/", ".svn/", ".hg/" },
      clang = {
        -- extraArgs   = {"-fms-extensions", "-fms-compatibility", "-f1elayed-template-parsing"},
        extraArgs = {
          "--header-insertion=iwyu",
          "--suggest-missing-includes",
          "--cross-file-rename",
          "--completion-style=detailed",
          "--pch-storage=memory",
          "--header-insertion-decorators",
          "--all-scopes-completion",
        },
        -- excludeArgs = {},
      },
    },

    flags = {
      debounce_text_changes = 150,
    },

    codeLens = {
      localVariables = true,
    },

    client = {
      snippetSupport = true,
    },

    completion = {
      placeholder = true,
      detailedLabel = false,
      spellChecking = true,
      -- filterAndSort = false;
    },
    index = {
      onChange = false,
      trackDependency = 1,
    },
  },
  cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=3" },
}

return configs
