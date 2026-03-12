-- lua/plugins/lsp.lua
return {
  -- LSP core
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Mason v2
    { "mason-org/mason.nvim", opts = {} },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
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
          'stylua',
          "tailwindcss",
          "ts_ls",
          "ts_query_ls",
          "vtsls",
          "vue_ls",
          "yamlls",
        },
        -- Neovim 0.11+ feature: uses vim.lsp.enable() under the hood
        automatic_enable = {
          -- vue_ls will be enabled manually later
          exclude = { "vue_ls" },
        },
      },
    },

    { "j-hui/fidget.nvim",    opts = {} },
    "folke/neodev.nvim",

    -- capabilities for nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
  },

  config = function()
    -- optional: better Lua LSP for Neovim runtime
    require("neodev").setup({})

    -- nvim-cmp capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

    -- vtsls: TS/JS server
    vim.lsp.config("vtsls", {
      capabilities = capabilities,
      -- tweak filetypes/settings if you want, but defaults are fine to start
      on_attach = function(client, bufnr)
        -- Start vue_ls once vtsls is up, to satisfy Volar's dependency
        if not vim.g._vue_ls_started then
          vim.g._vue_ls_started = true

          -- vue_ls has its own config in nvim-lspconfig (and any local lsp/vue_ls.lua you add)
          vim.schedule(function()
            vim.lsp.enable("vue_ls")
          end)
        end
      end,
    })


    -- -- Vue / Volar v3 (vue_ls)
    -- vim.lsp.config("vue_ls", {
    --   capabilities = capabilities,
    --   -- on_attach can be added if you need per-server behaviour
    -- })

    -- -- Emmet (HTML-like)
    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
    })

    -- -- Global LSP defaults that apply to *all* servers
    -- vim.lsp.config("*", {
    --   capabilities = capabilities,
    -- })

    ---------------------------------------------------------------------------
    -- Diagnostics config
    ---------------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true,
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.ERROR] = " ",
        },
      },
    })

    ---------------------------------------------------------------------------
    -- LspAttach: keymaps + format-on-save + auto-import
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        -- Format + autoimports on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = args.buf,
          callback = function()
            -- NOTE: Disabled LSP formatting in favor of conform.nvim
            -- if client:supports_method("textDocument/formatting") then
            --   vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            -- end

            if client:supports_method("textDocument/codeAction") then
              local function apply_code_action(action_type)
                local ctx = { only = action_type, diagnostics = {} }
                local actions = vim.lsp.buf.code_action({
                  context = ctx,
                  apply = true,
                  return_actions = true,
                })

                if actions and #actions > 0 then
                  vim.lsp.buf.code_action({ context = ctx, apply = true })
                end
              end

              apply_code_action({ "source.fixAll" })
              apply_code_action({ "source.organizeImports" })
            end
          end,
        })

        -- Keymaps
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, {
            buffer = args.buf,
            noremap = true,
            silent = true,
            desc = desc,
          })
        end

        nmap("K", vim.lsp.buf.hover, "Hover")
        nmap("<leader>r", vim.lsp.buf.rename, "Rename")
        nmap("<leader>dr", vim.lsp.buf.references, "References")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("<leader>df", vim.lsp.buf.definition, "Goto definition")
        nmap("<leader>ds", "<cmd>vs | lua vim.lsp.buf.definition()<cr>", "Goto definition (vsplit)")
        nmap("<leader>dh", "<cmd>sp | lua vim.lsp.buf.definition()<cr>", "Goto definition (hsplit)")
        nmap("<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        nmap("<space>wl", function()
          vim.print(vim.lsp.buf.list_workspace_folders())
        end, "List workspace folders")

        -- Diagnostics
        nmap("dn", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")
        nmap("dN", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Prev diagnostic")
        nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")
        nmap("<leader>e", vim.diagnostic.open_float, "Open diagnostic float")

        vim.keymap.set("i", "<M-t>", vim.lsp.buf.signature_help, { buffer = args.buf })

        -- Inlay hints toggle
        nmap("<leader>lh", function()
          local enabled = vim.lsp.inlay_hint.is_enabled()
          vim.lsp.inlay_hint.enable(not enabled)
        end, "Toggle inlay hints")

        vim.api.nvim_buf_create_user_command(args.buf, "Fmt", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end,
    })
  end,
}
