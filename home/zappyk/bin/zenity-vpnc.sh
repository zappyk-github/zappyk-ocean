#!/bin/env bash

default='payroll'

vpnc_conf=$1
file_icon="$HOME/Programmi/vpn/lock.png"
sleeptime=10
sleepwait=1

name_icon=$1
name_icon_tag='### I C O N = keyring.png ###'

getIcon() {
    file=$1
    row=0
    IFS=$'\t ' read row other < <(cat -n "$0" | grep -a "$name_icon_tag$")
    row=$(($row + 1))
    [ $row -eq 1 ] && return 1
    tail -n +$row "$0" > "$file"
}

setIcon() {
    this=$(basename $0 '.sh')
    tmp_icon="/tmp/$this-$USER.png"
    [ "$name_icon" == '-' ] && { getIcon "$tmp_icon" && name_icon=$tmp_icon || name_icon=''; }
    [ -z "$name_icon" ] && name_icon=/usr/share/pixmaps/status_lock.png
}

list_conf=''
for conf in /etc/vpnc/*.conf; do
    name_conf=$(basename $conf)
    name_conf=$(echo $name_conf | sed 's/\.conf//g')

    [ "$name_conf" == "$default" ] && name_conf="TRUE $name_conf" || name_conf="FALSE $name_conf"
    [ -z "$list_conf" ] && list_conf="$name_conf" || list_conf="$list_conf $name_conf"
done

if [ -z "$vpnc_conf" ]; then
    conf=$(zenity --display=:0.0 --list --radiolist --column "Seleziona" --column "configurazioni" $list_conf)
else
    conf=$vpnc_conf
fi

if [ $? == 0 ]; then
#CZ#setIcon

    command_0='vpnc'
    command_1="$command_0 --no-detach $conf"
    command_2="beesu $command_1"
    command_3="gnome-terminal -e '$command_2' -t 'vpn: $conf'"

    eval "alltray --sticky --icon \"$file_icon\" \"$command_3\"" &

    while [ $sleeptime -gt 0 ]; do sleeptime=$(($sleeptime -1))
    ps=$(sleep $sleepwait && ps -e | grep "$command_0")
    [ -n "$ps" ] && sleeptime=0; done
    [ -n "$ps" ] && zenity --display=:0.0 --text="vpn $conf connected ..." --info \
                 || zenity --display=:0.0 --text="vpn $conf not connected" --error
fi

exit

### I C O N = keyring.png ###
PNG

   IHDR   0   0   Wù   bKGD ÿ ÿ ÿ ½§   	pHYs    ÒÝ~ü   tIMEÒ!Wõíq  ÇIDATxÚí{pÓWvÇ?zÙòÏ/dc°uüby9¯å1ÙÆNÃ4Y.nÿYfÛ	N¦3Ýî´e»Mf¶³!¡Ó´Ý	MÚÂg15³mj¼lümb,°l+¶äd=~·Hæ²	dMHfzfÎÜé'ý~û=÷sï¾å¦ºÇëñqá øï«zÀRTTdZüÐãñàñxìÀá¸û¿i kEEEÚÚZêêêP«ÕÈ²L4Ee.^¼HKK--->Çsø»o*{¼¯¾úªp¹\"±±1Ñ××'ZZZÝnýýýbttTôõõ÷Þ{OTVV
àc íA+P»bÅ
ë¡CØ¾};óçÏã÷ûeù!Ðétäççc4áí·ßæý÷ß_+ ÅÿÓXû`LJJ²=zTªªª¢¹¹ËE4¥»»ÑÑQ!(--Å`0Ü Y·n¯ýï_Å¼~Í9LD°ëáà¯:iéÛ ë~¼ÛÐÐPÿÊ+¯pâÄ	&''éêêâÈ#¾@ `lÀ`,$ÕÕÔÔP\\ÌÂÂÌÍÍÑÐPFzzâíw	LaûÏ÷ùÃ?ûØçõÀ¥0fff´··3>>ÝnçØ±c´µµYãYÈÿ;Rªu[uymù
ògÙUÒrT	±ßÄt|cÙñ&]F,KRÊøX·cÇèííe``¶¶6ðô¤H_FZúÅçÙ°NBA4å@T*5È¼ ¿ ©`ÇÞ}ôu©ü"¥¬¬ËE àÔ©SÄgþìðßüèaÓÚ²\jI×k0B!R¥±QÀñÌ^£`ýF^ÿËÕpp)¤U«V199I4exxxpþß¤?U½²nß¶Jó¦X½z5ápÿhM`¨kLµ`ØJ9Lý6aÌQÕ/
 ÃaB¡HäË~cÝ·oe×ötH}BRMÄç$??p8L8»Y3àzOl¨Ô1%"¸Þúê¶¦O·K°ÇÁtKßs«íþùç-ÅÅÅÔ=iU"B­>JE8F§ÓñPQ.hÓA^=¼*îÓ×@SQ¤^R _GG:YÙ´iñ}éõú^z	·ÛMZVrA©bGïÄù¾s¼üÃ"ÈXÞ
(Õ±P!JrÄSò Øºººnô;eeedgg7 {nmìjjj$)ÞÓ) CR"A&qÍ6þíçIüüïG*Ý{øÀØí
hõ	*XÊElýäOèììDet:/¼ðYYYýÊd2ÅbÁyÕr
H+B$,C¨S ÃHÌ@ø:çúª¸Ø¨ÑóÝÓK
àôù|m6²,PPPÀÞ½{)//ÿiBB¨3L¨Õj,Ç~=éX	3A©F¿éF,L:¡ÏA(ÕÌÉ0ë'45NSghq\w¿¿÷Æær¹öL&­B+Ð%%%TUU±fÍmzzzNbb"J½å7¬_@ ¿!DDXt IhÑönô¾&|åÆdÞú§6érÞi¼]nt­Á`°íÜ¹SÒét!((( °°£ÑHrr2999èt:l6ÍßgWC-¨¤8@$V}Åç=
>;{y¿ñ~j|?Dü\¿ì"ó»Ù\ÝÕÒ=77×ÔÛÛû$IÚÆÆÆèîî¦££þþ~233ÉËËÃd2aû­4÷i2ÎE£7g_Üârä¼lãâ±Fÿè(ç;<ÛÇ[§Ã>àjOìF£GÌccc¦D"LMM!Ë26l@¡P°z}ï|xô+¿FÊPëãátB!GPF#(dRV.#8~%Qñ::ý0MmZ·'4òUZí/mm¼X4)--´´41LÃaÁ o¾òç¬ü5¼<ÄÌXH-Lyð~Jxvù@,ø^óYý%3Cû±ü .Çl=ð¯K	p'{·¶¶¶þÀddd´µµ1zæM¤¹l4^./\HcA*áoòQdy!AqwËÂøì¯¹¼Ë·Ü3ê+ Ø®^½ú\4rssÉÍÍEANNw¢+~!U#IOáNÛÎ@e%±ºpéá«xû¯ºÒ "HJ^á¹ØÌ²ï¾Áîj'M­ãuî©»§¯°Dl]]]Ï¹Ýn­×ë%233Ïç#
a6ÉÎÎfÅÈ²Ìñ§0|zÅg£¼sÒÇêhB'%/IwâuvW_¥©uì®!T_±~¸#È[£d`` dbbË/Ó××G?«V­"55p8LVVî)}&úfL´8Óimíakn9B¦C|vSÇ¯ÒÔrwªß£/ G}>ÕápLØívìv»/æ¼üòËh4æççQ*HD0$S¿÷/D"üË¿ÿ+ÎiP¸ÞÑÙ8Äd¢òuv?>JSëK!KÐtÅµª:B,ËØívTªØü±ÎÜétR]]ÙlÆjÇúý^ëÌeáihS®ã<ò§¤~ç¯±}økKõ?×T.w2¿Ûí®W«ÕÒàà ^¯ÂÂB"ÆÆF¶mÛÆòåË±Z­ÚG®LW±I¦^Lf<=S<ÿSb+®ÄÂXj 3gÎ<ÙÑÑ1ÑÕÕ%íÚµ¥RV«ezz¿ßÏ#<×ëz{{8&pXí­ô½GTZµßTIxÚ§óË¶`÷ã4µÞâ~ ÄÛ5ùý~sAA)))äççóÑGQYYIQQÇ¯BuÀ¡%êéYóüä<.²my7!*_c÷4Ùþ/Äý ¸­fïµX,ÚåËÇn¨RÑÙÙIEE²,kÏ=«N¾s#¬vFüVP[(§¼îÃsáË¶¾Æî÷"=>QK²¿pMÁúCòòrÜn7^¯úúzrssâûïx"¨·Ä?<ANyÚTÎÿÔüsð§Ýväs¿ p¹\õjµZeììlV®\ÉÉ'©ªª"??ÆÆFóçÚÉë>7><Ç¤4×§ñ\h"E_Ê?íX¼þë  °;úÁÁA¶mÛFzz:N§h4Jaa!¦±±±aùàÌeX*L%Î¢LT37:BtüÿlÃô ÞG\üàDkk«¸páØ·oÍÍÍ¸rëk7?~q¸>æufðî×B·ZÅüü¼yff¤¤$$Ibhhââb
tîÜ9>wèóá;sÕsÇVà¯ÔÛµÀÀ={öK._|Qööv¡×ë½÷zÜøu+à§LióæÍ³ÙLzz:íííÔÔÔ¬=}útÎ½¼?P> %Fº»»¤¨¨zzzxúé§)--­¿cÕðMMMÕí-[0L<yÇ{JÅéÓ§q¥¾±
8Á ùÒ¥K\»v¥RINNgÏ%
ÝÓéR Àïóùê
ä÷ûQ«Õ8Nèéé±Þ­Úªâ9Ý[RR"***ëAßB[ìãÿí[fÿÔj½y»    IEND®B`
