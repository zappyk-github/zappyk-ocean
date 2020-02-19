#!/bin/env bash

COMMANDS_ALL=${1:-status} ; shift
COMMANDS_SVN=$COMMANDS_ALL
COMMANDS_GIT=$COMMANDS_ALL
COMMANDS_OPT=$*

################################################################################
case "$COMMANDS_ALL" in
    up     ) COMMANDS_GIT=pull ;;
    pull   ) COMMANDS_SVN=up   ;;
    push   ) COMMANDS_SVN=     ;;
    add    ) COMMANDS_GIT=add  ; COMMANDS_OPT="--verbose $COMMANDS_OPT" ;;
    commit ) ;;
    status ) ;;
esac

################################################################################
 [ -n "$COMMANDS_SVN" ] &&             svn-admin-repos.sh "$COMMANDS_SVN" $COMMANDS_OPT

################################################################################
#[ -n "$COMMANDS_GIT" ] && GIT_TRACE=1 git-admin-repos.sh "$COMMANDS_GIT" $COMMANDS_OPT
 [ -n "$COMMANDS_GIT" ] &&             git-admin-repos.sh "$COMMANDS_GIT" $COMMANDS_OPT

exit
