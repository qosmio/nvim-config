local M = {}

local kind = vim.lsp.protocol.CompletionItemKind

local groups = {
  {
    detail = "zsh reserved word",
    kind = kind.Keyword,
    words = {
      "!",
      "[[",
      "{",
      "}",
      "case",
      "coproc",
      "declare",
      "do",
      "done",
      "elif",
      "else",
      "end",
      "esac",
      "export",
      "fi",
      "float",
      "for",
      "foreach",
      "function",
      "if",
      "integer",
      "local",
      "nocorrect",
      "readonly",
      "repeat",
      "select",
      "then",
      "time",
      "typeset",
      "until",
      "while",
    },
  },
  {
    detail = "zsh builtin",
    kind = kind.Function,
    words = {
      "-",
      ".",
      ":",
      "[",
      "alias",
      "autoload",
      "bg",
      "bindkey",
      "break",
      "builtin",
      "bye",
      "cd",
      "chdir",
      "command",
      "compadd",
      "comparguments",
      "compcall",
      "compctl",
      "compdescribe",
      "compfiles",
      "compgroups",
      "compquote",
      "compset",
      "comptags",
      "comptry",
      "compvalues",
      "continue",
      "declare",
      "dirs",
      "disable",
      "disown",
      "echo",
      "echotc",
      "echoti",
      "emulate",
      "enable",
      "eval",
      "exec",
      "exit",
      "export",
      "false",
      "fc",
      "fg",
      "float",
      "functions",
      "getln",
      "getopts",
      "hash",
      "history",
      "integer",
      "jobs",
      "kill",
      "let",
      "limit",
      "local",
      "log",
      "logout",
      "noglob",
      "popd",
      "print",
      "printf",
      "private",
      "pushd",
      "pushln",
      "pwd",
      "r",
      "read",
      "readonly",
      "rehash",
      "return",
      "sched",
      "set",
      "setopt",
      "shift",
      "source",
      "suspend",
      "test",
      "times",
      "trap",
      "true",
      "ttyctl",
      "type",
      "typeset",
      "ulimit",
      "umask",
      "unalias",
      "unfunction",
      "unhash",
      "unlimit",
      "unset",
      "unsetopt",
      "vared",
      "wait",
      "whence",
      "where",
      "which",
      "zcompile",
      "zformat",
      "zle",
      "zmodload",
      "zparseopts",
      "zregexparse",
      "zstyle",
    },
  },
  {
    detail = "zsh option",
    kind = kind.EnumMember,
    words = {
      "aliases",
      "aliasfuncdef",
      "allexport",
      "alwayslastprompt",
      "alwaystoend",
      "appendcreate",
      "appendhistory",
      "autocd",
      "autocontinue",
      "autolist",
      "automenu",
      "autonamedirs",
      "autoparamkeys",
      "autoparamslash",
      "autopushd",
      "autoremoveslash",
      "autoresume",
      "badpattern",
      "banghist",
      "bareglobqual",
      "bashautolist",
      "bashrematch",
      "beep",
      "bgnice",
      "braceccl",
      "braceexpand",
      "bsdecho",
      "caseglob",
      "casematch",
      "casepaths",
      "cbases",
      "cdablevars",
      "cdsilent",
      "chasedots",
      "chaselinks",
      "checkjobs",
      "checkrunningjobs",
      "clobber",
      "clobberempty",
      "combiningchars",
      "completealiases",
      "completeinword",
      "continueonerror",
      "correct",
      "correctall",
      "cprecedences",
      "cshjunkiehistory",
      "cshjunkieloops",
      "cshjunkiequotes",
      "cshnullcmd",
      "cshnullglob",
      "debugbeforecmd",
      "dotglob",
      "dvorak",
      "emacs",
      "equals",
      "errexit",
      "errreturn",
      "evallineno",
      "exec",
      "extendedglob",
      "extendedhistory",
      "flowcontrol",
      "forcefloat",
      "functionargzero",
      "glob",
      "globalexport",
      "globalrcs",
      "globassign",
      "globcomplete",
      "globdots",
      "globstarshort",
      "globsubst",
      "hashall",
      "hashcmds",
      "hashdirs",
      "hashexecutablesonly",
      "hashlistall",
      "histallowclobber",
      "histappend",
      "histbeep",
      "histexpand",
      "histexpiredupsfirst",
      "histfcntllock",
      "histfindnodups",
      "histignorealldups",
      "histignoredups",
      "histignorespace",
      "histlexwords",
      "histnofunctions",
      "histnostore",
      "histreduceblanks",
      "histsavebycopy",
      "histsavenodups",
      "histsubstpattern",
      "histverify",
      "hup",
      "ignorebraces",
      "ignoreclosebraces",
      "ignoreeof",
      "incappendhistory",
      "incappendhistorytime",
      "interactive",
      "interactivecomments",
      "ksharrays",
      "kshautoload",
      "kshglob",
      "kshoptionprint",
      "kshtypeset",
      "kshzerosubscript",
      "listambiguous",
      "listbeep",
      "listpacked",
      "listrowsfirst",
      "listtypes",
      "localloops",
      "localoptions",
      "localpatterns",
      "localtraps",
      "log",
      "login",
      "longlistjobs",
      "magicequalsubst",
      "mailwarn",
      "mailwarning",
      "markdirs",
      "menucomplete",
      "monitor",
      "multibyte",
      "multifuncdef",
      "multios",
      "nomatch",
      "notify",
      "nullglob",
      "numericglobsort",
      "octalzeroes",
      "onecmd",
      "overstrike",
      "pathdirs",
      "pathscript",
      "physical",
      "pipefail",
      "posixaliases",
      "posixargzero",
      "posixbuiltins",
      "posixcd",
      "posixidentifiers",
      "posixjobs",
      "posixstrings",
      "posixtraps",
      "printeightbit",
      "printexitvalue",
      "privileged",
      "promptbang",
      "promptcr",
      "promptpercent",
      "promptsp",
      "promptsubst",
      "promptvars",
      "pushdignoredups",
      "pushdminus",
      "pushdsilent",
      "pushdtohome",
      "rcexpandparam",
      "rcquotes",
      "rcs",
      "recexact",
      "rematchpcre",
      "restricted",
      "rmstarsilent",
      "rmstarwait",
      "sharehistory",
      "shfileexpansion",
      "shglob",
      "shinstdin",
      "shnullcmd",
      "shoptionletters",
      "shortloops",
      "shortrepeat",
      "shwordsplit",
      "singlecommand",
      "singlelinezle",
      "sourcetrace",
      "stdin",
      "sunkeyboardhack",
      "trackall",
      "transientrprompt",
      "trapsasync",
      "typesetsilent",
      "typesettounset",
      "unset",
      "verbose",
      "vi",
      "warncreateglobal",
      "warnnestedvar",
      "xtrace",
      "zle",
    },
  },
}

