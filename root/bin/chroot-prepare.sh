#!/bin/env bash

CHROOT_BASE='/chroot'
CHROOT_OWNER='zappyk'
CHROOT_GROUP='zappyk'

_die()   { echo "$*" && exit 1; }
_warn()  { echo "$*" && continue; }
_init()  { mkdir -p "$CHROOT_BASE" && cd "$CHROOT_BASE" || _die "Not create chroot dir '$CHROOT_BASE'"; }
_chown() { chown -R "$CHROOT_OWNER:$CHROOT_GROUP" *; }
_rsync() {
	for file in $*; do
		[ "${file:0:1}" != '/' ] && return 1
		dirname=`dirname "$file"`
		mkdir -p "./$dirname" && rsync -ra "$file" "./$file" || _warn "chroot $file not execute!"
		printf "chroot %-50s ok\n" "$file ..."
	done
}

_init

_rsync /bin/*

_rsync /lib/ld[.-]*
_rsync /lib/libc[.-]*
_rsync /lib/libm[.-]*
_rsync /lib/libdl[.-]*
_rsync /lib/librt[.-]*
_rsync /lib/libcap[.-]*
_rsync /lib/libacl[.-]*
_rsync /lib/libattr[.-]*
_rsync /lib/libuuid[.-]*
_rsync /lib/libexpat[.-]*
_rsync /lib/libtinfo[.-]*
_rsync /lib/libgcc_s[.-]*
_rsync /lib/libasound[.-]*
_rsync /lib/libpthread[.-]*
_rsync /lib/libselinux[.-]*

_rsync /usr/lib/libXi[.-]*
_rsync /usr/lib/libXv[.-]*
_rsync /usr/lib/libSM[.-]*
_rsync /usr/lib/libXau[.-]*
_rsync /usr/lib/libICE[.-]*
_rsync /usr/lib/libXss[.-]*
_rsync /usr/lib/libX11[.-]*
_rsync /usr/lib/libxcb[.-]*
_rsync /usr/lib/libXext[.-]*
_rsync /usr/lib/libXdmcp[.-]*
_rsync /usr/lib/libstdc++[.-]*
_rsync /usr/lib/libXrandr[.-]*
_rsync /usr/lib/libXfixes[.-]*
_rsync /usr/lib/libXrender[.-]*
_rsync /usr/lib/libXcursor[.-]*
_rsync /usr/lib/libXinerama[.-]*
_rsync /usr/lib/libfreetype[.-]*
_rsync /usr/lib/libxcb-xlib[.-]*
_rsync /usr/lib/libfontconfig[.-]*

#_chown
