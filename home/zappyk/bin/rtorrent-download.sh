#!/bin/env bash

path_file=$1
name_exte='.torrent'

path_download="$HOME/Scaricati"
path_torrents="$path_download/_TORRENTS_"
path_incoming="$path_download/_INCOMINGS_"

memGB=3
memMB=$(($memGB * 1024))
memKB=$(($memMB * 1024))
memBy=$(($memKB * 1024))

[ -z "$path_file" ] && echo -e "Select one of Path or File $name_exte:\n$(ls $path_download)" && exit 1
[ -d "$path_file" ] && path_file="$path_download/$path_file/*$name_exte"
[ -f "$path_file" ] && path_file="$path_download/$path_file"

cd $path_incoming && rtorrent -O max_memory_usage=$memBy $path_file

exit
