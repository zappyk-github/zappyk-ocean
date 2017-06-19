#!/bin/env bash

chroot_path='/var/empty/peervpn'

case $1 in
    -u) ####################################################
        umount "$chroot_path"/bin/  \
               "$chroot_path"/etc/  \
               "$chroot_path"/lib/  \
               "$chroot_path"/usr/  \
               "$chroot_path"/sbin/ \
               "$chroot_path"/var/run/
        ;;
    * ) ####################################################
        mount --bind -o ro /bin/     "$chroot_path"/bin/
        mount --bind -o ro /etc/     "$chroot_path"/etc/
        mount --bind -o ro /lib/     "$chroot_path"/lib/
        mount --bind -o ro /usr/     "$chroot_path"/usr/
        mount --bind -o ro /sbin/    "$chroot_path"/sbin/
        mount --bind -o ro /var/run/ "$chroot_path"/var/run/
        ;;
esac

exit
