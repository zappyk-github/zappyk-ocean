#!/bin/env bash

NAME_VERSION='0.3'
NAME_PACKAGE='mailnag'

PATH_INSTALL="/usr/share/$NAME_PACKAGE"
PATH_PACKAGE="/opt/$NAME_PACKAGE"

NAME_INSTALL="$NAME_PACKAGE-$NAME_VERSION"
FILE_PACKAGE="$NAME_INSTALL.tar.gz"
FILE_INSTALL="https://github.com/downloads/pulb/mailnag/$FILE_PACKAGE"
LINK_PACKAGE="$PATH_PACKAGE-$NAME_VERSION"

yum install\
 pyxdg\
 notify-python\
 gnome-python2-gnomekeyring\
 python-httplib2\
 pygtk2\
 pygobject2\
 alsa-utils\
&& wget -c "$FILE_INSTALL"\
\
&& mkdir -vp "$LINK_PACKAGE"\
&& tar -zxvf "$FILE_PACKAGE" -C "$LINK_PACKAGE" && chown -vR root:root "$LINK_PACKAGE"\
&& ln -vfsn "$NAME_INSTALL" "$PATH_PACKAGE"\
\
&& mkdir -vp "$PATH_INSTALL"\
&& ln -vfsn "$PATH_PACKAGE/mailnag_config"              "$PATH_INSTALL"\
&& ln -vfsn "$PATH_PACKAGE/data/mailnag.svg"            "$PATH_INSTALL"\
&& ln -vfsn "$PATH_PACKAGE/data/mailnag_config.desktop" "$PATH_INSTALL" && chmod -v +x "$PATH_PACKAGE/data/mailnag_config.desktop"\
