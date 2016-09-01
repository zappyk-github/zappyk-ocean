#!/bin/env bash
#_______________________________________________________________________________
#
THIS_PATH=$(dirname  "$0")
THIS_NAME=$(basename "$0" '.sh')
HTML_PATH=$(pwd)
HTML_PATH="$HOME"
HTML_PATH="$HOME/tmp"
HTML_FILE="$HTML_PATH/$THIS_NAME.html"
_EXCLUDE_="$HTML_PATH/$THIS_NAME.exclude"
_EXCLUDE_="$THIS_PATH/$THIS_NAME.exclude"
#_______________________________________________________________________________
#
 _YEAR_=''
 _FIND_='ita+movie'
#_FIND_='italian+movies'
 _FNOT_="-e ' TELESYNC'"
#SEARCH="$_FIND_"
 
 __MM__=$(date +'%_m')
#_AAAA_=$(date +'%Y')       ; [ $__MM__ -lt 6 ] && _AAAA_=$(($_AAAA_ -1))
#SEARCH="$_FIND_+$_AAAA_"
 
 AAAA_0=$(date +'%Y')
 AAAA_1=$(($AAAA_0 -1))
 AAAA_S="+$AAAA_0 +$AAAA_1" ; [ $__MM__ -ge 6 ] && AAAA_S="+$AAAA_0"
 SEARCH="$_FIND_%s"
#_______________________________________________________________________________
#
#URL_WWW='http://torrentz.eu'
#URL_WWW='https://torrentz.eu'
 URL_WWW='https://torrentz2.eu'
 URL_CSS="$URL_WWW/style.33.css"

 URL_SAFETY_QUALITY='any'
 URL_SAFETY_QUALITY='search'
#URL_SAFETY_QUALITY='verified'

 URL_ORDER='N' # by Rating
 URL_ORDER='A' # by Date
#URL_ORDER='S' # by Size
#URL_ORDER=''  # by Peers

 URL_FINDS=$_FIND_

 URL_ORDER_NAME=''
 URL_ORDER_NAME="sort -t '>' -k 2"

 URL_SEARCHING_PAGES='0'
 URL_SEARCHING_PAGES='0 1'
 URL_SEARCHING_PAGES='0 1 2'
 URL_SEARCHING_PAGES='0 1 2 3'
 URL_SEARCHING_PAGES='0 1 2 3 4'
 URL_SEARCHING_PAGES='0 1 2 3 4 5'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10 11'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10 11 12'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10 11 12 13'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10 11 12 13 14'
#URL_SEARCHING_PAGES='0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15'
#_______________________________________________________________________________
#
 URL_BASE="$URL_WWW/$URL_SAFETY_QUALITY$URL_ORDER?f=$SEARCH&p=%s"
#_______________________________________________________________________________
#
 CMD_WGET='wget --quiet --output-document=-'
#_______________________________________________________________________________
#
 PAG_REFRESH=5
 PAG_REFRESH=10
#_______________________________________________________________________________
#
#ROW_HTML="sed 's#^.*<dl><dt>##' | sed 's#</dt><dd>.*##' | grep '^<a href=' | sed 's#^\(<a href=\"\)#\\1$URL_WWW#'"
##########
 FIELDSEP='<i>\|</i>'
 ROW_HTML="sed 's#^.*<dl><dt>##'"
 ROW_HTML="$ROW_HTML | sed 's#<span class=\"v\" style=\"color:\#fff;background-color:\#A2EB80\">[0-9,]*</span>##'"
 ROW_HTML="$ROW_HTML | sed 's#<span class=\"v\" style=\"color:\#fff;background-color:\#8DDD69\">[0-9,]*</span>##'"
 ROW_HTML="$ROW_HTML | sed 's#\(<span class=\"a\">\)#\\1 $FIELDSEP #'"
 ROW_HTML="$ROW_HTML | sed 's#\(<span class=\"s\">\)#\\1 $FIELDSEP #'"
 ROW_HTML="$ROW_HTML | sed 's#<span class=\"u\">[0-9,]*</span>##'"
 ROW_HTML="$ROW_HTML | sed 's#<span class=\"d\">[0-9,]*</span>##'"
 ROW_HTML="$ROW_HTML | sed 's#<dd>##' | sed 's#</dd>##'"
 ROW_HTML="$ROW_HTML | grep '^<a href=' | sed 's#^\(<a href=\"\)#\\1$URL_WWW#'"
 ROW_HTML="$ROW_HTML | grep -v $_FNOT_"
