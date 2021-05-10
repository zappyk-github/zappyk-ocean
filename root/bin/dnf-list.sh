#!/bin/env bash

dnf list "$@" 2>&1 | tee ~/dnf-list.log

exit
