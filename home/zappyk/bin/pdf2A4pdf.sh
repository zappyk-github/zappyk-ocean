#!/bin/env bash

file_in=$1
filebase=$(basename $file_in .pdf)
file_out=`dirname "$file_in"`/$filebase-A4.pdf

\pdfjoin "$file_in" --outfile "$file_out" --paper a4paper --fitpaper false
