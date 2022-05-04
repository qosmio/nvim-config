local wk = require('which-key')
wk.register({
  d = {
    name = 'Dap Debugger',
    b    = {'Toggle breakpoint'},
    B    = {'Step back'},
    c    = {'Continue'},
    C    = {'Run to cursor'},
    d    = {'Disconnect'},
    S    = {'Sesion'},
    i    = {'Step into'},
    o    = {'Step over'},
    u    = {'Step out'},
    p    = {'Pause toggle'},
    r    = {'REPL Toggle'},
    s    = {'Continue'},
    q    = {'Close'}
  },
  g = {
    name = 'General',
    d    = 'Generate Docstrings',
    D    = 'View Definition',
    i    = 'Goto Implementation',
    r    = 'Rename variable',
    t    = 'View Type Definition'
  },
  l = {name = 'Latex', b    = {'Build Document'}, v    = {'Forward View'}},
  p = {'NvimTree'},
  q = {'Trouble'},
  n = {'Neogit'},
  h = {
    name = 'Git Signs',
    b    = {'Blame line'},
    p    = {'Preview hunk'},
    R    = {'Reset buffer'},
    r    = {'Reset hunk'},
    S    = {'Stage buffer'},
    s    = {'Stage hunk'},
    u    = {'Undo stage hunk'},
    U    = {'Reset buffer index'}
  },
  t = {
    name = 'Telescope',
    c    = {'Colorscheme'},
    f    = {'Files'},
    g    = {'Grep'},
    h    = {'Tags'},
    o    = {'Old files'},
    p    = {'Projects'}
  }
}, {prefix = '<Space>'})
