local M = {}

M.config = function()
  local status_ok, yanky = pcall(require, "yanky")
  if not status_ok then
    return
  end

  yanky.setup {
    picker = {
      select = {
        action = require("yanky.picker").actions.put "gp", -- put after cursor and leave the cursor after
      },
    },
  }
  -- require("user.keymaps").set_yanky_keymaps()
end

return M
