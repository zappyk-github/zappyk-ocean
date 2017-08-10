#!/bin/env bash

PEERVPN_tag=$(basename "$0")
PEERVPN_run="/etc/peervpn/$PEERVPN_tag.conf"
PEERVPN_log="/var/log/$PEERVPN_tag.log"
PEERVPN_slp=3

[ "$PEERVPN_tag" == "peervpn-1-client" ] && echo "Preparetion to bind mount chroot's diretcories..." && peervpn-root-chroot.sh 1

echo -e "Start peervpn $PEERVPN_tag \c"

nohup peervpn "$PEERVPN_run" >"$PEERVPN_log" 2>&1 &

for i in $(seq 1 $PEERVPN_slp); do echo -e ".\c"; sleep 1; done; echo

exit
