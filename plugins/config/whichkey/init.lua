return {
  opt    = true,
  setup  = function()
    require('core.utils').packer_lazy_load('which-key.nvim')
  end,
  config = function()
    require('custom.plugins.config.whichkey.mappings')
    require('custom.plugins.config.whichkey.settings')
  end
}
