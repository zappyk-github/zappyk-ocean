#!/bin/env bash
IFS_SAVE=$IFS

SVN_DEBUG=false
SVN_CMMND='svn'
SVN_CONFS="
 zappyk@:/home/zappyk/bin
 root@:/root/bin
 root@:/opt/sysadm
"
SVN_CONFS="
#@§$HOME/Programmi/_dvcs_/zappyk-github/zappyk-ocean
#@§$HOME/Programmi/_dvcs_/zappyk-github/zappyk-python
#@§$HOME/Programmi/_dvcs_/zappyk-github/zappyk-django
#@§$HOME/Programmi/_dvcs_/zappyk-github/crontab-ui
#@§$HOME/Programmi/_dvcs_/pes0zap-payroll/payroll-legacy§$SVN_CMMND co --username pes0zap --password crl0zpp1 \"https://svn.payroll.it/payroll/trunk\" payroll-svn-legacy
#@§/opt/payroll-var/webexe
#@§/opt/payroll
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
[ -z "$*" ] && echo -e "$($SVN_CMMND --help)\n$SVN_CONFS\nSpecifica un comando..." && exit 1

COMMAND="$SVN_CMMND "$(_quoting "$@")
EXITCODE=0
#-------------------------------------------------------------------------------
IFS=$'\n'
for SVN_CONF in $SVN_CONFS; do
    IFS=$IFS_SAVE

    SVN_CONF_skip=${SVN_CONF:0:1}
    SVN_CONF_line=${SVN_CONF:1}

    [ "$SVN_CONF_skip" == '#' ] && continue

    IFS=$'§' read SVN_USER_HOST SVN_PATH SVN_HELP < <(echo "$SVN_CONF_line")
    IFS=$'@' read SVN_USER SVN_HOST               < <(echo "$SVN_USER_HOST")

    [ -n "$SVN_HELP" ] && SVN_HELP="cd \"$(dirname "$SVN_PATH")\" && $SVN_HELP $(basename "$SVN_PATH")" \
                       && SVN_HELP="| Try the help :\n${SVN_HELP//?/-}\n$SVN_HELP"

    [ ! -d "$SVN_PATH" ] && _log "Directory not exists:  \"$SVN_PATH\"" && continue

    cmd_1="cd $SVN_PATH && $COMMAND"
    cmd_1="($cmd_1)"

    if   [ -n "$SVN_HOST" ]; then
        cmd_0="ssh $SVN_USER@$SVN_HOST \"$cmd_1\""
    elif [ -n "$SVN_USER" ]; then
    #CZ#cmd_0="su -c \"$cmd_1\" -s /bin/bash - $SVN_USER"
        cmd_0="su -c \"$cmd_1\" - $SVN_USER"
    else
        cmd_0="$cmd_1"
    fi

    ( $SVN_DEBUG ) && printf "%-15s - %-15s - %-30s - %s\n" "|$SVN_USER|" "|$SVN_HOST|" "|$SVN_PATH|" "|$cmd_0|" && continue

    _log "$cmd_0"
    eval "$cmd_0" ; EXITCODE=$?
    [ $EXITCODE -eq 0 ] && echo || { _err "Error! ($EXITCODE)"; _help "$SVN_HELP"; }
#CZ#echo
done
IFS=$IFS_SAVE
#-------------------------------------------------------------------------------
exit $EXITCODE
