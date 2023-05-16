return vim.defer_fn(function()
  local status, treesitter_parsers = pcall(require, "nvim-treesitter.parsers")
  if not status then
    return
  end
  local parser_config = treesitter_parsers.get_parser_configs()
  parser_config.zsh = {
    install_info = {
      url = "https://github.com/qosmio/tree-sitter-zsh",
      files = { "src/parser.c", "src/scanner.cc" },
    },
    filetype = "zsh",
  }
  parser_config.objc = {
    install_info = {
      url = "~/Documents/code/tree-sitter-objc", -- local path or git repo
      files = { "src/parser.c" },
      -- optional entries:
      -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
      -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "objc", -- if filetype does not match the parser name
  }
end, 5)
