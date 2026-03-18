return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = function()
    local configs = require 'nvim-treesitter.configs'
    configs.setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'lua',
        'vimdoc',
        'vim',
        'javascript',
        'typescript',
        'html',
        'css',
        'json',
        'yaml',
        'scss',
        'vue',
        'markdown',
        'markdown_inline',
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      -- TODO: TO VERIFY
      auto_install = true,
      -- List of parsers to ignore installing (or "all")
      -- ignore_install = {},
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
    }
  end,
}
