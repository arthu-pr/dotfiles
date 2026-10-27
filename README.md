# dotfiles

## How to use

1.  Clone or fork the repository. I like to keep it in ~/config:

    ```
    git clone git@github.com:arthur-plazanet/dotfiles.git config
    ```

2.  Clone [Prezto](https://github.com/sorin-ionescu/prezto) into `~/.zprezto` if you don't have it yet:

    ```bash
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
    ```

3.  Run the `set_symbolic_links.sh` script (only needed the first time, or when a new config is added):

    ```bash
    bash set_symbolic_links.sh
    ```

    This script will:
    - Ask for the location of your config files (default: `~/.config`)
    - Ask for the location of the target directory for the symbolic links (default: `link/` in the current directory where you cloned the repo)
    - Create symbolic links for everything inside `link/` to the real local configuration directory.
      - dot-prefixed entries go to the home directory, e.g. `~/.zshrc` &rarr; `~/config/.config/.zshrc`
      - everything else goes to the configuration directory, e.g. `~/.config/nvim` &rarr; `~/config/.config/nvim`
    - Ask whether to also link `.config/macos/` (same rule; defaults to yes on macOS, no elsewhere)

    To make zsh your default shell, run `chsh -s $(which zsh)`.

## Layout

- `.config/` holds everything that gets symlinked to the live system, all in one flat folder. The name
  decides where it's linked, so adding a new tool's config just means dropping it in:
  - `.config/.<name>` (dot-prefixed) &rarr; `~/.<name>`, e.g. `.zshrc`, `.vimrc`
  - `.config/<name>` &rarr; `~/.config/<name>`, e.g. `nvim`, `kitty`, `vim`
  - `.config/macos/` follows the same rule, but the script asks first, e.g. `.aerospace.toml` &rarr; `~/.aerospace.toml`
- `utils/` is never symlinked: shell utilities sourced by path (see [`utils/README.md`](utils/README.md)).
  - `utils/terminal/` is the shared, shell-agnostic base (exports, aliases, git aliases, functions), sourced by both `.bashrc` and `.zshrc` via `utils/terminal/init.sh`.
  - `utils/ansible/` holds personal ansible-droplet helpers.
- `.zshrc` is the zsh entry point: it loads Prezto, adds zsh-only extras, then sources `utils/terminal/init.sh`.
- `.zpreztorc` contains only Prezto options (modules, key bindings, prompt theme).
- Machine-local overrides go in `~/.zshrc.local` / `~/.bashrc.local` (sourced last, never committed).

## How to sync

After running the script once per machine, update the configuration in the repo directory, commit the changes to your repository, and then:

```bash
git pull
```

This will keep your configurations in sync across different machines.
