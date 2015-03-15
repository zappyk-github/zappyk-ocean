#!/bin/env bash                                                                                                                                                                                                                              

thisprogram=$(basename "$0")
loop_device=/dev/loop8

if [ -b $loop_device ]; then
    echo "$loop_device already exists!"
    exit 0
else
    mknod -m660 $loop_device b 7 8 && \
    chown root:disk $loop_device   && \
    chmod 666 $loop_device         && exit 0 \
                                   || \
    ( echo "$this: error, verify loop device $loop_device before use it!" && exit 1; )
fi

exit
