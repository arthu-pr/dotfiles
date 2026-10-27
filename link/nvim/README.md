# Neovim configuration

## Plugins

### Themes

- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) — Tokyo Night colorscheme.
- [bearded-nvim](https://github.com/Ferouk/bearded-nvim) — Neovim fork of the Bearded Themes collection.
- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) — Japanese-inspired colorscheme with rich contrasts.
- [everforest](https://github.com/sainnhe/everforest) — Soft, warm, pastel woodland colorscheme.
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) — Highly customizable theme family (nightfox, dayfox, nordfox, …).
- [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim) — Warmer, darker take on Nord.
- [synthweave.nvim](https://github.com/samharju/synthweave.nvim) — Neon synthwave retro-futuristic theme.

### UI & Navigation

- [snacks.nvim](https://github.com/folke/snacks.nvim) — Dashboard, fuzzy picker (replaces Telescope + fzf-lua), file explorer, notifications, and more.
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) — Stylish buffer/tab line with icons and diagnostics.
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — Fast and lightweight statusline written in Lua.
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) — Classic file explorer tree. (`<C-b>` to toggle)
- [which-key.nvim](https://github.com/folke/which-key.nvim) — Popup showing keybindings and available commands.
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) — Indentation guides with scope highlighting.
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) — Render Markdown with icons, checkboxes, etc.
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) — Highlight & search TODO/FIX/HACK/NOTE comments.

### LSP & Development

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) — LSP server management and configuration.
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) — Completion engine with snippet support (VSCode + Lua snippets).
- [conform.nvim](https://github.com/stevearc/conform.nvim) — Formatting, including format on save (prettierd etc.).
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — Better syntax highlighting and code structure parsing.
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) — Auto-close & auto-rename HTML/TSX/Vue tags using Treesitter.
- [neogen](https://github.com/danymat/neogen) — Generate annotations/docstrings for functions and classes.
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) — LSP progress notifications.
- [nvim-html-css](https://github.com/Jezda1337/nvim-html-css) — CSS class/id intellisense in HTML, Vue, Astro, and more (currently disabled — `enabled = false`).

### Coding & Editing

- [Comment.nvim](https://github.com/numToStr/Comment.nvim) — Smart commenting motions for lines and blocks.
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) — Find and replace across the project.
- [suave.lua](https://github.com/nyngwang/suave.lua) — Session management with colorscheme persistence.
- [live-server.nvim](https://github.com/barrett-ruth/live-server.nvim) — Launch a local dev server with live reload.

### Git Integration

- [neogit](https://github.com/NeogitOrg/neogit) — Magit-like interface for Git inside Neovim.
- [blame.nvim](https://github.com/FabijanZulj/blame.nvim) — Git blame annotations for lines and files.
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) — Git diff viewer with file history support.

### AI

- [copilot.vim](https://github.com/github/copilot.vim) — GitHub Copilot integration.
- [avante.nvim](https://github.com/yetone/avante.nvim) — Claude-powered AI coding assistant (currently disabled — see `disabled/avante.lua`).

### Database

- [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) — UI for database management using vim-dadbod.

---

## Cleanup suggestions

Several plugins have accumulated in `lua/plugins/disabled/` or are disabled inline. These are candidates for deletion:

| Plugin | File | Reason to delete |
|--------|------|------------------|
| telescope.nvim | `disabled/telescope.lua` | Replaced by `snacks.nvim` picker |
| fzf-lua | `disabled/fzf.lua` | Replaced by `snacks.nvim` picker |
| alpha-nvim | `disabled/alpha-nvim.lua` | Replaced by `snacks.nvim` dashboard |
| commander.nvim | `disabled/commander.lua` | Depended on Telescope (now gone) |
| simple-note.nvim | `disabled/simple-note.lua` | Depended on Telescope (now gone) |
| conform.nvim | `disabled/conform.lua.OLD` | Old copy, superseded by the active `conform.lua` |
| typescript-tools.nvim | `editor/typescript-tools.lua` | Broken since Neovim ≥ 0.11.2 (`enabled = false`); replaced by `vtsls` |

Also note: **nvim-tree** and **snacks.explorer** are both active. `<leader>e` opens `Snacks.explorer()` while `<C-b>` toggles nvim-tree. Consider picking one.

---

## Snippets

### VSCode

[`lua/config/snippets/vscode`](./lua/config/snippets/vscode) is the source of truth for snippets, shared with VSCode via a symbolic link.

#### macOS

> [!NOTE]
> Uses the default VSCode profile: `~/Library/Application\ Support/Code/User/snippets`

Navigate to the VSCode user directory:

```sh
cd ~/Library/Application\ Support/Code/User/
```

Back up existing snippets:

```sh
cp -r snippets ~/.config/nvim/lua/config/snippets/vscode-backup
```

Remove the existing snippets directory:

```sh
rm -rf snippets
```

Create the symbolic link:

```sh
ln -s ~/.config/nvim/lua/config/snippets/vscode snippets
```

## Checklist

See [checklist.md](./checklist.md)
