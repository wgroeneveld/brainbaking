+++
title = "Heavily used Unix Commands"
subtitle = "Unix Commandline stuff in here!"
draft = false
archived = true
tags = [
    "unix",
    "cmd"
]
date = "2013-10-01"
categories = [ "software" ]
+++

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
  * `wc` = wordcount; -e  enkel lijnen

## Video converting/concatenating etc 

Met behulp van `ffmpeg` .

#### Concatting 

Alle files die eindigen op mp4:

```
ffmpeg -f concat -i <(printf "file '%s'<br/>n" ./*.mp4) -c copy output.mp4
```

Gaat ook met `mplayer` en de tool `mencoder`:

```
mencoder -oac pcm -ovc copy -idx -o all.mp4 1.mp4 2.mp4 3.mp4 4.mp4 5.mp4
```

#### Resizing (compressing) 

Ook met `ffmpeg` - bijvoorbeeld reduceren naar "medium" quality. Neem alle mp4s in folder:

```
for i in *.mp4 ; do ffmpeg -i "$i" -c:a copy -preset medium "${i%.*}_medium.${i##*.}"; done
```

Voor meer presets zoals "medium", zie http://trac.ffmpeg.org/wiki/x264EncodingGuide

# Bash Scripting


#### Rerun last command 

```
!!
```

Joink.

#### bash opties uit een shell script halen 

Gepikt van http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

```bash
#!/bin/bash
for i in $*
do
case $i in
    -p######*|--prefix*)
    PREFIX######`echo $i | sed 's/[-a-zA-Z0-9]*//'`

    ;;
    -s######*|--searchpath*)
    SEARCHPATH######`echo $i | sed 's/[-a-zA-Z0-9]*//'`
    ;;
    -l######*|--lib*)
    DIR######`echo $i | sed 's/[-a-zA-Z0-9]*//'`
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
done
echo PREFIX = ${PREFIX}
echo SEARCH PATH = ${SEARCHPATH}
echo DIRS = ${DIR}
```

Makkelijker dan `getopts()`?

#### Pipen en multiple lines in shell scripts 

Dit is legale shell code:

```bash
#!/bin/sh
cat dinges.log |
  cut -d ' ' -f 3
  grep 'Exception' |
  uniq
```

De pipe aan het begin van een nieuwe lijn alleszins niet. Ook `>>` of `>` kan niet het begin zijn van een nieuwe lijn, dan wordt een spatie gepiped naar de outputstream.

#### array loops 

```bash
names=( Jennifer Tonya Anna Sadie )
for name in ${names[@]}
do
  echo $name
  # other stuff on $name
done
```

Ook mogelijk om bvb een counter bij te houden met `for (( i = 0 ; i < ${#names[@]} ; i++ ))`. Array waarde accessen met `${names[$i]}`.

Inline arrays "maken" en over lopen gaat met `for VAR in 'a' 'b' 'c' do ... done`.

##### argumenten samen rapen in een variabele 

```bash
DIR_EXCLUDES=(eclipsecompiled test bin target)
FILE_EXCLUDES=(messages errors)

SEARCH=""

for FILE_EXCLUDE in ${FILE_EXCLUDES[@]}
do
  SEARCH="${SEARCH} -not -name *${FILE_EXCLUDE}*"
done
for DIR_EXCLUDE in ${DIR_EXCLUDES[@]}
do
  SEARCH="${SEARCH} -not -path *${DIR_EXCLUDE}*"
done
```

:exclamation: dit werkt **niet** als er een dubbele quote bij komt kijken in de vorm van `<br/>"` - vreemd? uit te zoeken...

#### Controleren of een string in een variabele steekt 

Zie http://stackoverflow.com/questions/229551/string-contains-in-bash - makkelijkste manieren zijn

##### met grep 

```bash
if grep -q '|' <<<$line; then
  echo "jup"
fi
```

##### met regexp 

```bash
if [[ "$line" =~ "|" ]]; then
  echo "jup"
fi
```

#### Loopen over alle lijnen van bepaalde output voor verdere processing 

```bash
`cat somefile` | while read line
do
  echo "lijn $line"
done
```

Dit kan ook maar dan moet je de separator variabele voor `for` aanpassen:

```bash
IFS=$'<br/>n'
for line in `cat somefile`
do
  echo "lijn $line"
done
```

:exclamation: By default splitst for **op spaties**

# Find command 

-> Zie http://northredoubt.com/n/2009/12/30/linuxunixcygwin-find-command/ voor enorm veel uitleg over basics van `find`.

### Finding stuff 

```
find / -name "*.ext" -type f -exec [command with args] {} <br/>;
```

Bovenstaande lijn zoekt in root directory voor alle .ext bestanden (-type f is standaard, `d` staat voor directory etc, zie manual) en pipet alle resultaten naar een bepaald commando achter `-exec`. `{}` Stelt het gevonden bestand voor (full path), `<br/>;` eindigt het exec commando. De puntkomma wordt escaped door die backslash. 

:exclamation: - Er moet een **Spatie** tussen `{}` en `<br/>;` komen, anders krijgt men een foutmelding: 

> find: missing argument to '-exec'

### Includen en excluden: filters 

Ik zoek *.properties behalve die en die file en overal behalve in die en die directory:

```
find . -name "*.properties" -not -path "*dir*" -not -name "ugly.properties"
```

`-not` is te combineren met eender wat én te chainen, bijvoorbeeld met `-size` enzo.

# Greppin' away 

#### Surrounding lines while greppin' 

Dit heet **lines in context** in *man grep*.

```
grep -B 3 -A 2 foo README.txt
```

Verklaring: Zoek foo in readme.txt met 3 lijnen boven en 2 lijnen onderaan. <br/><br/>
Indien aantal lijnen gelijk, gebruik simpelweg `-C [x]`.

#### Inverse grepping 

##### In file contents 

Om te zoeken naar bijvoorbeeld 'hond', maar niet 'kat', moet je inverse zoeken voor kat:

```
cat file | grep 'hond' | grep -v 'kat'
```

#### Finding pattern a OR b 

Combineren gaat met het pipe character (escaped) `<br/>|` - voorbeeld zoekt naar hond of kat:

```
cat file | grep 'hond<br/>|kat'
```

:exclamation: Normale manier is `egrep pattern1|pattern2` gebruiken of `grep -E pattern1|pattern2`.

#### Toon meer info bij context 

```
grep 'zoekstring' file.bla -n -H 
```

Print ook line numbers & filename, vooral handig wanneer dit van een `-exec` commando komt van een search, bijvoorbeeld:

```
find . -name "*.php" -exec grep 'backlink' {} -C 2 -n -H <br/>; > find_backlinks.txt
```

  1. Zoek alle .php files vanaf de current directory
  2. Zoek in alle gevonden files naar 'backlink'
  3. Print 2 bovenste en onderste context lijnen af
  4. Print lijn nummer en prefix met bestandsnaam
  5. Output alles naar find_backlinks.txt

De `-print` flag bij find print de filename af voor elke gevonden file die naar de `-exec` doorgegeven wordt. 

:exclamation: Onder Solaris een commando uitvoeren met `-exec` moet dit ook nog gewrapped worden met een shell executable, zo:

```
find . -name "*.php" -exec sh -c 'grep -n "backlink" $1' {} {}<br/>; -print
```

Vergeet niet dat grep ook **andere argumenten** (of volgorde) heeft (eerst flags dan search pattern en file, geen -C option etc)!<br/><br/>
Zie http://www.compuspec.net/reference/os/solaris/find/find_and_execute_with_pipe.shtml <br/><br/>
