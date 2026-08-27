return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'quarto' },
  },
  keys = function()
    local wk = require 'which-key'
    local render = require 'render-markdown'

    wk.add {
      { '<leader>mr', group = 'render-markdown' },
      { '<leader>mr', render.buf_toggle,        desc = '[render-markdown] Toggle state of this plugin for current buffer' },
    }
  end,
}
