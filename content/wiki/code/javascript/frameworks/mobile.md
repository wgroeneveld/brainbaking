+++
title = "mobile"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "frameworks",
    "mobile"
]
date = "2013-03-12"
+++
# JS Clientside Mobile frameworks 

## Native applicaties deployen 

Gebruik http://www.phonegap.com/ om met CSS3+HTML5+JS een native applicatie te builden - ondersteuning voor iOS, Android, Blackberry etc.<br/><br/>
Ondersteunt ook **native hardware** zoals camera, accelerometer, GPS etc - zie [Documentatie](http://docs.phonegap.com/phonegap_media_capture_capture.md.html#Capture)

##### WebSockets in Phonegap 

Zit in de milestone 1.0 planning - nog niet officiëel ondersteund. 

  1. Voor **Android**: Zie http:*anismiles.wordpress.com/2011/02/03/websocket-support-in-android%E2%80%99s-phonegap-apps/ en [source](https:*github.com/anismiles/websocket-android-phonegap)
  2. Voor **iPhone**: Zie http:*remysharp.com/2010/10/04/websockets-in-phonegap-projects/ en [source](https:*github.com/remy/PhoneGap-Plugin-WebSocket)

## Mobile apps & Viewports 

In de `<head/>` tag is het belangrijk om viewport meta-informatie aan te geven zoals:

```html
<meta name######"viewport" content"width######device-width, initial-scale1.0"> 
```

Waarom? [daarom](https:*docs.google.com/present/view?id######dkx3qtm_22dxsrgcf4&pli1) - zie [HTML5 mobile boilerplate](http:*html5boilerplate.com/mobile/) en [A pixel is not a pixel is not a pixel](http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html).

## jQuery Mobile 

-> Zie ook [jQuery Mobile: Progressive Enhancement with HTML5](http://www.slideshare.net/todd_anderson/jquery-mobile-progressive-enhancement-with-html5-8302294) slideshare

### Zelf een pagina ophalen en tonen 

```javascript
//create markup
var newPage ###### $("<div data-rolepage data-url######yay><div data-roleheader><h1>YAY!!!!</h1></div><div data-role######content><img srchttp://bukk.it/yay.gif /></div></div");

//append it to the page container
newPage.appendTo( $.mobile.pageContainer );

//go to it
$.mobile.changePage( newPage );
```

Zie http://jquerymobile.com/test/docs/api/events.html

### Problemen met rerenderen Mobile widgets? doe het zelf! 

Zie [Coffeescript+Backbone+Mobile](https:*github.com/bnolan/Backbone-Mobile/blob/master/application.coffee) oplossing en [Corresponderende blogpost](http:*bennolan.com/2010/11/23/backbone-and-jquery-mobile.html):

<img style='float: left; width: nolink&|px;' src='/img//code/javascript/frameworks/floempie.jpg'> 

```javascript
	function render() {
		var activePage = $.mobile.activePage; // this also works: $(".ui-page-active")
		activePage.find('ul[data-role]').listview();
		activePage.find('div[data-role="fieldcontain"]').fieldcontain();
		activePage.find('button[data-role="button"]').button();
		activePage.find('input,textarea').textinput();
		activePage.page();
	}
```

Dit ziet er wel resource intensitief uit en zou op een mobiel device nogal kunnen "floepen". ((De bijhorende tekening is Copyright Kabouter Wesley enzo))

Wanneer je enkele `<li/>` elementen aan bijvoorbeeld een `listview` toevoegt, zou een `.listview("refresh")` call genoeg moeten zijn. Dit restylet enkel de nodige LI elementen, terwijl zonder argumenten de hele lijst *from scratch* re-rendert. Dit kost veel meer tijd... 

:exclamation: JS Frameworks die content dynamisch re-renderen zoals **KnockoutJS** of **Backbone** vervangen de hele lijst in de DOM tree. Dit wil zeggen dat `refresh` niet genoeg zal zijn... 
### Custom jQuery events 

jQuery Mobile laadt pagina transities allemaal in één single page HTML. Het DOM Loaded event wordt dus maar één keer afgevuurd. Hoe moet je custom JS uitvoeren bij het "laden" van één pagina?

```javascript
$("#myPage").live('pageshow', function() {
 // in here!
});
```

Waarbij `myPage` een `<div id######"myPage" data-role"page">` element is. 

:exclamation: Gebruik `live` omdat op het moment dat die code geëvalueerd wordt, die pagina waarschijnlijk nog niet aan de DOM hangt! (jQuery mobile intern)

Meer custom events:

  * `pageshow`
  * `pagehide`
  * `pagecreate`
  * `pagebeforecreate`
  * `pagebeforeshow`
  * `pagebeforehide`

Zie http://jquerymobile.com/test/docs/api/events.html

### Pagina transities: passing data 

jQuery Mobile is niet designed om 100% Client-side only Javascript applicaties te ondersteunen. `form` elementen worden gesubmit met een `POST` naar een server, nieuwe pagina's kunnen vanuit een server (PHP, JSP, ...) dynamisch opgebouwd worden. Hoe geven we tussen page transities, puur in Javascript, gegevens door?

  1. `GET` parameters manueel toevoegen en parsen vanuit de URL: *geen goed idee* omdat jQuery Mobile hashing etc toevoegt aan de URL voor navigatie!
  2. Zelf de transitie state bijhouden in een view objectje.

Het tweede kan door bijvoorbeeld een `onclick` event te registreren en HTML5 `data` attributes te gebruiken om IDs bij te houden:

```javascript
$(".vacatureLink").click(function() {
	application.setVacatureId($(this).data("id"));
});
```

Met bijvoorbeeld een KnockoutJS template:

```html
<img style='' src='/img/each vacatures'>
	<li>
		<a href######"detail.html" data-id"${id}" class="vacatureLink">${vacatureGegevens.aantalJobs} ${gezochtProfiel.functieNaam} ( ${kandidaten.length} kandidaten )</a>
	</li>
<img style='' src='/img//each'>
```

De transitie naar detail.html gebeurt ná onze `click` event handler. Bij het laden van de page op detail.html doen we "iets" met onze id:

```javascript
$("#detailsVacature").live('pagebeforeshow', function() {
	var id = application.getVacatureId();
	// doe iets?
});
```

Het is natuurlijk nog beter als die logica gewoon in de `setVacatureId` functie steekt die reeds is aangeroepen. 

## Andere JS Mobile frameworks 

  1. http://joapp.com/
  2. http://www.sencha.com/products/touch/ (ExtJS based)
  3. http://www.jqtouch.com/ (jQuery based - ouder, dev. overgeschakeld naar Sencha Touch)
  4. http://www.winktoolkit.org/ (Dojo based)
  5. http://xuijs.com/ (micro DOM manipulation framework)
  6. http://www.ipfaces.org/content/java (jsp-style bwerk)
  7. http://dhtmlx.com/touch/samples/
  8. http://www.nimblekit.com/index.php (native iOS only!)
  9. http://www.the-m-project.org/ (jQuery Mobile + Expresso, NodeJS build tool)