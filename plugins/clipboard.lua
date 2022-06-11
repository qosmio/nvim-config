-- Minimal implementation of OSC 52.
-- https://en.m.wikipedia.org/wiki/ANSI_escape_code#OSC
--
-- https://chromium.googlesource.com/apps/libapps/+/a5fb83c190aa9d74f4a9bca233dac6be2664e9e9/hterm/doc/ControlSequences.md#OSC
-- ESC ] 52 ; c ; [base64 data] \a
local STDERR = "/proc/self/fd/2"

local function encode_osc52(lines)
  local encoded = table.concat(vim.fn.systemlist({ "base64" }, lines))

  -- Set 'bad_string_escape = "allow"' in selene.toml to have it not complain.
  return "\x1B]52;c;" .. encoded .. "\x07"
end

local function copy(register)
  return function(lines)
    -- Set buffer scoped lines & given register to what was copied.
    vim.b.lines = lines
    vim.fn.setreg(register, lines)

    -- Write the encoded lines to stderr so the terminal will pick them up.
    if vim.fn.filewritable(STDERR) then
      vim.fn.writefile({ encode_osc52(lines) }, STDERR, "b")
    end
  end
end

local function paste(register)
  -- This is a no-op.
  return function()
    local data = vim.fn.getreginfo(register)
    return { data.regcontents, data.regtype }
  end
end

-- Set the clipboard here so clipboard.vim has less to do.
return {
  init = function()
    -- Set Neovim's clipboard to use OSC 52 over SSH..
    if vim.env.SSH_CONNECTION ~= nil then
      vim.g.clipboard = {
        name = "OSC52",
        copy = { ["*"] = copy "*", ["+"] = copy "+" },
        paste = { ["*"] = paste "*", ["+"] = paste "+" },
        cache_enabled = false,
      }
    elseif vim.loop.os_uname().sysname == "Darwin" then
      vim.g.clipboard = {
        name = "macOS",
        copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
        paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
        cache_enabled = 0,
      }
    end
  end,
}
