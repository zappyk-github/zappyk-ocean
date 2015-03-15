#!/bin/env bash

file=$1

[ -z "$file"   ] && exit
[ ! -f "$file" ] && echo "attentions, $file is not a regular file!" && exit 1

echo -n "Are you sure to remove and overwrite '$file' file? [yes/NO] "
read answer

exit_code=0

case "$answer" in
    y | yes ) shred -fuvz "$file" ; exit_code=$?
              [ $exit_code -eq 0 ] && echo "Ok, file is removed and overwrited done. :-)" \
                                   || echo "NO, file is not removed correctly! :-(" ;;
    *       ) ;;
esac

exit $exit_code
