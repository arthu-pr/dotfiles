-- lua/plugins/cmp.lua
local M = {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet engine
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Snippet collection (VS Code-style)
    'rafamadriz/friendly-snippets',

    -- You don't strictly need cmp-nvim-lsp here, we'll use it in lsp.lua
    -- but you could also list it here if you prefer.
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
  },
}

function M.opts()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'

  -- TODO: Not loaded
  -- Load VS Code-style snippets (including friendly-snippets)
  require('luasnip.loaders.from_vscode').lazy_load {
    paths = '~/config/nvim/lua/config/snippets/vscode',
  }

  -- Your custom Lua snippets
  require('luasnip.loaders.from_lua').lazy_load {
    paths = '~/config/nvim/lua/config/snippets',
  }

  cmp.setup {
    snippet = {
      expand = function(args)
        -- This makes LSP snippet items actually expand
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      -- You can still leave <Tab> free for Copilot
    },
    formatting = {
      format = function(entry, item)
        local icons = LazyVim.config.icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end

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
      {
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
        end, -- <--- HERE},
        { name = 'luasnip' }, -- <- this is how friendly-snippets show up
        -- add more (buffer, path, etc.) if you want
      },
    },
  }
end

return M
