return {
  'stevearc/conform.nvim',

  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },

  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          -- lsp_format = 'fallback',
        }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },

  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },

      javascript = { { 'prettierd', 'prettier' } },
      javascriptreact = { { 'prettierd', 'prettier' } },

      typescript = { { 'prettierd', 'prettier' } },
      typescriptreact = { { 'prettierd', 'prettier' } },

      vue = { { 'prettierd', 'prettier' } },

      html = { { 'prettierd', 'prettier' } },
      css = { { 'prettierd', 'prettier' } },

      json = { { 'prettierd', 'prettier' } },
      jsonc = { { 'prettierd', 'prettier' } },

      markdown = { { 'prettierd', 'prettier' } },

      yaml = { 'yamlfmt' },

      sh = { 'shfmt' },
      bash = { 'shfmt' },

      svg = { { 'prettierd', 'prettier' } },
    },

    default_format_opts = {
      lsp_format = 'fallback',
    },

    format_on_save = {
      -- prettierd spins up a per-project daemon on first use; 500ms was too
      -- tight and let cold starts (e.g. first css save after opening nvim)
      -- time out with no formatting applied and no visible error.
      timeout_ms = 3000,
    },

    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
