-- ~/.config/nvim/lua/keymap_utils.lua
local M = {}

M.nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

return M
