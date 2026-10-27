# utils

Plain shell utilities. **Never symlinked**: `set_symbolic_links.sh` only links `link/`. The rc
files source these directly by path from `$DOTFILES_DIR/utils` (`DOTFILES_DIR` is the repo root, which
the rc files work out from their own symlinks).

- `terminal/`: shell-agnostic exports, aliases, git aliases, functions and ssh helpers. Sourced by both `.bashrc` and `.zpreztorc`. `terminal/debian/` is only loaded
  on Debian.
- `ansible/`: personal ansible-droplet helpers (inventory, env vars, aliases, functions).
