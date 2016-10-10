#!/bin/env bash

PATH_MUSIC=${1:-.}
FILE_MUSIC=${2:-*.mp3}

TAGS_MUSIC_PRESERVE='-e APIC'
#mid3v2 -f Alan\ Walker\ -\ Faded.mp3 | grep -v APIC | cut -d' ' -f5 | xargs | sed 's/ --/,/g' | sed 's/^--/--delete-frames=/

IFS=$'\n'
for file_path in $(find "$PATH_MUSIC/" -type f -iname "$FILE_MUSIC" -print0 | xargs -0i echo "{}"); do
    file_name=$(basename "$file_path")

    tag_album=$(echo "$file_name" | sed -e 's/\.[^.]*$//')

    IFS=$'-' read tag_artist tag_song  < <(echo "$tag_album")

    tag_artist=$(echo "$tag_artist" | sed 's/  *$//')
    tag_song=$(echo "$tag_song" | sed 's/^  *//')

    delete_frame=$(mid3v2 --list-frames "$file_path" | eval "grep -v $TAGS_MUSIC_PRESERVE" |grep '\--' | cut -d' ' -f5 | xargs | sed 's/ --/,/g' | sed 's/^--/--delete-frames=/')

    echo "#___________"
    echo "# filepath =  $file_path"
    echo "# filename =  $file_name"
    echo "# · Artist = [$tag_artist]"
    echo "#  · Album = [$tag_album]"
    echo "#   · Song = [$tag_song]"
    echo "mid3v2 $delete_frame \"$file_path\""
    echo "mid3v2 --artist=\"$tag_artist\" --album=\"$tag_album\" --song=\"$tag_song\" \"$file_path\""
    echo "mid3v2 --list \"$file_path\""
done

exit
