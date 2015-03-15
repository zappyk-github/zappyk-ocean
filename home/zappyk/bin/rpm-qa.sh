#!/bin/env bash

package="$1"
packsep='-'
packsep=' '

rpm -qa  --qf "%-50{NAME}$packsep%-25{VERSION}$packsep%-25{RELEASE}$packsep%{ARCH}\n" "*$package*"

exit
