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
    - Ask for the location of the target directory for the symbolic links (default: current directory where you cloned the repo)
    - Create symbolic links for everything in `config/config/` to the configuration directory
        - Example: `~/.config/nvim` &rarr; `~/config/config/config/nvim`
    - Create symbolic links for everything in `config/home/` to the home directory
        - Example: `~/.vimrc` &rarr; `~/config/config/home/.vimrc`, `~/.zshrc` &rarr; `~/config/config/home/.zshrc`
    - On macOS, also create symbolic links for everything in `config/home-macos/` to the home directory

    To make zsh your default shell, run `chsh -s $(which zsh)`.

## Layout

- `config/` holds everything that gets symlinked out to the live system. Where a file lives decides where
  it's linked to, so adding a new tool's config is just a matter of dropping it in the right folder:
    - `config/config/<name>` &rarr; `~/.config/<name>`
    - `config/home/<name>` &rarr; `~/<name>`
    - `config/home-macos/<name>` &rarr; `~/<name>` (macOS only)
- `terminal/` is the shared, shell-agnostic base (exports, aliases, git aliases, functions) sourced by both `.bashrc` and `.zshrc` via `terminal/init.sh`. It is deliberately **not** symlinked into `~/.config` — the rc files source it directly from `~/config/terminal`.
- `.zshrc` is the zsh entry point: it loads Prezto, adds zsh-only extras, then sources `terminal/init.sh`.
- `.zpreztorc` contains only Prezto options (modules, key bindings, prompt theme).
- Machine-local overrides go in `~/.zshrc.local` / `~/.bashrc.local` (sourced last, never committed).

## How to sync

After running the script once per machine, update the configuration in the repo directory, commit the changes to your repository, and then:

```bash
git pull
```

This will keep your configurations in sync across different machines.
