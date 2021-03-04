# !/bin/bash
#
#
set -u
set -e
CURRENT_DIR="$(cd "$(dirname $BASH_SOURCE[0])" && pwd)"

source ${CURRENT_DIR}/tmux_functions.sh

echo "setting up metrics board tmux session"

readonly SESSION="metrics-board"

main() {
    create_session "${SESSION}"
    kill_window "=${SESSION}:2"
    create_window "=${SESSION}:2" "sys"
    send_command "=${SESSION}:2" "top"
    split_vertical "=${SESSION}:2"
    send_command "=${SESSION}:2.2" "watch -n 10 df -h" C-m

    kill_window "=${SESSION}:3"
    create_window "=${SESSION}:3" "adb"
    send_command "=${SESSION}:3.1" "watch adb devices" C-m
}

main
