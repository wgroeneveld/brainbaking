+++
title = "gpsmaps"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "personal",
    "random",
    "gpsmaps"
]
date = "2013-03-12"
+++
# Unlocking Garmin GPS Maps 

:exclamation: Niet de keygen 1.5 ofzo gebruiken - werkt niet!! Ook niet MapSource upgraden hoger dan v. 6.15.7

## Topo kaarten met IMG files 

Gebruik *Garmin Unlocker* exe (44kb), die gaat by default kijken in uw register wat geïnstalleerd is.

Ook mogelijk om één specifieke `img` file te unlocken met `GarminUnlocker.exe imgset c:<br/>garmin` (dir imgs)

:exclamation: Dat programma crasht regelmatig voor samengestelde mappen?

## Topo kaarten met DEM files 

Moeilijker, proces bestaat uit verschillende delen:

##### Installeer via de installer 

komt in `C:<br/>Documents and Settings<br/>All Users<br/>Application Data<br/>GARMIN<br/>Maps` in WinXP (niet wijzigbaar)

##### Unlock installed tdb map 

Die maps zijn dan "locked" volgens MapSource. Normaal zit er in de geïnstalleerde subdir **Product1** een **.tdb** file die unlocked moet worden<br/><br/>
tdb unlocken door vorige tool te laten wijsmaken dat dit via registry geïnstalleerd is - regedit & veranderen:

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE<br/>SOFTWARE<br/>Garmin<br/>Mapsource<br/>Families<br/>FAMILY_467]
"ID"=hex:d3,01
"IDX"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>TPAUT2.mdx"
"MDR"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>.TOPO_OES.MDR"
"TYP"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>I00001D3.typ"
"UnlockURL"="http://map.garmin.be"

[HKEY_LOCAL_MACHINE<br/>SOFTWARE<br/>Garmin<br/>Mapsource<br/>Families<br/>FAMILY_467<br/>1]
"Bmap"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>Product1<br/><br/>basemap_.dem"
"Loc"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>Product1<br/><br/>"
"Tdb"="C:<br/><br/>Documents and Settings<br/><br/>All Users<br/><br/>Application Data<br/><br/>GARMIN<br/><br/>Maps<br/><br/>TOPO Osterreich v2.gmap<br/><br/>Product1<br/><br/>TPAUT2.tdb"
```

Daarna terug die keymap verwijderen anders flipt MapSource.
Die hex ID((is hex versie van int MapID versie)) moet niet juist zijn, hij gaat toch enkel zoeken naar de Tdb key in subkey `1`.

MapIds zijn [hier](http:*masmap.org/forum/viewtopic.php?f######9&t137) of [hier](http:*forum.mobilism.org/viewtopic.php?t=36929) op te zoeken. 

##### Fix MapSource 

MapSource export standaard enkel naar GPS, kan ook naar HDD (C, D, ...) subdir Garmin dan. Voor v. 6.15.5 is er een **Special exe** die dat toelaat. Er zijn voor nieuwere versies blijkbaar ook zo speciale versies, zie thepiratebay om eentje vast te krijgen. Best gewoon niet updaten.

##### Stel mappen samen en exporteer naar HDD 

Via MapSource, resultaat moet een file genaamd **GMAPSUPP.IMG** zijn. 

##### Unlock die IMG via een andere tool 

Aangezien die Garmin Unlocker regelmatig crasht en soms niet werkt (op GPS machine zelf dan "Unable to unlock map" boodschap): gebruik 'GarminUnlockerAlternative' - UNLOCK MAP DIRECTORY.exe<br/><br/>
Smijt .img in locked dir en pas headers aan.

##### Kopieer unlocked img naar GPS in Garmin map 

And done! Pf...