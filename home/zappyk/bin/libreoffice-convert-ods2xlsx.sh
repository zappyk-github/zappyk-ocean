#!/bin/env bash

path_base=${1-.}
exte_from=${2-ods}

prog_name='soffice'
prog_name='libreoffice'

exte_conv=
exte_opts=

case "$exte_from" in
    ods ) exte_conv='xlsx' ; exte_opts='--calc'    ;;
    odt ) exte_conv='docx' ; exte_opts='--writer'  ;;
    odp ) exte_conv='pptx' ; exte_opts='--impress' ;;
    *   ) echo "Estensione '$exte_from' di conversione con configurata..." ; exit 1 ;;
esac

# Questa opzione non serve su nuovo LibreOffice
exte_opts=
echo "
# =========================
#    A T T E N Z I O N E 
# =========================
# Accertarsi che non ci sia
# nessun processo Office in
# esecuzione.
# Anche il Quick Luncher :)
# =========================
$(ps -ef | grep -v grep | grep "$prog_name" | xargs -i echo '# {}')
# =========================
"

IFS=$'\n'
for path_file in $(find "$path_base" -type f -iname "*\.$exte_from" -print0 | xargs -0 -i echo "{}"); do
    path_name=$(dirname  "$path_file")
    name_file=$(basename "$path_file")
    name_file=$(echo "$name_file" | sed "s/\.$exte_from/\.$exte_conv/i")

    [ -e "$path_name/$name_file" ] && continue

    echo "$prog_name --headless $exte_opts --convert-to $exte_conv --outdir \"$path_name\" \"$path_file\""
done

exit
