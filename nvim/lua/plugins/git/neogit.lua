return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required

    -- Only one of these is needed.
    "folke/snacks.nvim", -- optional, for picker integration
  },

  cmd = "Neogit",

  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open Neogit" },
  },

  config = function()
    require("neogit").setup({
      disable_commit_confirmation = true,
      integrations = { diffview = true },
    })
  end,
}
