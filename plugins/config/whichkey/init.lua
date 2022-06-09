return {
  -- opt = true,
  config = function()
    local wk = require "which-key"
    -- wk.setup {}
    wk.setup {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
      spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
      hidden = {
        "<silent>",
        "<cmd>",
        "<Cmd>",
        "<CR>",
        "call",
        "lua",
        "^:",
        "^ ",
      }, -- hide mapping boilerplate
    }
    wk.register({
      --["/"] = { "Toggle comment" },
      a = {
        name = "General",
        c = { "<cmd>e $MYVIMRC<cr>", "Edit Config" },
      },
      d = {
        name = "Dap Debugger",
        b = { "Toggle breakpoint" },
        B = { "Step back" },
        c = { "Continue" },
        C = { "Run to cursor" },
        d = { "Disconnect" },
        S = { "Sesion" },
        i = { "Step into" },
        o = { "Step over" },
        u = { "Step out" },
        p = { "Pause toggle" },
        r = { "REPL Toggle" },
        s = { "Continue" },
        q = { "Close" },
      },
      g = {
        name = "General",
        d = "Generate Docstrings",
        D = "View Definition",
        i = "Goto Implementation",
        r = "Rename variable",
        t = "View Type Definition",
      },
      k = { "Diagnostic Open Float" },
      l = {
        name = "LSP",
        w = {
          "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
          "Add Workspace",
        },
        -- r={'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',"Remove Workspace"},
        l = {
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
          "List Workspaces",
        },
        t = {
          "<cmd>lua vim.lsp.buf.type_definition()<CR>",
          "Type Definition",
        },
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        o = {
          "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
          "Loc List",
        },
        f = {
          "<cmd>lua vim.lsp.buf.format()<CR>",
          "Format",
        },
      },
      p = {
        name = "Packer",
        s = { "<cmd>PackerStatus<cr>", "Status" },
        p = { "<cmd>PackerSync<cr>", "Sync" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        l = { "<cmd>PackerClean<cr>", "Clean" },
      },
      q = { "Trouble" },
      n = { "Toggle Line Numbers" },
      h = {
        name = "Git Signs",
        b = { "Blame line" },
        p = { "Preview hunk" },
        R = { "Reset buffer" },
        r = { "Reset hunk" },
        S = { "Stage buffer" },
        s = { "Stage hunk" },
        u = { "Undo stage hunk" },
        U = { "Reset buffer index" },
      },
      t = {
        name = "Telescope",
        c = { "Colorscheme" },
        f = { "Files" },
        g = { "Grep" },
        h = { "Tags" },
        o = { "Old files" },
        p = { "Projects" },
      },
    }, { prefix = "<leader>" })
  end,
}
