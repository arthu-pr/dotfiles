# dotfiles

## How to use

1.  Clone or fork the repository. I like to keep it in ~/config:

    ```bash
    git clone git@github.com:arthu-pr/dotfiles.git config
    ```

2.  (Optionnal) Clone [Prezto](https://github.com/sorin-ionescu/prezto) into `~/.zprezto` if you don't have it yet and want to use it:

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
  - dot-prefixed entries go to the home directory, e.g. `~/.zshrc` &rarr; `~/config/link/.zshrc`
  - everything else goes to the configuration directory, e.g. `~/.config/nvim` &rarr; `~/config/link/nvim`
- Ask whether to also link `.config/macos/` (same rule; defaults to yes on macOS, no elsewhere)

To make zsh your default shell, run `chsh -s $(which zsh)`.

## Structure

- `link/` holds everything that gets symlinked to the live system configuration.
  - Specific OS-related configurations are asked or automatically symlinked by the script (`macos` or `debian`)
- `utils/` is never symlinked: utilities are sourced by path (see [`utils/README.md`](utils/README.md)).
  - `utils/terminal/` is the shared, shell-agnostic base (exports, aliases, git aliases, functions), sourced by both `.bashrc` and `.zshrc`
  - `utils/ansible/` holds personal ansible helpers (TODO: To keep versioned?)
- `.zshrc` is the zsh entry point: it loads Prezto, adds zsh-only extras, then sources `utils/terminal/init.sh`.
- `.zpreztorc` contains only Prezto options (modules, key bindings, prompt theme).


## Machine-local overrides

Machine-local overrides allow you to customize your configuration for a specific machine without affecting the shared repository. This is useful for settings that differ between environments, such as paths, host-specific aliases, or machine-specific tools.

### Create machine specific configuration files

Two files are sourced by default (if they exist): `~/.zshrc.local` for zsh and `~/.bashrc.local` for bash.
These files are sourced at the end of the respective shell configuration files, allowing machine or user specific configuration. They are not versioned.

## How to sync

After running the script once per machine, update the configuration in the repo directory, commit the changes to your repository, and then:

```bash
git pull
```

This will keep your configurations in sync across different machines.
