local M = {}
M.setup = function()
  local present, comment = pcall(require, "Comment")

  if not present then
    return
  end
  comment.setup()

  local ft = require "Comment.ft"

  -- set the default comment char to be '#'
  ft.set("", "#%s")
  ft.set("txt", "#%s")
  ft.set("samba", "#%s")
end
return M
