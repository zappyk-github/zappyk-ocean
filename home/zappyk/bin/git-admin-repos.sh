#!/bin/env bash
IFS_SAVE=$IFS

VCS_DEBUG=false
VCS_CMMND='git'
VCS_SLEEP=1
VCS_CONFS="
 zappyk@:/home/zappyk/bin
 root@:/root/bin
 root@:/opt/sysadm
"
VCS_CONFS="
 @§$HOME/Programmi/_VoCs_/github/crontab-ui§$VCS_CMMND clone \"https://zappyk@github.com/zappyk-github/crontab-ui.git\" crontab-ui
 @§$HOME/Programmi/_VoCs_/github/zappyk-ocean§$VCS_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-ocean.git\" zappyk-ocean
 @§$HOME/Programmi/_VoCs_/github/zappyk-python§$VCS_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-python.git\" zappyk-python
 @§$HOME/Programmi/_VoCs_/github/zappyk-django§$VCS_CMMND clone \"https://zappyk@github.com/zappyk-github/zappyk-django.git\" zappyk-django
 @§$HOME/Programmi/_VoCs_/payroll/pes0zappayroll-pes0zap-java§$VCS_CMMND clone \"https://pes0zappayroll@github.com/pes0zap-jaba/pes0zap-java.git\" pes0zappayroll-pes0zap-java
 @§$HOME/Programmi/_VoCs_/payroll/payroll-java-space-invaders§$VCS_CMMND clone \"https://pes0zappayroll@github.com/People-Solutions/space-invaders.git\" payroll-java-space-invaders
#@§$HOME/Programmi/_VoCs_/payroll/payroll-legacy§$VCS_CMMND clone \"ssh://pes0zap@payroll.it@source.developers.google.com:2022/p/payroll-datacenter/r/payroll-legacy\" payroll-git-google
#@§$HOME/Programmi/_VoCs_/payroll/payroll-legacy§$VCS_CMMND clone \"https://source.developers.google.com/p/payroll-datacenter/r/payroll-legacy\" payroll-git-google
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
_war() {
    local string="$*"
    echo -n -e "$EC_nBROWN_"
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
[ -z "$*" ] && echo -e "$($VCS_CMMND --help)\n$VCS_CONFS\nSpecifica un comando..." && exit 1

COMMAND="$VCS_CMMND "$(_quoting "$@")
EXITCODE=0
#-------------------------------------------------------------------------------
IFS=$'\n'
for VCS_CONF in $VCS_CONFS; do
    IFS=$IFS_SAVE

    VCS_CONF_skip=${VCS_CONF:0:1}
    VCS_CONF_line=${VCS_CONF:1}

    [ "$VCS_CONF_skip" == '#' ] && continue

    IFS=$'§' read VCS_USER_HOST VCS_PATH VCS_HELP < <(echo "$VCS_CONF_line")
    IFS=$'@' read VCS_USER VCS_HOST               < <(echo "$VCS_USER_HOST")

    [ -n "$VCS_HELP" ] && VCS_HELP="cd \"$(dirname "$VCS_PATH")\" && $VCS_HELP $(basename "$VCS_PATH")" \
                       && VCS_HELP="| Try the help :\n${VCS_HELP//?/-}\n$VCS_HELP"

    [ ! -d "$VCS_PATH" ] && _war "Directory not exists:  \"$VCS_PATH\"" && continue

    cmd_1="cd $VCS_PATH && $COMMAND"
    cmd_1="($cmd_1)"

    if   [ -n "$VCS_HOST" ]; then
        cmd_0="ssh $VCS_USER@$VCS_HOST \"$cmd_1\""
    elif [ -n "$VCS_USER" ]; then
    #CZ#cmd_0="su -c \"$cmd_1\" -s /bin/bash - $VCS_USER"
        cmd_0="su -c \"$cmd_1\" - $VCS_USER"
    else
        cmd_0="$cmd_1"
    fi

    ( $VCS_DEBUG ) && printf "%-15s - %-15s - %-30s - %s\n" "|$VCS_USER|" "|$VCS_HOST|" "|$VCS_PATH|" "|$cmd_0|" && continue

    _log "$cmd_0"
    eval "$cmd_0" ; EXITCODE=$?
    [ $EXITCODE -eq 0 ] && echo || { _err "Error! ($EXITCODE)"; _help "$VCS_HELP"; }
#CZ#echo
    sleep $VCS_SLEEP
done
IFS=$IFS_SAVE
#-------------------------------------------------------------------------------
exit $EXITCODE
