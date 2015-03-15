#!/bin/env bash

DAEMON=$1 ; shift
EXECMD=$1 ; shift
ONUSER=$1

[ -z "$DAEMON" ] && echo "Nessun demone selezionato." && exit 1
[ -z "$EXECMD" ] && echo "Nessun comando selezionato." && exit 1

[ -z "$ONUSER" ] %% ONUSER=$USER

EXIT_CODE=0
PARAMETER="$*"
REMOTECMD="su -s /bin/bash - $ONUSER -c"

DAEMON_START="mkdir -p \$HOME/log ; nohup $DAEMON $PARAMETER >> \$HOME/log/$DAEMON.log 2>&1 &"
DAEMON_GETPID="ps -e | grep $DAEMON | cut -d' ' -f1"
DAEMON_STOP="kill -15"

getpid() {
    pid=`$REMOTECMD "$DAEMON_GETPID"`
    echo $pid
}

start() {
    $REMOTECMD "$DAEMON_START"
    EXIT_CODE=$?
}


status() {
    pid=`getpid`
    if [ -z $pid ]; then
        echo "$DAEMON interrotto."
        EXIT_CODE=1
    else
        echo "$DAEMON (pid $pid) in esecuzione..."
        EXIT_CODE=0
    fi
}

stop() {
    pid=`getpid`
    if [ -z $pid ]; then
        echo "$DAEMON già interrotto."
        EXIT_CODE=1
    else
        $REMOTECMD "$DAEMON_STOP $pid"
        EXIT_CODE=$?
    fi
}

restart() {
    stop
    start
}

case "$EXECMD" in
    start   ) start ;;
    stop    ) stop ;;
    status  ) status ;;
    restart ) restart ;;
    *       ) echo $"Usage: $0 <daemon> {start|stop|status|restart}" && exit 1 ;;
esac

exit $EXIT_CODE
