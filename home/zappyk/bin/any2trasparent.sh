#!/bin/env bash

IMAGE_INPUT=$1
IMAGE_MODES=$2
COLOR_CLEAR=$3
IMAGE_CLEAR=false
IMAGE_CHECK=false

_write()  { echo -e "$*"; }
_clean() { rm -f "$*"; }

[ ! -r "$IMAGE_INPUT" ] && _write "Select file image trasform trasparent color..." && exit 1
[ ! -n "$IMAGE_MODES" ] && _write "Select trasparent metod [0='normal' 1='ugly fuzz' 2='ugly fuzz too much' 3='floodfill' 4='finished']?" && exit 1
[ ! -n "$COLOR_CLEAR" ] && COLOR_CLEAR='white'; _write "Select $COLOR_CLEAR color..."

for MODE in $IMAGE_MODES; do

    case "$MODE" in
    0 ) _write "$MODE] Create trasparent 'normal' (doesnt work)...:"
        convert -transparent $COLOR_CLEAR $IMAGE_INPUT $IMAGE_INPUT-normal.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-normal.png $IMAGE_INPUT-normal-check.png
        ;;

    1 ) _write "$MODE] Create trasparent 'ugly fuzz' (doesnt work)...:"
        convert -fuzz .2% -transparent $COLOR_CLEAR $IMAGE_INPUT $IMAGE_INPUT-ugly-fuzz.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-ugly-fuzz.png $IMAGE_INPUT-ugly-fuzz-check.png
        ;;

    2 ) _write "$MODE] Create trasparent 'ugly fuzz too much' (doesnt work)...:"
        convert -fuzz 10% -transparent $COLOR_CLEAR $IMAGE_INPUT $IMAGE_INPUT-ugly-fuzz-too-much.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-ugly-fuzz-too-much.png $IMAGE_INPUT-ugly-fuzz-too-much-check.png
        ;;

    3 ) _write "$MODE] Create trasparent 'floodfill' (works okay)..."
        convert $IMAGE_INPUT -bordercolor $COLOR_CLEAR -border 1x1 -matte -fill none -fuzz 7% -draw 'matte 1,1 floodfill' -shave 1x1 $IMAGE_INPUT-$COLOR_CLEAR-floodfill.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-$COLOR_CLEAR-floodfill.png $IMAGE_INPUT-$COLOR_CLEAR-floodfill-check.png
        ;;

    4 ) _write "$MODE] Create trasparent 'finished' (works real)..."
        convert $IMAGE_INPUT \( +clone -fx 'p{0,0}' \) -compose Difference -composite -modulate 100,0 +matte $IMAGE_INPUT-difference.png

        _write "$MODE] \t...remove the black, replace with transparency..."
        convert $IMAGE_INPUT-difference.png -bordercolor $COLOR_CLEAR -border 1x1 -matte -fill none -fuzz 7% -draw 'matte 1,1 floodfill' -shave 1x1 $IMAGE_INPUT-removed-black.png
        ( $IMAGE_CLEAR ) && _clean $IMAGE_INPUT-difference.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-removed-black.png $IMAGE_INPUT-removed-black-check.png

        _write "$MODE] \t...create the matte..."
        convert $IMAGE_INPUT-removed-black.png -channel matte -separate +matte $IMAGE_INPUT-matte.png
        ( $IMAGE_CLEAR ) && _clean $IMAGE_INPUT-removed-black.png

        _write "$MODE] \t...negate the colors..."
        convert $IMAGE_INPUT-matte.png -negate -blur 0x1 $IMAGE_INPUT-matte-negated.png
        ( $IMAGE_CLEAR ) && _clean $IMAGE_INPUT-matte.png

        _write "$MODE] \t...you are going for: $COLOR_CLEAR interior, black exterior."
        composite -compose CopyOpacity $IMAGE_INPUT-matte-negated.png $IMAGE_INPUT $IMAGE_INPUT-finished.png
        ( $IMAGE_CLEAR ) && _clean $IMAGE_INPUT-matte-negated.png
        ( $IMAGE_CHECK ) && composite -compose Dst_Over -tile pattern:checkerboard $IMAGE_INPUT-finished.png $IMAGE_INPUT-finished-check.png

        _write "$MODE] See file '$IMAGE_INPUT-finished.png'"
        ;;
    esac

done

exit
