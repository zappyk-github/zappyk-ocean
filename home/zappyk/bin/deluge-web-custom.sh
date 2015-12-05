#!/bin/env bash

CMDRUN_ROOT=true ; [ $(id -u) -ne 0 ] && CMDRUN_ROOT=false

DELUGE_USER='zappyk'
DELUGE_BASE='/var/opt/deluge'
DELUGE_LOGS="$DELUGE_BASE/log"
TWONKY_EXEC="$HOME/Programmi/twonky/twonky.sh start"

export DELUGE_USER DELUGE_BASE

SUDOCOMMAND='sudo '
SU_USER_CMD="su - $DELUGE_USER -c"

################################################################################
                    SYSTEM_INIT_LOG=''
                    SYSTEM_INIT_CMD='init 3'
                    SYSTEM_INIT_RUN="$SUDOCOMMAND$SYSTEM_INIT_CMD"
( $CMDRUN_ROOT ) && SYSTEM_INIT_RUN="$SYSTEM_INIT_CMD"

################################################################################
                    SYSTEM_IFCONFIG_LOG=''
                    SYSTEM_IFCONFIG_CMD='ifconfig wlan0 down'
                    SYSTEM_IFCONFIG_CMD='ifconfig wlp3s0 down'
                    SYSTEM_IFCONFIG_RUN="$SUDOCOMMAND$SYSTEM_IFCONFIG_CMD"
( $CMDRUN_ROOT ) && SYSTEM_IFCONFIG_RUN="$SYSTEM_IFCONFIG_CMD"

################################################################################
                    DELUGE_DAEMON_LOG='deluge-daemon.log'
                    DELUGE_DAEMON_CMD='deluged -p 58846 -L info'
                    DELUGE_DAEMON_CMD='deluged -p 58846 -L info -d'
                    DELUGE_DAEMON_RUN="cd $DELUGE_BASE && nohup $DELUGE_DAEMON_CMD >$DELUGE_LOGS/$DELUGE_DAEMON_LOG 2>&1 &"
( $CMDRUN_ROOT ) && DELUGE_DAEMON_RUN="$SU_USER_CMD \"$DELUGE_DAEMON_RUN\""

################################################################################
                    DELUGE_WEB_LOG='deluge-web.log'
                    DELUGE_WEB_CMD='deluge-web -p 8112 --no-ssl -L info'
                    DELUGE_WEB_RUN="cd $DELUGE_BASE && nohup $DELUGE_WEB_CMD >$DELUGE_LOGS/$DELUGE_WEB_LOG 2>&1 &"
( $CMDRUN_ROOT ) && DELUGE_WEB_RUN="$SU_USER_CMD \"$DELUGE_WEB_RUN\""

################################################################################
                    DELUGE_MOVE_LOG='deluge-execute-command-completed.log'
                    DELUGE_MOVE_CMD='deluge-execute-command-completed.sh'
                    DELUGE_MOVE_RUN="cd $DELUGE_BASE && nohup $DELUGE_MOVE_CMD >$DELUGE_LOGS/$DELUGE_MOVE_LOG 2>&1 &"
( $CMDRUN_ROOT ) && DELUGE_MOVE_RUN="$SU_USER_CMD \"$DELUGE_MOVE_RUN\""

################################################################################
_eval() { echo "${1//?/#}"; echo "$1"; }
################################################################################
_systemctl() {
    local command=$1 ; shift
    local actions=$@
    local cmdsudo=$SUDOCOMMAND
    local cmdbash=''

    ( $CMDRUN_ROOT ) && cmdsudo=

    for action in $actions; do
        [ -n "$cmdbash" ] && cmdbash="${cmdbash} && "
                             cmdbash="${cmdbash}${cmdsudo}systemctl $action $command"
    done

    _eval "$cmdbash"
}

##==============================================================================
 #_eval "$SYSTEM_INIT_RUN"
##------------------------------------------------------------------------------
  _eval "$SYSTEM_IFCONFIG_RUN"
##------------------------------------------------------------------------------
  _systemctl firewalld stop status
##------------------------------------------------------------------------------
 #_systemctl deluge-daemon.service restart status
  _systemctl deluge-daemon.service stop status
##------------------------------------------------------------------------------
##_systemctl deluge-web.service restart status
 #_systemctl deluge-web-custom.service link restart status
##------------------------------------------------------------------------------
  _eval "$DELUGE_DAEMON_RUN"
  _eval "$DELUGE_WEB_RUN"
 #_eval "$DELUGE_MOVE_RUN"
##==============================================================================
   eval "$TWONKY_EXEC"
##==============================================================================

exit
