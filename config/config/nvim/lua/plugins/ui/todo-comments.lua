return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    -- pre-load Which-Key grouping (instant and cheap)
    local wk = require("which-key")

    wk.add({
      { "<leader>td",  group = "Todo" },
      { "<leader>tda", group = "Comments" },
    })
  end,

  -- declarative keymaps → plugin only loads on first press
  keys = {
    { "<leader>tda", "<cmd>TodoAdd<cr>",     desc = "Add Todo Comment" },
    { "<leader>tdf", "<cmd>TodoNext<cr>",    desc = "Next Todo Comment" },
    { "<leader>tdl", "<cmd>TodoLocList<cr>", desc = "List Todo Comments" },
    -- { "<leader>tdt", "<cmd>TodoTelescope<cr>", desc = "Search Todo Comments" },
  },
  opts = {
    signs = true,      -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
      ["TODO-V2"] = {
        icon = " ",
        color = "blue",
        alt = { "TODO-V2" },
      },
      ["TODO-DESIGN"] = {
        icon = " ",
        color = "#6F53DB",
        alt = { "TODO-DESIGN" },
      },
    },
    -- TODO-DESIGN:
    -- qsdqsdqsd
    gui_style = {
      fg = "NONE",         -- The gui style to use for the fg highlight group.
      bg = "BOLD",         -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      multiline = true,                -- enable multine todo comments
      multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
      before = "wide_bg",              -- "fg" or "bg" or empty
      keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = "fg",                    -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true,            -- uses treesitter to match keywords in comments only
      max_line_len = 400,              -- ignore lines longer than this
      exclude = {},                    -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
      blue = { "#0000FF" },
      ["#6F53DB"] = { "#6F53DB" },
      ["#00DC82"] = { "#00DC82" },
      ["#646cff"] = { "#646cff" },
      ["#fe5000"] = { "#fe5000" },
      ["#e3c567"] = { "#e3c567" },
      ["#ffffff"] = { "#ffffff" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },

  },
}