local items

local function build_items()
  if items then
    return items
  end

  local seen = {}
  items = {}
  for _, group in ipairs(groups) do
    for _, word in ipairs(group.words) do
      local key = group.detail .. "\000" .. word
      if not seen[key] then
        seen[key] = true
        items[#items + 1] = {
          label = word,
          kind = group.kind,
          detail = group.detail,
        }
      end
    end
  end

  return items
end

local function filter_items(prefix)
  local all_items = build_items()
  if not prefix or prefix == "" then
    return all_items
  end

  local lower_prefix = prefix:lower()
  local filtered = {}
  for _, item in ipairs(all_items) do
    if vim.startswith(item.label:lower(), lower_prefix) then
      filtered[#filtered + 1] = item
    end
  end

  return filtered
end

function M.has_prefix(prefix)
  return #filter_items(prefix) > 0
end

local function blink_prefix(ctx)
  if not ctx or not ctx.bounds or not ctx.line then
    return ""
  end

  return ctx.line:sub(ctx.bounds.start_col, ctx.bounds.start_col + ctx.bounds.length - 1)
end

local function cmp_prefix(request)
  local line = request and request.context and request.context.cursor_before_line or ""
  return line:match "[%w_]+$" or ""
end

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.bo.filetype == "zsh"
end

source.enabled = source.is_available

function source:get_keyword_pattern()
  return [[\k\+]]
end

function source:complete(request, callback)
  callback {
    items = filter_items(cmp_prefix(request)),
    isIncomplete = false,
  }
end

function source:get_completions(ctx, callback)
  callback {
    items = filter_items(blink_prefix(ctx)),
    is_incomplete_forward = false,
    is_incomplete_backward = false,
  }
end

M.new = source.new

function M.register_cmp()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    cmp.register_source("zsh_syntax", M.new())
  end
end

return M
