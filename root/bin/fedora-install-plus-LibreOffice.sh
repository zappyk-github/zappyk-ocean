#!/bin/env bash

PATH_LIBREOFFICE=$1 ; [ -z "$PATH_LIBREOFFICE" ] && echo "$0: specifica la directory per LibreOffice..." && exit 1
VERS_LIBREOFFICE=$2 ; [ -z "$VERS_LIBREOFFICE" ] && echo "$0: specifica la versione di LibreOffice..." && exit 1

TEST_EXECUTE='--test'

PATH_WORK='.'
NAME_UNIN='LibO_'
NAME_INST="$NAME_UNIN$VERS_LIBREOFFICE"
RPMS_EXCL='-en-US-'
DESK_EXCL='/desktop-integration/'
DESK_INCL='-redhat-menus-'

list_rpms_uninstall() {
    rpm -qa | grep "^$NAME_UNIN"
}

rpms_uninstall() {
#CZ#xargs rpm -e $TEST_EXECUTE
    xargs yum remove
}

change_directory() {
    cd "$PATH_WORK" || exit 1
}

uncompress_files() {
    for file in $(ls $PATH_LIBREOFFICE/$NAME_INST*); do
        echo "Uncompress '$file' ..."
        tar -zxf $file
    done
}

list_rpms_install() {
    for file in $(find $NAME_INST* -iname "*.rpm" | grep -v -e "$RPMS_EXCL" -e "$DESK_EXCL" | sort); do
        echo "$file"
    done
    for file in $(find $NAME_INST* -iname "*.rpm" | grep "$DESK_EXCL" | grep "$DESK_INCL" | sort); do
        echo "$file"
    done
}

rpms_install() {
#CZ#xargs rpm -Uvh $TEST_EXECUTE
    xargs yum install
}

echo "Uninstall LibreOffice ..."
list_rpms_uninstall | rpms_uninstall

change_directory && uncompress_files

echo "Install LibreOffice $VERS_LIBREOFFICE ..."
list_rpms_install | rpms_install

exit
