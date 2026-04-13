local bearded = require 'bearded'
bearded.setup { flavor = 'feat-will' }

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        -- theme = require('bearded.plugins.lualine').theme(bearded.palette()),
        component_separators = '|',
        section_separators = '',
        theme = 'tokyonight',
      },
      tabline = { lualine_a = {}, lualine_b = { 'branch' }, lualine_c = { 'filename' }, lualine_x = {}, lualine_y = {}, lualine_z = {} },
    }
  end,
}
