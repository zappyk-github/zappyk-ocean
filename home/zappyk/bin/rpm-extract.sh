#!/bin/env bash

rpm_pkg=$1 ; shift
rpm_lst=$*
rpm_all='%'

[ -z "$rpm_pkg" ] && echo "$0 <package-name> [ <list-files> | <$rpm_all> for all ]" && exit 1

rpm_dir="./$(basename "$rpm_pkg").d"

if [ -z "$rpm_lst" ]; then
    echo "List of files in '$rpm_pkg':"
    rpm -qlp "$rpm_pkg" | sed 's#^/# \./#'
    echo "Extract all file with '$rpm_all', otherwise enter a list of files..."
    exit
fi

mkdir -p "$rpm_dir" && cd "$rpm_dir" || exit 1

if [ "$rpm_lst" == "$rpm_all" ]; then
    echo "Extract all files..."
    eval "rpm2cpio '../$rpm_pkg' | cpio -idmv"
else
    echo "Extract only files: $rpm_lst ..."
    eval "rpm2cpio '../$rpm_pkg' | cpio -idmv $rpm_lst"
fi

exit
