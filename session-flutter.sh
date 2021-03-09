#!/bin/bash
#
#
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
source $CURRENT_DIR/tmux_functions.sh
source $CURRENT_DIR/config.sh

SESSION="flutter"

function create_flutter_session {
	export PATH="$FLUTTER_SDK_PATH/bin:$PATH"

	create_session $SESSION

	check_path $FLUTTER_SDK_PATH "sdk"
	create_window $SESSION 2 "sdk" $FLUTTER_SDK_PATH

	check_path $FLUTTER_LOCAL_REPO_PATH "local repo"
	create_window $SESSION 3 "local-repos" $FLUTTER_LOCAL_REPO_PATH

	check_path $FLUTTER_GITHUB_REPO_PATH "github repo"
	create_window $SESSION 4 "github-repos" $FLUTTER_GITHUB_REPO_PATH
}

# $1 path
# $2 path name
function check_path {
	if [[ -z "$1" ]]; then
		echo "$2 path not set"
		return 1
	fi
	if [[ ! -d "$1" ]]; then
		echo "path $1 not exist"
		return 1
	fi
}

# $1 session
# $2 window index
# $3 window name
# $4 work directory
function create_window {
	target_window="$1:$2"
	tmux kill-window -t $target_window 2>/dev/null
	tmux new-window -d -t $target_window -n $3 -c "$4"
	echo "window [$1:$3] created"
}

# create_flutter_session
