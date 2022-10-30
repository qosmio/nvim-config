local present, ls = pcall(require, "luasnip")

if not present then
  return
end

local types = require "luasnip.util.types"

local options = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "LuasnipChoice" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "LuasnipInsert" } },
      },
    },
  },
}

ls.config.set_config(options)

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- Reload snippets config
vim.keymap.set("n", "<leader>sl", "<cmd>source ~/.config/nvim/lua/custom/plugins/config/luasnip.lua<cr>")

-- Snippets

require "custom.plugins.config.snippets.lua"
require "custom.plugins.config.snippets.javascript"
require "custom.plugins.config.snippets.typescript"
require "custom.plugins.config.snippets.typescriptreact"
require "custom.plugins.config.snippets.vue"

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})
