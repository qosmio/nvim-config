local util = require "lspconfig/util"
local swift_root = { "Package.swift" }

return {
  cmd = { vim.fn.exepath "sourcekit-lsp" },
  docs = {
    description = [[
https://github.com/apple/sourcekit-lsp
Language server for Swift and C/C++/Objective-C.
    ]],
  },
  filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
  root_dir = function(fname)
    local general_root = { ".project.*", ".git/", "README.md" }
    return util.root_pattern(unpack(vim.tbl_deep_extend("force", swift_root, general_root)))(fname)
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
  end,
  settings = {
    inlayHints = {
      enabled = true,
    },
    -- serverArguments = { "--log-level", "debug" },
    -- trace = { server = "messages" },
  },
}
