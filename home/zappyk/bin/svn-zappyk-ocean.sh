#!/bin/env bash

THIS=$(basename "$0")
BASE=$HOME/Programmi/zappyk-ocean/

_log() {
    echo "$*"
}

_die() {
    _log "$THIS: $*"
    exit 1
}

_svn() {
    cd "$BASE" || _die "directory $BASE not change!"

    local log="[$USERNAME@$HOSTNAME $PWD] svn $*"
    _log "${log//?/_}"
    _log "$log"
    svn "$@" || _die "command [svn $*] not execute!"
}

_svn "$@"

exit
