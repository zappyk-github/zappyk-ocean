#!/bin/env bash

PATH_BASE="$HOME/.local/share/gnome-shell"
PATH_EXTE="$PATH_BASE/extensions"

if [ -d "$PATH_BASE" ];
    [ ! -d "$PATH_EXTE" ] && mkdir "$PATH_EXTE"
else
    echo "Gnome Shell path not found [$PATH_BASE]"
    exit
fi

#git clone https://github.com/anduchs/audio-output-switcher.git "$PATH_EXTE/audio-output-switcher@anduchs"
 git clone https://github.com/AndresCidoncha/audio-switcher.git "$PATH_EXTE/audio-switcher@AndresCidoncha"

echo "____________________________________________________________________________________________________________"
echo "Then restart the gnome-shell via ALT+F2, typing in the box r and enable the extension using gnome-tweak-tool"
