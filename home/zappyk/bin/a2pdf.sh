#!/bin/env bash

FILE_INPUT=''
FILE_OUTPUT=''
A2PS_OPTIONS=''

TEST_EXECUTE=false
PAGE_MEDIA='A4'
PAGE_MEDIA_DISABLE='-'
BASENAME=`basename $0`

while test -n "$1"; do
    case "$1" in
        -h  | --help        ) cat << _EOD_  ; exit 1 ;;
+----------------------------------------------------------------------------+
`a2ps --help`
+----------------------------------------------------------------------------+
`a2ps --list=media`

  $PAGE_MEDIA_DISABLE              disabled --medium option on a2ps and
                 disabled -sPAPERSIZE option on ps2pdf
+----------------------------------------------------------------------------+
| Usage:                                                                     |
|     $BASENAME
|       [ -h  | --help                ]   This help                          |
|       [ -te | --test-execute        ]   Only print what execute            |
|       [ -pm | --page-media  <media> ]   Set media dimension (default A4)   |
|         -fi | --file-input  <file>      File to read input                 |
|         -fo | --file-output <file>      File to write output (PDF)         |
|       [ *                           ]   Any parameter of a2ps command      |
|                                        (a2ps help on top of this help)     |
+----------------------------------------------------------------------------+
_EOD_
        -te | --test-execute ) TEST_EXECUTE=true ;;
        -pm | --page-media   ) PAGE_MEDIA=$2  ; shift ;;
        -fi | --file-input   ) FILE_INPUT=$2  ; shift ;;
        -fo | --file-output  ) FILE_OUTPUT=$2 ; shift ;;
        *                    ) A2PS_OPTIONS="$A2PS_OPTIONS \"$1\"" ;;
    esac
    shift
done

A2PS_MEDIA=''
PS2PDF_MEDIA=''
[ "$PAGE_MEDIA" != "$PAGE_MEDIA_DISABLE" ] && A2PS_MEDIA="--medium=$PAGE_MEDIA" \
                                           && PS2PDF_MEDIA="-sPAPERSIZE=`echo "$PAGE_MEDIA" | tr "[:upper:]" "[:lower:]"`"

[ -z "$FILE_INPUT"  ] && echo "$BASENAME: non hai speficicato il file di input" && exit 1
[ -z "$FILE_OUTPUT" ] && echo "$BASENAME: non hai speficicato il file di output" && exit 1

COMMAND="set -o pipefail ; a2ps $A2PS_MEDIA --columns=1 --highlight-level=heavy -o - $A2PS_OPTIONS '$FILE_INPUT' | ps2pdf $PS2PDF_MEDIA - '$FILE_OUTPUT'"

( $TEST_EXECUTE ) && echo "$COMMAND" \
                  || eval "$COMMAND"

exit