##########
 ROW_CHAR='\&#187;'
 ROW_INIT="<div class=\"row\"><span class=\"left\">"
 ROW_MIDD="<\/span><span class=\"right\">$ROW_CHAR"
 ROW_DONE="<\/span><\/div>"
#_______________________________________________________________________________
#
_space() { sed 's/^  *//' | sed 's/  *$//' | sed 's/  */.\*/g'; }
#_______________________________________________________________________________
#
#================
# Sorgente video
#================
# CAM                      :4: La tipologia CAM indica che il film è stato ripreso con una telecamera nascosta direttamente all'interno del cinema. Solitamente la ripresa è mossa o non perfettamente centrata e a causa della bassa quantità di luce la lente non viene messa a fuoco correttamente. I colori sono spenti e sfocati, le immagini quasi mai nitide. La maggior parte delle volte il sonoro viene registrato anch'esso tramite il microfono della videocamera ed è quindi afflitto da riverbero. È inoltre possibile che in sottofondo si sentano conversazioni o altri suoni emessi dal pubblico in platea. I film italiani pubblicati tramite peer-to-peer nei primi mesi dall'uscita nelle sale cinematografiche sono generalmente di questa tipologia.
# TS (TeleSync)            :5: Il TS (abbreviazione di Telesync) è una tipologia di ripping leggermente migliore rispetto al metodo CAM. In questo caso la telecamera utilizzata per effettuare le riprese è di tipo professionale e l'inquadratura è sempre fissa e centrata grazie all'uso di un treppiede. Per ovvi motivi, i film ottenuti con questo procedimento sono una merce piuttosto inconsueta.
# TC (TeleCine)            :7: Il metodo TC (abbreviazione di TeleCine) consiste nell'impiego di una apposita macchina capace di riversare le pellicole 35mm, spesso presente negli studi dei cinema. Quando le bobine del film vengono distribuite, un operatore della macchina le riversa e poi le diffonde. La qualità è decisamente superiore rispetto a quella ottenuta coi metodi CAM e TS.
# DV/MiniDV                : : Molto rara, questa dicitura indica che la fonte di ripresa è una videocamera che utilizza un nastro in formato DV. Solitamente si tratta di videocamere MiniDV e comunque la qualità è paragonabile a quella di un rip TS.
# R3 (Region 3)            : : Questo termine sta ad indicare che il film proviene da un DVD pubblicato in Corea del Sud o comunque altre zone dell'Sud-Est asiatico. Se sul titolo vi è anche la nomenclatura ".ITALIAN", significa che l'audio proviene da fonte italiana. La qualità video di un R3 è simile a quella dei DVDRip ma può contenere anche sottotitoli in lingue straniere. O, alternativamente, sottotitoli in sovraimpressione ed in lingua italiana.
# R4 (Region 4)            : : Questo termine sta ad indicare che il film proviene da un DVD pubblicato in America del Sud, America Centrale, Caraibi, Messico, Nuova Zelanda, Australia, Nuova Guinea ed Oceania. Se sul titolo vi è anche la nomenclatura ".ITALIAN", significa che l'audio proviene da fonte italiana. La qualità video di un R4 è simile a quella dei DVDRip. Può contenere anche sottotitoli in lingue straniere o, alternativamente, sottotitoli in sovraimpressione ed in lingua italiana.
# R5 (Region 5)            :7: Questo tipologia sta ad indicare che il film è stato ottenuto da un DVD di provenienza russa e/o di altri paesi dell'est europeo. Se il titolo del film comprende anche la nomenclatura "LINE.ITALIAN", con essa viene indicato che il sonoro è proveniente da fonte italiana. La qualità video di un R5 è simile a quella dei DVDRip ma come per il caso precedente può contenere sottotitoli.
# R6 (Region 6)            : : Questo termine sta ad indicare che il film è stato ottenuto da un DVD di provenienza cinese. Se sul titolo del film vi è anche la nomenclatura ".ITALIAN", significa che l'audio proviene da una fonte italiana. La qualità video di un R6 è simile a quella dei DVDRip ma può contenere sottotitoli.
# VHSSCR (VHS Screener)    :6: Con questo termine viene indicata la fonte video proveniente da una videocassetta (VHS) specificatamente realizzata dalle case di produzione ad uso esclusivo della critica cinematografica. La qualità è generalmente discreta, ma spesso sono presenti delle scritte in sovraimpressione che reclamano il copyright.
# DVDSCR (DVD Screener)    :7: Si tratta di un DVD realizzato dalle case cinematografiche per i critici o i censori. La qualità è buona anche se, come nei VHSSCR, sono presenti scritte in sovraimpressione o scene in bianco/nero.
# DVDRip                   :7: Si tratta di un video (spesso di tipo DivX o XviD) realizzato comprimendo il segnale da DVD originali tramite l'utilizzo di appositi software e codec specifici. La qualità del film è paragonabile a quella dei DVD, sebbene in realtà il procedimento di conversione della sorgente video riduca inevitabilmente il dettaglio o la fluidità delle immagini. È possibile trovarne delle release solo nelle settimane successive alla commercializzazione del film.
# DVDMux                   : : Questa sigla indica che il video proviene da un DVD, l'audio da un'altra sorgente (praticamente sempre da linea diretta).
# DVD5                     : : Indica che il film è in formato DVD Single Layer (4,7 GB). Solitamente vengono mantenute tutte le caratteristiche del DVD originale, come per esempio le multilingue ed i sottotitoli, oltre ai menù interattivi e contenuti speciali. Il video è codificato nel formato DVD originale MPEG-2, senza perdita di qualità.
# DVD9                     : : Le dimensioni del file sono quelle di un DVD Dual Layer (8,5 GB).
# BRRip                    :8: È la sigla comparsa più di recente ed indica che il video è stato ottenuto dal Rip di una pre-release di un bluray. Può essere in diverse risoluzioni, anche HD, ma generalmente mai in formato pieno perché, salvo rare eccezioni (non ha senso rippare un 1080p sempre in 1080p), sono da 720p a scendere. La qualità del video è generalmente buona, ma essendo la lavorazione di un file già lavorato, non può raggiungere la qualità di un BDRip mentre in termini di "peso" (MB) non è differente.
# BDRip                    :8: Al contrario del BRRip la sorgente è il BluRay e la qualità è la più alta reperibile in rete. L'audio può essere AC3 o DTS. I filmati di questa tipologia sono contenuti in file (solitamente .mkv) dalle dimensioni anche superiori alla decina di Gigabytes.In termini di qualità, il BDRip è inferiore solo al Bluray Disc (BDFull) e, in alcuni casi, addirittura superiore. Alcuni bluray (di solito titoli "datati") vengono infatti messi sul mercato con una qualità video scadente. Quando vengono rippati, alcuni riescono a migliorarne la qualità applicando dei filtri che rimuovono o riducono i difetti presenti (es. puntinatura).
# Untouched                : : Il film è copiato da un disco Blu-Ray a 1080p senza nessuna ulteriore compressione audio/video, con tutti i sottotitoli e tracce audio a disposizione nel disco. È quindi impossibile notare la differenza tra un Blu-Ray Disc originale e questo tipo tipo di ripping, quindi la loro dimensione è quasi sempre superiore ai 20 GB.
# SBS                      : : Side By Side in riferimento al Video in 3D si divide ulteriormente in:
#                              * Full SBS (ogni singola immagine è ancora in HD)
#                              * Half SBS (la risoluzione è suddivisa tra le due immagini, ognuna metà)
# WEB-DL / DLMux           : : Si tratta di un 720p o 1080p reperito da iTunes americano. La qualità è paragonabile a quella di un BRRip dato che non presenta loghi di canali TV o watermark. La sua diffusione è aumentata negli ultimi tempi e permette una alta qualità senza loghi subito dopo la trasmissione TV. Il WEB-DL essendo preso quasi sempre da iTunes americano è in lingua inglese, per cui quando viene rilasciato con audio aggiuntivi è perché viene "muxato" con audio proveniente da emittenti televisive ( solitamente si tratta di audio AC3 2.0 o 5.1 a 384kbps). In questi casi il Mux è obbligatorio perché la velocità di trasmissione audio (FPS) varia da paese a paese, e il lavoro di sincronia e aggiunta di flussi audio viene appunto chiamata MUX (da Muxing/Muxer).
# WEBRip                   : : Riscontriamo questa sigla quando i film (ma in questo caso molto più spesso le serie TV o le Webseries) vengono reperite da portali di canali televisivi (come rai.tv, la7.tv e ondemand.mtv.it) o di video sharing come YouTube. La qualità varia dall'SD al 1080p, dipendente dalle politiche che il network, nel caso di canali televisivi, o la produzione (o i ripper che hanno lavorato il video) ha scelto per la distribuzione del prodotto tramite i portali.
# HQ                       :8: Codifica video in alta qualità.
# HDTV                     :8: È possibile trovare questa sigla quando il film viene registrato da TV ad alta definizione. La qualità è paragonabile a quella proveniente da una fonte DVD fino ad arrivare quasi al Bluray (1080i o 720p), ma al contrario di questi ultimi, gli HDTV presentano i loghi del canale televisivo e watermark. Eventuali intermezzi pubblicitari sono molto rari perché vengono eliminati dai ripper, tuttavia possono apparire sporadicamente delle piccole pubblicità in sovraimpressione.
# PDTV/SATRip/DVBRip/DVB-S :6: Riscontriamo queste sigle quando i film (ma in questo caso molto più spesso le serie TV) vengono registrati da canali satellitari. La qualità è buona. La sigla alternativa DVBRip (o DVB-rip o DVB-S) è spesso usata per i rip europei, in quanto il DVB è uno standard europeo (in particolare il DVB-S indica lo standard di registrazione dai decoder satellitari come SKY e DVB-T quello da digitale terrestre).
# DTTRip                   :6: In questo caso il film (ma solitamente si tratta di serie TV) viene registrato da un canale digitale terrestre. La qualità è buona e spesso sono registrati con rapporto 16:9. La registrazione da canali italiani garantisce un audio di buona qualità e senza sottotitoli o tratti in lingua originale. Talvolta è possibile trovare film o serie TV registrati da digitale terrestre sotto la dicitura PDTV o DVBRip.
# TVRip                    :6: Metodo simile al SATRip, usando però canali analogici. La qualità non è paragonabile a quella dei canali digitali e può variare a seconda di interferenze o fattori meteorologici. In genere viene usato per le registrazioni di programmi TV o avvenimenti sportivi.
# VHSRip                   :6: Il film proviene da una videocassetta (VHS). La qualità è variabile a seconda del codec.
# WP (WorkPrint)           : : Questa sigla deriva da WorkPrint ed identifica la copia di un film in versione non definitiva, ad esempio in fase di montaggio.
# SCREENER                 : : In 4:3, Dicitura inesatta introdotta negli ultimi anni, solitamente indica una qualità video VHS SCREENER.
#
#=======================
# Formato dell'immagine
#=======================
# FS (FullScreen)          : : Questa sigla indica il formato del video, in particolare il Full Screen con un rapporto di 4:3.
# WS (WideScreen)          : : Anche in questo caso si indica il formato del video, in particolare con Wide Screen si intende il formato panoramico con rapporto di 16:9.
# SD (Standard Definition) : : Questa sigla indica che il video ha una risoluzione non in HD. Spesso usata per indicare registrazione satellitari o da digitale terrestre di buona qualità ma con risoluzione minore della 720p.
# 720p                     : : La dicitura 720p indica che il video ha una risoluzione di 1280×720 pixel in modalità progressiva (p). Il video risulta molto pesante, ma allo stesso tempo di ottima qualità. WideScreen (16:9).
# 1080p                    : : È la risoluzione massima che si può trovare per un file video e corrisponde a 1920×1080 pixel in modalità progressiva (p). È la stessa dimensione pixel dei televisori Full-HD. Anche questa risoluzione è WideScreen (16:9).
#
#=============
# Codec Video
#=============
# DivX                     : : È stata sicuramente la codifica video più diffusa tra i film piratati, fino a che non è entrato in gioco il formato open source Xvid, che adesso ha praticamente soppiantato il DivX. È basato su una variante del codec libero MPEG-4.
# XviD                     : : A oggi il codec video maggiormente utilizzato nel mondo del warez, XviD è un codec video open source basato su MPEG-4 e sul progetto originale di OpenDivx. La qualità video (a parità di bitrate) è leggermente superiore a quella del suo diretto concorrente DivX. Il fatto che sia anche completamente open source e che la sua decodifica impegni meno la CPU lo fanno preferire a tutti gli altri codec.
# x264                     : : È il nome di una libreria software gratuita per la codifica in H.264 (MPEG-4 AVC) che ha preso piede tra le maggiori crew internazionali per il migliore rapporto dimensione-qualità. Lo standard sta avendo sempre maggiore successo anche per merito delle stesse crew che all'inizio del 2012 hanno stilato un manifesto dichiarando l'accoppiata x264 + AAC in un contenitore MP4 come standard de facto per la distribuzione contenuti televisivi da parte delle crew stesse.
# x265                     : : High Efficiency Video Coding (HEVC o H.265) è uno standard di compressione video approvato il 25 gennaio 2013, erede dell'H.264/MPEG-4 AVC (Advanced Video Coding, codifica video avanzata), sviluppato dal Moving Picture Experts Group (MPEG) e dal Video Coding Expert Group (VCEG) dell'ITU-T sotto il nome di ISO/IEC 23008-2 MPEG-H Part 2 e ITU-T H.HEVCMPEG e VCEG hanno stabilito un gruppo JCT-VC (Joint Collaborative Team on Video Coding) per sviluppare lo standard HEVC.HEVC migliora la qualità video, raddoppia il rapporto della compressione dei dati rispetto ad H.264 e supporta l'ultra definizione a 8k e risoluzioni maggiori fino a 8192×4320
#
#================
# Sorgente audio
#================
# MD (MicDubbed)           :4: Con questa sigla viene indicato che l'audio del film è stato preso tramite microfono (da cui appunto deriva il nome Mic Dubbed). La qualità è appena mediocre ma può variare a seconda di molti fattori acustici: qualita del microfono, presenza di spettatori nella sala, ecc.
# LC (LineDubbed)          :7: Acronimo per Low-Complexity, formato di compressione audio utilizzato per bassi bitrate.
# LD (LineDubbed)          :7: Con la sigla LD (Line Dubbed) viene indicato che l'audio è stato preso mediante un "jack" collegato con la macchina da presa. La qualità di questo metodo è molto buona.
# AAC                      :8: Codifica audio in alta qualità.
# AC3                      :8: In questo caso l'audio viene preso da un DVD/BluRay già in commercio ed è quindi di altissima qualità (spesso Dolby Digital, in quanto l'AC3 è appunto l'algoritmo di compressione del Dolby Digital). Questo metodo è tipico dei DVDRip/BDRip, ma a volte può indicare, come per la dicitura DSP, che la sorgente audio è l'impianto audio del cinema.
# DD (DigitalDubbed)       :7: Si usa questa sigla quando l'audio è preso da una fonte DTS digitale (DD appunto sta per Digital Dubbed). Con l'avvento dei nuovi sistemi audio digitali DTS2 questo non è più possibile.
# DTS                      :8: Indica che il video utilizza un codec audio di tipo DTS. Lo si può trovare nei recenti video AVS di tipo BDRip. Da non confondere con il DTS-HD Master dei BluRay, che è molto più pesante e di qualità molto più elevata.
# DSP/DSP2                 :7: Indica, in generale, che la traccia audio è passata attraverso un processore digitale (processore DSP appunto) che, in linea teorica, dovrebbe aver migliorato la qualità del suono. Talvolta indica che la traccia audio è stata registrata direttamente dal sistema audio del cinema e quindi è di qualità eccellente.
# MP3                      :7: Il codec utilizzato per la compressione audio è MP3 (ottima qualità, ma non paragonabile all'AC3).
# AC3.MERGED/MP3.MERGED    : : Indica che la traccia audio è originale (quindi molto probabilmente rippata da sorgente estera e spesso di buona qualità), ma vi è stata applicata la traccia vocale italiana per le scene che contengono dei discorsi (solitamente con qualità MD). Molto in voga tra i primi muxer, ormai è caduta in disuso.
#                              Sta invece prendendo piede il Merged dei flussi audio DTS-HD. Molto spesso infatti le Major rilasciano i film con audio DTS-HD solo in lingua inglese e il semplice DTS per le altre lingue. Alcuni ripper inseriscono la traccia vocale del proprio paese sostituendo quella inglese, trasformando il DTS-HD inglese in italiano, spagnolo, francese ecc.
# DUAL                     : : Generalmente indica la presenza di doppia traccia audio.
# RESYNC                   : : Quando si usa questa sigla vuol dire che l'audio proviene da un altro video. Questo può rendere l'audio migliore oppure subire alcuni ritardi in confronto ai rumori o alla voce del video.
#
#====================
# Altre nomenclature
#====================
# MH                       : : MultiHost, indica che il film è stato caricato su più siti di file hosting.
# UNRATED                  : : Indica che il film è privo di censure; è usato generalmente per i film horror.
# LIMITED                  : : Film uscito in un numero limitato di cinema, in una sola area geografica o in una sola nazione.
# STV                      : : Indica che il film non è mai stato prodotto per le sale cinematografiche, ma solo per la messa in onda televisiva o per il mercato home-video.
# INTERNAL                 : : Indica che il film presenta delle imperfezioni (generalmente nella parte audio).
# PROPER                   : : Indica una versione corretta di un video pubblicato precedentemente con imperfezioni di vario tipo (mancanza di audio in qualche scena, desincronizzazione audio, ecc.)
# REPACK o RECODE          : : Indica che il video è stato ripubblicato dopo essere stato corretto da eventuali imperfezioni (probabilmente per un desync audio/video nella versione precedente o per l'aggiunta di filtri per aumentarne la qualità).
# SUBBED                   : : Sta ad indicare che il film è sottotitolato in una lingua specifica. I sottotitoli non sono però rimovibili, in quanto "impressi" direttamente sul video (hardsub).
# READNFO                  : : Indica che nel file .nfo distribuito assieme al file video vi sono contenute delle informazioni o delle note riguardo al video stesso. Molto spesso, per via della caotica distribuzione sulle reti P2P, il file .nfo viene perso e ne rimane quindi solo la dicitura nel nome del file video.
# REMASTERED               : : Indica che il film è stato rimasterizzato in digitale.
# RESERVED                 : : Purtroppo non si hanno indicazioni certe, ma è probabile che indichi che il film è stato rippato in anticipo rispetto alla sua data di uscita da una fonte che già lo possedeva (come un critico cinematografico ecc...).
# NUKED                    : : Rarissimo (si può trovare quasi esclusivamente sui pre-network e sui pre-database, tracker solitamente privati dove vengono uploadati originariamente i file), indica un file che non verrà mai distribuito sui canali P2P pubblici in quanto corrotto o di qualità inferiore ad uno stesso file rilasciato precedentemente o nello stesso giorno da una crew avversaria (specialmente serie TV). È indicato anche per programmi con crack non funzionanti o infetti e file "fake".
# DUPE                     : : Versione duplicata già presente in rete e semplicemente rinominata da altri.
#
#==============
# Ripper/Muxer
#==============
# Molto spesso capita di trovare nei titoli degli screener, oltre alle sigle che indicano la qualità dello screener,
#  anche le sigle di chi ne fa rip o mux (ovvero coloro che registrano lo screener, ma non necessariamente quelli che lo diffondono)
#  quali ad esempio SiLENT, Republic, TRL, NERO69 (chiusa nel 2011), MDM, NWS, FREE, ZEN, TNZ, REV, T4P3, SVD, IDN_CREW, TSR, BmA,
#  SUNRiSE, CRiME, GBM, MvN, trtd-Team, MarcoHD (MHD) per i film, FoRaCrEw, BLUWORLD e altri per i DvdRip, BrRip e PdTv di alta qualità,
#  UBi, UPZ, DpHs, TLS, FSH ecc.
# Per le serie TV i più quotati sono NovaRip, SiD (chiusa nel 2012), DarkSideMux (chiusa nel 2013), SEEDCREW (chiusa nel 2014),
#  FoRaCrEw, Cleyndori, Pir8, ErVaas92, UBi, UPZ, TRL e altri.
# Queste sigle indicano quindi la provenienza e danno un certo livello di sicurezza sulla qualità del prodotto.
#_______________________________________________________________________________
#
 ROW_GREP="grep -v -e ' [LM]D ' -e ' HDCAM ' -e ' porn '"
