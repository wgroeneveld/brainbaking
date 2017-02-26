+++
title = "performance"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "performance"
]
date = "2013-03-12"
+++
# Javascript Performance 

:exclamation: **Best practices on performance**: zie http:*developer.yahoo.com/performance/rules.html en ook http:*sites.google.com/site/io/even-faster-web-sites

## Script volgorde 

  1. de `<head/>` tag wordt door de browser geparsed, inclusief sequentiëel alle `<script/>` blocks. Op dit moment kunnen scripts *GEEN* DOM Manipulatie doen.
  2. de `<body/>` tag wordt door de browser geparsed, ...
  3. de DOM tree is geladen nadat alle elementen in body geparsed zijn, dus events als `$(document).ready` worden gefired. 
  4. de resources worden verder geladen (`<img/>` source attributes, dynamische script of css tags - zie volgende sectie -, en eventuele frames)
  5. de hele pagina is geladen, dus events als `window.onload` worden gefired.

Hou hier rekening mee bij het includen van scripts in pagina's. Zorg ervoor dat nét na de opbouw van de DOM tree zoveel mogelijk scripts uitgevoerd kunnen worden. Waarom?

  * De gebruiker heeft reeds (gedeeltelijk) visuele feedback ontvangen over de pagina - geen volledig blank scherm
  * Images die groot zijn duren lang om in te laden, wacht daarom nooit op een window load event. Externe domeinen kunnen ook plat liggen. 

## Async Script loading 

#### Het probleem 

`<script/>` tags inladen door browsers **blokkeert alles**, zelfs *cross-domain*! 

Dit wil zeggen dat voor het inladen van images of andere scripts of eender wat in de DOM tree, eerst het volledige script moet geëvalueerd worden. Waarom is dit zo? 

  1. Het kan zijn dat in een script tag `window.location = 'bla';` staat, dus de rest evalueren redundant is
  2. Het kan zijn dat in een script tag `document.write()` gebruikt wordt, dus dit eerst moet uitgevoerd worden (DOM manipulatie)

Moderne browsers (>= FF3, IE8) maken het mogelijk om resources *parallel* in te laden. Hiermee bedoel ik images en andere resources. Voor oudere browsers is dit dichtgeschroefd tot 2 items parallel, per domein. Resources verspreiden over verschillende domeinen versnelt dus het laden van een pagina! 

:exclamation: In Firefox worden CSS files via `<link/>` ook sequentiëel ingeladen, in IE8 parallel. Dit is op dezelfde manier op te lossen.

#### De oplossing 

##### Include scripts op het einde van de pagina 

Bij voorkeur net voor de `</body>` tag wordt afgesloten. Dit heeft *geen enkele* impact op performantie, aangezien het javascript block nog altijd geëvalueerd moet worden, maar is voor de gebruiker veel aangenamer, omdat hij de pagina letterlijk "ziet" laden. Wanneer er bijvoorbeeld een zwaar javascript filetje door de head tag gesleurd moet worden, en dit evalueren 3 seconden kan duren, ervaart de gebruiker 3 seconden lang totaal niets. Dit is super irriterend!

##### Non-blocking loading 

Gebruik non-blocking javascript block loads: zie http://yuiblog.com/blog/2008/07/22/non-blocking-scripts/

Zonder:

<img style='' src='/img//code/javascript/js_sequential.jpg|'>

```javascript
function loadScript() {
	for(var i = 0; i < arguments.length; i++) {
		var js = document.createElement("script");
		var head = document.getElementsByTagName("head")[0];

		js.src = arguments[i];
		js.type = "text/javascript";
		head.appendChild(js);
	}
}
```

Met:

<img style='' src='/img//code/javascript/js_parallel.jpg|'>

-> Dit is natuurlijk maar een voorbeeld en het gaat in dit geval over banale javascript files.

Wat zou hier moeten opvallen? (Dat het uit de cache komt maakt hier *totaal niet uit*!) Je kan aan de bruine balk ("blocked" indicatie bij firebug) zien dat in screenshot een de scripts op elkaar wachten om uitgevoerd te worden, en bij screenshot twee is dit niet het geval. 

