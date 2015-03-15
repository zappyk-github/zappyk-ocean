#!/bin/env bash

PGREP_USERS=''
NOTIFY_TIME=''
NOTIFY_ICON=''
NOTIFY_BEEP=false
SOUNDS_BEEP=''
NOTIFY_LEVEL=''
NOTIFY_TITLE=''
NOTIFY_MESSAGE=''

CHAR_STDIN='-'
READ_STDIN=false

ICON_LOW=gtk-dialog-info
ICON_NORMAL=gtk-dialog-warning
ICON_CRITICAL=gtk-dialog-error

PGREP_SESSION='gnome-panel'   # for Gnome 2
PGREP_SESSION='gnome-session' # for Gnome 3

_help() {
    local message=$1
    cat << _EOD_
Usage:
        $0
          [ -u  <utente>                ]    Notifica solo all’utente selezionato. (se non specificato la notifica viene inviata a tutti gli utenti attualmente attivi con DE GNOME)
          [ -l  low | normal | critical ]    Seleziona il livello di informazione del messaggio, in base a quello impostato, cambia l’icona. (default e' low)
          [ -s  <tempo>                 ]    Tempo di visualizzazione, in millisecondi, del messaggio.
          [ -i  <icona>                 ]    Icona di visualizzazione.
          [ -b                          ]    Riproduce un suono.
          [ -bs <sounds-beep>           ]    Specifica il file audio per il suono da riprodurre.
            -t  <titolo>                     Titolo del messaggio.
            -m  <messaggio>                  Testo del messaggio (specifica '$CHAR_STDIN' per lettura dall STDIN).
_EOD_
    [ -z "$message" ] && echo -e "\nMessage: $message"
}

_set() {
    local pid=$1
    local string=$2

    strings /proc/$pid/environ | grep "^$string" | sed "s/^$string//"
}

_notify() {
    COMMANDS="notify-send $NOTIFY_TIME $NOTIFY_ICON $NOTIFY_LEVEL -- \"$NOTIFY_TITLE\" \"$NOTIFY_MESSAGE\""
    echo "$VARIABLE $COMMANDS"
    eval "$VARIABLE $COMMANDS"
}

_notify_old() {
    while read PID; do
        VARIABLE="DBUS_SESSION_BUS_ADDRESS=\"`_set "$PID" 'DBUS_SESSION_BUS_ADDRESS='`\""
        _notify
    done < <(pgrep $PGREP_USERS $PGREP_SESSION)
}

_notify_new() {
    VARIABLE='DISPLAY=:0'
    _notify
}

_notify_beep() {
    if ( $NOTIFY_BEEP ); then
        local commands="play '$SOUNDS_BEEP'"
        echo "$commands"
        eval "$commands"
    fi
}

[ -z "$*" ] && _help && exit 1
while test -n "$1"; do
    case "$1" in
        -h  ) _help ; exit ;;
        -u  ) PGREP_USERS="$2"    ; shift ;;
        -s  ) NOTIFY_TIME="$2"    ; shift ;;
        -i  ) NOTIFY_ICON="$2"    ; shift ;;
        -b  ) NOTIFY_BEEP=true            ;;
        -bs ) NOTIFY_BEEP=true
              SOUNDS_BEEP="$2"    ; shift ;;
        -l  ) NOTIFY_LEVEL="$2"   ; shift ;;
        -t  ) NOTIFY_TITLE="$2"   ; shift ;;
        -m  ) NOTIFY_MESSAGE="$2" ; shift ;;
        *   ) _help ; echo "Option '$1' unknown" ; exit 1 ;;
    esac
    shift
done

[ -z "$NOTIFY_TITLE" ] && _help 'non hai specificato il titolo del messaggio.' && exit 1

[ "$NOTIFY_MESSAGE" == "$CHAR_STDIN" ] && READ_STDIN=true
( $READ_STDIN ) && while read line; do NOTIFY_MESSAGE="$NOTIFY_MESSAGE$line\n"; done; NOTIFY_MESSAGE=`echo -e "$NOTIFY_MESSAGE"`

if [ -z "$NOTIFY_ICON" ]; then
case $NOTIFY_LEVEL in
    low      ) NOTIFY_ICON=$ICON_LOW ;;
    normal   ) NOTIFY_ICON=$ICON_NORMAL ;;
    critical ) NOTIFY_ICON=$ICON_CRITICAL ;;
    *        ) NOTIFY_ICON=$ICON_LOW
               NOTIFY_LEVEL='low' ;;
esac
fi

if ( $NOTIFY_BEEP ); then
if [ -z "$SOUNDS_BEEP" ]; then
case $NOTIFY_LEVEL in
    low      ) SOUNDS_BEEP='/usr/share/sounds/freedesktop/stereo/dialog-information.oga' ;;
    normal   ) SOUNDS_BEEP='/usr/share/sounds/freedesktop/stereo/dialog-warning.oga' ;;
    critical ) SOUNDS_BEEP='/usr/share/sounds/freedesktop/stereo/dialog-error.oga' ;;
esac
fi
fi

[ -n "$PGREP_USERS"  ] && PGREP_USERS="-u $PGREP_USERS"
[ -n "$NOTIFY_TIME"  ] && NOTIFY_TIME="-t $NOTIFY_TIME"
[ -n "$NOTIFY_ICON"  ] && NOTIFY_ICON="-i $NOTIFY_ICON"
[ -n "$NOTIFY_LEVEL" ] && NOTIFY_LEVEL="-u $NOTIFY_LEVEL"

VARIABLE=''
COMMANDS="notify-send $NOTIFY_TIME $NOTIFY_ICON $NOTIFY_LEVEL -- \"$NOTIFY_TITLE\" \"$NOTIFY_MESSAGE\""

# for Gnome 2/3:
_notify_old

#CZ## for Gnome 3:
#CZ#_notify_new

_notify_beep

exit
