#!/bin/env bash

WINE_RUN='wine'
WINE_RUN='wine64'

NAME_PROG='ça_bouge'
FILE_EXEC='activebook.exe'
WINE_PATH="$HOME/.wine-$NAME_PROG"
DIR_MOUNT="$HOME/$NAME_PROG"
ISO_MOUNT="$HOME/$NAME_PROG.iso"
ISO_LABEL='9788861611054A'
DVD_MOUNT="/run/media/$USER/$ISO_LABEL"

if [ -e "$ISO_MOUNT" ]; then
    [ ! -d "$DIR_MOUNT" ] && mkdir -p    "$DIR_MOUNT"
    [   -d "$DIR_MOUNT" ] && sudo umount "$DIR_MOUNT"
                             sudo mount  "$ISO_MOUNT" "$DIR_MOUNT"
else
    DIR_MOUNT="$DVD_MOUNT"
fi

cd "$DIR_MOUNT" && WINEPREFIX=$WINE_PATH wine "$FILE_EXEC"

exit
