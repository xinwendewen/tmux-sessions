# !/bin/bash
#
#
set -u
set -e
CURRENT_DIR="$(cd "$(dirname $BASH_SOURCE[0])" && pwd)"

source ${CURRENT_DIR}/tmux-functions.sh

echo "setting up system metrics board tmux session"

readonly SESSION="sys-metrics-board"

main() {
    create_session "${SESSION}"
    kill_window "=${SESSION}:2"
    create_window "=${SESSION}:2" "sys"
    send_command "=${SESSION}:2" "top"
    split_vertical "=${SESSION}:2"
    send_command "=${SESSION}:2.2" "watch -n 10 df -h" C-m
}

main
