local keymap = vim.keymap
local wk = require 'which-key'

keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Helpers
local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

local imap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end
  keymap.set('i', keys, func, { desc = desc })
end

------- LSP ------------------------------------------------
---healthcheck lsp diagnostics shortcuts
nmap('<leader>cl', ':checkhealth lsp<CR>', 'LSP Check Health')

--  local nmap = require('utils').nmap
nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
------- Git ------------------------------------------------

-- Diffview
nmap('<leader>gd', function()
  require('diffview').open { file_panel = { width = 35 } }
end, 'Open Diffview')

-- Git Pickers (Snacks)
nmap('<leader>gs', function() Snacks.picker.git_status() end, '[G]it [S]tatus')
nmap('<leader>gst', function() Snacks.picker.git_stash() end, '[G]it [S]tash')

-- Neogit
-- local neogit = require 'neogit'

-- -- open using defaults
-- nmap('<leader>gn', neogit.open, '[G]it [N]eogit')
-- open as a split
-- vim.keymap.set('n', '<leader>gns', neogit.open_split, { desc = 'Open Neogit in a split' })

-------------------------------------------------------------
-- Plugins

-- typescript-tools.nvim
-- local wk = require 'which-key'

-- wk.add {
--   { '<leader>ts',  group = 'typescript-tools' },
--   { '<leader>tsi', '<cmd>TSToolsOrganizeImports<cr>',      desc = 'Organize Imports' },
--   { '<leader>tss', '<cmd>TSToolsSortImports<cr>',          desc = 'Sort Imports' },
--   { '<leader>tsr', '<cmd>TSToolsRemoveUnusedImports<cr>',  desc = 'Remove Unused Imports' },
--   { '<leader>tsu', '<cmd>TSToolsRemoveUnused<cr>',         desc = 'Remove Unused' },
--   { '<leader>tsa', '<cmd>TSToolsAddMissingImports<cr>',    desc = 'Add Missing Imports' },
--   { '<leader>tsf', '<cmd>TSToolsFixAll<cr>',               desc = 'Fix All' },
--   { '<leader>tsd', '<cmd>TSToolsGoToSourceDefinition<cr>', desc = 'Go To Source Definition' },
--   { '<leader>tsn', '<cmd>TSToolsRenameFile<cr>',           desc = 'Rename File' },
--   { '<leader>tsr', '<cmd>TSToolsFileReferences<cr>',       desc = 'File References' },
-- }

-- todo-comments.nvim - https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#-usage

-- wk.add {
--   { '<leader>td',  group = 'todo' },
--   { '<leader>tda', '<cmd>TodoAdd<cr>',       desc = 'Add Todo Comment' },
--   { '<leader>tdf', '<cmd>TodoQuickFix<cr>',  desc = 'Goto Next Todo Comment' },
--   { '<leader>tdl', '<cmd>TodoLocList<cr>',   desc = 'List Todo Comments' },
--   { '<leader>tdt', '<cmd>TodoTelescope<cr>', desc = 'Search Todo Comments' },
-- }

--
-- Telescope luasnip
--
-- vim.keymap.set('n', '<leader>ps', function()
--   vim.cmd [[ Telescope luasnip ]]
-- end, { noremap = true, silent = true })

--
-- conform
--
-- nmap('<leader>f', function()
--   vim.lsp.buf.format { async = true }
-- end, 'LSP formatting')

--
-- File Explorer
--
keymap.set('n', '<C-x>', ':NvimTreeFocus<CR>')
keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>')

-- Resize window using <ctrl> arrow keys
keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

keymap.set('n', '<C-k>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
keymap.set('n', '<C-j>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
keymap.set('n', '<C-h>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
keymap.set('n', '<C-l>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Switch windows
keymap.set('n', '<C-S-Up>', ':wincmd k<CR>', { desc = 'Move to window above' })
keymap.set('n', '<C-S-Right>', ':wincmd l<CR>', { desc = 'Move to window right' })
keymap.set('n', '<C-S-Down>', ':wincmd j<CR>', { desc = 'Move to window below' })
keymap.set('n', '<C-S-Left>', ':wincmd h<CR>', { desc = 'Move to window left' })

keymap.set('n', '<C-S-k>', ':wincmd k<CR>', { desc = 'Move to window above' })
keymap.set('n', '<C-S-l>', ':wincmd l<CR>', { desc = 'Move to window right' })
keymap.set('n', '<C-S-j>', ':wincmd j<CR>', { desc = 'Move to window below' })
keymap.set('n', '<C-S-h>', ':wincmd h<CR>', { desc = 'Move to window left' })

-- Tabs
keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Open a new tab' })
keymap.set('n', '<leader>t<Right>', ':tabn<CR>', { desc = 'Move to the next tab' })
keymap.set('n', '<leader>t<Left>', ':tabp<CR>', { desc = 'Move to the previous tab' })
keymap.set('n', '<leader>tl', ':tabn<CR>', { desc = 'Move to the next tab' })
keymap.set('n', '<leader>th', ':tabp<CR>', { desc = 'Move to the previous tab' })
keymap.set('n', '<leader>tw', ':tabc<CR>', { desc = 'Close current tab' })

-- Split windows
keymap.set('n', '<C-s>', ':sp<CR>', { desc = 'Split window horizontally' })
keymap.set('n', '<C-S-s>', ':vs<CR>', { desc = 'Split window vertically' })
-- keymap.set("n", "<C-h>", ":sp<CR>", { desc = "Split window horizontally" })
-- keymap.set("n", "<C-v>", ":vs<CR>", { desc = "Split window vertically" })

------- Files ------------------------------------------------

-- new file
-- keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- keymap("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
--
-- vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope file_browser<CR>', { noremap = true })

------Database------------------------------------------------
--- nvim-dbee
---
-- local dbee = require('dbee')
-- keymap.set("n", "<leader>db", dbee.toggle, { desc = "Toggle DBEE" })
