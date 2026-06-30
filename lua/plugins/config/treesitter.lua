pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local M = {}

local ensure_installed = {
  "bash",
  "html",
  "javascript",
  "json",
  "kconfig",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "toml",
  "vim",
  "yaml",
  "zsh",
}

local filetype_languages = {
  ["yaml.ansible"] = "yaml",
  ["yaml.docker-compose"] = "yaml",
}

local perf = require "plugins.config.perf"
local utils = require "utils"

local slow_host = perf.is_slow_host()

local function can_install_parsers()
  if slow_host then
    return false
  end

  local os_info = utils.get_os_info() or nil
  if os_info and os_info.id == "openwrt" then
    return false
  end

  return vim.fn.executable "cc" == 1
    or vim.fn.executable "gcc" == 1
    or vim.fn.executable "clang" == 1
end

local function to_set(values)
  local set = {}
  for _, value in ipairs(values) do
    set[value] = true
  end
  return set
end

local function language_for_buffer(bufnr)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    return nil
  end

  if filetype_languages[filetype] then
    return filetype_languages[filetype]
  end

  local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)
  if ok and lang then
    return lang
  end

  local base_filetype = filetype:match "^[^.]+"
  if base_filetype and base_filetype ~= filetype then
    ok, lang = pcall(vim.treesitter.language.get_lang, base_filetype)
    if ok and lang then
      return lang
    end
    return base_filetype
  end

  return filetype
end

local function missing_parsers(nvim_treesitter, parsers)
  local ok, installed = pcall(nvim_treesitter.get_installed, "parsers")
  if not ok then
    return parsers
  end

  local installed_set = to_set(installed)
  return vim.tbl_filter(function(parser)
    return not installed_set[parser]
  end, parsers)
end

local function install_missing_parsers(opts)
  if not opts.auto_install or #opts.ensure_installed == 0 then
    return
  end

  local nvim_treesitter = require "nvim-treesitter"
  local missing = missing_parsers(nvim_treesitter, opts.ensure_installed)
  if #missing > 0 then
    nvim_treesitter.install(missing)
  end
end

local function configure_filetype_languages()
  vim.treesitter.language.register("bash", "sh")
  vim.treesitter.language.register("javascript", { "javascriptreact", "jsx", "js" })
  vim.treesitter.language.register("json", "jsonc")
end

local function enable_for_buffer(bufnr, opts)
  if slow_host or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local lang = language_for_buffer(bufnr)
  if not lang or not opts.enabled_languages[lang] or perf.disable_treesitter(lang, bufnr) then
    return
  end

  vim.treesitter.start(bufnr, lang)

  if opts.indent then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local opts = {
  install_dir = vim.fn.stdpath "data" .. "/site",
  ensure_installed = can_install_parsers() and ensure_installed or {},
  enabled_languages = to_set(ensure_installed),
  auto_install = can_install_parsers(),
  indent = not slow_host,
}

function M.setup(_, user_opts)
  local merged = vim.tbl_deep_extend("force", opts, user_opts or {})

  require("nvim-treesitter").setup {
    install_dir = merged.install_dir,
  }

  configure_filetype_languages()
  install_missing_parsers(merged)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
    callback = function(args)
      enable_for_buffer(args.buf, merged)
    end,
  })

  enable_for_buffer(vim.api.nvim_get_current_buf(), merged)
end

M.opts = opts

return M
