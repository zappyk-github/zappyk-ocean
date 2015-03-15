URL_BASE='http://vimcolorschemetest.googlecode.com/svn/colors/'
DIR_BASE=$(basename "$0" '.sh')
[ ! -d "$DIR_BASE" ] && svn co "$URL_BASE" "$DIR_BASE"
[   -d "$DIR_BASE" ] && cd "$DIR_BASE" && pwd && svn up
