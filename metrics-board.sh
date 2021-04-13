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
    local target_window="=${SESSION}:2"
    kill_window "${target_window}"
    create_window "${target_window}" "adb"
    if [[ -n ${HOST} && -n ${PORT} ]]; then
        send_command "${target_window}.1" "watch adb -H ${HOST} -P ${PORT} devices" C-m
    else
        send_command "${target_window}.1" "watch adb devices" C-m
    fi
}

setup_sys_metrics_window() {
    local target_window="=${SESSION}:1"
    kill_window "${target_window}"
    create_window "${target_window}" "sys"
    send_command "${target_window}" "top"
    split_vertical "${target_window}"
    send_command "${target_window}.2" "watch -n 10 df -h" C-m
}

main() {
    create_session "${SESSION}"
    create_window "${SESSION}:0" "dummy"
    setup_sys_metrics_window
    setup_adb_metrics_window
    kill_window "${SESSION}:0"
}

main
