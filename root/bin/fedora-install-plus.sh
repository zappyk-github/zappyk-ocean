#!/bin/env bash

PATH_CONFIG=$(dirname "$0")
PATH_INSTALL='/home/zappyk/Installati'

#yum install --nogpgcheck\
# "$PATH_INSTALL/yum-repos/rpmfusion-free-release-stable.noarch.rpm"\
# "$PATH_INSTALL/yum-repos/rpmfusion-nonfree-release-stable.noarch.rpm"\
# "$PATH_INSTALL/yum-repos/adobe-release-i386-1.0-1.noarch.rpm"\
# "$PATH_INSTALL/yum-repos/PlayOnLinux_yum-3.3.rpm"\
# "$PATH_INSTALL/programs/google/google-earth-stable_current_i386.rpm"\
# "$PATH_INSTALL/programs/google/google-musicmanager-beta_current_i386.rpm"\
# "$PATH_INSTALL/programs/google/google-talkplugin_current_i386.rpm"\
# "$PATH_INSTALL/programs/java/jre-6u18-linux-i586.rpm"\
#&& yum update

#yum install\
# fedora-release-rawhide\

#"$PATH_INSTALL/programs/java/alternatives-install-jre.sh" | bash

#yum install --nogpgcheck\
# skype\
# truecrypt\

#yum install\
# mplayer\
# mplayer-common\
# "$PATH_INSTALL/programs/mplayer-codes/mplayer-codecs.rpm"
# "$PATH_INSTALL/programs/mplayer-codes/mplayer-codecs-extra.rpm"\

yum install\
 gpsbabel\
 gpsbabel-gui\
 audacity-freeworld\
 audacity-manual\
 vlc\
 vlc-extras\
 smplayer\
 beesu\
 unison227\
 thunderbird\
 lm_sensors\
 dconf\
 dconf-editor\
 gconf-cleaner\
 gconf-editor\
 vpnc-consoleuser\
 alltray\
 banner\
 p7zip\
 p7zip-plugins\
 vim-X11\
 vim-enhanced\
 gecko-mediaplayer\
 gnome-mplayer\
 gnome-mplayer-common\
 gnome-mplayer-minimal\
 gnome-mplayer-nautilus\
 gnome-shell-extension-mediaplayers\
 gnome-shell-extension-alternate-tab\
 gnome-shell-extension-alternative-status-menu\
 gnome-shell-extension-calc\
 gnome-shell-extension-cpu-temperature\
 gnome-shell-extension-systemMonitor\
 gnome-shell-extension-theme-selector\
 gnome-shell-extension-user-theme\
 gnome-shell-theme-*\
 gnome-applet-alarm-clock\
 gnome-applet-music\
 gnome-applet-netspeed\
 gnome-applet-remmina\
 gnome-applet-sensors\
 gnome-applet-sshmenu\
 gnome-applet-timer\
 gnome-applet-window-picker\
 gnome-documents\
 nautilus-actions\
 nautilus-beesu-manager\
 nautilus-dropbox\
 nautilus-image-converter\
 nautilus-open-terminal\
 nautilus-search-tool\
 nautilus-sound-converter\
 pidgin\
 pidgin-libnotify\
 pidgin-guifications\
 pidgin-latex\
 pidgin-privacy-please\
 pidgin-sipe\
 purple-facebookchat\
 purple-facebookchat\
 purple-microblog\
 purple-msn-pecan\
 purple-plugin_pack\
 purple-plugin_pack-pidgin\
 purple-sipe\
 fbreader-gtk\
 mail-notification\
 pdftk\
 gimp\
 gimp-data-extras\
 AdobeReader_ita\
 adobeair\
 playonlinux\
 flash-plugin\
 gwibber\
 google-chrome-stable\
 googlecl\
 gnome-gmail\
 picasa\
 subversion\
 links\
 html2text\
 html-xml-utils\
 gstreamer-ffmpeg\
 gstreamer-plugins-ugly\
 gstreamer-plugins-bad\
 gstreamer-plugins-bad-free\
 gstreamer-plugins-bad-nonfree\
 gstreamer-plugins-base-tools\
 perl-WWW-Mechanize\
 perl-Crypt-SSLeay\
 openoffice.org-ure\
 openoffice.org-opensymbol-fonts\
 openoffice.org-writer-core\
 openoffice.org-pdfimport\
 openoffice.org-core\
 openoffice.org-draw-core\
 openoffice.org-writer\
 openoffice.org-presenter-screen\
 openoffice.org-math-core\
 openoffice.org-langpack-it\
 openoffice.org-calc\
 openoffice.org-impress-core\
 openoffice.org-calc-core\
 openoffice.org-langpack-en\
 openoffice.org-draw\
 openoffice.org-brand\
 openoffice.org-math\
 openoffice.org-impress\
 openoffice.org-graphicfilter\
 openoffice.org-xsltfilter\
 gtk-recordmydesktop\
 caca-utils\
 zzuf\
 uget\
 uzbl*\
 nmap\
 python-urwid\
 gtraffic\
 iptraf\

yum install\
 hugin\
 autopano-sift-C\
 panoglview\
 jpanoramamaker\

yum install\
 wine\

yum install\
 openshot\

yum install\
 rsnapshot\

yum install\
 sqlite\
 sqliteman\

yum install\
 mysql\
 mysql-server\
 php-gd\
 php-mysql\

########################################
#  Installazione Mailnag mail checker  #
########################################
#$PATH_CONFIG/fedora-install-plus-switch-mailnag.sh

####################################################
#  Installazione switch attiva/disattiva Touchpad  #
####################################################
#$PATH_CONFIG/fedora-install-plus-switch-touchpad.sh

###############################
#  Installazione LibreOffice  #
###############################
#$PATH_CONFIG/fedora-install-plus-LibreOffice.sh "$PATH_INSTALL/programs/LibreOffice" "3.4.2"

######################################################
#  Installazione cups filter per Samsung CLX-3175FN  #
######################################################
#$PATH_CONFIG/fedora-install-plus-printer.sh "$PATH_INSTALL"

#############################################
#  Installazione MythTV linux media center  #
#############################################
#$PATH_CONFIG/fedora-install-plus-MythTV.sh

###################################################
#  Installazione firmware per DVB AVerMedia A309  #
###################################################
#case "$HOSTNAME" in
# zappyk-mc ) cp -iv "$PATH_INSTALL/firmware/dvb-usb-af9015.fw" /lib/firmware/ ;;
#esac

##########################################################################################
#  Installazione firmware per Wireless/Bluetooth ma non fa funzionare bene il Bluetooth  #
##########################################################################################
#case "$HOSTNAME" in
# zappyk-mc |\
# zappyk-ws ) $PATH_CONFIG/fedora-install-plus-nvidia.sh ;;
# zappyk-nb ) $PATH_CONFIG/fedora-install-plus-broadcom-wl.sh ;;
#esac
