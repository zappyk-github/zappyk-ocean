#!/bin/env bash

path_repo='/etc/yum.repos.d'
file_exte='.repo'
grep_expr='-e "^\[" -e "^enabled="'

IFS=$'\n'
for file_repo in `find "$path_repo" -iname "*$file_exte" -print0 | xargs -0 -i echo "{}"`; do
    file_name=`basename "$file_repo"`
    file_tags=`printf "%-50s | " "$file_name"`

    eval "grep $grep_expr "$file_repo"" | sed "s/^/$file_tags/"
done

exit
