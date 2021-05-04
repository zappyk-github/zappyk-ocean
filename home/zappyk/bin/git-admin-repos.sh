#!/bin/env bash
IFS_SAVE=$IFS

GIT_DEBUG=false
GIT_CMMND='git'
GIT_CONFS="
 zappyk@:/home/zappyk/bin
 root@:/root/bin
 root@:/opt/sysadm
"
GIT_CONFS="
 @§$HOME/Programmi/_VoCs_/github/crontab-ui§$GIT_CMMND clone \"https://zappyk@github.com/zappyk-github/crontab-ui.git\" crontab-ui
 @§$HOME/Programmi/_VoCs_/github/zappyk-ocean§$GIT_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-ocean.git\" zappyk-ocean
 @§$HOME/Programmi/_VoCs_/github/zappyk-python§$GIT_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-python.git\" zappyk-python
 @§$HOME/Programmi/_VoCs_/github/zappyk-django§$GIT_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-django.git\" zappyk-django
 @§$HOME/Programmi/_VoCs_/payroll/pes0zappayroll-pes0zap-java§$GIT_CMMND clone \"https://pes0zappayroll@github.com/pes0zap-jaba/pes0zap-java.git\" pes0zappayroll-pes0zap-java
 @§$HOME/Programmi/_VoCs_/payroll/payroll-java-space-invaders§$GIT_CMMND clone \"https://pes0zappayroll@github.com/People-Solutions/space-invaders.git\" payroll-java-space-invaders
#@§$HOME/Programmi/_VoCs_/payroll/payroll-legacy§$GIT_CMMND clone \"ssh://pes0zap@payroll.it@source.developers.google.com:2022/p/payroll-datacenter/r/payroll-legacy\" payroll-git-google
#@§$HOME/Programmi/_VoCs_/payroll/payroll-legacy§$GIT_CMMND clone \"https://source.developers.google.com/p/payroll-datacenter/r/payroll-legacy\" payroll-git-google
 @§$HOME/Programmi/_VoCs_/payroll/payroll-legacy§gcloud source repos clone payroll-legacy --project=payroll-datacenter
"

EC_nBLACK_='\033[0;30m' ; EC_dGREY__='\033[0;30m'
EC_nRED___='\033[0;31m' ; EC_lRED___='\033[0;31m'
EC_nGREEN_='\033[0;32m' ; EC_lGREEN_='\033[0;32m'
EC_nBROWN_='\033[0;33m' ; EC_YELLOW_='\033[0;33m'
EC_nBLUE__='\033[0;34m' ; EC_lBLUE__='\033[0;34m'
EC_nPURPLE='\033[0;35m' ; EC_lPURPLE='\033[0;35m'
EC_nCYAN__='\033[0;36m' ; EC_lCYAN__='\033[0;36m'
EC_lGREY__='\033[0;37m' ; EC_WHITE__='\033[0;37m'
EC_n_xxx_1='\033[0;38m' ; EC_l_xxx_1='\033[0;38m'
EC_n_xxx_2='\033[0;39m' ; EC_l_xxx_2='\033[0;39m'
EC_n_xxx_3='\033[0;40m' ; EC_l_xxx_3='\033[0;40m'
EC_NoC____='\033[0m'

################################################################################
_log() {
    local string="$*"
    echo -n -e "$EC_nGREEN_"
    echo "+-${string//?/-}-+"
    echo "| ${string} |"
    echo "+-${string//?/-}-+"
    echo -n -e "$EC_NoC____"
}

################################################################################
_err() {
    local string="$*"
    echo -n -e "$EC_nRED___"
    echo "+-${string//?/-}-+"
    echo "| ${string} |"
#CZ#echo "+-${string//?/-}-+"
    echo -n -e "$EC_NoC____"
}

################################################################################
_help() {
    local string="$*"
    echo -n -e "$EC_YELLOW_"
    [ -n "$string" ] && echo -e "$string"
    echo -n -e "$EC_NoC____"
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
[ -z "$*" ] && echo -e "$($GIT_CMMND --help)\n$GIT_CONFS\nSpecifica un comando..." && exit 1

COMMAND="$GIT_CMMND "$(_quoting "$@")
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
    [ $EXITCODE -eq 0 ] && echo || { _err "Error! ($EXITCODE)"; _help "$GIT_HELP"; }
#CZ#echo
done
IFS=$IFS_SAVE
#-------------------------------------------------------------------------------
exit $EXITCODE
