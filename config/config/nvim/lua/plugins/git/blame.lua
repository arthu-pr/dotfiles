return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
    opts = {
      blame_options = { '-w' },
    },
    keys = {
      { '<leader>gb', ":BlameToggle<CR>", desc = '[G]it [B]lame', }
    }
  },
}
