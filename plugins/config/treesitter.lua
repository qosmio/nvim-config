local ensure_installed = {
  "dockerfile",
  "lua",
  "vim",
  "css",
  "javascript",
  "json",
  "make",
  "python",
  "c",
  "bash",
  "php",
  "yaml",
  "cpp",
  "cmake",
  "go",
  "tsx",
  "http",
  "sql",
  "regex",
}

return {
  -- auto_install = true,
  ensure_installed = (function()
    _ = vim.fn.system "which gcc"
    if vim.v.shell_error ~= 0 then
      return false
    else
      return ensure_installed -- only install if gcc is installed
    end
  end)(),
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  textobjects = { select = { enable = true } },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  context_commentstring = { enable = true, enable_autocmd = true },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
  indent = { enable = true },
  context = { enable = true, throttle = true },
  matchup = {
    --   -- disable     = {},
    enable = true,
    disable_virtual_text = true,
    include_match_words = true,
  },
}
