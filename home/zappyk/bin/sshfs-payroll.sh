#!/bin/env bash

#--------+------------+
# HOSTs  | IP ADDRESS |
#--------+------------+
# vls    | 10.0.3.5   |
# pls    | 10.0.3.6   |
# sls    | 10.0.3.7   |
# pdb    | 10.0.3.20  |
# eis    | 10.0.3.21  |
# test   | 10.0.3.22  |
# win01  | 10.0.3.23  |
#--------+------------+

user=pes0zap ; [ "$USER" == 'root' ] && user=$USER
host=10.0.3.6  # vls.payroll
host=10.0.3.64 # sipert.payroll.local

mountpoint="$HOME/Lavoro/_SSHFS_/$user@$host"

directory=$1 ; shift
_options_=$*

mkdir -p "$mountpoint"

sshfs $user@$host:$directory "$mountpoint" $_options_
