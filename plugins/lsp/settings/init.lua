local M = {}
-- UI
M.icons = require "lsp.settings.icons"
M.codes = require "lsp.settings.codes"
M.popup_border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

M.handlers = {
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false, -- if using pop-up window
    signs = true,
    underline = true,
    update_in_insert = false, -- update diagnostics insert mode
    severity_sort = false,
  }),
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = M.popup_border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = M.popup_border }),
}

M.define_signs = function(signs)
  for type, _ in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
    -- without icon, but with number highlight
  end
end

M.setup = function()
  M.define_signs {
    Error = M.icons.errorSlash,
    Warn = M.icons.warningTriangle,
    Hint = M.icons.lightbulbOutline,
    Info = M.icons.info,
  }

  -- Show diagnostics in popup window (using the border above)
  local group_name = "LspDiagnostics"
  vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = group_name,
    callback = function()
      vim.diagnostic.open_float { source = false, border = M.popup_border, focusable = false, show_header = false }
    end,
  })

  vim.diagnostic.config {
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    float = {
      header = false,
      -- source = "always",
      -- source = false,
      format = function(diagnostic)
        if not diagnostic.source then
          return string.format("%s", diagnostic.message)
        end

        -- if diagnostic.source ~= "shellcheck" then
        if diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code then
          local code = diagnostic.user_data.lsp.code

          if diagnostic.source == "eslint" then
            for _, table in pairs(M.codes) do
              if vim.tbl_contains(table, code) then
                return string.format("%s [%s]", table.icon .. diagnostic.message, code)
              end
            end
            return string.format("%s [%s]", diagnostic.message, code)
          end

          for _, table in pairs(M.codes) do
            if vim.tbl_contains(table, code) then
              return table.message
            end
          end
        end

        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
      end,
    },
    severity_sort = true,
  }
end

return M
