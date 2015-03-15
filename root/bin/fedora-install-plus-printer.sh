#!/bin/env bash

PATH_INSTALL=$1
PRINTER_NAME='zappyk-lp'

make_cups_printers() {
 cp -iv /etc/cups/printers.conf /etc/cups/printers.conf~ &&\
 cat << _EOD_ >> /etc/cups/printers.conf
<DefaultPrinter $PRINTER_NAME>
AuthInfoRequired none
Info Samsung CLX-3170 (CLX-3175FN)
Location Casa
MakeModel Samsung CLX-3170 Series (SPL-C)
DeviceURI ipp://$PRINTER_NAME:631/ipp
State Idle
StateTime 1294263068
Type 8392780
Filter application/vnd.cups-raw 0 -
Filter application/vnd.cups-postscript 0 rastertosamsungsplc
Filter application/vnd.cups-command 0 commandtops
Accepting Yes
Shared Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy stop-printer
Attribute marker-colors none,none,none,none,none,none,none,none,none
Attribute marker-levels 83,83,83,80,99,99,99,96,99
Attribute marker-names Cyan Color Cartridge S/N:CRUM-00000000000,Magenta Color Cartridge S/N:CRUM-00000000000,Yellow Color Cartridge S/N:CRUM-00000000000,Black Color Cartridge S/N:CRUM-00000000000,Fuser life,Transfer Roller life,Tray1 Pickup Roller life,Imaging Unit life,Image Transfer Belt
Attribute marker-types toner,toner,toner,toner,other,other,other,other,other
Attribute marker-change-time 1294263067
</Printer>
_EOD_
}

copy_cups_filter() {
 cp -iv "$PATH_INSTALL/hardware/Samsung CLX-3175FN/rastertosamsungsplc" /usr/lib/cups/filter
}

copy_cups_ppd() {
 mkdir -p /etc/cups/ppd &&\
 cp -iv "$PATH_INSTALL/hardware/Samsung CLX-3175FN/CLX-3170splc.ppd" /etc/cups/ppd/$PRINTER_NAME.ppd
}

add_printer() {
 make_cups_printers && copy_cups_filter && copy_cups_ppd
}

service cups stop && add_printer && service cups start
