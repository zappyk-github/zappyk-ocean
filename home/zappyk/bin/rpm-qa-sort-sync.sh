#!/bin/env bash

cmd_common="$HOME/bin/rpm-qa.sh | sort"

host_1_='zappyk-ws'
host_2_='zappyk-mc'
host_3_='zappyk-nb'

host_locale=''
host_remote=''
[ "$HOSTNAME" == "$host_1_" ] && host_locale_1_=$host_1_ \
                              && host_remote_2_=$host_2_ \
                              && host_remote_3_=$host_3_

[ "$HOSTNAME" == "$host_2_" ] && host_locale_1_=$host_2_ \
                              && host_remote_2_=$host_1_ \
                              && host_remote_3_=$host_3_

[ "$HOSTNAME" == "$host_3_" ] && host_locale_1_=$host_3_ \
                              && host_remote_2_=$host_1_ \
                              && host_remote_3_=$host_2_

[ -z "$host_locale_1_" ] && echo "Host locale (1) not set" && exit 1
[ -z "$host_remote_2_" ] && echo "Host remote (2) not set" && exit 1
[ -z "$host_remote_3_" ] && echo "Host remote (3) not set" && exit 1

log_locale_1_="rpm-qa-sort-$host_locale_1_.log"
log_remote_2_="rpm-qa-sort-$host_remote_2_.log"
log_remote_3_="rpm-qa-sort-$host_remote_3_.log"

help_string="Use: `basename "$0"` [[ rpm ] diff ]"

[ -z "$*" ] && echo "$help_string" && exit 1
while test -n "$1"; do
  case "$1" in
    rpm  ) echo "Run local command: $cmd_common"
           eval                     "$cmd_common > $log_locale_1_"

           echo "Run remote command (@$host_remote_2_): $cmd_common"
           eval "ssh $host_remote_2_ $cmd_common > $log_remote_2_"

           echo "Run remote command (@$host_remote_3_): $cmd_common"
           eval "ssh $host_remote_3_ $cmd_common > $log_remote_3_"
    ;;

    diff ) sdiff -s <(cat "$log_locale_1_" | cut -d' ' -f1 | sort) <(cat "$log_remote_2_" | cut -d' ' -f1 | sort) | sed "s/^/$host_remote_2_: /"
           sdiff -s <(cat "$log_locale_1_" | cut -d' ' -f1 | sort) <(cat "$log_remote_3_" | cut -d' ' -f1 | sort) | sed "s/^/$host_remote_3_: /"
    ;;

    *    ) echo "$help_string" && exit 1
    ;;
  esac
  shift
done

exit
