user='root'
[ "$(whoami)" != "$user" ] && echo "Not valid user $(whoami); try with $user!" && exit 1
cd /var/www/lighttpd/temp && /home/zappyk/bin/raspberry-temp-check-on-raspiX.sh
