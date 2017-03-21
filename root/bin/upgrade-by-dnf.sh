#!/bin/env bash
#
RELEASEVER=$1 ; [ -z "$RELEASEVER" ] && echo "Releasever?" && exit 1
#_______________________________________________________________________________
#
 dnf upgrade --refresh
 dnf install dnf-plugin-system-upgrade
 dnf system-upgrade download --releasever=$RELEASEVER
#_______________________________________________________________________________
#
 dnf repoquery --unsatisfied
 dnf repoquery --duplicated
 dnf list extras
#dnf autoremove
#_______________________________________________________________________________
#
exit
################################################################################
#
# https://fedoraproject.org/wiki/DNF_system_upgrade/it
#
################################################################################
# Cos'é il 'DNF system upgrade'
# 
# dnf-plugin-system-upgrade è un plugin per il manager di pacchetti dnf che gestisce gli aggiornamenti di sistema. É il metodo di aggiornamento raccomandato per le versioni di Fedora superiori alla 21.
# 
# Funzionamento
# 
# Il 'DNF system upgrade' aggiorna il sistema ad una nuova versione di Fedora usando un meccanismo simile a quello usato per gli aggiornamenti in locale (offline). I pacchetti aggiornati vengono scaricati mentre il sistema funziona normalmente, per poi riavviarsi in una modalità adatta ad installarli. Una volta terminato, il sistema si riavvìa di nuovo nella nuova Fedora.
# 
# Come si usa
# 
# Backup dei propri dati. Ogni cambiamento del sistema è potenzialmente a rischio, quindi essere prepararsi all'eventualità. Nel caso si voglia aggiornare la propria (Fedora) workstation, è ancora preferibile scaricare una immagine live della Workstation ed assicurarsi che il proprio hardware (scheda grafica, wifi, etc) funzioni bene con l'ultimo kernel disponibile.
# Aggiornare il sistema usando gli strumenti grafici standard oppure pkcon o dnf:
# $ sudo dnf update --refresh
# É raccomandato riavviare il computer, specie se viene installato un nuovo kernel.
# Si prega di tener presente che esiste un problema se si usa un tema plymouth non predefinito.</br>
# 
# Seguire i seguenti passaggi.
# 
# Installare Package-x-generic-16.pngdnf-plugin-system-upgrade:
# $ sudo dnf install dnf-plugin-system-upgrade
# Scaricare i pacchetti aggiornati:
# $ sudo dnf system-upgrade download --refresh --releasever=25
# Modificare il numero --releasever= in base al sistema a cui si vuole aggiornare. Molti utenti aggiornano all'ultimo sistema stabile disponibile, cioé 25, ma se si usa una Fedora 23, si potrebbe voler aggiornare ad una Fedora 24. Si può anche usare 26 oppure rawhide per avere una Rawhide (attenzione: queste sono versioni instabili di Fedora).
# 
# Se alcuni pacchetti hanno dipendenze insoddisfatte, l'aggiornamento non andrà avanti a meno che non si usi l'opzione --allowerasing. Spesso accade se si usano pacchetti provenienti da scaricamenti esterni a quelli ufficiali.
# In caso di dipendenze insoddisfatte, si possono avere ulteriori dettagli aggiungendo l'opzione --best.
# Innescare il processo di aggiornamento:
#  $ sudo dnf system-upgrade reboot
# Il sistema verrà riavviato immediatamente, ed apparirà il processo di aggiornamento all'avvìo.
# 
# Attenderne il completamento.
# FAQ
# 
# Come riportare eventuali bug
# Innanzitutto dare uno sguardo ai Common F25 bugs o Common F26 bugs per controllare se il problema è già conosciuto. Se non c'é, fare una ricerca per un eventuale bug report esistente. Se non esiste ancora, se ne può aprire uno seguendo le istruzioni nel file README ed in man dnf.plugin.system-upgrade.
# 
# Se si incontrano problemi con uno specifico pacchetto, aprire un bug report riferito a quello stesso RPM.
# 
# Il 'DNF system upgrade' verifica il software in esecuzione o quello che installa durante l'aggiornamento ?
# Sì. Le chiavi firmate per i nuovi rilasci di Fedora vengono inviati al vecchio sistema in modo da permettere a dnf di verificare l'integrità dei pacchetti scaricati. É possibile scaricare questa funzione con il parametro --nogpgcheck (non raccomandato, il sistema sarebbe poi vulnerabile ad attacchi di software malevole).
# 
# I pacchetti da repository non-fedora verranno aggiornati ?
# Sì, se impostati come repository per dnf. I repository non-fedora comunemente usati di solito funzionano, ma meglio verificare che siano già disponibili i pacchetti adatti alla nuova versione di Fedora. In caso contrario non impedirebbe il completamento dell'aggiornamento.
# 
# 
# É possibile aggiornare i rilasci End of life?
# Fedora raccomanda fortemente di non usare versioni obsolete non più supportate; si dovrebbe perciò evitare di far "scadere" la propria Fedora installata.
# 
# Detto questo, se si utilizza una versione più recente della 20 si dovrebbe cercare di aggiornarla. É possibile farlo attraverso rilasci intermedi, oppure aggiornando alla versione più recente in una sola volta. Non è possibile stabilire con certezza quale approccio è più probabile che abbia successo.
# 
# Se si preferisce aggiornare attraverso due o più versioni, leggi qui.
# 
# Se si usa una versione di Fedora più vecchia della 20 è impossibile utilizzare il DNF system upgrade soltanto, ma bisogna seguire il vecchio metodo con dnf o yum. Aggiornare fino a Fedora 21 e poi continuare usando 'DNF system upgrade'.
# 
# 
# Posso usare questa procedura per aggiornamenti a versioni non-stabili di Fedora (ad esempio ad un rilascio Beta) ?
# Sì. Sarebbe sempre possibile farlo, tuttavia questa funzione potrebbe essere soggetta a malfunzionamenti temporanei proprio per la natura non-stabile dei pacchetti.
# 
# Operazioni opzionali post-aggiornamento
# 
# Queste sono operazioni che è possibile fare dopo un aggiornamento avvenuto con successo. Sono da utilizzare per utenti esperti, se non si è abituati ad usare un terminale non bisogna preoccuparsi.
# 
# Aggiornamento dei file di configurazione di sistema
# La maggior parte dei file di configurazione sono immagazzinati in /etc. Se c'é qualche aggiornamento e questi file sono stati modificati prima, RPM creerà nuovi file con il suffisso .rpmnew (il nuovo file config), oppure con .rpmsave (il vecchio file config conservato). É possibile cercarli per recuperare le modifiche apportate precedentemente. rpmconf è uno strumento che aiuta in questa operazione:
# 
# $ sudo rpmconf -a
# Pulizia dai vecchi pacchetti
# É possibile avere una lista di pacchetti con dipendenza mancante con il comando:
# 
# $ sudo dnf repoquery --unsatisfied
# Se ce ne sono alcuni, meglio rimuoverli perché comunque non funzioneranno come devono.
# 
# Per avere una lista dei file duplicati:
# 
# $ sudo dnf repoquery --duplicated
# Dei pacchetti ordinari dovrebbe essere installata soltanto la versione più aggiornata.
# 
# Alcuni pacchetti potrebbero rimanere sul sistema mentre sono stati rimossi dai repository:
# 
# $ sudo dnf list extras
# Rimuoverli se non più utili. Da notare che la lista è valida se si usa un sistema pienamente aggiornato, in caso contrario si otterranno paccheti installati che non sono più disponibili nei repository perché in una nuova versione.
# 
# É possibile rimuovere i pacchetti non più necessari con:
# 
# $ sudo dnf autoremove
# Notare che DNF decide che un pacchetto non è più necessario se non si è esplicitamente chiesto di installarlo oppure non è richiesto da altri pacchetti. Ciò non significa che il pacchetto non è utile, rimuovere solo ciò che si è consapevoli non essere più necessario. Notare inoltre che esiste un bug noto in PackageKit: bug 1259865.
# 
# Risoluzione di alcuni eventuali problemi post-aggiornamento
# 
# Da seguire solo se necessario.
# 
# Ricostruzione del database degli RPM
# Se si notano degli avvertimenti mentre RPM/DNF lavora, il database degli RPM potrebbe essere corrotto. É possibile ricostruirlo per tentare di risolvere il problema. Fare un back-up di /var/lib/rpm/ prima. Per ricostruire si usa:
# 
# $ sudo rpm --rebuilddb
# Utilizzo di distro-sync per risolvere problemi di dipendenza
# Lo strumento d'aggiornamento usa il metodo distro-sync predefinito. Se il sistema rimane parzialemente non aggiornato o si notano problemi di dipendenza tra pacchetti, potrebbe essere uitle riavviare il distro-sync manualemte:
# 
# $ sudo dnf distro-sync
# Una variante più efficace permette di rimuovere il pacchetto con le dipendenze non soddisfatte. Fare sempre attenzione a quali pacchetti si decide di rimuovere:
# 
# $ sudo dnf distro-sync --allowerasing
# Rietichettatura dei file con le recenti regole di SELinux
# Se si notano avvertimenti riguardo ad operazioni non permesse a causa delle correnti regole SELinux imposte, alcuni file potrebbero avere etichettature non corrette per i permessi di SELinux. Questo potrebbe essere causato da bug o se SELinux è disabilitato, in questi casi si procede con la rietichettatura dell'intero sistema:
# 
# $ sudo touch /.autorelabel
# $ reboot
# L'avvìo successivo e solo quello sarà più lungo a causa dei controlli effettuati su tutti i file.
