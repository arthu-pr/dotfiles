# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal cross-machine dotfiles repo (macOS/Linux), cloned to `~/config` (any location works, nothing hardcodes it). Covers zsh (Prezto-based),
vim (minpac), neovim (lazy.nvim), terminal emulators (alacritty, kitty, wezterm, zellij), KDE,
VSCode, lazydocker, and a personal ansible-droplet workflow. No application code — there is no
build, test, or lint tooling, and no CI.

## Symlink / install mechanism

- `link/` is one flat folder holding everything that gets symlinked to the live system. The entry
  name decides the destination, so there's no exclude/include list to maintain:
    - dot-prefixed `link/.<name>` → `~/.<name>`, e.g. `link/.zshrc` → `~/.zshrc`
    - anything else `link/<name>` → `~/.config/<name>`, e.g. `link/nvim` → `~/.config/nvim`
    - `link/macos/` is the exception: never linked as a folder; its entries follow the same rule,
      but `set_symbolic_links.sh` asks first (default yes on macOS, no elsewhere), e.g. `.aerospace.toml`
    - vim's runtime folder is therefore `link/vim` (no dot) → `~/.config/vim`, which `.vimrc` points
      `runtimepath`/`packpath` at
- `set_symbolic_links.sh` walks `link/` and symlinks each entry to its destination. It is
  interactive and prompts before overwriting existing files/dirs.
- `utils/` is never symlinked (see `utils/README.md`):
    - `utils/terminal/` holds shell-agnostic aliases/exports/functions, sourced directly by path from
      `.bashrc`/`.zpreztorc` via `$DOTFILES_DIR/utils/terminal/init.sh`. The rc files set and export
      `DOTFILES_DIR` by resolving their own symlink, so no path to the clone is hardcoded.
    - `utils/ansible/` holds personal ansible-droplet workflow files (inventory + env
      exports/aliases/functions), sourced by `utils/terminal/init.sh`. They're kept separate from
      `terminal/*.sh` because they're specific to this user's ansible workflow, not general shell config.
- `.claude/` and `.vscode/` stay repo-local and are never deployed to `~/.config`.

**Once symlinks are set up on a machine, editing files in this repo takes effect immediately on the live
system** — `.zshrc`, `.bashrc`, `.vimrc`, `.zpreztorc`, and folders like `nvim/`, `alacritty/`, `kitty/`,
`zellij/`, `vim/` (all under `link/`) are symlinks pointing back into the repo, not copies.
Re-running `set_symbolic_links.sh` is only needed for a *new* entry added under `link/` that isn't
linked yet, or to relocate config dirs.

**Adding a new tool's config:** drop it in `link/<name>` (or `link/.<name>` for a home dotfile) —
no script changes needed. Use the `/new-config` skill for this.

**Never run `set_symbolic_links.sh` without asking first.** This repo is used across multiple
machines/OSes — it overwrites live symlinks on whichever machine it's run on, so confirm before
running it or assuming a given machine's setup state.

## Neovim

Plugin manager is lazy.nvim (`link/nvim/lazy-lock.json`). Config is split under
`link/nvim/lua/config`, `link/nvim/lua/plugins/{lsp,ui,git,editor,database,themes,disabled,config}`,
and `link/nvim/lua/lsp/*` for per-server configs.

## Vim

Plugin manager is minpac (`link/vim/pack/minpac`), driven from `link/.vimrc`.

## Commit style

Freeform, short, imperative/noun-phrase summaries (e.g. "KDE config", "Add lazydocker config"). No
conventional-commits prefixes. PR-number suffixes like `(#7)` appear when merged via PR — not required.
