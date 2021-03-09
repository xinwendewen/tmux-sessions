#!/bin/bash
#
#
# setup dev environment for flutter
set -u
set -e

readonly FLUTTER_REPO_URL="git@github.com:flutter/flutter.git"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
source $CURRENT_DIR/flutter.conf

main() {
    # check whether the repo exist
    if [[ -d ${FLUTTER_PATH} && -x ${FLUTTER_PATH}/bin/flutter ]]; then
        # show version details
        ${FLUTTER_PATH}/bin/flutter --version
        echo "flutter installed! Consider"
        echo "echo PATH=\\\"\\\$PATH:${FLUTTER_PATH}/bin\\\" >> $HOME/.bash_profile"
        echo "or"
        echo "echo PATH=\\\"\\\$PATH:${FLUTTER_PATH}/bin\\\" >> $HOME/.bashrc"
    else
        # ask if you need to install flutter
        echo "clone flutter ....."
        cd ${FLUTTER_PATH}
        git clone ${FLUTTER_REPO_URL}
    fi
}

main
