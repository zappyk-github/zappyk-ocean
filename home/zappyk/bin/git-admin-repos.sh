#!/bin/env bash
IFS_SAVE=$IFS

GIT_DEBUG=false
GIT_CONFS="
 zappyk@:/home/zappyk/bin
 root@:/root/bin
 root@:/opt/sysadm
"
GIT_CONFS="
 @§$HOME/Programmi/zappyk-github/zappyk-ocean§git clone \"https://zappyk@github.com/zappyk-github/zappyk-ocean.git\" zappyk-ocean
 @§$HOME/Programmi/zappyk-github/zappyk-python§git clone \"https://zappyk@github.com/zappyk-github/zappyk-python.git\" zappyk-python
"

################################################################################
_log() {
    local string="$*"
    echo "+-${string//?/-}-+"
    echo "| ${string} |"
    echo "+-${string//?/-}-+"
}

################################################################################
_help() {
    local string="$*"
    [ -n "$string" ] && echo -e "$string"
}

################################################################################
_quote() {
    echo "$*" | sed 's/ /\\ /g' \
              | sed "s/'/\\\'/g"
}

################################################################################
_quoting() {
    local options=''
    for i in "$@"; do
        [ -n "$options" ] && options="$options "
        options=$options$(_quote "$i")
    done
    echo "$options"
}

#-------------------------------------------------------------------------------
GIT_COMMAND='git'

[ -z "$*" ] && echo -e "$($GIT_COMMAND --help)\n$GIT_CONFS\nSpecifica un comando..." && exit 1

COMMAND="$GIT_COMMAND "$(_quoting "$@")
EXITCODE=0
#-------------------------------------------------------------------------------
IFS=$'\n'
for GIT_CONF in $GIT_CONFS; do
    IFS=$IFS_SAVE

    GIT_CONF_skip=${GIT_CONF:0:1}
    GIT_CONF_line=${GIT_CONF:1}

    [ "$GIT_CONF_skip" == '#' ] && continue

    IFS=$'§' read GIT_USER_HOST GIT_PATH GIT_HELP < <(echo "$GIT_CONF_line")
    IFS=$'@' read GIT_USER GIT_HOST               < <(echo "$GIT_USER_HOST")

    [ -n "$GIT_HELP" ] && GIT_HELP="cd \"$(dirname "$GIT_PATH")\" && $GIT_HELP $(basename "$GIT_PATH")" \
                       && GIT_HELP="| Try the help :\n${GIT_HELP//?/-}\n$GIT_HELP"

    [ ! -d "$GIT_PATH" ] && _log "Directory not exists:  \"$GIT_PATH\"" && continue

    cmd_1="cd $GIT_PATH && $COMMAND"
    cmd_1="($cmd_1)"

    if   [ -n "$GIT_HOST" ]; then
        cmd_0="ssh $GIT_USER@$GIT_HOST \"$cmd_1\""
    elif [ -n "$GIT_USER" ]; then
    #CZ#cmd_0="su -c \"$cmd_1\" -s /bin/bash - $GIT_USER"
        cmd_0="su -c \"$cmd_1\" - $GIT_USER"
    else
        cmd_0="$cmd_1"
    fi

    ( $GIT_DEBUG ) && printf "%-15s - %-15s - %-30s - %s\n" "|$GIT_USER|" "|$GIT_HOST|" "|$GIT_PATH|" "|$cmd_0|" && continue

    _log "$cmd_0"
    eval "$cmd_0" ; EXITCODE=$?
    [ $EXITCODE -eq 0 ] && echo || { _log "Error! ($EXITCODE)"; _help "$GIT_HELP"; }
    echo
done
IFS=$IFS_SAVE
#-------------------------------------------------------------------------------
exit $EXITCODE
