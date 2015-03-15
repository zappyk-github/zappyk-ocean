#!/bin/env bash

PATH_BASE="$HOME/zappyk-hd/Public/Shared Videos"
PATH_FILM='Films'

(cd "$PATH_BASE" && film-file-list.pl "$PATH_FILM")
