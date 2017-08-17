#!/bin/env bash

rpm -qia "$@" | awk '$1=="Name" { n=$3} $1=="Size" {s=$3} $1=="Description" {printf "%-15s %s\n", s, n }'

exit
