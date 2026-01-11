pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

-- require "plugins.config.treesitter_parsers"
local ensure_installed = {
  -- "awk",
  "bash",
  -- "c",
  -- "cmake",
  -- "comment",
  -- "cpp",
  -- "css",
  -- "csv",
  -- "diff",
  -- "dockerfile",
  -- "editorconfig",
  -- "embedded_template",
  -- "func",
  -- "git_config",
  -- "git_rebase",
  -- "gitattributes",
  -- "gitcommit",
  -- "gitignore",
  -- "go",
  -- "gomod",
  -- "gosum",
  "html",
  -- "http",
  "javascript",
  -- "jq",
  "json",
  "kconfig",
  "lua",
  -- "luadoc",
  "make",
  -- "nginx",
  -- "passwd",
  -- "perl",
  -- "php",
  -- "printf",
  -- "pymanifest",
  "python",
  -- "regex",
  -- "requirements",
  -- "rust",
  -- "sql",
  -- "ssh_config",
  "toml",
  -- "tsx",
  -- "typescript",
  "vim",
  -- "xml",
  "yaml",
}

local utils = require "utils"

-- Check GCC and tree-sitter first
local auto_install_enabled = (function()
  local os_info = utils.get_os_info() or nil
  if os_info and os_info.id == "openwrt" then
    return false
  end
  return true
end)()

local ensure_installed_config = {}
if auto_install_enabled then
  _ = vim.fn.system "which gcc"
  if vim.v.shell_error == 0 then
    _ = vim.fn.system "which tree-sitter"
    if vim.v.shell_error ~= 0 then
      require("utils").tbl_filter_inplace(ensure_installed, "sql")
    end
    ensure_installed_config = { ensure_installed = ensure_installed }
  end
end

local opts = vim.tbl_extend("force", {
  parser_install_dir = vim.fn.stdpath "data" .. "/site",
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
    use_languagetree = true,
  },
  textobjects = { select = { enable = true } },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
  indent = { enable = true },
  context = { enable = true, throttle = true },
  matchup = {
    enable = true,
    disable_virtual_text = false,
    include_match_words = true,
  },
}, ensure_installed_config)

return opts
