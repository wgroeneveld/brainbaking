+++
title = "eclipse"
draft = false
tags = [
    "code",
    "tools",
    "eclipse"
]
date = "2013-03-12"
+++
# Eclipse tips & tricks 

## Shortcuts die ik nog niet vanbuiten ken 

  * CTRL+(SHIFT)+E: view open editors & quickfind!! 
  * CTRL+M: minimize/maximize editor
  * CTRL+
    * F6: switch editor
    * F7: switch view
    * F8: switch perspective
  * CTRL+ALT+
    * R: run server
    * D: debug server
  * CTLR+SHIFT+NUMPAD/: minimize all trees in package explorer (handig bij link with editor)

## Custom preferences 

#### Static imports 

CTRL+3, "favorites" (Java/Editor/Context assist) -> New Type.<br/><br/>
Zeker handig voor *Assertions* van FEST Assert.

#### Eclipse 3.5+ en CTRL+F11 (rerun last test) 

CTRL+3, "launching" (Run-Debug/Launching) -> launch operation op "always launch prev. launched app" zetten.

#### Goto next Search Occurence combineren met next/prev. Annotation 

**next**: CTRL+SHIFT+; (punt)<br/><br/>
**prev.**: CTRL+, 

Om de shortcuts *Next/prev Annotation* te koppelen aan zoekresultaten (gearceerd door Eclipse):<br/><br/>
General->Editors->Text Editors->Annotations->Search Results->Include in next/previous navigation aanvinken.

#### Formatting en chaining 

Om niet de hele tijd commentaar te moeten plakken achter elk chained commando (anders formatteert eclipse dit allemaal op één lijn), kan je de optie *"Never linewrap"* aanzetten in Java Formatter.

## Plugins 

#### Enforce keyboard shortcuts 

http://www.mousefeed.com/ <br/><br/>
:exclamation: Knoppen waar geen snelkoppeling voor zijn werken **niet** indien deze plugin geïnstalleerd is. (bug?)

## Hacks 

#### JUnit Failure Trace iets wijsmaken 

Wanneer een JUnit test in het *fail* bericht een stracktrace regel emuleert, kan je door dubbelklikken ook daadwerkelijk naar eender welke java file op een bepaalde lijn springen, zoals het dubbelklikken op de failure trace van een bepaalde lijn zich gedraagd. Voorbeeld:

```java
		fail("Found duplicate entries in MESSAGES.PROPERTIES:<br/>r<br/>n<br/>r<br/>n"
				+ "	at be..i18n.DuplicateValuesInMessagesPropertiesTest.findDuplicateValuesInMessagesProperties(DuplicateValuesInMessagesPropertiesTest.java:30)");
```

Uw eigen regel gaat eerste staan, en eclipse "denkt" dat het een deel van de stacktrace is. <br/><br/>
Jammer genoeg niet bruikbaar voor properties files ("*Test class not found in selected project*")...