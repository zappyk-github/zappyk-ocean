#!/bin/env bash

cat << _EOD_ && read
+--------------------------------------------------------------------------+
|                                                                          |
|    Da provare sul server che esce su Internet pulito.                    |
|                                                                          |
|    Provare da andromeda.payroll oppure da pls.payroll (misc.payroll?)    |
|                                                                          |
+--------------------------------------------------------------------------+
_EOD_

read -p "Immetti l'indirizzo IP: "      ip_address
read -p "Immetti la sequenza tok-tok: " _knocking_

[ -z "$ip_address" ] && ip_address='88.149.182.140'
[ -z "$_knocking_" ] && _knocking_='51973,51008,51975,51228,52004,51128'
                        sleep_time='1s'

nmap -p T:$_knocking_ -r $ip_address --scan-delay $sleep_time

exit
