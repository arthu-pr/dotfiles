# Environment variables and PATH (shell-agnostic)

# GPG
export GPG_TTY=$(tty)

# PATH
[ -d "$HOME/zellij-bin/bin" ] && export PATH="$HOME/zellij-bin/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
