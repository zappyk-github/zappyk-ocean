#!/bin/env bash

#dnf clean all
 dnf clean dbcache
 dnf clean expire-cache

#dnf -y update 'rpm*' 'dnf*'
#dnf -y update
 dnf -y update --best --allowerasing 'rpm*' 'dnf*'
 dnf -y update --best --allowerasing

#dnf distro-sync --setopt=deltarpm=0

exit
