#!/usr/bin/env bash

this=`basename $0`

rotate=$1
case "$rotate" in
    '-' ) xrandr --orientation normal   ; exit ;;
    '^' ) xrandr --orientation inverted ; exit ;;
    '>' ) xrandr --orientation right    ; exit ;;
    '<' ) xrandr --orientation left     ; exit ;;
esac

wait=10
exec='eval'

action_normal='visualizza-normale'
action_inverted='visualizza-invertito'
action_left='rotazione-sinistra'
action_right='rotazione-destra'
action_select="TRUE $action_normal FALSE $action_inverted FALSE $action_left FALSE $action_right"

selection=`zenity --display=:0.0 --width=200 --height=220 --list --radiolist --title='Orientamento monitor' --text="Selezionare l'orientamento..." --column '' --column 'Orientamento:' $action_select`
direction=''
case "$selection" in
    $action_normal   ) direction='normal'   ;;
    $action_inverted ) direction='inverted' ;;
    $action_left     ) direction='left'     ;;
    $action_right    ) direction='right'    ;;
esac

exitcode=0

if [ -n "$direction" ]; then
    $exec "xrandr --orientation $direction"; exitcode=$?

    return=100

    rc=''
    { for i in `seq 1 $wait`; do echo "100*$i/$wait" | bc; echo $rc; sleep 1; done; } \
    | rc=`zenity --display=:0.0 --width=500 --height=100 --progress --title="Orientamento '$selection' eseguito... ($exitcode)" --text='Tornare alle impostazioni precedenti?' --percentage=0 --auto-close` \
    && { exitcode=$return; $exec "xrandr --orientation normal"; }

    if   [ $exitcode -eq 0       ]; then zenity --display=:0.0 --width=500 --height=100 --info    --text="Orientamento '$selection' eseguito"
    elif [ $exitcode -eq $return ]; then zenity --display=:0.0 --width=500 --height=100 --warning --text="Orientamento '$selection' annullato"
                                    else zenity --display=:0.0 --width=500 --height=100 --error   --text="Orientamento '$selection' NON eseguito!"
    fi
fi

exit $exitcode
