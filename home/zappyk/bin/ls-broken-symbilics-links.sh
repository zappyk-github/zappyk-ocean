#!/bin/env bash

dir=$1

[ ! -n "$dir" ] && dir=.
[ ! -d "$dir" ] && echo "Elemento '$dir' non e' una directory" && exit 1

_find_symbolik_link() {
    find "$dir" -type l
}

_ls_broken() {
    while read file; do
        test -e "$file" || ls -ld --color=auto "$file"
    done
}

_find_symbolik_link | _ls_broken

exit
