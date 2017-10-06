#!/bin/env bash

test=false ; DELUGE_BASE='/var/opt/deluge/var/completed/'

THIS_FILE=$0
THIS_NAME=$(basename "$THIS_FILE" '.sh')
THIS_PATH=$(dirname  "$THIS_FILE")
THIS_PATH=$(cd "$THIS_PATH" && pwd)
THIS_FILE="$THIS_PATH/$THIS_NAME"

CMMD_MAIL=$(which mail)     # mailx.x86_64.rpm
CMMD_MAIL=$(which mailsend) #
CMMD_XMPP=$(which sendxmpp) # sendxmpp.noarch.rpm

#[ -z "$CMMD_MAIL" ] && echo "Pacchetto mailx.x86_64.rpm non installato..." && exit 1
 [ -z "$CMMD_XMPP" ] && echo "Pacchetto sendxmpp.noarch.rpm non installato..." && exit 1

################################################################################
    FILE_tID_=$1                              # f28c4e754f19816a7a61d42ac30b2b6bb90a820f
    FILE_NAME=$2                              # Jobs.2013.BDRip.x264-COCAIN[rarbg]
    FILE_PATH=$3                              # /var/opt/deluge/var/completed/
    PATH_NAME="$FILE_PATH/$FILE_NAME"
#===============================================================================
if [ -n "$FILE_tID_" ] \
&& [ -n "$FILE_NAME" ] \
&& [ -n "$FILE_PATH" ] \
&& [ -e "$PATH_NAME" ]; then
    PATH_BASE_DOWNLOADS=$(dirname "$FILE_PATH")
    PATH_BASE_DELUGEDIR=$(dirname "$PATH_BASE_DOWNLOADS")
    PATH_BASE_COMPLETED=$PATH_NAME
    PATH_BASE_INCOMINGS=$PATH_BASE_DOWNLOADS/incomings
    FILE_LOGS_COMPLETED=$PATH_BASE_DELUGEDIR/log/$THIS_NAME.log
    FILE_FIND_COMPLETED="ls -d \"$PATH_BASE_COMPLETED\" 2>/dev/null"
    TIME_FIND_COMPLETED=180
    TIME_FIND_TRY_AGAIN=1
else
#CZ#PATH_BASE_DOWNLOADS=${1-${DELUGE_BASE-.}} ; PATH_BASE_DOWNLOADS=$(cd -P "$PATH_BASE_DOWNLOADS" && pwd)
    PATH_BASE_DOWNLOADS=$(dirname "$FILE_PATH")
#CZ#PATH_BASE_DELUGEDIR=
    PATH_BASE_DELUGEDIR=$(dirname "$PATH_BASE_DOWNLOADS")
#CZ#PATH_BASE_COMPLETED=${2-$PATH_BASE_DOWNLOADS/completed}
    PATH_BASE_COMPLETED=$PATH_NAME
#CZ#PATH_BASE_INCOMINGS=${3-$PATH_BASE_DOWNLOADS/incomings}
    PATH_BASE_INCOMINGS=$PATH_BASE_DOWNLOADS/incomings
#CZ#FILE_LOGS_COMPLETED=/dev/null
    FILE_LOGS_COMPLETED=$PATH_BASE_DELUGEDIR/log/$THIS_NAME.log
#CZ#FILE_FIND_COMPLETED="ls -d \"$PATH_BASE_COMPLETED\"/* 2>/dev/null | xargs -0 -i echo \"{}\""
    FILE_FIND_COMPLETED="ls -d \"$PATH_BASE_COMPLETED\" 2>/dev/null"
    TIME_FIND_COMPLETED=${4-60}
    TIME_FIND_TRY_AGAIN=${5-300}
fi
################################################################################

 CMMD_MOVE='mv -bv'
 CMMD_MOVE='mv -b'
 CMMD_MOVE='mv -f'
#CMMD_MOVE='echo'

################################################################################
_exc() { ( $test ) && echo "$*" || eval "$*"; }
_now() { date +'%F %T'; }
_tag() { printf "%s [%-5s| " "$(_now)" "$$"; }
_row() { printf "$@"; }
_lIl() { _tag && _row "$@"; }
_lpl() {         _row "$@"; }
_lDl() {         _row "$@" && echo; }
_log() { _tag && _row "$@" && echo; }
_nsm() { ( $test ) && return
    local names="$@"
    local count=$(echo -e "$names" | grep -v "^$" | wc -l)
#CZ#local tdate=$(date -R)
#CZ#local tdate=$(date --rfc-3339=seconds)
    local tdate=$(_now)
    #___________________________________________________________________________
    #
    local signin="\n\nhost: $(uname -n) ($(uname -m))\n$(df -H /)"
    local notify="zappyk@gmail.com"
    local string="Completed files are:\n$names\nDone.$signin"
    #___________________________________________________________________________
    #
    local mail__to_=$notify
    local mail_mssg=$string
    local mail_subj="Deluge $count files completed download [$tdate]"
    local mail_from="zappyk@zappyk-rp"
    local mail_cmmd=$CMMD_MAIL
    local mail_cmmd="$(which $mail_cmmd)"

#CZ#echo -e "$mail_mssg" | eval "$mail_cmmd -s \"$mail_subj\" -r $mail_from    $mail__to_"
#CZ#echo -e "$mail_mssg" | eval "$mail_cmmd -s \"$mail_subj\" -f $mail_from -t $mail__to_"
    echo -e "$mail_mssg" | eval "$mail_cmmd -s \"$mail_subj\"               -t $mail__to_"
    #___________________________________________________________________________
    #
    local xmpp__to_=$notify
    local xmpp_mssg=$string
    local xmpp_from="zappyk.notice"
    local xmpp_cmmd=$CMMD_XMPP
    local xmpp_cmmd="perl -X $(which $xmpp_cmmd)"

    echo -e "$xmpp_mssg" | eval "$xmpp_cmmd -t -u $xmpp_from $xmpp__to_"
    #___________________________________________________________________________
}
################################################################################
main() {
    loop=true
    while $loop; do

        _log "Find files, execute command: \"$FILE_FIND_COMPLETED\""
        files=$(eval "$FILE_FIND_COMPLETED")
        names="\n"

        if [ -n "$files" ]; then
            loop=false
            _log "Exec: $CMMD_MOVE $files $PATH_BASE_INCOMINGS"
            _log "Sync files, wait $TIME_FIND_COMPLETED seconds to complete..." && sleep $TIME_FIND_COMPLETED && sync
            IFS=$'\n'
            for file in $files; do
                name=$(basename "$file")
                move="$CMMD_MOVE \"$file\" \"$PATH_BASE_INCOMINGS\""
                _log "* $move"
    	        eval   "$move" && names="$names * save * $name\n" \
                               || names="$names # FAIL # $name\n"
            done
            _lIl "Syncronize for complete files move... " && sync          && _lDl "done!"
            _lIl "Notify mail for completed download... " && _nsm "$names" && _lDl "done!"
            _log "Exec: done."
        else
            _log "...sleep $TIME_FIND_TRY_AGAIN seconds, check on \"$PATH_BASE_COMPLETED\", move to \"$PATH_BASE_INCOMINGS\"" && sleep $TIME_FIND_TRY_AGAIN
        fi
    done
    _log "________________________________________________________________________________________________________________________"
    _log ""
}

main 2>&1 | stdbuf -oL tee -a "$FILE_LOGS_COMPLETED"

exit
