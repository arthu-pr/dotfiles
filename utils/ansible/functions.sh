run_playbook() {
  # shift so extra args (-e target_hosts=play, --check, --list-tasks…) reach
  # ansible-playbook instead of being dropped.
  local __playbook="$1"; shift
  ansibleplaybook "$PROJECT_PATH/$__playbook" "$@"
}

run_in_terminal() {
  # launch terminal with the specified command
  konsole --hold -e "$1"
}

monitoring() {
  run_in_terminal "ansibleplaybook $PROJECT_PATH/monitoring/server_metrics.yml"
}

disk_cleanup() {
  run_playbook "disk_cleanup/disk_cleanup.yml" "$@"
}

# Install the repo's reclaim.sh into the Claude skill dir, so local runs use the
# version-controlled copy rather than a hand-edited one that drifts.
# disk_cleanup_install() {
#   run_playbook "disk_cleanup/disk_cleanup_install.yml" "$@"
# }

# !!! Important
# Will run the update_reboot_check.sh script in the background and tail the log file
# for all the hosts in the inventory automatically
ansible_update_reboot_check() {
  bash ~/www/infra/ansible-droplet/projects/update_reboot_check/run_update_reboot_check.sh &
  tail -f ~/.ansible/logs/update_reboot_check.log
}

