# Shared shell-agnostic config, sourced by both .bashrc and .zshrc.
# Lives in the repo's utils/terminal on purpose (not symlinked into ~/.config).
# DOTFILES_DIR is set by the rc file that sources this.
_terminal_dir="$DOTFILES_DIR/utils/terminal"

for _f in exports aliases git functions ssh; do
  [ -f "$_terminal_dir/$_f.sh" ] && . "$_terminal_dir/$_f.sh"
done

# Debian-only helpers
[ -f /etc/debian_version ] && [ -f "$_terminal_dir/debian/functions.sh" ] \
  && . "$_terminal_dir/debian/functions.sh"

# Personal ansible-droplet helpers, kept separate from the shell-agnostic files
# above since they're specific to this user's ansible workflow, not general shell config.
# Opt-in per machine via install.sh (defaults to on if never asked, e.g. pre-existing
# machines set up before this toggle existed) — skip with `echo no > ~/.config/dotfiles-ansible`.
_ansible_marker="$HOME/.config/dotfiles-ansible"
if [ ! -f "$_ansible_marker" ] || [ "$(cat "$_ansible_marker")" = "yes" ]; then
  _ansible_dir="$DOTFILES_DIR/utils/ansible"
  for _f in init aliases functions; do
    [ -f "$_ansible_dir/$_f.sh" ] && . "$_ansible_dir/$_f.sh"
  done
  unset _ansible_dir
fi

unset _terminal_dir _ansible_marker _f
