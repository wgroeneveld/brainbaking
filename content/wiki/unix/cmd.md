+++
title = "cmd"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "unix",
    "cmd"
]
date = "2013-03-12"
+++
# Unix Commandline Stuff 

### Binaries zoeken 

Kan met `whereis`, **maar** die zoekt blijkbaar niet in "alle" binary dirs - enkel degene die geconfigureerd zijn onder:

```
sysctl user.cs_path
# output: user.cs_path = /usr/bin:/bin:/usr/sbin:/sbin
```

### Shell automatisation 

Command-line programs *feeden* kan met het `expect` tooltje. Bijvoorbeeld, bij het aanloggen in `ssh` moet je daarna een wachtwoord geven en op enter drukken dat niet als commandline argument meegegeven kan worden. Dit kan je dan zo forceren:

```
#!/usr/bin/expect -f
# Expect script to supply root/admin password for remote ssh server 
# and execute command.
# This script needs three argument to(s) connect to remote server:
# password = Password of remote UNIX server, for root user.
# ipaddr = IP Addreess of remote UNIX server, no hostname
# scriptname = Path to remote script which will execute on remote server
# For example:
#  ./sshlogin.exp password 192.168.1.11 who 
# ------------------------------------------------------------------------
# Copyright (c) 2004 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# ----------------------------------------------------------------------
# set Variables
set password [lrange $argv 0 0] 
set ipaddr [lrange $argv 1 1]   
set username [lrange $argv 2 2] 
set timeout -1   
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn ssh $username@$ipaddr
match_max 100000
# Look for passwod prompt
expect "*?assword:*"
# Send password aka $password 
send -- "$password<br/>r"
# send blank line (<br/>r) to make sure we get back to gui
send -- "<br/>r"
expect eof
```

