URL_BASE='https://github.com/google/vim-codefmt/trunk/'
DIR_BASE=$(basename "$0" '.sh')
[ ! -d "$DIR_BASE" ] && svn co "$URL_BASE" "$DIR_BASE"
[   -d "$DIR_BASE" ] && cd "$DIR_BASE" && pwd && svn up
