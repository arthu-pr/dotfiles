#!/bin/bash
#
# This script is to launch the first time you sync with the repo or if you wish to change the location of your config files
# It will:
# - Ask for the location of your config files
# - Ask for the location of the target directory for the symbolic links
# - Create symbolic links for all files inside folders in the current directory to the configuration directory (default .config)
#  example: .config/nvim -> ~/config/nvim
# - Create symbolic links for files listed in HOME_FILES in the home directory to the target directory (default current directory)
#  example: .vimrc -> ~/config/.vimrc
#

CONFIG_DIR="$HOME/.config"                                          # Configuration directory for directories
HOME_FILES=(".vimrc" ".zpreztorc")                                  # List of files to link in the home directory
TARGET_DIR="$HOME/config"                                           # Target directory for the symbolic links
INCLUDE_DOTFILES="true"                                             # Include hidden files and directories by default




  EXCLUDE_FOLDERS=("set_symbolic_links.sh" "Code" ".git" "README.md" "macos") # Add folders to exclude

read -p "Enter your configuration directory (default $CONFIG_DIR): " custom_config_dir
read -p "Enter the target directory for symbolic links (default $TARGET_DIR): " custom_target_dir

if [[ -n "$custom_config_dir" ]]; then
  CONFIG_DIR="$custom_config_dir"
fi

if [[ -n "$custom_target_dir" ]]; then
  TARGET_DIR="$custom_target_dir"
fi

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

# Check if entry is in HOME_FILES, and if so, we return 0
is_home_file() {
  local file=$1
  for home_file in "${HOME_FILES[@]}"; do
    if [[ "$file" == "$home_file" ]]; then
      return 0
    fi
  done
  return 1
}

# Process regular files and directories in TARGET_DIR
for entry_path in "$TARGET_DIR"/*; do
  entry="$(basename "$entry_path")"

  if [[ " ${EXCLUDE_FOLDERS[*]} " =~ [[:space:]]${entry}[[:space:]] ]]; then
    echo "Skipping excluded folder: $entry."
    continue
  fi

  if is_home_file "$entry"; then
    echo "Skipping $entry for $CONFIG_DIR."
    continue
  fi

  create_symlink "$entry_path" "$CONFIG_DIR/$entry"
done

# Process special home directory files
for file in "${HOME_FILES[@]}"; do
  create_symlink "$TARGET_DIR/$file" "$HOME/$file"
done

# Process macOS-specific files
IS_MACOS="false"
if [[ "$(uname)" == "Darwin" ]]; then
  IS_MACOS="true"
else
  read -p "This does not appear to be macOS. Include macOS-specific configs anyway? (y/N): " macos_reply
  if [[ "$macos_reply" == "y" || "$macos_reply" == "Y" ]]; then
    IS_MACOS="true"
  fi
fi

if [[ "$IS_MACOS" == "true" && -d "$TARGET_DIR/macos" ]]; then
  for file in "$TARGET_DIR"/macos/* "$TARGET_DIR"/macos/.*; do
    filename="${file##*/}"
    if [[ "$filename" == "." || "$filename" == ".." ]]; then
      continue
    fi
    create_symlink "$file" "$HOME/$filename"
  done
fi

if [[ "$INCLUDE_DOTFILES" == "true" ]]; then
  shopt -u dotglob
fi

echo "Symbolic links have been created."
