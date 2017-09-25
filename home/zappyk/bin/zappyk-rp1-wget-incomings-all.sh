#!/bin/env bash
################################################################################
hostname="zappyk-rp1"
base_url="http://$hostname/incomings"
wget_opt="--quiet --show-progress"
################################################################################
_wait() {
    local pget=${1}
    local sget=${2:-60}

    printf "wait($pget):"

    local cmmd="ps -ef | grep -i -e \"$pget\" | grep -v grep | wc -l"
    local loop=true
    while $loop; do
        local prun=$(eval "$cmmd")
        [ $prun -eq 0 ] && loop=false
        ( $loop ) && printf '.' && sleep $sget || echo 'done!'
    done
}
################################################################################
_wget() {
    local url_file=${1}
    local url_name=$(basename "$url_file")
    local tag_name=${2:-$url_name}
    local tag_path=$(basename "$0" '.sh')
    local url_base=$base_url

    ping -c5 -q $hostname >/dev/null || { echo "Host $hostname not responding..."; exit 1; }

    mkdir -p "$tag_path"
    wget --continue $wget_opt --directory-prefix="$tag_path" "$url_base/$url_file" ; rc=$?
    if [ $rc == 0 ]; then
        [ "$url_name" != "$tag_name" ] && mv -v "$tag_path/$url_name" "$tag_path/$tag_name"
        md5sum "$tag_path/$tag_name" | tee "$tag_path/$tag_name.md5sum"
    fi
}
################################################################################
