#!/bin/env bash

file_dir="$HOME/Configurazioni/yum"
file_log="$file_dir/yum-rpm-qa-sort.log"

mkdir -p "$file_dir"

echo "Create log $file_log ..."
rpm-qa.sh | sort > "$file_log"
