#!/bin/bash
#
# funcions for tmux automation
# target-session默认模糊匹配，完全匹配需要使用‘=target-session’

create_session() {
    local session_name=$1
	tmux has-session -t "=${session_name}" || tmux new-session -d -s "${session_name}"
}

kill_window() {
    local target_window=$1
    tmux kill-window -t "${target_window}" || true
}

create_window() {
    local target_window=$1
    local window_name=$2
    if [[ $# = 3 ]]; then
        local dir="$3"
        tmux new-window -d -t "${target_window}" -n "${window_name}" -c "${dir}"
    else
        tmux new-window -d -t "${target_window}" -n "${window_name}"
    fi
	echo "window ${window_name} created"
}

recreate_window() {
    local target_window=$1
    local window_name=$2
    kill_window $target_window
    create_window $target_window $window_name
}

rename_window() {
	echo "rename window $1:$2 to $3"
	tmux rename-window -t "=$1:$2" $3
}

send_command() {
    local target_window=$1
    local cmd=$2
	tmux send-keys -t "${target_window}" "${cmd}" C-m
}

go_dir() {
    local target_window=$1
    local dir=$2
    send_command $target_window "cd $dir"
}

export_env() {
    local target_window=$1
    local name=$2
    local value=$3
    send_command $target_window "export $2 $3"
}

split_vertical() {
    local target_window=$1
    tmux split-window -v -t "$target_window"
}

# $1 sessiom
# $2 window index
# $3 window name
# $4 remote host
# $5 init dir
# $6 command
function setup_remote_window {
	kill_window $1 $2
	create_window $1 $2 $3
	send_command $1 $2 "ssh $4"
	send_command $1 $2 "cd $5"
	[ ! -z $6 ] && send_command $1 $2 "$6"
}

# $1 sessiom
# $2 window index
# $3 window name
# $4 init dir
function setup_window {
	kill_window $1 $2
	create_window $1 $2 $3
	send_command $1 $2 "cd $4"
}
