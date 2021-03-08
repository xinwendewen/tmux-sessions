# !/bin/bash
#
#
set -u
set -e
CURRENT_DIR="$(cd "$(dirname $BASH_SOURCE[0])" && pwd)"

source ${CURRENT_DIR}/tmux-functions.sh
source ${CURRENT_DIR}/adb-metrics.conf

echo "setting up adb metrics board tmux session"

readonly SESSION="adb-metrics-board"

main() {
    create_session "${SESSION}"
    kill_window "=${SESSION}:3"
    create_window "=${SESSION}:3" "adb"
    if [[ -n ${HOST} && -n ${PORT} ]]; then
        send_command "=${SESSION}:3.1" "watch adb -H ${HOST} -P ${PORT} devices" C-m
    else
        send_command "=${SESSION}:3.1" "watch adb devices" C-m
    fi
}

main
