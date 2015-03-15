#!/bin/env bash

URL_BASE_1='http://translate.google.it/translate_t'
URL_BASE_2='http://translate.google.it'
URL_BASE_3='http://www.google.it/dictionary'

DEF_LANG_HL='it'    # Linguaggio della pagina web
DEF_LANG_SL='it'    # Linguaggio da tradurre in...
DEF_LANG_TL='en'    # Linguaggio tradotto in...

TEXTURE=''
LANGUAGE=''
TRANSLATE=''
INVERT=false

while test -n "$1"; do
    case "$1" in
        -l  | --language  ) LANGUAGE=$2 ; shift ;;
        -t  | --translate ) TRANSLATE=$2 ; shift ;;
        -i  | --invert    ) INVERT=true ;;
        *                 ) [ -z "$TEXTURE" ] && TEXTURE="$1" || TEXTURE="$TEXTURE $1" ;;
    esac
    shift
done

[ -n "$LANGUAGE"  ] && LANG_HL=$DEF_LANG_HL
[ -n "$TRANSLATE" ] && IFS=$':' read LANG_SL LANG_TL < <(echo "$TRANSLATE")

[ -z "$LANG_HL" ]   && LANG_HL=$DEF_LANG_HL
[ -z "$LANG_SL" ]   && LANG_SL=$DEF_LANG_SL
[ -z "$LANG_TL" ]   && LANG_TL=$DEF_LANG_TL

( $INVERT )         && LANG_XX=$LANG_SL && LANG_SL=$LANG_TL && LANG_TL=$LANG_XX

[ -z "$LANG_HL" ]   && echo 'Settare il linguaggio della pagina...'   && exit 1
[ -z "$LANG_SL" ]   && echo 'Settare il linguaggio da tradurre in...' && exit 1
[ -z "$LANG_TL" ]   && echo 'Settare il linguaggio tradotto in...'    && exit 1
[ -z "$TEXTURE" ]   && echo 'Settare il testo da tradurre...'         && exit 1

URL_TRANSLATE="$URL_BASE_1?hl=$LANG_HL&text=$TEXTURE&sl=$LANG_SL&tl=$LANG_TL#"
URL_TRANSLATE="$URL_BASE_2/#$DEF_LANG_SL|$DEF_LANG_TL|$TEXTURE"
URL_TRANSLATE="$URL_BASE_3?aq=f&langpair=$LANG_SL|$LANG_TL&q=$TEXTURE&hl=$LANG_HL"
CMD_TRANSLATE="links -source '$URL_TRANSLATE'"

_html_prune_lenguage() {
    tag=`cat -n "$0" | grep '^_LIST_LENGUANGE_$' | xargs | cut -d' ' -f1`
    tot=`cat "$0" | wc -l`
    num=`echo "$tot-$tag" | bc`
    cmd=`tail -$num "$0" | sed "s/^/-e \\\'^/" | sed "s/$/\\\'/" | xargs echo grep -i -v -e '^\&'`
    eval "$cmd"
}

_html_normalize() {
    hxnormalize -l 99999 2>/dev/null
}

_html_extract() {
#CZ#hxextract table -
    hxextract .dct-srch-otr -
}

_html_prune() {
#CZ#hxprune -c tabbar     | \
#CZ#hxprune -c tab        | \
#CZ#hxprune -c footer     | \
#CZ#hxprune -c small      | \
#CZ#hxprune -c big        | \
#CZ#hxprune -c main       | \
    hxprune -c gls        | \
    hxprune -c mr-wds     | \
    hxprune -c prn-btn    | \
    hxprune -c dct-rt-sct
}

_html_prune_element() {
#CZ#grep -i -v -e option -e select -e 'id="zippyicon"'
    cat -
}

_html_replace_char() {
#CZ#sed 's/&raquo;/>>/'
    cat -
}

_html_view() {
    html2text "$@"
}

_init() {
    echo
    echo "$CMD_TRANSLATE"
    echo "${CMD_TRANSLATE//?/_}"
}

_main() {
#CZ#eval "$CMD_TRANSLATE" \
#CZ#| _html_view -unparse \
#CZ#| _html_prune_lenguage \
#CZ#| _html_prune_element \
#CZ#| _html_replace_char \
#CZ#| _html_view -style pretty

    eval "$CMD_TRANSLATE" \
    | _html_normalize \
    | _html_extract \
    | _html_prune \
    | _html_prune_element \
    | _html_replace_char \
    | _html_view
}

_done() {
    notify="Traduzione [$LANG_SL ==> $LANG_TL] di [$TEXTURE]"

    echo "${notify//?/_}"
    echo "$notify"
}

_init
_main
_done

exit
 
_LIST_LENGUANGE_
Afrikaans
Albanese
Arabo
Bielorusso
Bulgaro
Catalano
Ceco
Cinese
Coreano Croato
Danese
Ebraico
Estone
Finlandese
Francese
Galician
Gallese
Giapponese  Greco
Hindi
Indonesiano
Inglese
Irlandese
Islandese
Italiano
Lettone
Lituano Macedone
Malese
Maltese
Norvegese
Olandese
Persiano
Polacco
Portoghese
Rumeno  Russo
Serbo
Slovacco
Sloveno
Spagnolo
Svedese
Swahili
Tagalog
Tailandese  Tedesco
Turco
Ucraino
Ungherese
Vietnamita
Yiddish
