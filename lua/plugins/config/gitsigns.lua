-- local present, gitsigns = pcall(require, "gitsigns")
--
-- if not present then
--   return
-- end

return {
  -- on_attach = function(bufnr)
  --   local gs = package.loaded.gitsigns
  --   local function map(mode, l, r, opts)
  --     opts = opts or {}
  --     opts.buffer = bufnr
  --     vim.keymap.set(mode, l, r, opts)
  --   end
  --
  --   -- Navigation
  --   map("n", "]h", function()
  --     if vim.wo.diff then
  --       return "]h"
  --     end
  --     vim.schedule(function()
  --       gs.next_hunk()
  --     end)
  --     return "<Ignore>"
  --   end, { expr = true })
  --
  --   map("n", "[h", function()
  --     if vim.wo.diff then
  --       return "[h"
  --     end
  --     vim.schedule(function()
  --       gs.prev_hunk()
  --     end)
  --     return "<Ignore>"
  --   end, { expr = true })
  -- end,
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
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
  -- yadm = { enable = false },
}
