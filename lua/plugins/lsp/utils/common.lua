local opts = { noremap = true, silent = true }

local M = {}

M.set_contains = function(set, val)
  for _, value in pairs(set) do
    if value == val then
      return true
    end
  end
  return false
end

M.set_default_formatter_for_filetypes = function(language_server_name, filetypes)
  if not M.set_contains(filetypes, vim.bo.filetype) then
    return
  end

  local active_servers = {}

  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    table.insert(active_servers, client.config.name)
  end

  if not M.set_contains(active_servers, language_server_name) then
    return
  end

  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    if client.name ~= language_server_name then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end
end

M.has_exec = function(filename)
  return function(_)
    return vim.fn.executable(filename) == 1
  end
end

---@param on_attach fun(client, buffer)
M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.file_fn = function(mode, filepath, content)
  local data
  local fd = assert(vim.loop.fs_open(filepath, mode, 438))
  local stat = assert(vim.loop.fs_fstat(fd))
  if stat.type ~= "file" then
    data = false
  else
    if mode == "r" then
      data = assert(vim.loop.fs_read(fd, stat.size, 0))
    else
      assert(vim.loop.fs_write(fd, content, 0))
      data = true
    end
  end
  assert(vim.loop.fs_close(fd))
  return data
end

-- Get functions in current file
local python_function_query_string = [[
  (function_definition
    name: (identifier) @func_name (#offset! @func_name)
  )
]]

local lua_function_query_string = [[
  (function_declaration
  name:
    [
      (dot_index_expression)
      (identifier)
    ] @func_name (#offset! @func_name)
  )
]]

local func_lookup = {
  python = python_function_query_string,
  lua = lua_function_query_string,
}

local function get_functions(bufnr, lang, query_string)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local syntax_tree = parser:parse()[1]
  local root = syntax_tree:root()
  local query = vim.treesitter.query.parse(lang, query_string)
  local func_list = {}

  for _, captures, metadata in query:iter_matches(root, bufnr) do
    local row, col, _ = captures[1]:start()
    local name = vim.treesitter.get_node_text(captures[1], bufnr)
    table.insert(func_list, { name, row, col, metadata[1].range })
  end
  return func_list
end

function M.goto_function(bufnr, lang)
  local pickers, finders, actions, action_state, conf
  if pcall(require, "telescope") then
    pickers = require "telescope.pickers"
    finders = require "telescope.finders"
    actions = require "telescope.actions"
    action_state = require "telescope.actions.state"
    conf = require("telescope.config").values
  else
    error "Cannot find telescope!"
  end

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lang = lang or vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  local query_string = func_lookup[lang]
  if not query_string then
    vim.notify(lang .. " is not supported", vim.log.levels.INFO)
    return
  end
  local func_list = get_functions(bufnr, lang, query_string)
  if vim.tbl_isempty(func_list) then
    vim.notify("No functions found in current file", vim.log.levels.INFO)
    return
  end
  local funcs = {}
  for _, func in ipairs(func_list) do
    table.insert(funcs, func[1])
  end

  pickers
      .new(opts, {
        prompt_title = "Function List",
        finder = finders.new_table {
          results = func_list,
          entry_maker = function(entry)
            return { value = entry, display = entry[1], ordinal = entry[1] }
          end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function()
          actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local row, col = selection.value[2] + 1, selection.value[3] + 2
            vim.fn.setcharpos(".", { bufnr, row, col, 0 })
          end)
          return true
        end,
      })
      :find()
end

M.imap = function(tbl)
  if tbl[3] then
    for k, v in ipairs(tbl[3]) do
      opts[k] = v
    end
  end
  vim.keymap.set("i", tbl[1], tbl[2], opts)
end

M.nmap = function(tbl)
  if tbl[3] then
    for k, v in ipairs(tbl[3]) do
      opts[k] = v
    end
  end
  vim.keymap.set("n", tbl[1], tbl[2], opts)
end

M.tmap = function(tbl)
  if tbl[3] then
    for k, v in ipairs(tbl[3]) do
      opts[k] = v
    end
  end
  vim.keymap.set("t", tbl[1], tbl[2], opts)
end

M.vmap = function(tbl)
  if tbl[3] then
    for k, v in ipairs(tbl[3]) do
      opts[k] = v
    end
  end
  vim.keymap.set("v", tbl[1], tbl[2], opts)
end

M.execute = function()
  local config = {
    cmds = {
      markdown = "glow %",
      python = "python3 %",
      cpp = "./$fileBase",
      lua = "luafile %",
      vim = "source %",
    },
    ui = {
      -- bot|top|vert
      pos = "vert",
      size = 50,
    },
  }

  local cmd = config.cmds[vim.bo.filetype]
  cmd = cmd:gsub("%%", vim.fn.expand "%")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  cmd = cmd:gsub(
    "$moduleName",
    vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand "%:r", ":~:."), "/", ".", "g"), "\\", ".", "g")
  )

  vim.cmd "silent! make"

  if cmd ~= nil then
    if cmd ~= "" then
      vim.cmd(config.ui.pos .. " " .. config.ui.size .. "new | term " .. cmd)
    end
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<C-\\><C-n>:bdelete!<CR>", { silent = true })
    vim.wo.number = false
    vim.wo.relativenumber = false
    if vim.fn.argc() > 0 then
      vim.schedule(function()
        vim.api.nvim_set_option_value("filetype", "Execute", { buf = buf })
      end)
    end
  else
    vim.cmd "echohl ErrorMsg | echo 'Error: Invalid command' | echohl None"
  end
end

return M
