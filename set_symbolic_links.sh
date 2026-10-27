#!/bin/bash
#
# This script is to launch the first time you sync with the repo or if you wish to change the location of your config files
# It will:
# - Ask for the location of your config files
# - Ask for the location of the target directory for the symbolic links
# - Create symbolic links for everything in this repo's link folder:
#   - dot-prefixed entries go to the home directory, e.g. ~/.zshrc -> ~/config/link/.zshrc
#   - everything else goes to the configuration directory (default .config),
#     e.g. ~/.config/nvim -> ~/config/link/nvim
# - Ask whether to link link/macos too (same rule), e.g. ~/.aerospace.toml -> ~/config/link/macos/.aerospace.toml
# - utils/ is never linked (sourced by path from the rc files instead)
#

CONFIG_DIR="$HOME/.config"                                          # Configuration directory for directories
TARGET_DIR="$(cd "$(dirname "$0")" && pwd)"                         # Target directory for the symbolic links (this repo)
INCLUDE_DOTFILES="true"                                             # Include hidden files and directories by default

read -p "Enter your configuration directory (default $CONFIG_DIR): " custom_config_dir
read -p "Enter the target directory for symbolic links (default $TARGET_DIR): " custom_target_dir

if [[ -n "$custom_config_dir" ]]; then
  CONFIG_DIR="$custom_config_dir"
fi

if [[ -n "$custom_target_dir" ]]; then
  TARGET_DIR="$custom_target_dir"
fi

CONFIG_SRC_DIR="$TARGET_DIR/link"

mkdir -p "$CONFIG_DIR"
mkdir -p "$TARGET_DIR"

if [[ "$INCLUDE_DOTFILES" == "true" ]]; then
  shopt -s dotglob
fi
shopt -s nullglob

# Function to create symbolic links
create_symlink() {
  local source=$1
  local target=$2

  if [[ ! -e "$source" ]]; then
    echo "Source does not exist: $source"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    echo "A file or directory already exists at $target."
    read -p "Do you want to overwrite it with a symbolic link? (y/N): " reply

    if [[ "$reply" != "y" && "$reply" != "Y" ]]; then
      echo "Skipping $target."
      return
    fi

    rm -rf "$target"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "Linked $target -> $source"
}

# Link every entry of a folder: dot-prefixed -> $HOME, everything else -> $CONFIG_DIR
link_entries() {
  local src_dir=$1

  for entry_path in "$src_dir"/*; do
    local entry="$(basename "$entry_path")"
    [[ "$entry" == ".DS_Store" || "$entry_path" == "$CONFIG_SRC_DIR/macos" ]] && continue

    if [[ "$entry" == .* ]]; then
      create_symlink "$entry_path" "$HOME/$entry"
    else
      create_symlink "$entry_path" "$CONFIG_DIR/$entry"
    fi
  done
}

link_entries "$CONFIG_SRC_DIR"

# link/macos: ask, defaulting to yes on macOS and no elsewhere
if [[ "$(uname)" == "Darwin" ]]; then
  read -p "Link macOS-specific configs (link/macos)? (Y/n): " macos_reply
  [[ "$macos_reply" != "n" && "$macos_reply" != "N" ]] && link_entries "$CONFIG_SRC_DIR/macos"
else
  read -p "This does not appear to be macOS. Link macOS-specific configs (link/macos) anyway? (y/N): " macos_reply
  [[ "$macos_reply" == "y" || "$macos_reply" == "Y" ]] && link_entries "$CONFIG_SRC_DIR/macos"
fi

if [[ "$INCLUDE_DOTFILES" == "true" ]]; then
  shopt -u dotglob
fi

echo "Symbolic links have been created."
