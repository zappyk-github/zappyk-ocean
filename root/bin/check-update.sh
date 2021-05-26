#!/bin/env bash

 rpm-list.sh

 dnf-list.sh

 dnf check-update

#read -p '========== processo terminato, premi un pulsante per chiudere ==========' answare
 read -p '========== premi un pulsante per chiudere, "s" per aggiornare ==========' answare
[ "$answare" == "s" ] && {
 dnf update
 read -p '========== processo terminato, premi un pulsante per chiudere =========='
}

exit
