-- Fuzzy Finder (files, lsp, etc)
local file_exclude_options = {
  defaults = {
    file_ignore_patterns = { '^./node_modules/', 'node_modules/.*', '^./.nuxt/', '.nuxt/.*', '^./.output/', '.output/.*' },
  }
}

function _G.TelescopeToggleIgnore()
  if #file_exclude_options.defaults.file_ignore_patterns == 0 then
    file_exclude_options.defaults.file_ignore_patterns = { "node_modules/" }
  else
    file_exclude_options.defaults.file_ignore_patterns = {}
  end
  require('telescope').setup(file_exclude_options)
end

vim.cmd([[ command! TelescopeToggleIgnore lua _G.TelescopeToggleIgnore() ]])

local telescope = {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
  keys = {
    { '<leader>sf', ':Telescope find_files<CR>',  desc = 'Search Files',           mode = 'n' },
    { '<leader>sh', ':Telescope help_tags<CR>',   desc = 'Search Help',            mode = 'n' },
    { '<leader>sw', ':Telescope grep_string<CR>', desc = 'Search Current Word',    mode = 'n' },
    { '<leader>sg', ':Telescope live_grep<CR>',   desc = 'Search by Grep',         mode = 'n' },
    { '<leader>sd', ':Telescope diagnostics<CR>', desc = 'Search Diagnostics',     mode = 'n' },
    { '<leader>tt', ':TelescopeToggleIgnore<CR>', desc = 'Toggle Ignore Patterns', mode = 'n' },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local gfh_actions = require('telescope').extensions.git_file_history.actions
    local file_excude_from_options = file_exclude_options.defaults.file_ignore_patterns

    require('telescope').setup {

      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
        file_ignore_patterns = file_excude_from_options,
      },
      pickers = {
        find_files = {
          theme = 'dropdown',
        },
      },
      extensions = {
        git_file_history = {
          -- Keymaps inside the picker
          mappings = {
            i = {
              ['<C-g>'] = gfh_actions.open_in_browser,
            },
            n = {
              ['<C-g>'] = gfh_actions.open_in_browser,
            },
          },

          -- The command to use for opening the browser (nil or string)
          -- If nil, it will check if xdg-open, open, start, wslview are available, in that order.
          browser_command = nil,
        },
      },
    }
    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension 'fzf')
    require('telescope').load_extension 'file_browser'
    require('telescope').load_extension 'luasnip'
    local builtin = require 'telescope.builtin'
    local nmap = require('utils').nmap
    -- See `:help telescope.builtin`
    -- nmap('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
    -- vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    nmap('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
    nmap('<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, '[/] Fuzzily search in current buffer')
    -- local nmap = require('utils').nmap

    -- nmap('<leader>sf', builtin.find_files, '[S]earch [F]iles')
    -- nmap('<leader>sh', builtin.help_tags, '[S]earch [H]elp')
    -- nmap('<leader>sw', builtin.grep_string, '[S]earch current [W]ord')
    -- nmap('<leader>sg', builtin.live_grep, '[S]earch by [G]rep')
    -- nmap('<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics')
  end,
  keys = function()
    local builtin = require 'telescope.builtin'
    local wk = require 'which-key'
    wk.add {
      { '<leader>s',  group = 'telescope' },
      { '<leader>sf', builtin.find_files,  desc = 'Search Files' },
      { '<leader>sh', builtin.help_tags,   desc = 'Search Help' },
      { '<leader>sw', builtin.grep_string, desc = 'Search Current Word' },
      { '<leader>sg', builtin.live_grep,   desc = 'Search by Grep' },
      { '<leader>sd', builtin.diagnostics, desc = 'Search Diagnostics' },
      { '<leader>sb', builtin.builtin,     desc = 'Search Builtins' },
      { '<leader>?',  builtin.oldfiles,    desc = 'Search in Recently Opened Files' },
      -- { "<leader>ss", ':Telescope luasnip<CR>', desc = "Search Snippets" },
    }
  end,
}

-- Telescope extensions

-- https://github.com/nvim-telescope/telescope-symbols.nvim
-- Emoji Picker for Telescope.nvim
local telescope_symbols = {
  'nvim-telescope/telescope-symbols.nvim',
  keys = {
    { '<leader>se', ':Telescope symbols<CR>', desc = 'Search Emojis', mode = 'n' },
  },
}

-- Show and search luasnip snippets in telescope
local telescope_luasnip = {
  'benfowler/telescope-luasnip.nvim',
  keys = {
    { '<leader>ss', ':Telescope luasnip<CR>', desc = 'Search Snippets', mode = 'n' },
  },
}

-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file
local telescope_file_browser = {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>fb', ':Telescope file_browser<CR>', desc = 'File Browser', mode = 'n' },
  },
}

-- Fuzzy Finder Algorithm which requires local dependencies to be built.
-- Only load if `make` is available. Make sure you have the system
-- requirements installed.
local telescope_fzf_native = {
  'nvim-telescope/telescope-fzf-native.nvim',
  -- NOTE: If you are having trouble with this installation,
  --       refer to the README for telescope-fzf-native for more instructions.
  build = 'make',
  cond = function()
    return vim.fn.executable 'make' == 1
  end,
}

-- TODO: To test
local telescope_project = {
  'nvim-telescope/telescope-project.nvim',
  -- enabled = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<leader>fp', ':Telescope project<CR>', desc = 'Find Projects', mode = 'n' },
  },
}

-- Telescope Git File History Extension setup
-- https://github.com/isak102/telescope-git-file-history.nvim
local telescope_git_file_history = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    {
      'isak102/telescope-git-file-history.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'tpope/vim-fugitive',
      },
    },
  },
  keys = {
    {
      '<leader>gh',
      ':Telescope git_file_history<CR>',
      desc = 'Git File History',
      mode = 'n',
    },
  },
}
return {
  telescope,
  telescope_symbols,
  telescope_luasnip,
  telescope_file_browser,
  telescope_fzf_native,
  telescope_project,
  telescope_git_file_history,
}
