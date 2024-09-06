-- Your original configuration
return {
  signs = {
    add = {
      text = "",
    },
    change = {
      text = "",
    },
    delete = {
      text = "",
    },
    topdelete = {
      text = "",
    },
    changedelete = {
      text = "",
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 300,
  },
  sign_priority = 3,
  update_debounce = 100,
  preview_config = {
    border = vim.g.border_chars,
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
}
