-- lua/plugins/cmp.lua
return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet engine
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Snippet collection (VS Code-style)
    'rafamadriz/friendly-snippets',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
  },

  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    -- Load VS Code-style snippets (friendly-snippets + custom)
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load {
      paths = { vim.fn.stdpath 'config' .. '/lua/config/snippets/vscode' },
    }

    -- Custom Lua snippets
    require('luasnip.loaders.from_lua').lazy_load {
      paths = { vim.fn.stdpath 'config' .. '/lua/config/snippets' },
    }

    -- Completion for props and emits
    -- https://github.com/vuejs/language-tools/discussions/4495
    local cmpIntegrationVue = {
      name = 'nvim_lsp',
      ---@param entry cmp.Entry
      ---@param ctx cmp.Context
      entry_filter = function(entry, ctx)
        -- Check if the buffer type is 'vue'
        if ctx.filetype ~= 'vue' then
          return true
        end

        local cursor_before_line = ctx.cursor_before_line
        -- For events
        if cursor_before_line:sub(-1) == '@' then
          return entry.completion_item.label:match '^@'
          -- For props also exclude events with `:on-` prefix
        elseif cursor_before_line:sub(-1) == ':' then
          return entry.completion_item.label:match '^:' and not entry.completion_item.label:match '^:on%-'
        else
          return true
        end
      end,
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          -- This makes LSP snippet items actually expand
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        -- <Tab> left free for Copilot
      },
      formatting = {
        format = function(_, item)
          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
            end
          end

          return item
        end,
      },
      sources = {
        cmpIntegrationVue, -- nvim_lsp with vue props/emits filtering
        { name = 'luasnip' }, -- <- this is how friendly-snippets show up
        -- add more (buffer, path, etc.) if you want
      },
    }

    -- SQL-specific completion (vim-dadbod)
    cmp.setup.filetype('sql', {
      sources = {
        { name = 'vim-dadbod-completion' },
      },
    })

    -- Clear the vue cache when menu is closed
    -- https://github.com/vuejs/language-tools/discussions/4495
    cmp.event:on('menu_closed', function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
    end)
  end,
}
