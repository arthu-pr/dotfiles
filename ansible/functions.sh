run_playbook() {
  ansibleplaybook "$PROJECT_PATH/$1"
}

run_in_terminal() {
  # launch terminal with the specified command
  konsole --hold -e "$1"
}

monitoring() {
  run_in_terminal "ansibleplaybook $PROJECT_PATH/monitoring/server_metrics.yml"
}

disk_cleanup() {
  run_playbook "common/disk_cleanup.yml"
}
