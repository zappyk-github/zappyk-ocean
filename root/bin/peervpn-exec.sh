#!/bin/env bash

PEERVPN_tag=$(basename "$0")
PEERVPN_run="/etc/peervpn/$PEERVPN_tag.conf"
PEERVPN_log="/var/log/$PEERVPN_tag.log"

nohup peervpn "$PEERVPN_run" >"$PEERVPN_log" 2>&1 &

exit