_grep_exclude() {
 local file=$1
 if [ -s "$file" ]; then [ -n "$ROW_GREP" ] && ROW_GREP="$ROW_GREP |"
#ROW_GREP="$ROW_GREP grep -v -i"
 ROW_GREP="$ROW_GREP grep-v-i.pl"
  IFS=$'\n'
  for row in $(cat $file); do [ "${row:0:1}" == '#' ] && continue || string=$(echo "$row" | _space)
#ROW_GREP="$ROW_GREP -e '$string'"
 ROW_GREP="$ROW_GREP '$string'"
  done
 fi
 [ -z "$ROW_GREP" ] && ROW_FONT="grep '.'"
}
_grep_exclude "$_EXCLUDE_"
#_______________________________________________________________________________
#
 ROW_FONT=''
_font_color() {
 local file=$1
 if [ -s "$file" ]; then
  IFS=$'\n'
  for row in $(cat $file); do [ "${row:0:1}" != '#' ] && continue || string=$(echo "$row" | sed 's/^#.//' | _space)
  [ -n "$ROW_FONT" ] && ROW_FONT="$ROW_FONT |"
                             COLOR='black'
  [ "${row:1:1}" == 'b' ] && COLOR='black'
  [ "${row:1:1}" == 'g' ] && COLOR='green'
  [ "${row:1:1}" == 'o' ] && COLOR='orange'
  [ "${row:1:1}" == 'y' ] && COLOR='yellow'
  [ "${row:1:1}" == 'r' ] && COLOR='red'
 ROW_FONT="$ROW_FONT sed \"s#\(<a .*>\)\(.*$string.*\)</a>#\\1<font color='$COLOR'>\\2</font></a>#i\""
  done
 fi
 [ -z "$ROW_FONT" ] && ROW_FONT="grep '.'"
}
_font_color "$_EXCLUDE_"
#_______________________________________________________________________________
#
_html_style() {
cat << _EOD_
<head>
  <title>$URL_WWW | $URL_SAFETY_QUALITY | $URL_ORDER | $URL_FINDS</title>
  <meta http-equiv="refresh" content="$PAG_REFRESH">
</head>
<style>
.row {
  display          : block;
  border-top       : 4px solid #a7a59b;
  border-top       : 1px solid #a7a59b;
  background-color : #f6e9d9;
  height           : 22px;
  line-height      : 22px;
  padding          : 4px 6px;
  padding          : 0px 0px;
  font-size        : 14px;
  font-family      : Courier;
  color            : #000;
  margin-bottom    : 13px;
  margin-bottom    : 0px;
  clear            : both;
}
.left  { float : left }
.right { float : right }
</style>
_EOD_
#echo '<style>' ; wget "$URL_CSS" -O - 2>/dev/null ; echo '</style>'
}
#_______________________________________________________________________________
#
_wget_table() { eval "$ROW_HTML"; }
#_______________________________________________________________________________
#
_wget_pages() { eval "sed 's/^/$_YEAR_ Pag.$1 /'"; }
#_______________________________________________________________________________
#
_wget_order() { eval "$URL_ORDER_NAME"; }
#_______________________________________________________________________________
#
_html_wget() {
 IFS=$' '
 echo "# wget init..." >&2
 for year in $AAAA_S; do _YEAR_=$year
 for page in $URL_SEARCHING_PAGES; do URL=$(printf "$URL_BASE" "$year" "$page")
  wget="$CMD_WGET \"$URL\""
  echo "$wget" >&2
  eval "$wget" | _wget_table | _wget_pages $page | _wget_order
 done
 done
 echo "# ...done wget" >&2
}
#_______________________________________________________________________________
#
_wget_grep() { eval "$ROW_GREP"; }
#_______________________________________________________________________________
#
_wget_rows() { eval "sed 's/^/$ROW_INIT/' | sed 's/$ROW_CHAR/$ROW_MIDD/' | sed 's/$/$ROW_DONE/'"; }
#_______________________________________________________________________________
#
_wget_font() { eval "$ROW_FONT"; }
#_______________________________________________________________________________
#
_html_line() { echo "<span class=\"left\">$1</span><span class=\"right\">$2</span>"; }
#_______________________________________________________________________________
#
_html_rows() {
_html_line "<b>Init</b>" $(date)
_html_wget | _wget_grep | _wget_rows | _wget_font
_html_line "<b>Done</b>" $(date)
}
#_______________________________________________________________________________
#
_html() { log="$1"; _html_style >"$log"; _html_rows | tee -a "$log"; }
#_______________________________________________________________________________
#
_main() { out="$1"; tmp="$out~"; _html "$tmp" ; mv -v "$tmp" "$out"; }
#_______________________________________________________________________________
#
_main "$HTML_FILE"
#_______________________________________________________________________________
#
exit
