-- Need to be set before lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'plugins'

require('ibl').setup()
require 'config'
-- vim.opt.number = true

-- TODO: TO VERIFY
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3232#issuecomment-1198882715
-- Issue in droplet that uses wget by default (therefore permission issues)
require('nvim-treesitter.install').prefer_git = true

-- To call after vim.o.termguicolors = true
-- https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file#usage
-- require("bufferline").setup {}
