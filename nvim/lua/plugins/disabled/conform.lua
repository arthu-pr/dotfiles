-- TODO:
-- Run the first available formatter followed by more formatters
-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters - 15/07/2024
---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require 'conform'
  for i = 1, select('#', ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  'stevearc/conform.nvim',
  enabled = false,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>f',
      function()
        require('conform').format { async = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      markdown = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      javascript = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      typescript = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      json = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      lua = function(bufnr)
        return { first(bufnr, 'stylua'), 'injected' }
      end,
      css = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      html = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      yaml = function(bufnr)
        return { first(bufnr, 'yamlfmt') }
      end,
      yml = function(bufnr)
        return { first(bufnr, 'yamlfmt') }
      end,
      sh = function(bufnr)
        return { first(bufnr, 'shfmt') }
      end,
      vue = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      svg = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,

      -- ['*'] = { 'prettierd', 'prettier' },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = 'fallback',
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
