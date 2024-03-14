#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

ansifilter_installed() {
    type ansifilter >/dev/null 2>&1 || return 1
}

system_osx() {
    [ "$(uname)" == "Darwin" ]
}

pipe_pane_ansifilter() {
    if [[ "$compression_enabled" -eq 1 ]]; then
        tmux pipe-pane "exec cat - | ansifilter | gzip >> $1"
    else
        tmux pipe-pane "exec cat - | ansifilter >> $1"
    fi
}

pipe_pane_sed_osx() {
    # Warning, very complex regex ahead.
    # Some characters below might not be visible from github web view.
    local ansi_codes_osx="(\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]|
|]0;[^]+|[[:space:]]+$)"


    if [[ "$compression_enabled" -eq 1 ]]; then
        tmux pipe-pane "exec cat - | sed -E \"s/$ansi_codes_osx//g\" | gzip >> $1"
    else
        tmux pipe-pane "exec cat - | sed -E \"s/$ansi_codes_osx//g\" >> $1"
    fi
}

pipe_pane_sed() {
    local ansi_codes="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]|
)"

    if [[ "$compression_enabled" -eq 1 ]]; then
        tmux pipe-pane "exec cat - | sed -r 's/$ansi_codes//g' | gzip >> $1"
    else
        tmux pipe-pane "exec cat - | sed -r 's/$ansi_codes//g' >> $1"
    fi
}

start_pipe_pane() {
    if ansifilter_installed; then
        pipe_pane_ansifilter "$1"
    elif system_osx; then
        # OSX uses sed '-E' flag and a slightly different regex
        pipe_pane_sed_osx "$1"
    else
        pipe_pane_sed "$1"
    fi
}

main() {
    local file
    if [[ "$compression_enabled" -eq 1 ]]; then
        file=$(expand_tmux_format_path "${logging_full_filename}").gz
    else
        file=$(expand_tmux_format_path "${logging_full_filename}")
    fi
    start_pipe_pane "$file"
    display_message "Started logging to $file"
}
main
