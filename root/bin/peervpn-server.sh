#!/bin/env bash

__PEERVPN__='client'
__PEERVPN__='server'

PEERVPN_run="/etc/peervpn/peervpn-$__PEERVPN__.conf"
PEERVPN_log="/var/log/peervpn-$__PEERVPN__.log"

nohup peervpn "$PEERVPN_run" >"$PEERVPN_log" 2>&1 &

exit
