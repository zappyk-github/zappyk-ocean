#!/bin/env bash

THIS=$(basename "$0" '.sh')

TAG_FILE="$THIS-$(date +'%Y%m%d')"

DIR_SCAN_TUNING='/usr/share/dvb/dvb-t/'
CMD_SCAN_TUNING=$(basename $(which w_scan))
CMD_SCAN_CHANNEL=$(basename $(which scandvb))

DEF_SCAN_TUNING_COUNTRY='IT'

################################################################################
_help() {
    local message=$2

    cat << _EOD_
Usage:
        $THIS
            [ -h   | --help                          ]	Show this help.
            [ -t   | --tuning                        ]   Set tuning operation ($CMD_SCAN_TUNING), default country is '$DEF_SCAN_TUNING_COUNTRY'.
            [ -tc  | --tuning-by-country <country>   ]   Set contry for tuning for generate file tuning.
            [ -tf  | --tuning-by-filedat <file-name> ]   Set file tuning for scan channels ($CMD_SCAN_CHANNEL).
            [ -tfl | --tuning-file-lists             ]   List files tuning for scan shannels.
            [ -ex  | --execute                       ]   Execute commands.
_EOD_

    [ -n "$message" ] && cat << _EOD_
Message: $message
_EOD_
}

################################################################################
_eval() {
    local command=$*

    if ( $FLG_EXECUTE ); then eval "$command"
                         else echo "$command"
    fi
}

FLG_EXECUTE=false
FLG_SCAN_TUNING=false
FLG_FILE_TUNING=false

TUNING_DATA_COUNTRY=''
TUNING_DATA_OUTFILE=''
DVB_CHANNEL_OUTFILE=''

while test -n "$1"; do
    case "$1" in
        -h   | --help              ) _help ; exit 1 ;;
        -t   | --tuning            ) FLG_SCAN_TUNING=true  ; FLG_FILE_TUNING=true ;;
        -tc  | --tuning-by-country ) FLG_SCAN_TUNING=true  ; FLG_FILE_TUNING=true ;;
        -tf  | --tuning-by-filedat ) FLG_SCAN_TUNING=false ; FLG_FILE_TUNING=true
                                     TUNING_DATA_OUTFILE=$2 ; shift ;;
        -tfl | --tuning-list-files ) find "$DIR_SCAN_TUNING" | sort ; exit 1 ;;
        -ex  | --execute           ) FLG_EXECUTE=true ;;
        *                          ) _help "option '$1' unknown" ; exit 1 ;;
    esac
    shift
done

[ -z "$TUNING_DATA_COUNTRY" ] && TUNING_DATA_COUNTRY=$DEF_SCAN_TUNING_COUNTRY
[ -z "$TUNING_DATA_OUTFILE" ] && TUNING_DATA_OUTFILE="$TAG_FILE-tuning-$TUNING_DATA_COUNTRY.dat"

if   ( $FLG_SCAN_TUNING ); then DVB_CHANNEL_OUTFILE="$TAG_FILE-channels-$TUNING_DATA_COUNTRY.conf"
elif ( $FLG_FILE_TUNING ); then DVB_CHANNEL_OUTFILE="$TAG_FILE-channels-$(basename "$TUNING_DATA_OUTFILE").conf"
                           else DVB_CHANNEL_OUTFILE="$TAG_FILE-channels.conf"
fi

( $FLG_SCAN_TUNING  ) && _eval "$CMD_SCAN_TUNING -ft -c '$TUNING_DATA_COUNTRY' -x > '$TUNING_DATA_OUTFILE'"
( $FLG_FILE_TUNING  ) && _eval "$CMD_SCAN_CHANNEL -n -o zap -p '$TUNING_DATA_OUTFILE' > '$DVB_CHANNEL_OUTFILE'"\
                      || _eval "$CMD_SCAN_CHANNEL -n -o zap -c > '$DVB_CHANNEL_OUTFILE'"

( $FLG_SCAN_TUNING ) && echo "File tuning '$TUNING_DATA_OUTFILE' could be deleted..."
                        echo "File channels '$DVB_CHANNEL_OUTFILE' should be created!"

exit
