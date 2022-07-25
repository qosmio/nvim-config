return {
  setup_lsp = function()
    require "custom.plugins.lsp.settings"
    require "custom.plugins.lsp.installers"
    require "custom.plugins.lsp.handlers"
    -- require "custom.plugins.lsp.servers"
    vim.defer_fn(function()
      vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
    end, 0)
  end,
}
