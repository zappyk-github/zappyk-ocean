#!/bin/env bash

REMOTE_SERVER=$1  ; [ -z "$REMOTE_SERVER"  ] && echo "$0: remoter server printer?" && exit 1
REMOTE_PRINTER=$2 ; [ -n "$REMOTE_PRINTER" ] && REMOTE_PRINTER='.'

CUPS_REMOTE_SERVER="$REMOTE_SERVER:631"
PROT_REMOTE_SERVER="ipp://$REMOTE_SERVER/printers"

LIST_REMOTE_PRINTER="lpstat -h $CUPS_REMOTE_SERVER -a | grep 'accepting' | grep -i '$REMOTE_PRINTER' | cut -d ' ' -f 1"

for printer in $(eval "$LIST_REMOTE_PRINTER"); do
    echo "lpadmin -p $printer -v $PROT_REMOTE_SERVER/$printer"
    echo "cupsenable $printer"
    echo "cupsaccept $printer"
done

exit
