+++
title = "regexp"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "regexp"
]
date = "2013-03-12"
+++
# Regexp Stuff 

## Eclipse Regexp Find & replace 

### Autowired fields als method omvormen 


Probleem: ik wil voor elke autowired field een private method aanmaken die diezelfde field retourneert om snel te kunnen inlinen. Dus dit staat er:

```java
@Autowired
private SjabloonService<VonnisArrestSjabloon, VonnisArrestSjabloonDTO> vonnisArrestSjabloonService;
```

En dit gaat bijkomen:
```java
 SjabloonService<VonnisArrestSjabloon, VonnisArrestSjabloonDTO> vonnisArrestSjabloonService() {
        return vonnisArrestSjabloonService;
    }
```

**Zoeken op**

`private (<br/>w+(<[<br/>w<br/>,<br/>s]+>)?) (<br/>w+);`

**Vervangen door**

`$0public $1 $3() { return $3; }`

:exclamation: "`<br/>n`" toevoegen tussenin gaf een fout in Eclipse, snel "`;`" vervangen door "`;<br/>n`" in Notepad++ werkte wel.

### Javadoc bij Overrides verwijderen 

Probleem: ik wil mottige Javadoc verwijderen die automatisch gegenereerd wordt bij `@Override` methods.

** Zoeken op**

`<br/>}([<br/>s]*)/<br/>*<br/>*[^<br/>{]*@Override`

**Vervangen door**

`}<br/>1@Override`

### Urls matchen en HTML tags toevoegen 

**Zoeken op**


/(https?:(.[^<br/>s]+))/


Doet het volgende:
  1. http met eventueel secure
  2. dubbelpunt
  3. één of meer keer (plus)
  4. een karakter (punt)
  5. behalve (vierkante haakjes)
  6. spatie (backslash s)
  7. capture alles in een argument met haakjes (voor dollar in replace)

**Vervangen door**

`<a>$1</a>`

### Bepaalde substrings met een prefix matchen 

Bijvoorbeeld `@Jef: hey coole!`

**Zoeken op**

`/@(<br/>w+)/`

Makkelijker omdat backslash w alfanumerieke waarden covert, en men weet wat de startende character is.