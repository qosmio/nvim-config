local M = {}
M.setup = function()
  local present, nvim_comment = pcall(require, "Comment")

  if not present then
    return
  end

  nvim_comment.setup()
  local _, ft = pcall(require, "Comment.ft")

  -- set the default comment char to be '#'
  ft.set("", "#%s")
  ft.set("txt", "#%s")
end
return M
