#!/bin/bash
#
# This script is to launch the first time you sync with the repo or if you wish to change the location of your config files
# It will:
# - Ask for the location of your config files
# - Ask for the location of the target directory for the symbolic links
# - Create symbolic links for everything in this repo's config/config subfolder to the configuration
#   directory (default .config)
#  example: ~/.config/nvim -> ~/config/config/config/nvim
# - Create symbolic links for everything in this repo's config/home subfolder to the home directory
#  example: ~/.vimrc -> ~/config/config/home/.vimrc
# - On macOS, also create symbolic links for everything in config/home-macos to the home directory
#

CONFIG_DIR="$HOME/.config"                                          # Configuration directory for directories
TARGET_DIR="$HOME/config"                                           # Target directory for the symbolic links
INCLUDE_DOTFILES="true"                                             # Include hidden files and directories by default

read -p "Enter your configuration directory (default $CONFIG_DIR): " custom_config_dir
read -p "Enter the target directory for symbolic links (default $TARGET_DIR): " custom_target_dir

if [[ -n "$custom_config_dir" ]]; then
  CONFIG_DIR="$custom_config_dir"
fi

if [[ -n "$custom_target_dir" ]]; then
  TARGET_DIR="$custom_target_dir"
fi

CONFIG_SRC_DIR="$TARGET_DIR/config"

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

# config/config/* -> $CONFIG_DIR/*
for entry_path in "$CONFIG_SRC_DIR"/config/*; do
  entry="$(basename "$entry_path")"
  create_symlink "$entry_path" "$CONFIG_DIR/$entry"
done

# config/home/* -> $HOME/*
for entry_path in "$CONFIG_SRC_DIR"/home/*; do
  entry="$(basename "$entry_path")"
  create_symlink "$entry_path" "$HOME/$entry"
done

# config/home-macos/* -> $HOME/* (macOS only)
IS_MACOS="false"
if [[ "$(uname)" == "Darwin" ]]; then
  IS_MACOS="true"
else
  read -p "This does not appear to be macOS. Include macOS-specific configs anyway? (y/N): " macos_reply
  if [[ "$macos_reply" == "y" || "$macos_reply" == "Y" ]]; then
    IS_MACOS="true"
  fi
fi

if [[ "$IS_MACOS" == "true" ]]; then
  for entry_path in "$CONFIG_SRC_DIR"/home-macos/*; do
    entry="$(basename "$entry_path")"
    create_symlink "$entry_path" "$HOME/$entry"
  done
fi

if [[ "$INCLUDE_DOTFILES" == "true" ]]; then
  shopt -u dotglob
fi

echo "Symbolic links have been created."
