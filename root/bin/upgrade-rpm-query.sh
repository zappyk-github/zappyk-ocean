#!/bin/env bash

THIS=`basename $0 '.sh'`
DATE=`date +%F`
FILE="$THIS-$HOSTNAME-$DATE-all"

OLD_PKG="old-packages"
NEW_PKG="new-packages"
OLD_PKG_NAME="$OLD_PKG-name"
NEW_PKG_NAME="$NEW_PKG-name"
NEW_PKG_NAME_INSTALL="$NEW_PKG_NAME-install"

_pre_install() {
    (
        IFS=$'\n'
        for package in `rpm -qa --qf '%{NAME} %{VERSION}-%{RELEASE} %{ARCH}\n' | sort`; do
            IFS=$' '
            echo "$package" | while read name version release; do
                printf "%-40s %-40s %-10s\n" "$name" "$version" "$release"
            done
        done
    ) 2>&1 | tee "$FILE-$OLD_PKG.txt"
}

_post_install() {
    cat "$FILE-$OLD_PKG.txt" | cut -d' ' -f1 | grep 'release$'

    cat "$FILE-$OLD_PKG.txt" | cut -d' ' -f1 | sort | uniq > "$FILE-$OLD_PKG_NAME.txt"

    rpm -qa --qf '%{NAME}\n' | sort | uniq > "$FILE-$NEW_PKG_NAME.txt"

    diff -u "$FILE-$OLD_PKG_NAME.txt" "$FILE-$NEW_PKG_NAME.txt" | grep '^-' | sed 's/^-//' > "$FILE-$NEW_PKG_NAME_INSTALL.txt"
}

case "$1" in
    pre-install  ) _pre_install  ;;
    post-install ) _post_install ;;
    * ) echo "Usage: $THIS pre-install || post-install" ;;
esac

exit
