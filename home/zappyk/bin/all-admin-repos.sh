#!/bin/env bash

COMMANDS_ALL=$1 ; shift
COMMANDS_SVN=$COMMANDS_ALL
COMMANDS_GIT=$COMMANDS_ALL

################################################################################
case "$COMMANDS_ALL" in
    up     ) COMMANDS_GIT=pull ;;
    pull   ) COMMANDS_SVN=up ;;
    push   ) COMMANDS_SVN= ;;
    commit ) ;;
    status ) ;;
esac

################################################################################
[ -n "$COMMANDS_SVN" ] && svn-admin-repos.sh "$COMMANDS_SVN" "$@"

################################################################################
[ -n "$COMMANDS_GIT" ] && git-admin-repos.sh "$COMMANDS_GIT" "$@"

exit
