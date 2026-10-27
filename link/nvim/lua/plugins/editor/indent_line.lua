-- TODO: Improve config

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  -- -@module "ibl"
  -- -@type ibl.config
  opts = {
    indent = {
      char = '·',
      -- tab_char = { 'a', 'b', 'c' },
      highlight = { 'Function', 'Label', 'NonText' },
      -- highlight = { 'Label' },
      smart_indent_cap = true,
      priority = 2,
      repeat_linebreak = false,
    },
    -- scope = { enabled = true, highlight = 'NonText', show_start = true, show_end = true, priority = 1, 'Function', 'Label' },
  },
}
