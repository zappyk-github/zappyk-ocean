#!/bin/env bash

# ftp://download.nvidia.com/XFree86/Linux-x86_64/290.10/README/supportedchips.html

echo '...nuevu...'
exit

KERNEL_PAE=''
KERNEL_PAE='-PAE'

FILE_MODPROBE='/etc/modprobe.d/blacklist-nouveau.conf'

COMMAND_POST="grep dracut \"$FILE_MODPROBE\" | cut -d'#' -f2-"
COMMAND_POST="new-kernel-pkg --mkinitrd --dracut --update $(rpm -q --queryformat="%{version}-%{release}.%{arch}\n" kernel$KERNEL_PAE | tail -n 1)"

yum install\
 kmod-nvidia$KERNEL_PAE\
 akmod-nvidia$KERNEL_PAE\
 nvidia-xconfig\
 nvidia-settings\
&& cat "$FILE_MODPROBE"\
&& echo '_____________________'\
&& echo 'Execute this command:'\
&& echo "$COMMAND_POST"

################################################################################

echo "## Backup old initramfs nouveau image ##"
echo mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
echo "## Create new initramfs image ##"
echo dracut /boot/initramfs-$(uname -r).img $(uname -r)

#-------------------------------------------------------------------------------
echo reboot
#-------------------------------------------------------------------------------

echo "## Modify following line on /etc/default/grub ##"
echo GRUB_CMDLINE_LINUX="quiet rhgb"
echo "## to ##"
echo GRUB_CMDLINE_LINUX="quiet rhgb rdblacklist=nouveau nouveau.modeset=0"

echo grub2-mkconfig -o /boot/grub2/grub.cfg

################################################################################

#======================================================================================================================================================================
# Pacchetto                                          Arch                    Versione                                 Repository                                  Dim.
#======================================================================================================================================================================
#Installazione:
# akmod-nvidia                                       i686                    1:260.19.29-1.fc14                       rpmfusion-nonfree-updates                  6.7 M
# kmod-nvidia                                        i686                    1:260.19.29-1.fc14.4                     rpmfusion-nonfree-updates                   32 k
# nvidia-settings                                    i686                    1.0-9.fc14                               rpmfusion-nonfree-updates                  707 k
# nvidia-xconfig                                     i686                    1.0-6.fc14                               rpmfusion-nonfree-updates                   76 k
#Installazioni per dipendenze:
# akmods                                             noarch                  0.3.6-3.fc12                             rpmfusion-free                              16 k
# cloog-ppl                                          i686                    0.15.7-2.fc14                            fedora                                      93 k
# cpp                                                i686                    4.5.1-4.fc14                             fedora                                     3.7 M
# fakeroot                                           i686                    1.12.4-2.fc14                            fedora                                      74 k
# fakeroot-libs                                      i686                    1.12.4-2.fc14                            fedora                                      23 k
# gcc                                                i686                    4.5.1-4.fc14                             fedora                                      12 M
# glibc-devel                                        i686                    2.12.90-21                               updates                                    968 k
# glibc-headers                                      i686                    2.12.90-21                               updates                                    605 k
# kernel-devel                                       i686                    2.6.35.10-74.fc14                        updates                                    6.5 M
# kernel-headers                                     i686                    2.6.35.10-74.fc14                        updates                                    738 k
# kmod-nvidia-2.6.35.10-74.fc14.i686                 i686                    1:260.19.29-1.fc14.4                     rpmfusion-nonfree-updates                  2.7 M
# kmodtool                                           noarch                  1-18.fc11                                rpmfusion-free                              14 k
# libmpc                                             i686                    0.8.1-1.fc13                             fedora                                      45 k
# libvdpau                                           i686                    0.4.1-1.fc14.1                           fedora                                      22 k
# ppl                                                i686                    0.10.2-10.fc12                           fedora                                     1.1 M
# rpm-build                                          i686                    4.8.1-5.fc14                             fedora                                     126 k
# rpmdevtools                                        noarch                  7.10-1.fc14                              fedora                                     111 k
# xorg-x11-drv-nvidia                                i686                    1:260.19.29-2.fc14                       rpmfusion-nonfree-updates                  1.9 M
# xorg-x11-drv-nvidia-libs                           i686                    1:260.19.29-2.fc14                       rpmfusion-nonfree-updates                   15 M
#
#Riepilogo della transazione
#======================================================================================================================================================================
#Install      23 Package(s)
#
#Dimensione totale del download: 53 M
#Dimensione installata: 152 M
