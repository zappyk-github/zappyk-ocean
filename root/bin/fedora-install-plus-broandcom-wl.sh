#!/bin/env bash

PATH_CONFIG=$(dirname "$0")

#----------------+
#  metodo nuovo  |
#----------------+
yum install akmod-wl.i686 kmod-wl.i686

#======================================================================================================================================================================
# Pacchetto                                        Arch                      Versione                               Repository                                    Dim.
#======================================================================================================================================================================
#Installazione:
# akmod-wl                                         i686                      5.60.48.36-2.fc14.1                    rpmfusion-nonfree                            1.7 M
# kmod-wl                                          i686                      5.60.48.36-2.fc14.6                    rpmfusion-nonfree-updates                    8.7 k
#Installazioni per dipendenze:
# akmods                                           noarch                    0.3.6-3.fc12                           rpmfusion-free                                16 k
# broadcom-wl                                      noarch                    5.60.48.36-1.fc13                      rpmfusion-nonfree                             13 k
# cloog-ppl                                        i686                      0.15.7-2.fc14                          fedora                                        93 k
# cpp                                              i686                      4.5.1-4.fc14                           fedora                                       3.7 M
# fakeroot                                         i686                      1.12.4-2.fc14                          fedora                                        74 k
# fakeroot-libs                                    i686                      1.12.4-2.fc14                          fedora                                        23 k
# gcc                                              i686                      4.5.1-4.fc14                           fedora                                        12 M
# glibc-devel                                      i686                      2.12.90-21                             updates                                      968 k
# glibc-headers                                    i686                      2.12.90-21                             updates                                      605 k
# kernel-devel                                     i686                      2.6.35.10-72.fc14                      updates                                      6.5 M
# kernel-headers                                   i686                      2.6.35.10-72.fc14                      updates                                      738 k
# kmod-wl-2.6.35.10-72.fc14.i686                   i686                      5.60.48.36-2.fc14.6                    rpmfusion-nonfree-updates                    562 k
# kmodtool                                         noarch                    1-18.fc11                              rpmfusion-free                                14 k
# libmpc                                           i686                      0.8.1-1.fc13                           fedora                                        45 k
# ppl                                              i686                      0.10.2-10.fc12                         fedora                                       1.1 M
# rpm-build                                        i686                      4.8.1-5.fc14                           fedora                                       126 k
# rpmdevtools                                      noarch                    7.10-1.fc14                            fedora                                       111 k
#
#Riepilogo della transazione
#======================================================================================================================================================================
#Install      19 Package(s)
#
#Dimensione totale del download: 28 M
#Dimensione installata: 72 M

#------------------+
#  metodo vecchio  |
#------------------+
EXECUTE=false
BROADCOM_WL_name='broadcom-wl-4.150.10.5'
BROADCOM_WL_name='broadcom-wl-4.178.10.4'
BROADCOM_WL_driver="$BROADCOM_WL_name/driver/wl_apsta_mimo.o"
BROADCOM_WL_driver="$BROADCOM_WL_name/linux/wl_apsta.o"
BROADCOM_WL_source="$BROADCOM_WL_name.tar.bz2"
BROADCOM_WL_download="http://downloads.openwrt.org/sources/$BROADCOM_WL_source"
BROADCOM_WL_firmware="$BROADCOM_WL_name.firmware"
BROADCOM_WL_packages='b43-fwcutter'
( $EXECUTE )\
&& cd "$PATH_CONFIG"\
&& yum install $BROADCOM_WL_packages\
&& wget -c "$BROADCOM_WL_download"\
&& tar -jxf "$BROADCOM_WL_source" "$BROADCOM_WL_driver"\
&& mkdir "$BROADCOM_WL_firmware"\
&& b43-fwcutter -w "$BROADCOM_WL_firmware" "$BROADCOM_WL_driver"\
&& cp -a "$BROADCOM_WL_firmware"/* /lib/firmware/
