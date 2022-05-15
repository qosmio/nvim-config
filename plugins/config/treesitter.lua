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
}

return {
  ensure_installed = (function()
    local out = vim.fn.system("which gcc")
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
  context_commentstring = { enable = true, enable_autocmd = false },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    -- keybindings           = {
    --   toggle_query_editor       = 'o',
    --   toggle_hl_groups          = 'i',
    --   toggle_injected_languages = 't',
    --   toggle_anonymous_nodes    = 'a',
    --   toggle_language_display   = 'I',
    --   focus_language            = 'f',
    --   unfocus_language          = 'F',
    --   update                    = 'R',
    --   goto_node                 = '<cr>',
    --   show_help                 = '?'
    -- },
  },
  -- highlight        = {
  --   additional_vim_regex_highlighting = true,
  --   -- custom_captures                   = {},
  --   -- disable                           = {},
  --   enable                            = true,
  --   -- loaded                            = true,
  --   -- module_path                       = "nvim-treesitter.highlight",
  --   use_languagetree                  = true
  -- },
  -- -- incremental_selection = {
  -- --   disable     = {},
  -- --   enable      = false,
  -- --   keymaps     = {
  -- --     init_selection    = "gnn",
  -- --     node_decremental  = "grm",
  -- --     node_incremental  = "grn",
  -- --     scope_incremental = "grc"
  -- --   },
  -- --   -- module_path = "nvim-treesitter.incremental_selection"
  -- -- },
  indent = { enable = true },
  context = { enable = true, throttle = true },
  matchup = {
    --   -- disable     = {},
    enable = true,
    disable_virtual_text = true,
    include_match_words = true,
  },
}