([bron](http://nixcraft.com/shell-scripting/4489-ssh-passing-unix-login-passwords-through-shell-scripts.html)) - voor meer uitleg zie {{< wp "Expect" >}} wiki. 

### Synchronizing/backupping/file copying 

Gebruik het `rsync` commando om incrementeel een kopie te nemen van een directory en alle subdirs van plaats1 naar plaats2. Dit kan lokaal, naar een externe HDD of zelfs via een server. `rsync` heeft ook een daemon mode die je aan kan zetten met `--daemon` - Zie [rsync man](http://www.samba.org/ftp/rsync/rsync.html). Het belangrijkste commando is zonder twijfel:

```
$ rsync -auv -E -W --del [src] [dest]
```

Opties:

  * `-a`: archive mode: auto-enable een hoop andere opties (keep timestamps etc)
  * `-u`: update (incremental mode)
  * `-v`: verbose
  * `-E`: preserve executability (niet nodig onder windows)
  * `--del`: delete files die in de source verdwijnen ook in de destination.

Een extra optie `-z` kan ook compressie over netwerk toevoegen. Verwijder dan best `-W`.

Je kan periodiek dit commando uit voeren om de destination dir up-to-date te houden. Vergeet niet dat rsync ook een `daemon` mode heeft, met nog veel meer opties! 

### User rechten geven om root te worden 

Probleem bij `su` commando: *su: Sorry for normal user account.*

Vergeten toe te voegen aan de `wheel` user group, zo doen:

```pw user mod vivek -G wheel```

### Shell editing mode 

Zie http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/

```
$ set -o vi
```

Best opslaan in uw `.bashrc` (of whateverrc)

-> Tof om te weten: `CTRL+L` **cleart het scherm** van een **terminal** (dit werkt ook voor Cygwin!)

### Command History 

voorbeeld:

```
dir $ history
   1 ls -la
   2 cd ~
   3 rm somedir
dir $ !2
~ $ !!
```

waarbij ![getal] laatste x commando uitvoert en !! het laatste. Zie `man history` voor geavanceerde voorbeelden.

### Copy and auto-create dir structure 

Bewaar dit shell script naar cpi.sh:

```bash
#!/bin/bash
if [ ! -d "$2" ]; then
    mkdir -p "$2"
fi
cp -R "$1" "$2"
```

`chmod +x cpi.sh` en dan in uw `.bashrc` een link leggen om `cpi` te gebruiken.

### xargs 

Het bovenstaande kan ook uitgevoerd worden met `xargs` en piping. Bijvoorbeeld bepaalde bestanden (niet-recursief) kopiëren naar "tmp":

```
ls | grep .php | xargs -i cp {} ./tmp
```

Andere interessante opties van xargs:

  * `-ix`: gebruik `{}` (of `x` karakters indien specified) om lijn per lijn de input te vervangen. Het kan zijn dat dit escaped moet worden met backslashen voor de shell!
  * `-0`: gebruik in combinatie met `-print0` en `find` om het verschil tussen spaties en newlines duidelijk te maken
  * `-p`: confirm elke actie, interessant bij verwijderen van crutiale files
  * `-lx`: gebruik maximum x lijnen input per command line. 
  * `-nx`: gebruik maximum x argumenten per command line.
  * `-t`: verbose mode (`--verbose` werkt ook)

### sed 

Gebruik `sed` om snel replaces te doen door middel van regex, of door lines te nummeren, ... <br/><br/>
Het is ook mogelijk om regex partities te *groeperen*, vergeet niet de haakjes zelf te escapen! Om de gegroepeerde waarde in het "replace" geteelde te gebruiken, moeten we niet `$1` maar `<br/>1` gebruiken. Bijvoorbeeld:

```
sed 's/<br/>(.*<br/>)/regel:<br/>1/g' log.tmp >> $logfile
```

Resultaat:

  1. Replace x door y via `s/regex/replace/`
  2. Replace alle gevonden instanties (`g` na expressie)
  3. Groepeer alles door te zoeken op `.*` en er haakjes rond te plaatsen
  4. Vervang alles door 'regel:' + alles van de groep

Dus prepend elke regel met 'regel:'.

-> Groeperen in sed vereist escaped parentheses, anders matchen we exact `(` in de zoekstring zelf!

##### chainen 

Een keer sed aanroepen en in een sequentie meerdere replaces doen gaat met het `-e` argument (script mode):

```
cat file | sed -e 's/replace/by/g' -e 's/other/new/g' 
```

##### Aan begin van lijnen prependen 

Gebruik het symbool '^' om het begin van een lijn te matchen, en '$' om het einde van een lijn te matchen:

```
cat file | sed 's/^<br/>([^=]<br/>)/  *<br/>1/'
```

Hier wordt in het begin van elke lijn spatie spatie ster toegevoegd behalve als de lijn begint met het gelijkheidsteken. Omdat we anders het eerste karakter vervangen moeten we die ook capturen! 

-> Zoals in eclipse een getal matchen met `<br/>d` werkt niet, daarvoor moet je `[0-9]` gebruiken. 

### uniq 

Vergelijkt een lijn met de volgende en gooit dubbels eruit. Instelbaar met een beperkt aantal parameters. <br/><br/>
**adjacent matching lines**, meer kan dit ding niet!

##### sed gebruiken om uniq te emuleren 

Zie http://www.catonmat.net/blog/sed-one-liners-explained-part-three/ voor volledige uitleg

```
sed '$!N; /^<br/>(.*<br/>)<br/>n<br/>1$/!P; D'
```

##### sed gebruiken om álle dubbels eruit te smijten: buffering 

```
sed -n 'G; s/<br/>n/&&/; /^<br/>([ -~]*<br/>n<br/>).*<br/>n<br/>1/d; s/<br/>n//; h; P'
```

### cut 

Een utility command dat meestal gebruikt wordt om lijnen op te splitsen afhankelijk van een __delimiter__. Bijvoorbeeld:

```
cat test.txt | cut -d '|' -f 3
```

meest gebruikte opties:

  * `-d` verplicht, geef delimiter op
  * `-f` selecteer enkel deze kolommen

### Combinatievoorbeeld 

Onderstaand script zoekt in de svn log entries met 'jira' of 'hel' (case insensitive, `-i` grep operator) behalve 'gcl' of 'lvm', print context 1 lijn above en 2 lijnen below, filtert dubbels, haalt de derde kolom eruit gesplitst door '|' (datum), vervangt eender welke hoeveelheid '-' door niets en wrap datums beginnende met 2011 met twee = tekens.

```bash
#!/bin/sh
datefrom=2011-02-28
dateto=2011-03-12
logfile=/cygdrive/c/opt/wamp/www/wiki/data/wiki/helena/svnlog.txt

pushd /cygdrive/c/opt/hudson/jobs/Helena_build/workspace/burgerlijkestand
echo "### Svn log Helena Trunk " > $logfile
echo ":exclamation: periode **[$datefrom - $dateto]**" >> $logfile
echo "#### Helena Jira's via svn log" >> $logfile
svn --username######cp8tsc --passwordq3Sp8Phu log -r{$datefrom}:{$dateto} |
	grep -B 2 -A 1 -i 'HEL-<br/>|jira' |
	grep -v 'gcl<br/>|lvm' |
	sed -e 's/-*//' -e 's/r[0-9]* .*(<br/>(.*<br/>)).*/#####<br/>1/g' -e 's/^<br/>([^=]<br/>)/  *<br/>1/' |
	sed -n 'G; s/<br/>n/&&/; /^<br/>([ -~]*<br/>n<br/>).*<br/>n<br/>1/d; s/<br/>n//; h; P' >> $logfile
popd
```


# Random commands 

  * `seq 1 10` print in een sequence getalletjes. 
  * `head` werkt ook in plaats van `tail`, maar zelfs van een lijst - ge kunt `head 1` van een stream dus gebruiken als pop voor een stack.
  * `ftp -i -n [host] << FTP_SCRIPT` newline, een hoop commands, en `FTP_SCRIPT` op het laatste = in 1 regel wat op een ftp server doen.
  * `mail -a [attach]` = in 1 regel als attach iets mailen naar iemand (zie `man`)
  * `wc` ###### wordcount; -e  enkel lijnen