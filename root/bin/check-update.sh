#!/bin/env bash
################################################################################

#rpm-list.sh

 dnf-list.sh

 dnf check-update ; rt=$? ; echo $rt

################################################################################
if [ $rt -eq 0 ]; then
    read -p '========== processo terminato, premi un pulsante per chiudere ==========' answare
fi

if [ $rt -eq 100 ]; then
    read -p '========== premi un pulsante per chiudere, "s" per aggiornare ==========' answare
    [ "$answare" == "s" ] && {
        dnf -y update ; rt=$? ; echo $rt
        echo    '========== processo terminato, premi un pulsante per chiudere'
        read -p '                               o "r" per ripetere il processo ==========' answare
        [ "$answare" == "r" ] && $0
    }
fi
################################################################################

exit
