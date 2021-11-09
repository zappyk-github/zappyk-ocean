#!/bin/env bash

package="$1"
packsp1='-'
packsp2='.'

oformat="%-50{NAME}$packsp1%-25{VERSION}$packsp1%-25{RELEASE}$packsp2%{ARCH}\n"
oformat="%-55{NAME}$packsp1%-30{VERSION}$packsp1%-30{RELEASE}$packsp2%{ARCH}\n"

rpm -qa  --qf "$oformat" "*$package*" 2>&1 | sort | tee ~/rpm-list.log

exit
