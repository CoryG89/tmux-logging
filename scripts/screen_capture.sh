#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
	if supported_tmux_version_ok; then
        local file

        if [[ "$compression_enabled" -eq 1 ]]; then
            file=$(expand_tmux_format_path "${screen_capture_full_filename}").gz
            tmux capture-pane -J -p | gzip > "${file}"
        else
            file=$(expand_tmux_format_path "${screen_capture_full_filename}")
		    tmux capture-pane -J -p > "${file}"
        fi

        remove_empty_lines_from_end_of_file "${file}"
		display_message "Screen capture saved to ${file}"
	fi
}
main
