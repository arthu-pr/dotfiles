# Custom functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}

sitespeed() {
	docker run --rm \
		-v "$(pwd):/sitespeed.io" \
		sitespeedio/sitespeed.io:33.5.0 \
		"$1"
}

# --------------------------------------------
# https://stackoverflow.com/a/30029855
# List all listening ports, optionally filtering by a pattern
listening() {
	if [ $# -eq 0 ]; then
			sudo lsof -iTCP -sTCP:LISTEN -n -P

			
	elif [ $# -eq 1 ]; then
			sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
	else
			echo "Usage: listening [pattern]"
	fi
}

worktree() {
	local current_dir wt_path

	current_dir=$(pwd)
	wt_path=$1

	(
			cd "$current_dir" || exit
			git worktree add "$wt_path/$2" "$2"
			cp .env "$wt_path/$2"
			cd "$wt_path/$2" || exit
	)
}


# --------------------------------------------
# PM2 commands
pm2restart() {
  if [ $# -eq 0 ]; then
    pm2 restart all
  elif [ $# -eq 1 ]; then
    pm2 restart "$1"
  else
    echo "Usage: pm2restart [process_name]"
  fi
}

pm2logrestart() {
  if [ $# -eq 0 ]; then
    pm2 restart all && pm2 logs
  elif [ $# -eq 1 ]; then
    pm2 restart "$1" && pm2 logs "$1"
  else
    echo "Usage: pm2restartlog [process_name]"
  fi
}

pm2listNames() {
  pm2 list | awk 'NR>1 {print $2}'
}

