-- Diagnostic config
local icons = require "custom.icons"

local codes = {
  -- Lua
  no_matching_function = {
    message = " Can't find a matching function",
    "redundant-parameter",
    "ovl_no_viable_function_in_call",
  },
  empty_block = {
    message = " That shouldn't be empty here",
    "empty-block",
  },
  missing_symbol = {
    message = " Here should be a symbol",
    "miss-symbol",
  },
  expected_semi_colon = {
    message = " Please put the `;` or `,`",
    "expected_semi_declaration",
    "miss-sep-in-table",
    "invalid_token_after_toplevel_declarator",
  },
  redefinition = {
    message = " That variable was defined before",
    icon = " ",
    "redefinition",
    "redefined-local",
    "no-duplicate-imports",
    "@typescript-eslint/no-redeclare",
    "import/no-duplicates",
  },
  no_matching_variable = {
    message = " Can't find that variable",
    "undefined-global",
    "reportUndefinedVariable",
  },
  trailing_whitespace = {
    message = " Whitespaces are useless",
    "trailing-whitespace",
    "trailing-space",
  },
  unused_variable = {
    message = " Don't define variables you don't use",
    icon = " ",
    "unused-local",
    "@typescript-eslint/no-unused-vars",
    "no-unused-vars",
  },
  unused_function = {
    message = " Don't define functions you don't use",
    "unused-function",
  },
  useless_symbols = {
    message = " Remove that useless symbols",
    "unknown-symbol",
  },
  wrong_type = {
    message = " Try to use the correct types",
    "init_conversion_failed",
  },
  undeclared_variable = {
    message = " Have you delcared that variable somewhere?",
    "undeclared_var_use",
  },
  lowercase_global = {
    message = " Should that be a global? (if so make it uppercase)",
    "lowercase-global",
  },
  -- Typescript
  no_console = {
    icon = " ",
    "no-console",
  },
  -- Prettier
  prettier = {
    icon = " ",
    "prettier/prettier",
  },
}

-- UI

local function define_signs(signs)
  for type, _ in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
    -- without icon, but with number highlight
  end
end

define_signs { Error = "", Warn = "", Hint = "", Info = "" }

local popup_border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local group_name = "LspDiagnostics"

-- -- Show diagnostics in popup window (using the border above)
-- vim.api.nvim_command( "autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border=" .. vim.inspect(popup_border) .. ", focusable=false, show_header=false})")

vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = group_name,
  callback = function()
    vim.diagnostic.open_float { border = popup_border, focusable = false, show_header = false }
  end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false, -- if using pop-up window
  signs = true,
  underline = true,
  update_in_insert = false, -- update diagnostics insert mode
  severity_sort = false,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = popup_border })
vim.lsp.handlers["textDocument/signatureHelp"] =
vim.lsp.with(vim.lsp.handlers.signature_help, { border = popup_border })

vim.diagnostic.config {
  -- virtual_text = { prefix = "", },
  signs = true,
  underline = true,
  update_in_insert = false,
  -- virtual_text = false,
  float = {
    header = false,
    source = "always",
    -- source = false,
    format = function(diagnostic)
      local code = diagnostic.user_data.lsp.code

      if not diagnostic.source or not code then
        return string.format("%s", diagnostic.message)
      end

      if diagnostic.source == "eslint" then
        for _, table in pairs(codes) do
          if vim.tbl_contains(table, code) then
            return string.format("%s [%s]", table.icon .. diagnostic.message, code)
          end
        end

        return string.format("%s [%s]", diagnostic.message, code)
      end

      for _, table in pairs(codes) do
        if vim.tbl_contains(table, code) then
          return table.message
        end
      end

      return string.format("%s [%s]", diagnostic.message, diagnostic.source)
    end,
  },
  severity_sort = true,
  virtual_text = {
    prefix = icons.circle,
  },
}
