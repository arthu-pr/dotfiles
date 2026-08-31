return {
  'danymat/neogen',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  -- enabled = true,
  keys = {
    { '<leader>docc', ':Neogen class<CR>', desc = 'Annotations Generate (class)' },
    { '<leader>docf', ':Neogen func<CR>',  desc = 'Annotations Generate (function)' },
    { '<leader>doct', ':Neogen type<CR>',  desc = 'Annotations Generate (type)' },
  }
}
