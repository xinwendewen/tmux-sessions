# !/bin/bash
#
#
set -u
set -e
CURRENT_DIR="$(cd "$(dirname $BASH_SOURCE[0])" && pwd)"

source ${CURRENT_DIR}/tmux-functions.sh
source ${CURRENT_DIR}/adb-metrics.conf

echo "setting up metrics board tmux session"

readonly SESSION="metrics-board"

setup_adb_metrics_window() {
    kill_window "=${SESSION}:3"
    create_window "=${SESSION}:3" "adb"
    if [[ -n ${HOST} && -n ${PORT} ]]; then
        send_command "=${SESSION}:3.1" "watch adb -H ${HOST} -P ${PORT} devices" C-m
    else
        send_command "=${SESSION}:3.1" "watch adb devices" C-m
    fi
}

setup_sys_metrics_window() {
    kill_window "=${SESSION}:2"
    create_window "=${SESSION}:2" "sys"
    send_command "=${SESSION}:2" "top"
    split_vertical "=${SESSION}:2"
    send_command "=${SESSION}:2.2" "watch -n 10 df -h" C-m
}

main() {
    create_session "${SESSION}"
    setup_sys_metrics_window
    setup_adb_metrics_window
}

main
