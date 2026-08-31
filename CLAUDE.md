# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal cross-machine dotfiles repo (macOS/Linux), cloned to `~/config`. Covers zsh (Prezto-based),
vim (minpac), neovim (lazy.nvim), terminal emulators (alacritty, kitty, wezterm, zellij), KDE,
VSCode, lazydocker, and a personal ansible-droplet workflow. No application code — there is no
build, test, or lint tooling, and no CI.

## Symlink / install mechanism

- `config/` holds everything that gets symlinked to the live system, split by destination — the folder a
  file lives in decides where it's linked, so there's no exclude/include list to maintain:
    - `config/config/<name>` → `~/.config/<name>`, e.g. `config/config/nvim` → `~/.config/nvim`
    - `config/home/<name>` → `~/<name>`, e.g. `config/home/.zshrc` → `~/.zshrc`
    - `config/home-macos/<name>` → `~/<name>`, macOS only
- `set_symbolic_links.sh` walks those three folders and symlinks each entry to its destination. It is
  interactive and prompts before overwriting existing files/dirs.
- `terminal/` is deliberately **not** in `config/` — it holds shell-agnostic aliases/exports/functions
  and is sourced directly by path from `.bashrc`/`.zshrc` via `~/config/terminal/init.sh`.
- `ansible/` holds personal ansible-droplet workflow files (inventory + env exports/aliases/functions),
  also not in `config/` — sourced directly by `terminal/init.sh` (same pattern as `terminal/`), kept
  separate from `terminal/*.sh` because it's specific to this user's ansible workflow, not general
  shell config.
- `.claude/` and `.vscode/` stay repo-local and are never deployed to `~/.config`.

**Once symlinks are set up on a machine, editing files in this repo takes effect immediately on the live
system** — `.zshrc`, `.bashrc`, `.vimrc`, `.zpreztorc`, and folders like `nvim/`, `alacritty/`, `kitty/`,
`zellij/`, `.vim/` (all now under `config/`) are symlinks pointing back into the repo, not copies.
Re-running `set_symbolic_links.sh` is only needed for a *new* entry added under `config/` that isn't
linked yet, or to relocate config dirs.

**Adding a new tool's config:** drop it in `config/config/<name>` or `config/home/<name>` — no script
changes needed. Use the `/new-config` skill for this.

**Never run `set_symbolic_links.sh` without asking first.** This repo is used across multiple
machines/OSes — it overwrites live symlinks on whichever machine it's run on, so confirm before
running it or assuming a given machine's setup state.

## Neovim

Plugin manager is lazy.nvim (`config/config/nvim/lazy-lock.json`). Config is split under
`config/config/nvim/lua/config`, `config/config/nvim/lua/plugins/{lsp,ui,git,editor,database,themes,disabled,config}`,
and `config/config/nvim/lua/lsp/*` for per-server configs. `config/config/nvim_kickstart/` is legacy/unused.

## Vim

Plugin manager is minpac (`config/config/.vim/pack/minpac`), driven from `config/home/.vimrc`.

## Commit style

Freeform, short, imperative/noun-phrase summaries (e.g. "KDE config", "Add lazydocker config"). No
conventional-commits prefixes. PR-number suffixes like `(#7)` appear when merged via PR — not required.
