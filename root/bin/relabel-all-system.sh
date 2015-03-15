read -p 'Are you sure to relabel all system? [s/N]' answare
[ "$answare" == 's' ] && touch /.autorelabel && reboot
