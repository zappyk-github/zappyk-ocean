#!/bin/env bash

chroot_path='/var/empty/peervpn-'$1

[ ! -e "$chroot_path" ] && echo "peervpn chroot path \"$chroot_path\" not exist!" && exit 1

[ ! -e "$chroot_path"/bin/ ] && mkdir -pv "$chroot_path"/bin/
[ ! -e "$chroot_path"/etc/ ] && mkdir -pv "$chroot_path"/etc/
[ ! -e "$chroot_path"/lib/ ] && mkdir -pv "$chroot_path"/lib/
[ ! -e "$chroot_path"/usr/ ] && mkdir -pv "$chroot_path"/usr/

case $1 in
    -u) ####################################################
        umount "$chroot_path"/bin/ \
               "$chroot_path"/etc/ \
               "$chroot_path"/lib/ \
               "$chroot_path"/usr/
        ;;
    * ) ####################################################
        mount --bind -o ro /bin/ "$chroot_path"/bin/
        mount --bind -o ro /etc/ "$chroot_path"/etc/
        mount --bind -o ro /lib/ "$chroot_path"/lib/
        mount --bind -o ro /usr/ "$chroot_path"/usr/
        ;;
esac

exit
