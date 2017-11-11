#!/bin/env bash

#dnf clean all
 dnf clean dbcache
 dnf clean expire-cache
 dnf -y update 'rpm*' 'dnf*'
#dnf -y update --best --allowerasing
 dnf -y update

exit
