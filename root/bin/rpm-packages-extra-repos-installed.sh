#!/bin/env bash

all_packages_rpm='all-packages-install.log'
all_packages_yum='all-packages-on-repo.log'

_execute() {
    local message=$1
    local command=$2

    echo -e "$message"
    eval "$command"
    echo 'Done.'
}

_select_packages_install() {
    [ -s "$all_packages_rpm" ] && echo -n 'alredy exists, ' && return

    rpm -qa --qf "%{NAME}\n" "*" \
    | sort -u \
    > "$all_packages_rpm"
}

_select_packages_on_repo() {
    [ -s "$all_packages_yum" ] && echo -n 'alredy exists, ' && return

    ls /var/cache/yum/*/*primary* \
    | xargs -i file '{}' | grep SQLite | cut -d':' -f1 \
    | xargs -i sqlite3 '{}' 'select name from packages;' \
    | sort -u \
    > "$all_packages_yum"
}

_detect_packages() {
    local sep=': '
    local tag='  '

    cat "$all_packages_rpm" \
    | xargs -i bash -c "echo -n '{}$sep'; grep -LZ '^{}$' '$all_packages_rpm' '$all_packages_yum'; echo" \
    | grep "$sep$all_packages_yum" \
    | sed "s/$sep$all_packages_yum//" \
    | sed "s/^/$tag/"
}

_execute "Create '$all_packages_rpm'... \c" _select_packages_install
_execute "Create '$all_packages_yum'... \c" _select_packages_on_repo

_execute "Check rows in '$all_packages_rpm' that not are present in '$all_packages_yum'..." _detect_packages

exit
