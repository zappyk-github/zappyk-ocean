#!/bin/env bash

BASE_PATH=$(dirname "$0")
BASE_NAME=$(basename "$0" '.sh')

################################################################################
rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o
 
    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * )               printf -v o '%%%02x' "'$c"
         esac
         encoded+="${o}"
    done

    echo "${encoded}"    # You can either set a return variable (FASTER) 
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

BitTorrentMagnetic='magnet:?xt=urn:btih:'
BitTorrentInfoHash=$1 ; shift
BitTorrentInfoName=$* ; BitTorrentInfoName=$(rawurlencode "$BitTorrentInfoName")
BitTorrentFileName=

[ -n "$BitTorrentInfoName" ] && BitTorrentFileName="&dn=$BitTorrentInfoName"

echo "$BitTorrentMagnetic$BitTorrentInfoHash"
echo "$BitTorrentMagnetic$BitTorrentInfoHash$BitTorrentFileName"

exit
################################################################################
replace_value=$(echo $replace_value | sed -f /usr/lib/ddns/url_escape.sed)

# Where url_escape.sed was a file that contained these rules:
#.....%<............%<........
# sed url escaping
s:%:%25:g
s: :%20:g
s:<:%3C:g
s:>:%3E:g
s:#:%23:g
s:{:%7B:g
s:}:%7D:g
s:|:%7C:g
s:\\:%5C:g
s:\^:%5E:g
s:~:%7E:g
s:\[:%5B:g
s:\]:%5D:g
s:`:%60:g
s:;:%3B:g
s:/:%2F:g
s:?:%3F:g
s^:^%3A^g
s:@:%40:g
s:=:%3D:g
s:&:%26:g
s:\$:%24:g
s:\!:%21:g
s:\*:%2A:g
#.....%<............%<........
