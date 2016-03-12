#!/bin/env bash

slaves_only='grep -e "Spazio su disco recuperabile:" -e "File da eliminare:"'
master_only='grep "."'

slaves_only='grep "."'
master_only='grep -v "system"'
master_only='grep -e "google"'

master_list=$(bleachbit -l | cut -d'.' -f1 | sort -u | eval "$master_only")

bleachbit_command='-p'
bleachbit_command='-c'

for master in $master_list; do
    slaves=$(bleachbit -l | grep ^$master | xargs)
    echo "#"
    echo "# ${master}"
    echo "#-${master//?/-}-+"
    bleachbit $bleachbit_command $slaves | eval "$slaves_only" | sed "s/^/# $master | /g"
    echo "#_____________________________________________________________________"
    echo "#"
done

exit
