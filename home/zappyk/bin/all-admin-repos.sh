#!/bin/env bash

COMMANDS_ALL=$1 ; shift
COMMANDS_SVN=$COMMANDS_ALL
COMMANDS_GIT=$COMMANDS_ALL

################################################################################
case "$COMMANDS_ALL" in
    up     ) COMMANDS_GIT=pull ;;
    commit ) COMMANDS_GIT=push ;;
    status ) ;;
esac

################################################################################
svn-admin-repos.sh "$COMMANDS_SVN" "$@"

################################################################################
git-admin-repos.sh "$COMMANDS_GIT" "$@"

exit
