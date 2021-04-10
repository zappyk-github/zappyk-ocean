#!/bin/env bash

tag_name='filenull'

time dd if=/dev/urandom of=$tag_name-dd-random-10G.1.dat bs=1G  count=10    iflag=fullblock
time dd if=/dev/urandom of=$tag_name-dd-random-10G.2.dat bs=10M count=1024
time dd if=/dev/urandom of=$tag_name-dd-random-10G.3.dat bs=1M  count=10240
time dd if=/dev/zero    of=$tag_name-dd-zero-10G.dat     bs=1  count=1      seek=$((10 * 1024 * 1024 * 1024 - 1))

time head -c 10G </dev/urandom >$tag_name-head-random-10G.dat

time fallocate -l 10G $tag_name-fallocate-10G.dat

exit
