-- https://github.com/akinsho/bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  setup = function()
    require('bufferline').setup {
      options = {
        diagnostics = 'nvim_lsp',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    }
  end,
}
