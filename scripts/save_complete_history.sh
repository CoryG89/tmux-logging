#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
	if supported_tmux_version_ok; then
        local file
        local history_limit
        history_limit="$(tmux display-message -p -F "#{history_limit}")"

        if [[ "$compression_enabled" -eq 1 ]]; then
            file=$(expand_tmux_format_path "${save_complete_history_full_filename}").gz
            tmux capture-pane -J -S "-${history_limit}" -p | gzip > "${file}"
        else
            file=$(expand_tmux_format_path "${save_complete_history_full_filename}")
		    tmux capture-pane -J -S "-${history_limit}" -p > "${file}"
        fi

        remove_empty_lines_from_end_of_file "${file}"
		display_message "History saved to ${file}"
	fi
}
main
