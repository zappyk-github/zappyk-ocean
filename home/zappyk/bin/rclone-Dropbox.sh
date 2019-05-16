#!/bin/env bash

LOCALE_HOME="$HOME"
LOCALE_PATH="$LOCALE_HOME/Dropbox+pes0zap.payroll@rclone/"
REMOTE_PATH="remote:Working/"

BASE_PATH=$(dirname  "$0")
BASE_NAME=$(basename "$0" ".sh")
LOCK_FILE="$BASE_PATH/$BASE_NAME.lock"
LOG__FILE="$BASE_PATH/$BASE_NAME.log"

MSGSYNCOK="Synchronization ok"
MSGSYNCKO="Synchronization must be performed..."

################################################################################
_echo() {
    lsep="____________________"
    line=$* ; [ -n "$line" ] && line="|$line|"
    line="$lsep$line$lsep"
    echo "$line"
}

################################################################################
_rclone_show() {
    _echo ; rclone check "$REMOTE_PATH" "$LOCALE_PATH"
    _echo ; rclone ls    "$REMOTE_PATH"
    _echo ; rclone lsl   "$REMOTE_PATH"
    _echo ; ls -l                       "$LOCALE_PATH"
}

################################################################################
_rclone() {
    cmmd=$1 ; shift
    _echo "$cmmd"
    rclone $cmmd "$@"
}

################################################################################
_rclone_sync() {
    vCheck=true
    vCloud=false
    vLocal=false
    action='copy'
    versus=$1 ; shift
    [ "$versus" == "^" ] && vCloud=true && action='sync'
    [ "$versus" == "." ] && vLocal=true && action='sync'
    [ "$versus" == "-" ] && vCloud=true && vLocal=true

    sync=false
    ( $vCheck ) && sync=true
    ( $vCheck ) && _rclone check   "$REMOTE_PATH" "$LOCALE_PATH" "$@" && sync=false && echo "$MSGSYNCOK" || echo "$MSGSYNCKO"
    if ( $sync ); then
    ( $vCloud ) && _rclone $action "$REMOTE_PATH" "$LOCALE_PATH" "$@"
    ( $vLocal ) && _rclone $action "$LOCALE_PATH" "$REMOTE_PATH" "$@"
    fi
}

################################################################################
_rclone_main() {
    (
    if flock -n 9 ; then
        echo "**********************************························" | tee -a "$LOG__FILE"
        echo ">>> Starting RCLONE upload script: " `date`                 | tee -a "$LOG__FILE"
    #CZ#_rclone_sync "$@" -v --log-file="$LOG__FILE"
    #CZ#_rclone_sync "$@" -v                                              | tee -a "$LOG__FILE"
        _rclone_sync "$@" -v                                          2>&1| tee -a "$LOG__FILE"
        echo "<<< RCLONE upload script finished: " `date`                 | tee -a "$LOG__FILE"
        echo "**********************************························" | tee -a "$LOG__FILE"
    else
        echo "**********************************************************" | tee -a "$LOG__FILE"
        echo "*** RCLONE upload script already running, exiting now! ***" | tee -a "$LOG__FILE"
        echo "**********************************************************" | tee -a "$LOG__FILE"
        exit 1
    fi
    ) 9>"$LOCK_FILE"
}

 _rclone_main "$@"
#_rclone_show

exit

# ::::::::::LINK::::::::::
# https://www.dropbox.com/developers/apps
# https://medium.com/@tegola/backup-home-dir-with-rclone-6289d3372987

# ::::::::::URL::::::::::
# https://www.dropbox.com/1/oauth2/authorize?client_id=5jcck7diasz0rqy&redirect_uri=http%3A%2F%2Flocalhost%3A53682%2F&response_type=code&state=fc804b1a8b6f70682b7bf303231b3689

# ::::::::::CODE::::::::::
# {"access_token":"rK4N1OfE1YAAAAAAAAAAK9FItix2s940-unNmqo4H1OTz-RRIxHZHXL1BMHwCJcW","token_type":"bearer","expiry":"0001-01-01T00:00:00Z"}
# {"access_token":"rK4N1OfE1YAAAAAAAAAALQcq70N26BjF1s6iWDLGhiUQNt8JcUw3Ev_JXC_nmXDj","token_type":"bearer","expiry":"0001-01-01T00:00:00Z"}

# ::::::::::COMMAND::::::::::
# rclone ls    remote:Work
# rclone check remote:Work ~/Dropbox+pes0zap.payroll@rclone/
# rclone sync  remote:Work ~/Dropbox+pes0zap.payroll@rclone/

# ::::::::::?::::::::::
# http://localhost:53682/?state=fc804b1a8b6f70682b7bf303231b3689&code=rK4N1OfE1YAAAAAAAAAAKuBCx75xyzsz6GZzaX0w6aI
# http://localhost:53682/?state=052048a1219a09d4e0a5d90632fa3e98&code=rK4N1OfE1YAAAAAAAAAALFlmZURuNvJ3e0vIFTJPTa8
