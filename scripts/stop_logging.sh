#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
    local file
    if [[ "$compression_enabled" -eq 1 ]]; then
        file=$(expand_tmux_format_path "${logging_full_filename}").gz
    else
        file=$(expand_tmux_format_path "${logging_full_filename}")
    fi
    tmux pipe-pane
    display_message "Ended logging to $file"
}

main
