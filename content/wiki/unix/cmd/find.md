+++
title = "find"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "unix",
    "cmd",
    "find"
]
date = "2013-03-12"
+++
# Find command 

-> Zie http://northredoubt.com/n/2009/12/30/linuxunixcygwin-find-command/ voor enorm veel uitleg over basics van `find`.

**Voor een combinatievoorbeeld met grep**, zie [unix/cmd]({{< relref "wiki/unix/cmd.md" >}})

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
