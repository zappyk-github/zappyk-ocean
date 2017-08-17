#!/bin/env bash

chroot_path='/var/empty/peervpn-'$1 ; shift

[ ! -e "$chroot_path" ] && echo "peervpn chroot path \"$chroot_path\" not exist!" && exit 1

[ ! -e "$chroot_path"/bin/   ] && mkdir -pv "$chroot_path"/bin/
[ ! -e "$chroot_path"/etc/   ] && mkdir -pv "$chroot_path"/etc/
[ ! -e "$chroot_path"/lib/   ] && mkdir -pv "$chroot_path"/lib/
[ ! -e "$chroot_path"/lib64/ ] && mkdir -pv "$chroot_path"/lib64/
[ ! -e "$chroot_path"/run/   ] && mkdir -pv "$chroot_path"/run/
[ ! -e "$chroot_path"/usr/   ] && mkdir -pv "$chroot_path"/usr/
[ ! -e "$chroot_path"/var/   ] && mkdir -pv "$chroot_path"/var/

case $1 in
    -u) ####################################################
        umount -v "$chroot_path"/bin/
        umount -v "$chroot_path"/etc/
        umount -v "$chroot_path"/lib/
        umount -v "$chroot_path"/lib64/
        umount -v "$chroot_path"/run/
        umount -v "$chroot_path"/usr/
        ;;
    * ) ####################################################
        mount -v --bind -o ro /bin/   "$chroot_path"/bin/
        mount -v --bind -o ro /etc/   "$chroot_path"/etc/
        mount -v --bind -o ro /lib/   "$chroot_path"/lib/
        mount -v --bind -o ro /lib64/ "$chroot_path"/lib64/
        mount -v --bind -o ro /run/   "$chroot_path"/run/
        mount -v --bind -o ro /usr/   "$chroot_path"/usr/
        (cd "$chroot_path"/var && printf "%s: " "$(pwd)" && ln -vfs ../run)
        ;;
esac

exit
