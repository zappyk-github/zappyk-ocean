#!/bin/env bash

file_pdf=$1

[ ! -n "$file_pdf" ] && echo "Specifica un file PDF da convertire in JPG." && exit 1
[ ! -e "$file_pdf" ] && echo "Il file '$file_pdf' non esiste o non e' possibile leggerlo." && exit 1

path_jpg=$(dirname  "$file_pdf")
name_jpg=$(basename "$file_pdf" ".pdf")
file_jpg="$path_jpg/$name_jpg.jpg"

echo convert -density 300 "$file_pdf" "$file_jpg"

exit
