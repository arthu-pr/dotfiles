return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation#lazy-loading
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvim_tree = require "nvim-tree"
    -- Custom mapping
    local function my_mapping(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- Tree mappings
      vim.keymap.set('n', '<C-b>', api.tree.toggle, opts 'Toggle')
      vim.keymap.set('n', '<C-f-e>', api.tree.focus, opts 'Focus')
      vim.keymap.set('n', '<leader>ff', api.tree.find_file, opts 'Find')

      -- Dotfiles & .gitignore
      vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
      vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Filter: Git Ignore'))
      -- vim.keymap.set('n', '<leader>nm', api.tree.toggle_custom_filter, opts('Toggle Filter: node_modules'))

      -- Filesystem operations mappings
      vim.keymap.set('n', '<leader>fc', api.fs.create, opts 'Create')
      vim.keymap.set('n', '<leader>fr', api.fs.rename, opts 'Rename')
      vim.keymap.set('n', '<leader>fd', api.fs.remove, opts 'Delete')
      vim.keymap.set('n', '<C-c>', api.fs.copy.node, opts 'Copy')
      vim.keymap.set('n', '<C-v>', api.fs.paste, opts 'Paste')
      vim.keymap.set('n', '<C-x>', api.fs.cut, opts 'Cut')
    end

    nvim_tree.setup {
      sort = {
        sorter = "name",
        folders_first = true,
      },
      on_attach = my_mapping,
      sync_root_with_cwd = true,
      view = {
        width = 50,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_modified = "all",
        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
        },
      },
      filters = {
        dotfiles = false,
        git_ignored = true,
        custom = { node_modules = true },
      },
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
      },
      update_focused_file = {
        enable = true,
        update_root = true,
        -- enable = false,
        -- update_root = false,
        -- ignore_list = {},
        -- update_cwd = true,
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false
          }
        }
      }
    }

    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
    local function open_nvim_tree(data)
      -- buffer is a [No Name]
      local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

      -- buffer is a directory
      local directory = vim.fn.isdirectory(data.file) == 1

      if not no_name and not directory then
        return
      end

      -- change to the directory
      if directory then
        vim.cmd.cd(data.file)
      end

      -- open the tree
      require("nvim-tree.api").tree.open()
    end

    -- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
  end,
}
