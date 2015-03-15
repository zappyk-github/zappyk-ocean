#!/bin/env bash

yum clean all && rm -Rf /var/cache/yum/* && yum -y update "rpm*" "yum*" && yum -y update "$@"

exit
