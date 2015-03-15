#!/bin/env bash

file_txt=$1 ; shift
file_pdf="$file_txt.pdf"

[   -z "$file_txt" ] && echo "Specifica il file per la conversione in pdf." && exit 1
[ ! -r "$file_txt" ] && echo "Il file '$file_txt' non puo' essere letto."   && exit 1

set -o pipefail

cat "$file_txt" \
| recode UTF-8..Latin-1 \
| a2ps -X latin1 --medium=A4 --columns=1 --highlight-level=heavy --stdin="$file_txt" "$@" -o - - \
| ps2pdf -sPAPERSIZE=a4 - "$file_pdf"

exit
