# !/bin/bash
#
#
set -u
set -e
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
source $CURRENT_DIR/tmux-functions.sh
source $CURRENT_DIR/flutter-session.conf

SESSION_NAME="flutter"

main() {
    create_session ${SESSION_NAME}
    recreate_window "=${SESSION_NAME}:2" "sdk"
    go_dir "=${SESSION_NAME}:2" "${SDK_PATH}"
    recreate_window "=${SESSION_NAME}:3" "engine"
    go_dir "=${SESSION_NAME}:3" "${ENGINE_PATH}"
    recreate_window "=${SESSION_NAME}:4" "packages"
    go_dir "=${SESSION_NAME}:4" "${PACKAGE_PATH}"
}

main


