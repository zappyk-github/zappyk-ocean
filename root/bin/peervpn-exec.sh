#!/bin/env bash

PEERVPN_tag=$(basename "$0")
PEERVPN_ifc="peervpn$(echo "$PEERVPN_tag" | cut -d'-' -f2)"
PEERVPN_run="/etc/peervpn/$PEERVPN_tag.conf"
PEERVPN_log="/var/log/$PEERVPN_tag.log"
PEERVPN_slp=20

[ "$PEERVPN_tag" == "peervpn-1-client" ] && echo "Preparetion to bind mount chroot's diretcories..." && peervpn-root-chroot.sh 1 client | sed 's/^/\t/g'
[ "$PEERVPN_tag" == "peervpn-2-client" ] && echo "Preparetion to bind mount chroot's diretcories..." && peervpn-root-chroot.sh 2 client | sed 's/^/\t/g'

echo -e "Start peervpn $PEERVPN_tag \c" && { nohup peervpn "$PEERVPN_run" >"$PEERVPN_log" 2>&1 & }

for i in $(seq 1 $PEERVPN_slp); do echo -e ".\c"; sleep 1; done; echo

echo "________________________________________________________________________________"
tail "$PEERVPN_log"

echo "________________________________________________________________________________"
ifconfig "$PEERVPN_ifc"

exit
