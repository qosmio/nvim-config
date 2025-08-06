return {
  -- server = require("copilot.config.server").default,
  -- root_dir = require("copilot.config.root_dir").default,
  -- should_attach = require("copilot.config.should_attach").default,
  -- auth_provider_url = nil,
  -- workspace_folders = {},
  -- copilot_model = "gpt-4o-copilot",
  -- copilot_model = "gpt-4o-2024-11-20",
  copilot_model = "gpt-4o-copilot", -- this is the latest model as of 2025-04-14
  -- the current model is actually not gpt-4o-2024-11-20, but gpt-4.1-2025-04-14
  --
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<C-J>",
      accept_word = false,
      accept_line = false,
      next = "<C-K>",
      prev = "<C-Z>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = true,
    gitcommit = true,
    gitrebase = true,
    hgcommit = true,
    svn = true,
    cvs = true,
    ["."] = true,
  },
  copilot_node_command = "node", -- Node.js version must be > 18.x
  server_opts_overrides = {},
}
