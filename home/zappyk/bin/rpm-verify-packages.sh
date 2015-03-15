#!/bin/env bash

[ -z "$1" ] && grep_string='' \
            || grep_string="| grep -i '$1'"

echo -n "Controllo dei pacchetti installati... "
list_packages=`rpm -qa --queryformat "%{NAME}\n" $grep_string | sort`
numb_packages=`echo "$list_packages" | wc -l`
echo "$numb_packages pacchetti trovati :-D"

echo "Controllo integrita' pacchetto,"
for package_name in $list_packages; do
	echo -n "$package_name: "
	list_files=`rpm -Vv "$package_name" | grep -v '^\.\.\.\.\.\.\.\.'`
	[ -z "$list_files" ] && echo "ok" || echo -e "verify...\n$list_files"
done

exit
