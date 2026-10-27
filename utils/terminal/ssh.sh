# Start SSH agent (or reuse an existing one) and add keys once per agent lifetime
_ssh_env="$HOME/.ssh/agent-environment"

_ssh_start_agent() {
  (umask 077; ssh-agent -s > "$_ssh_env")
  . "$_ssh_env" > /dev/null
}

[ -f "$_ssh_env" ] && . "$_ssh_env" > /dev/null

ssh-add -l > /dev/null 2>&1
_ssh_status=$?

# exit 2 = can't reach an agent at all -> need a fresh one
if [ "$_ssh_status" -eq 2 ]; then
  _ssh_start_agent
  ssh-add -l > /dev/null 2>&1
  _ssh_status=$?
fi

# exit 1 = agent is alive but holds no keys yet -> add them (prompts for passphrase)
if [ "$_ssh_status" -eq 1 ]; then
  ssh-add ~/.ssh/id_ed25519
fi

unset _ssh_env _ssh_status
