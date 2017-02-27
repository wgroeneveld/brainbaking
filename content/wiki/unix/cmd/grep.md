+++
title = "grep"
draft = false
tags = [
    "unix",
    "cmd",
    "grep"
]
date = "2013-03-12"
+++
# Greppin' away 

:exclamation: **Combinatievoorbeeld met find** te vinden op [unix/cmd]({{< relref "wiki/unix/cmd.md" >}}).

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
