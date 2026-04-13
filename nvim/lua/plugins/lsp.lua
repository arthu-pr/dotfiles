-- lua/plugins/lsp.lua

local lsp = {
  "ansiblels",
  "bashls",
  "copilot",
  "css_variables",
  "cssls",
  -- "emmet_ls",
  "eslint",
  "gh_actions_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "stylelint_lsp",
  "stylua",
  "tailwindcss",
  "ts_query_ls",
  "vtsls",
  "vue_ls",
  "yamlls"
}
return {
  -- LSP core
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason v2
    { 'mason-org/mason.nvim', opts = {} },
    {
      'mason-org/mason-lspconfig.nvim',
      opts = {
        ensure_installed =
            lsp
        ,
        -- Neovim 0.11+ feature: uses vim.lsp.enable() under the hood
        automatic_enable = {
          -- ts_ls excluded in favor of vtsls for Vue support
          exclude = { 'ts_ls' },
        },
      },
    },

    { 'j-hui/fidget.nvim',    opts = {} },
    'folke/neodev.nvim',

    -- capabilities for nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },

  config = function()
    -- optional: better Lua LSP for Neovim runtime
    require('neodev').setup {}

    -- nvim-cmp capabilities
    local capabilities = require('cmp_nvim_lsp').default_capabilities()


    -- Per-server tweaks (these MERGE with mason-lspconfig defaults)

    -- Tailwind
    -- vim.lsp.config("tailwindcss", {
    --   capabilities = capabilities,
    --   filetypes = {
    --     "javascript",
    --     "javascriptreact",
    --     "typescript",
    --     "typescriptreact",
    --     "vue",
    --     "css",
    --     "scss",
    --   },
    --   settings = {
    --     tailwindCSS = {
    --       classFunctions = { "cva", "cx" },
    --       experimental = {
    --         classRegex = {
    --           "cva%(([^)]*)%)",
    --           "[\"'`]([^\"'`]*)[\"'`]", -- keep if you want broad capture
    --         },
    --       },
    --     },
    --   },
    -- })

    -- vtsls: TS/JS server (vue_ls starts automatically; its on_init bridges tsserver/request to vtsls)

    -- SEE https://github.com/vuejs/language-tools/wiki/Neovim#configuration
    local vue_language_server_path =
        vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    vim.lsp.config("vtsls", {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    })
    -- vim.lsp.enable({ 'vtsls', 'vue_ls' }) -- If using `ts_ls` replace `vtsls` to `ts_ls`

    -- -- Vue / Volar v3 (vue_ls)
    -- vim.lsp.config("vue_ls", {
    --   capabilities = capabilities,
    --   -- on_attach can be added if you need per-server behaviour
    -- })

    -- -- Emmet (HTML-like)
    -- vim.lsp.config('emmet_ls', {
    --   capabilities = capabilities,
    -- })

    -- -- Global LSP defaults that apply to *all* servers
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    for _, server in ipairs(lsp) do
      vim.lsp.enable(server)
    end

    ---------------------------------------------------------------------------
    -- Diagnostics config
    ---------------------------------------------------------------------------
    -- vim.diagnostic.config {
    --   virtual_text = true,
    --   update_in_insert = true,
    --   underline = true,
    --   severity_sort = true,
    --   float = {
    --     focusable = true,
    --     style = 'minimal',
    --     border = 'rounded',
    --     source = true,
    --     header = '',
    --     prefix = '',
    --   },
    --   signs = {
    --     text = {
    --       [vim.diagnostic.severity.HINT] = ' ',
    --       [vim.diagnostic.severity.INFO] = ' ',
    --       [vim.diagnostic.severity.WARN] = ' ',
    --       [vim.diagnostic.severity.ERROR] = ' ',
    --     },
    --   },
    -- }

    ---------------------------------------------------------------------------
    -- LspAttach: keymaps + format-on-save + auto-import
    ---------------------------------------------------------------------------
    -- vim.api.nvim_create_autocmd('LspAttach', {
    --   desc = 'LSP actions',
    --   callback = function(args)
    --     local client = vim.lsp.get_client_by_id(args.data.client_id)
    --     if not client then
    --       return
    --     end

    --     -- Format + autoimports on save
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --       buffer = args.buf,
    --       callback = function()
    --         -- NOTE: Disabled LSP formatting in favor of conform.nvim
    --         -- if client:supports_method("textDocument/formatting") then
    --         --   vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --         -- end

    --         if client:supports_method 'textDocument/codeAction' then
    --           local function apply_code_action(action_type)
    --             local ctx = { only = action_type, diagnostics = {} }
    --             local actions = vim.lsp.buf.code_action {
    --               context = ctx,
    --               apply = true,
    --               return_actions = true,
    --             }

    --             if actions and #actions > 0 then
    --               vim.lsp.buf.code_action { context = ctx, apply = true }
    --             end
    --           end

    --           apply_code_action { 'source.fixAll' }
    --           apply_code_action { 'source.organizeImports' }
    --         end
    --       end,
    --     })

    --     -- Keymaps
    --     local nmap = function(keys, func, desc)
    --       if desc then
    --         desc = 'LSP: ' .. desc
    --       end
    --       vim.keymap.set('n', keys, func, {
    --         buffer = args.buf,
    --         noremap = true,
    --         silent = true,
    --         desc = desc,
    --       })
    --     end

    --     nmap('K', vim.lsp.buf.hover, 'Hover')
    --     nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
    --     nmap('<leader>dr', vim.lsp.buf.references, 'References')
    --     nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    --     nmap('<leader>df', vim.lsp.buf.definition, 'Goto definition')
    --     nmap('<leader>ds', '<cmd>vs | lua vim.lsp.buf.definition()<cr>', 'Goto definition (vsplit)')
    --     nmap('<leader>dh', '<cmd>sp | lua vim.lsp.buf.definition()<cr>', 'Goto definition (hsplit)')
    --     -- vtsls: jumps to actual .vue/.ts source instead of .d.ts declaration
    --     if client.name == 'vtsls' then
    --       nmap('<leader>dF', function()
    --         client:exec_cmd({
    --           title = 'goToSourceDefinition',
    --           command = 'typescript.goToSourceDefinition',
    --           arguments = { vim.uri_from_bufnr(args.buf), vim.lsp.util.make_position_params(0, client.offset_encoding).position },
    --         }, { bufnr = args.buf })
    --       end, 'Goto source definition')
    --     end
    --     nmap('<space>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
    --     nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
    --     nmap('<space>wl', function()
    --       vim.print(vim.lsp.buf.list_workspace_folders())
    --     end, 'List workspace folders')

    --     -- Diagnostics
    --     nmap('dn', function()
    --       vim.diagnostic.jump { count = 1, float = true }
    --     end, 'Next diagnostic')
    --     nmap('dN', function()
    --       vim.diagnostic.jump { count = -1, float = true }
    --     end, 'Prev diagnostic')
    --     nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
    --     nmap('<leader>e', vim.diagnostic.open_float, 'Open diagnostic float')

    --     vim.keymap.set('i', '<M-t>', vim.lsp.buf.signature_help, { buffer = args.buf })

    --     -- Inlay hints toggle
    --     nmap('<leader>lh', function()
    --       local enabled = vim.lsp.inlay_hint.is_enabled()
    --       vim.lsp.inlay_hint.enable(not enabled)
    --     end, 'Toggle inlay hints')

    --     vim.api.nvim_buf_create_user_command(args.buf, 'Fmt', function(_)
    --       vim.lsp.buf.format()
    --     end, { desc = 'Format current buffer with LSP' })
    --   end,
    -- })
  end,
}
