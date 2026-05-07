local M = {}

local valid_backends = {
  blink = true,
  cmp = true,
}

local copilot_node_command
local copilot_node_checked = false

local function valid_copilot_node(command)
  if not command or command == "" or vim.fn.executable(command) ~= 1 then
    return false
  end

  local output = vim.fn.systemlist { command, "--version" }
  if vim.v.shell_error ~= 0 then
    return false
  end

  local major = tonumber((output[1] or ""):match "^v(%d+)%.")
  return major ~= nil and major >= 22
end

function M.backend()
  local backend = vim.g.completion_backend
    or vim.env.NVIM_COMPLETION_BACKEND
    or vim.env.NVIM_COMPLETION
  backend = backend and tostring(backend):lower() or "cmp"

  if valid_backends[backend] then
    return backend
  end

  vim.schedule(function()
    vim.notify(
      ("Unknown completion backend %q; using nvim-cmp"):format(backend),
      vim.log.levels.WARN
    )
  end)

  return "cmp"
end

function M.is(backend)
  return M.backend() == backend
end

function M.copilot_node_command()
  if copilot_node_checked then
    return copilot_node_command
  end

  copilot_node_checked = true
  local command = vim.env.COPILOT_NODE_COMMAND or "node"
  if valid_copilot_node(command) then
    copilot_node_command = command
  end

  return copilot_node_command
end

function M.copilot_node_available()
  return M.copilot_node_command() ~= nil
end

function M.copilot_completion_enabled()
  return vim.env.COPILOT_ENABLE ~= "false" and M.copilot_node_available()
end

return M
