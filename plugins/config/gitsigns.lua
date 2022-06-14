local present, gitsigns = pcall(require, "gitsigns")

if not present then
  print "ASDF"
  return
end

return gitsigns.setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]h", function()
      if vim.wo.diff then
        return "]h"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[h", function()
      if vim.wo.diff then
        return "[h"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- -- Actions
    -- map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    -- map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    -- map("n", "<leader>hS", gs.stage_buffer)
    -- map("n", "<leader>hu", gs.undo_stage_hunk)
    -- map("n", "<leader>hR", gs.reset_buffer)
    -- map("n", "<leader>hp", gs.preview_hunk)
    -- map("n", "<leader>hb", function()
    --   gs.blame_line { full = true }
    -- end)
    -- map("n", "<leader>tb", gs.toggle_current_line_blame)
    -- map("n", "<leader>hd", gs.diffthis)
    -- map("n", "<leader>hD", function()
    --   gs.diffthis "~"
    -- end)
    -- map("n", "<leader>td", gs.toggle_deleted)

    -- -- Text object
    -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
  signs = {
    add = { hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
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
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  keymaps = {
    -- Default keymap options
    noremap = true,

    ["n ]h"] = {
      expr = true,
      "&diff ? ']h' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
    },
    ["n [h"] = {
      expr = true,
      "&diff ? '[h' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
    },

    ["n <leader>hs"] = "<cmd>Gitsigns stage_hunk <CR>",
    ["v <leader>hs"] = '<cmd>Gitsigns stage_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>',
    ["n <leader>hu"] = "<cmd>Gitsigns undo_stage_hunk <CR>",
    ["n <leader>hr"] = "<cmd>Gitsigns reset_hunk <CR>",
    ["v <leader>hr"] = '<cmd>Gitsigns reset_hunk({vim.fn.line("."), vim.fn.line("v")}) <CR>',
    ["n <leader>hR"] = "<cmd>Gitsigns reset_buffer <CR>",
    ["n <leader>hp"] = "<cmd>Gitsigns preview_hunk <CR>",
    ["n <leader>hb"] = "<cmd>Gitsigns blame_line(true) <CR>",
    ["n <leader>hS"] = "<cmd>Gitsigns stage_buffer <CR>",
    ["n <leader>hU"] = "<cmd>Gitsigns reset_buffer_index <CR>",

    -- Text objects
    ["o ih"] = ":<C-U>Gitsigns select_hunk <CR>",
    ["x ih"] = ":<C-U>Gitsigns select_hunk <CR>",
  },
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
  yadm = { enable = true },
}