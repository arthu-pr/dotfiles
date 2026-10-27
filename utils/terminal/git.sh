# Git aliases
alias gst="git status"
alias gitfake="git add . && git commit -m 'fake'"
alias gitresetlast="git reset HEAD~1"
alias gitstashpull="git stash -u && git pull && git stash pop"
alias gitrestorecheckoutclean="git restore --staged . && git checkout . && git clean -fd"
alias gclone="git clone "

# Reminder
alias gitshowmestupid="echo 'git clean -fd'"