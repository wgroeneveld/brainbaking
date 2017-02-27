+++
title = "feeds"
draft = false
tags = [
    "code",
    "javascript",
    "feeds"
]
date = "2013-03-12"
+++
# JS RSS Feed Readers 

Doel: Client-side RSS feeds lezen en via jQuery toevoegen aan de DOM tree in de vorm van `<li/>` elementen.

### Feed gebruiken 

:exclamation: **Prerequirements**: Eerst jQuery includen, Klak code is afhankelijk hiervan

  1. Include javascript: 2 files nodig, core klak en feeds klak:```html<script type######"text/javascript" src"http://www.jefklak.be/dev/js/klakCore.js"></script>
<script type######"text/javascript" src"http://www.jefklak.be/dev/js/klakFeeds.js"></script>```
  1. Maak ergens een `<div/>` element met een unieke ID waar de inhoud van de feed in komt.
  2. Roep de feed code aan (Na DOM Load, we wijzigen de DOM tree!): ```javascript
jQuery(document).ready(function() {
	Klak.Feeds.read(new Klak.Feeds.WikiWouter().feed(), $j("#wiki"));
});
```
  1. Klaar!

### Custom Feeds aanmaken 

De feed reader verwacht een object binnen te krijgen dat de volgende properties heeft:

  * `title` (string) toegevoegd als header aan de container
  * `url` (string)
  * `params` (object) wordt meegestuurd met JSON Request (optioneel)
  * `container` (function) retourneert een DOM element waar alles in gestoken wordt
  * `fetchData` (function, `data` arg) haalt uit het JSON response object (data) de lijst om over te loopen
  * `parse` (function, `item` arg) retourneert een opgebouwd DOM element dat aan de container toegevoegd wordt, voor elk item

Indien geen custom parsing vereist is, kan je je beperken tot de url en title en de rest overerven via `prototype`:

```javascript
Klak.Feeds.BlogWouter = function() {
	this.title = 'Jefklak<br/>'s Codex Blog Latest Updates';
	this.url ###### 'https:*ajax.googleapis.com/ajax/services/feed/load?v1.0&q=http:*www.jefklak.be/feed/';	
}
Klak.Feeds.BlogWouter.prototype = new Klak.Feeds.WikiWouter();
```

Aangezien er ook al een predefined Twitter reader in zit, kan je makkelijk een nieuwe aanmaken en enkel `title`, `url` en `user` definiëren.

### Klak API 

#### Core 

  * `loading(jQueryEl)` voegt een (hardcoded) loading image toe aan element
  * `doneLoading(jQueryEl)` verwijdert loading images die reeds toegevoegd zijn van dat element
  * `loadScript()` (vararg) laadt eender welk javascript bestand parallel - zie [code/javascript/performance]({{< relref "wiki/code/javascript/performance.md" >}})

#### Feeds 

  * `read(feed, jQueryEl)`: lees de feed en voeg de gerenderde elementen toe aan het meegegeven element. Mogelijke __predefined__ feeds:
    * BlogWouter
    * TwitterWouter
    * WikiWouter
    * WikiKristof
    * LibraryThing