Problemen kunnen zo wel ontstaan als het ene afhankelijk is van het andere... <br/><br/>
Daarom ook altijd best practices volgen en *separation of concerns* zo goed mogelijk toepassen!

#### Asynchrone scripts koppelen aan elkaar 

Een van de grotere problemen van de bovenstaande oplossing is de afhankelijkheid van bijvoorbeeld inline script tags met externe die dan vanaf nu *lazy-loaded* zijn via `loadScript()`. Hoe weet ik wanneer een bepaald script ingeladen en geëvalueerd werd, als dit nu allemaal parallel gebeurt? Op de volgende manier zou dit heel elegant zijn:

```html
<script src="jquery.js">
  $('.bla').show(); // and more jQuery dependant stuff
</script>
```

:exclamation: Dit werkt **niet**. Momenteel moet men twee `script` tags gebruiken... 

Stel u voor dat we jquery via `loadScript()` laden. Het zou kunnen dat bovenstaand script block dus uitgevoerd wordt voordat `$` gedefiniëerd is op toplevel scope. Oei. Nu zorgt de `src` attribute ervoor dat **altijd** eerst die externe resource volledig geladen is (jquery.js), vooraleer de interne tekst te evalueren (de CSS selector `.bla` tonen). Libraries bootstrappen kan je dus daarin doen, nadat ze geladen zijn. 

-> Indien het laden van de externe resource niet lukt, wordt de code die binnen de script tags staan ook __niet__ uitgevoerd!

Een stap verder zou zijn de library zichzelf bootstrappen, door `loadScript()` lichtjes aan te passen:

```javascript
function loadScript() {
	for(var i = 0; i < arguments.length; i++) {
		var js = document.createElement("script");
		var head = document.getElementsByTagName("head")[0];

		js.src = arguments[i].src;
		js.type = "text/javascript";
		js.text = arguments[i].callback.toString();
		head.appendChild(js);
	}
}

//usage:
loadScript({ src: 'jQuery.js',
             callback: function() {
                $('.bla').show();
             }
});
```

In de js file zelf kunnen we de tekst van de script tag die onszelf inlaadt (wow) dan evalueren ((Zie http://api.jquery.com/jQuery.globalEval/ - geen `eval()` hier dus):
 
```javascript
// library code, blablablah

var scripts = document.getElementsByTagName("script");
var curScript = scripts[ scripts.length - 1 ];
var script = curScript.innerHTML;
if (script) {
    jQuery.globalEval(script);
}
```

Zie ook http:*www.stevesouders.com/blog/2008/12/27/coupling-async-scripts/ en http:*ejohn.org/blog/degrading-script-tags/ voor meer info.

## Async Module Definition (AMD) pattern 

Zie presentatie hier: http://unscriptable.com/code/Using-AMD-loaders/#0

Komt op dit neer:

```javascript
define(['dep1', 'dep2'], function(dep1ref, dep2ref) {
  function private() {}

  return { public1: "lala", public2: "loeloe" };
});
// more defines

require('mod1', function(mod1ref) {
  // do stuff with mod1
});
```

## Head.js: parallel loading & serial executing 

http://headjs.com/ - Bevat een JS loader module dat *parallel* scripts laadt, maar in seriële volgorde de scripts uitvoert (of net niet). Zo heb je maar één script in de `<HEAD/>` tag nodig om te laden voordat de rest van de pagina geladen wordt. Onderaan de pagina wordt de rest geladen met Headjs:

```javascript
// use jQuery on the body of the page even though it is not included yet
head.ready(function() {
   $("#my").jquery_plugin();
});
 
// load jQuery whenever you wish bottom of the page
head.js("/path/to/jquery.js");
```

Wat is allemaaal mogelijk?

  * Parellel laden + serieel uitvoeren (afhankelijk van elkaar in volgorde)
  * Serieel laden + serieel uitvoeren
  * JS feature checking
  * callbacks per script dat geladen is (evt gelabeled)
  * ...

Dus nooit meer **zelf load scripts schrijven** maar gewoon *headJS* gebruiken!