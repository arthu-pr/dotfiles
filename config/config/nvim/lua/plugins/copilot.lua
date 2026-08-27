return {
  'github/copilot.vim',
  config = function()
    -- TODO: check
    -- pttps://github.com/LunarVim/LunarVim/issues/1856#issuecomment-954224770
    -- Copilot with cmp
    --
    vim.g.copilot_assume_mapped = true
    -- vim.g.copilot_no_tab_map = true
    -- vim.g.copilot_tab_fallback = ""
  end,
}
