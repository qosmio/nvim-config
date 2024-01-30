local keymap = vim.keymap
local lsp = vim.lsp
local mappings = {}

local opt = { noremap = true, silent = true }

local M = {}
M.setup = function(client)
  keymap.set({ "n" }, "ga", vim.lsp.buf.code_action, opt)
  keymap.set({ "v" }, "ga", ":lua vim.lsp.buf.range_code_action()<cr>", opt)
  keymap.set("n", "gD", lsp.buf.declaration, opt)
  keymap.set("n", "gd", lsp.buf.definition, opt)
  keymap.set("n", "gi", lsp.buf.implementation, opt)
  keymap.set("n", "gt", lsp.buf.type_definition, opt)
  keymap.set("n", "K", vim.lsp.buf.hover, opt)
  keymap.set("n", "gR", lsp.buf.references, opt)

  keymap.set("n", "<leader>li", ":LspInfo<CR>", opt)
  keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opt)
  keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opt)
  keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opt)
  keymap.set("n", "<leader>wl", ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opt)

  -- keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
  keymap.set("n", "]d", ":lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })", opt)
  keymap.set("n", "[d", ":lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })", opt)
  keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opt)

  if mappings[client.name] then
    mappings[client.name]()
  end
end

return M
