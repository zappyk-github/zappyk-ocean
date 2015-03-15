#!/bin/env bash

BASENAME=`/bin/basename $0`

CHANNEL=7
SLEEP=0.2
DISPLAY=:0.0
WINDOW=root
COUNT=0

print_usage() {
    echo "Usage:"
    echo "        $BASENAME"
    echo "                 -h | --help"
    echo "                 -c | --channel    <number>	($CHANNEL)"
    echo "                 -s | --sleep      <second>   ($SLEEP)"
    echo "                 -d | --display    <display>  ($DISPLAY)"
    echo "                 -w | --window     <window>   ($WINDOW)"
    echo "                 -f | --files      <files>"
}

print_info() {
    echo ""
    echo "Attention: $1"
    echo ""
    print_usage
}

print_help() {
    print_usage
    echo ""
    echo "Create a sequenzial files png of screen display."
}

while test -n "$1"; do
    case "$1" in
        -h|--help)    print_help ; exit 1 ;;
        -c|--channel) shift ; CHANNEL=$1  ;;
        -s|--sleep)   shift ; SLEEP=$1    ;;
        -d|--display) shift ; DISPLAY=$1  ;;
        -w|--window)  shift ; WINDOW=$1   ;;
        -f|--files)   shift ; FILES=$1    ;;
        *)
            print_info "Unknown argument $1"
            exit 1
            #CZ#OPTIONS="$OPTIONS $1"
            ;;
    esac
    shift
done

echo "Aspetto 3 secondi..." && \
sleep 3

[ -n "$CANALE" ] && \
echo "Cambio canale in $CANALE" && \
chvt $CANALE

while (true); do

    let COUNT=$COUNT+1

    echo -n "Scrivo il file $FILES-$COUNT.png " && \
    import -display $DISPLAY -window $WINDOW -snaps 10 $FILES-$COUNT.png

    echo "Aspetto $SLEEP secondi..." && \
    sleep $SLEEP
done

exit
