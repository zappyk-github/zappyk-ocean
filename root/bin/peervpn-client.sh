#!/bin/env bash

__PEERVPN__='server'
__PEERVPN__='client'

PEERVPN_run="/etc/peervpn/peervpn-$__PEERVPN__.conf"
PEERVPN_log="/var/log/peervpn-$__PEERVPN__.log"

nohup peervpn "$PEERVPN_run" >"$PEERVPN_log" 2>&1 &

exit
