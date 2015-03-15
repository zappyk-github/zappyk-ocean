#!/bin/env bash

for file in $(find /etc /var -name '*.rpm?*'); do diff -uq ${file%.rpm?*} $file; done
