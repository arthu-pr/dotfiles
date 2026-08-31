-- lua/plugins/lsp.lua
local servers = {
  'ansiblels',
  'bashls',
  'copilot', -- binary only; enable excluded below (copilot.vim provides ghost text)
  'css_variables',
  'cssls',
  'eslint',
  'gh_actions_ls',
  'html',
  'jsonls',
  'lua_ls',
  'marksman',
  'tailwindcss',
  'ts_ls',
  'ts_query_ls',
  -- vtsls is the TypeScript server (same tsserver as VS Code);
  -- ts_ls stays installed but disabled below to avoid two TS servers per buffer
  'vtsls',
  'vue_ls',
  'yamlls',
}

return {
  'neovim/nvim-lspconfig',

  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {},
    },

    {
      'mason-org/mason-lspconfig.nvim',
      opts = {
        ensure_installed = servers,
        automatic_enable = {
          -- ts_ls: vtsls is the TS server
          -- copilot: ghost text comes from github/copilot.vim; the LSP
          -- client would be a duplicate doing nothing visible
          exclude = { 'ts_ls', 'copilot' },
        },
      },
    },

    {
      'j-hui/fidget.nvim',
      opts = {},
    },

    'hrsh7th/cmp-nvim-lsp',
  },

  config = function()
    ---------------------------------------------------------------------------
    -- Capabilities
    ---------------------------------------------------------------------------

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- File watching is off by default on Linux; we have inotify-tools
    -- installed so the efficient inotifywait backend is used
    capabilities = vim.tbl_deep_extend('force', capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    })

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- Register per-server configs from lua/lsp/*.lua explicitly.
    -- Explicit vim.lsp.config() calls take priority over lsp/ runtime files,
    -- where nvim-lspconfig's defaults would win over ours for conflicting
    -- keys like `filetypes` (e.g. vtsls needs 'vue' added).
    for file in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/lsp') do
      local name = file:match('^(.+)%.lua$')
      if name then
        vim.lsp.config(name, require('lsp.' .. name))
      end
    end

    -- nvim-lspconfig's default list copies VSCode language ids
    -- (django-html, ejs, jade, ...) that are not Neovim filetypes;
    -- keep only the ones filetype detection can actually produce
    vim.lsp.config('tailwindcss', {
      filetypes = {
        -- templating
        'astro',
        'blade',
        'clojure',
        'htmldjango',
        'eelixir',
        'elixir',
        'eruby',
        'haml',
        'handlebars',
        'heex',
        'html',
        'htmlangular',
        'liquid',
        'markdown',
        'markdown.mdx',
        'mustache',
        'php',
        'razor',
        'twig',
        -- css
        'css',
        'less',
        'sass',
        'scss',
        'stylus',
        -- js
        'javascript',
        'javascriptreact',
        'rescript',
        'typescript',
        'typescriptreact',
        'vue',
        'svelte',
        'templ',
      },
    })

    ---------------------------------------------------------------------------
    -- Diagnostics
    ---------------------------------------------------------------------------

    vim.diagnostic.config {
      virtual_text = true,
      update_in_insert = true,
      underline = true,
      severity_sort = true,

      float = {
        focusable = true,
        style = 'minimal',
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
      },

      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.ERROR] = ' ',
        },
      },
    }

    ---------------------------------------------------------------------------
    -- LSP keymaps
    ---------------------------------------------------------------------------

    local group = vim.api.nvim_create_augroup('UserLspConfig', {
      clear = true,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,

      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
          return
        end

        local bufnr = args.buf

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = 'LSP: ' .. desc,
          })
        end

        -- Navigation
        map('n', 'K', vim.lsp.buf.hover, 'Hover')
        map('n', 'gd', vim.lsp.buf.definition, 'Definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Implementation')
        map('n', 'gr', vim.lsp.buf.references, 'References')

        -- Actions
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')

        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')

        -- Diagnostics
        map('n', ']d', function()
          vim.diagnostic.jump {
            count = 1,
            float = true,
          }
        end, 'Next diagnostic')

        map('n', '[d', function()
          vim.diagnostic.jump {
            count = -1,
            float = true,
          }
        end, 'Previous diagnostic')

        map('n', '<leader>e', vim.diagnostic.open_float, 'Diagnostic float')

        map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostic list')

        -- Signature help
        map('i', '<M-k>', vim.lsp.buf.signature_help, 'Signature help')

        -- Inlay hints
        if client:supports_method 'textDocument/inlayHint' then
          map('n', '<leader>lh', function()
            local enabled = vim.lsp.inlay_hint.is_enabled {
              bufnr = bufnr,
            }

            vim.lsp.inlay_hint.enable(not enabled, {
              bufnr = bufnr,
            })
          end, 'Toggle inlay hints')
        end
      end,
    })
  end,
}
