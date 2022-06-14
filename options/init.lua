-- OPTIONS
local opt = vim.opt

opt.backupdir = "," .. os.getenv "HOME" .. "/.vim/backup//"
opt.directory = os.getenv "HOME" .. "/.vim/swap//"
opt.undodir = os.getenv "HOME" .. "/.vim/undo//"
opt.undolevels = 5000
opt.diffopt = opt.diffopt:append { "algorithm:patience" }
opt.completeopt = "menu,menuone,preview,noselect"
opt.pumheight = 6

-- opt.spell = true
opt.spelllang = { "en_us" }

-- MatchUp
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_mappings_enabled = 1
vim.g.matchup_override_vimtex = 1

-- Fix common typo commands
--
vim.cmd "command! -nargs=* W w"
vim.cmd "command! -nargs=* Wq wq"
vim.cmd "command! -nargs=* WQ wq"
vim.cmd "command! -nargs=* Q q"
vim.cmd "command! -nargs=* Qa qa"
vim.cmd "command! -nargs=* QA qa"
vim.g.redrawtime = 50

vim.schedule(function()
  opt.shadafile = vim.fn.expand "$HOME" .. "/.local/share/nvim/shada/main.shada"
  vim.cmd [[ silent! rsh ]]
end)

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
local M = {}

function M.clean(s)
  ---if s it not nil, strip leading and trailing whitespace
  if s == nil then
    return s
  end
  return s:match "^%s*(.-)%s*$"
end

function M.check_vim_option(option, value)
  if opt[option] ~= nil then
    -- if M.clean(_value) == M.clean(value) then
    if value ~= opt[option]._value then
      print("opt." .. option .. " = " .. tostring(opt[option]._value) .. " -- " .. tostring(value))
    end
    -- print(string.format("%s=%s -- %s", option, opt[option]._value, value))
  end
  -- vim.cmd("set " .. option)
  -- end
end

-- M.check_vim_option("completeopt", "menuone,noselect,menu")
-- M.check_vim_option("modeline", true)
-- M.check_vim_option("signcolumn", "yes")
-- M.check_vim_option("breakindent", true)
-- M.check_vim_option("formatoptions", "l")
-- M.check_vim_option("linebreak", true)
-- M.check_vim_option("laststatus", 3)
-- M.check_vim_option("showmode", false)
-- M.check_vim_option("updatetime", 4000)
-- M.check_vim_option("termguicolors", true)
-- M.check_vim_option("timeoutlen", 1000)
-- M.check_vim_option("textwidth", 120)
-- M.check_vim_option("relativenumber", true)
-- M.check_vim_option("cursorlineopt", "number")
-- M.check_vim_option("number", true)
-- M.check_vim_option("backspace", "indent,eol,start")
-- M.check_vim_option("tabstop", 2)
-- M.check_vim_option("softtabstop", 0)
-- M.check_vim_option("expandtab", true)
-- M.check_vim_option("shiftwidth", 0)
-- M.check_vim_option("smarttab", true)
-- M.check_vim_option("splitbelow", true)
-- M.check_vim_option("splitright", true)
-- M.check_vim_option("foldlevel", 99)
-- M.check_vim_option("foldmethod", "expr")
-- M.check_vim_option("foldexpr", "nvim_treesitter#foldexpr()")
-- M.check_vim_option("autoread", true)
-- M.check_vim_option("undodir", 'vim.fn.expand("~/.cache/nvim/undodir")')
-- M.check_vim_option("hidden", true)
-- --M.check_vim_option('shortmess:append("c")','')
-- M.check_vim_option("ignorecase", true)
-- M.check_vim_option("smartcase", true)
-- M.check_vim_option("conceallevel", 3)
-- M.check_vim_option("mouse", "a")
-- M.check_vim_option("inccommand", "nosplit")
-- M.check_vim_option("fillchars", "fold: ,foldclose:,foldopen:,foldsep: ,diff: ,eob: ")
-- M.check_vim_option("switchbuf", "useopen")
-- M.check_vim_option("viewoptions", "cursor,folds,slash,unix")
-- M.check_vim_option("list", false)
-- M.check_vim_option("scrolloff", 10)
-- M.check_vim_option("pyxversion", 3)
-- M.check_vim_option("wrap", false)
-- M.check_vim_option("diffopt", "internal,filler,closeoff,algorithm:patience")
-- M.check_vim_option("fixendofline", false)
-- M.check_vim_option("regexpengine", 0)
opt.breakindent = true
opt.linebreak = true
opt.updatetime = 550
opt.timeoutlen = 400
opt.textwidth = 120
opt.relativenumber = false -- true
opt.cursorlineopt = "both" -- number
opt.tabstop = 2
opt.shiftwidth = 0
-- opt.foldlevel = 0 -- 99
opt.conceallevel = 3
--opt.fillchars="fold:,foldclose:,foldopen:,foldsep:,diff:,eob:"
opt.switchbuf = useopen -- useopen
opt.viewoptions = "cursor,folds,slash,unix"
vim.cmd "set listchars=tab:╍╍,nbsp:_,trail:·"
opt.list = false
opt.scrolloff = 10
opt.wrap = true
opt.fixendofline = true
-- Preview changes when using search and replace
-- vim.opt.characters for after foldtext, eof, foldcolumn
opt.fillchars = "fold: ,foldclose:,foldopen:,foldsep: ,diff: ,eob: "
-- if os.getenv "LC_TERMINAL" == "iTerm2" then
--   vim.cmd [[
--   let &t_ti.="\<Esc>]1337;HighlightCursorLine=true\x7"
--   let &t_te.="\<Esc>]1337;HighlightCursorLine=false\x7"
-- ]]
-- end
