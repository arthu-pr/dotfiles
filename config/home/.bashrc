# Interactive shells only
case $- in
  *i*) ;;
  *) return ;;
esac

# History
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize
HISTSIZE=2000
HISTFILESIZE=4000
HISTTIMEFORMAT="%F %T "

# Colors
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Bash completion
if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi

# Shared shell-agnostic layer (deliberately ~/config, not ~/.config)
[ -f "$HOME/config/terminal/init.sh" ] && . "$HOME/config/terminal/init.sh"

# --------------------------------------------
# Set additional custom rules if needed
# source .bashrc.local only if it exists
#
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
