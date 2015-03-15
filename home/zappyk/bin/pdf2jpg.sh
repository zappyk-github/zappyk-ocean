#!/bin/env bash

file_pdf=$1

[ ! -n "$file_pdf" ] && echo "Specifica un file PDF da convertire in JPG." && exit 1
[ ! -e "$file_pdf" ] && echo "Il file '$file_pdf' non esiste o non e' possibile leggerlo." && exit 1

convert -density 300 "$file_pdf" "$file_pdf.jpg"

exit
