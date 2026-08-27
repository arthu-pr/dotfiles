return {
  'barrett-ruth/live-server.nvim',
  build = 'npm install -g live-server',
  cmd = { 'LiveServerStart', 'LiveServerStop' },
  config = true,
  keys = {
    { '<leader>ls', ':LiveServerStart<CR>', desc = 'Start Live Server' },
    { '<leader>lq', ':LiveServerStop<CR>',  desc = 'Stop Live Server' },
  },
}
