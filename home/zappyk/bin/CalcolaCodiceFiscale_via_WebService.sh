#!/bin/env bash

_execute() {
#==================================================================================================================================================================
 _CalcolaCodiceFiscale "$ID"      "$Nome"                "$Cognome"                        "$ComuneNascita"                "$DataNascita" "$Sesso" "$CodiceFiscale"
 _CalcolaCodiceFiscale "$ID"      "$Nome"                "$Cognome"                        "$CodiceComune"                 "$DataNascita" "$Sesso" "$CodiceFiscale"
#==================================================================================================================================================================
#==================================================================================================================================================================
}

ID=0
Nome='Pinco'
Cognome='Pallo'
ComuneNascita='CHIETI'
CodiceComune='C632'
DataNascita='08/10/1973'
DATE_LEN8_1='GGMMAAAA'
DATE_LEN8_2='AAAAMMGG'
DATE_LEN8_S=$FORM_DATE_1
Sesso='M'
CodiceFiscale='PLLPNC73R08C632X'
CF_TAGSKIPPED='*** skippato ***'

BASE_URL_CF="http://webservices.dotnethell.it/codicefiscale.asmx/CalcolaCodiceFiscale"
BASE_URL_NC="http://webservices.dotnethell.it/codicefiscale.asmx/NomeComune"

S='|'
#_normalize() { xmllint --htmlout -; }
#_normalize() { grep '<string .*CodiceFiscale'; }
 _normalize() { grep '<string .*CodiceFiscale' | cut -d'>' -f2- | cut -d'<' -f1; }
 _verbose()   { printf "%10s $S %-20s %-20s %-35s %10s %1s $S%s$S" "$@"; }
 _check()     { while read line; do IFS=$S read CF1 CF2 < <(echo "$line" | cut -d"$S" -f4,5); echo -n "$line|"; [ "$CF1" != "$CF2" ] && echo '<= NOT EQUAL!' || echo; done; }
 _trim()      { echo "$1" | sed 's/^ *//g' | sed 's/ *$//g'; }
 _wget()      { wget -q -nv -O - "$1" | _normalize; }
 _CalcolaCodiceFiscale() {
    local ID=$1
    local Nome=$2          ; Nome=$(_trim "$Nome")
    local Cognome=$3       ; Cognome=$(_trim "$Cognome")
    local ComuneNascita=$4 ; ComuneNascita=$(_trim "$ComuneNascita")
    local DataNascita=$5   ; DataNascita=$(_trim "$DataNascita")
    local Sesso=$6         ; Sesso=$(_trim "$Sesso")
    local CodiceFiscale=$7 ; CodiceFiscale=$(_trim "$CodiceFiscale")

    local CodiceComune='    '
    if [ ${#ComuneNascita} -eq ${#CodiceComune} ]; then
        CodiceComune=$ComuneNascita
        ComuneNascita=$(_CalcolaNomeComune "$CodiceComune")
    fi

    if [ ${#DataNascita} -eq 8 ]; then
        [ "$DATE_LEN8_S" == "$DATE_LEN8_1" ] && DataNascita="${DataNascita:0:2}/${DataNascita:2:2}/${DataNascita:4:4}"
        [ "$DATE_LEN8_S" == "$DATE_LEN8_2" ] && DataNascita="${DataNascita:6:2}/${DataNascita:4:2}/${DataNascita:0:4}"
    fi

    _verbose "$ID" "$Nome" "$Cognome" "$CodiceComune|$ComuneNascita" "$DataNascita" "$Sesso" "$CodiceFiscale"

    if [ -n "$Nome" ] &&
       [ -n "$Cognome" ] &&
       [ -n "$ComuneNascita" ] &&
       [ -n "$DataNascita" ] &&
       [ -n "$Sesso" ] &&
       [ -n "$CodiceFiscale" ]; then
    _wget "$BASE_URL_CF?Nome=$Nome&Cognome=$Cognome&ComuneNascita=$ComuneNascita&DataNascita=$DataNascita&Sesso=$Sesso"
    else
    echo "$CF_TAGSKIPPED"
    fi
}
 _CalcolaNomeComune() { _wget "$BASE_URL_NC?CodiceComune=$1"; }

_execute | _check

exit
