-- lua/plugins/treesitter.lua

return {
  'nvim-treesitter/nvim-treesitter',

  build = ':TSUpdate',

  opts = {
    ensure_installed = {
      'astro',
      'javascript',
      'typescript',
      'html',
      'css',
      'json',
      'yaml',
      'scss',
      'vue',
    },

    sync_install = false,

    auto_install = true,

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = false,

      keymaps = {
        init_selection = '<C-Space>',
        node_incremental = '<C-Space>',
        scope_incremental = '<C-s>',
        node_decremental = '<M-Space>',
      },
    },
  },
}
