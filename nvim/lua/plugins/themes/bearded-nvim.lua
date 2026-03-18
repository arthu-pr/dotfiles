return {
  'Ferouk/bearded-nvim',
  name = 'bearded',
  priority = 1000,
  build = function()
    -- Generate helptags so :h bearded-theme works
    local doc = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy', 'bearded', 'doc')
    pcall(vim.cmd, 'helptags ' .. doc)
  end,
  config = function()
    require('bearded').setup {
      flavor = 'feat-will',
      transparent = true,
      bold = true,
      italic = true,
      dim_inactive = false,
      terminal_colors = true,
      on_highlights = function(set, palette, opts)
        -- optional override
        set('Normal', { fg = palette.ui.Ferouk, bg = 'none' })
      end,
    }
    vim.cmd.colorscheme 'bearded'
  end,
}
