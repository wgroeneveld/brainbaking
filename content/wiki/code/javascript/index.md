+++
title = "home"
draft = false
tags = [
    "code",
    "javascript",
    "home"
]
date = "2014-07-29"
+++
# Javascript 

> Use functions to guard your scope and optimize encapsulation, gentlemen! 

JS in één-twéé-drié:

https://docs.google.com/present/edit?id######0AXaRvIf-WHu3ZGRjNnFnN2pfMmM3ajVmdjN0&hlen&authkey=COqTqcsL

:exclamation: JS **fiddles**: http://jsfiddle.net/user/jefklak/fiddles/

**JS Must watch videos**

[https:*github.com/vjdhama/js-must-watch](https:*github.com/vjdhama/js-must-watch)


#### Inhoudsopgave 

Om [Prototypal Inheritance]({{< relref "wiki/code/javascript/inheritance.md" >}}) te kunnen begrijpen, moeten eerst een aantal andere zaken duidelijk worden.

  1. De basislegging van Javascript versus klassieke class-based OO systemen:
    1. Hoe werken `function` referenties en declaraties
    2. Functies en objecten in functies steken om klassen te emuleren:
      1. Er is geen verschil tussen functies en variabelen, het zijn allemaal key/value pairs ("*first-class citizens*")
      2. De `delete` operator gebruiken om een key te verwijderen uit een object
    3. Closures als functies definiëren
    4. Constructors als functies definiëren
  2. Het aanroepen van functies:
    1. De werking van de `this` operator, functies zijn pas *gebonden* als ze aangeroepen worden! ("methods" ((een method is altijd gebonden aan een instance, een functie niet)) bestaan niet)
    2. Aanroeping door middel van `call` (vararg) en `apply` (array arg) en de verandering van `this`
    3. Via string evaluatie met `eval`
  3. de interne werking van de `new` operator
  4. Inheritance opbouwen afhankelijk van de `prototype` property
  5. Inheritance afchecken met `instanceof`, het verschil tussen dat en `typeof` kennen
  6. Mixins kunnen gebruiken in JS met:
    1. Doen alsof de constructor van een parent object wordt aangeroepen
    2. Direct bepaalde functie referenties overkopiëren met `prototype`
    3. De limitaties hiervan kennen (échte multiple inheritance bestaat niet)

### Referenties 

##### Nog te bekijken boeken 

  * {{< lib "Test Driven Javascript Development" >}}
  * {{< lib "High Performance Javascript" >}}
  * {{< lib "Javascript Patterns" >}}

##### Intern 

  * [inleiding]({{< relref "inleiding.md" >}}) bevat: constructor functies, `this` en `delete` keywords, closures en AOP in JS
  * [inheritance]({{< relref "inheritance.md" >}}) bevat: `new`, `typeof` en `instanceof` keyword, inheritance via `prototype`, mixins gebruiken en multiple inheritance faken
  * [frameworks]({{< relref "frameworks.md" >}}) bevat: uitleg hoe interne werking van Prototype JS `Object.Extend` werkt, verschillen tussen jQuery en Prototype JS
  * [snippets]({{< relref "snippets.md" >}}) bevat: herbruikbare stukken JS code
  * [scoping]({{< relref "scoping.md" >}})
  * [magic properties]({{< relref "magic_properties.md" >}}) beschikbaar in de console, in Firefox, of in Javascript 1.8.5 (ECMA impl. V5)
  * [troubleshooting]({{< relref "troubleshooting.md" >}}) in verschillende browsers
  * [performance]({{< relref "performance.md" >}}) (dynamic script loading etc)
  * [testing]({{< relref "testing.md" >}}) en automatisatie in CI omgevingen
  * [serverside]({{< relref "serverside.md" >}}) Javascript parsing en implementaties
  * [pitfalls]({{< relref "pitfalls.md" >}}) bevat het leukste deel van eender welke taal bijleren!!
  * [async]({{< relref "async.md" >}}) blocks schrijven, integratie testen met async blocks etc

**Volledige inhoudsopgave:**

<img style='' src='/img/indexmenu>code/javascript|js context navbar nocookie'>

##### Extern 

**Blogs, algemene howtos en nieuws items**

  * [http:*dailyjs.com/](http:*dailyjs.com/): A Javascript blog (ook meer NodeJS-oriented)
  * [Perfection kills: exploring Javascript by Example](http://perfectionkills.com/)
  * [John Resig blog](http://ejohn.org/category/blog/) - de bedenker van jQuery en experimenteur met ECMA5

**Documentatie en in-depth manuals**

  * [Mozilla Developer Javascript Reference](https://developer.mozilla.org/en/JavaScript/Reference)
  * [Crockford on Javascript](http://yuiblog.com/crockford/) - YUIBlog talks
  * [Dougles Crockford's Wrrrld Wide Web](http://www.crockford.com/) met hoop interessante javascript-gerelateerde pagina's!

**Specifieke frameworks/APIs**

  * [http:*knockoutjs.com/](http:*knockoutjs.com/): GUI logica loskoppelen van domein logica met knockout *"observables"*
  * [CommonsJS](http:*www.commonjs.org/) - Javascript ecosystem for building webservers, desktop apps and more (voorbeeldimplementatie: [node.js](http:*nodejs.org/))
  * [http:*jqapi.com/](http:*jqapi.com/) jQuery API buiten officiële website
  * [http:*howtonode.org/](http:*howtonode.org/) Tutorials on NodeJS

### Nog uit te pluizen 

  * - [ ] JavascriptMVC een kans geven
  * - [ ] Live.js eens in detail bekijken "ooit"
  * - [ ] Coffeescript uitgebreider toepassen
  * - [x] Jasmine en een JsTestDriver gebruiken met Maven build
  * - [ ] Node.js uitproberen
  * - [x] Envjs uitproberen
  * - [x] Zien hoe DDD in JS toegepast kan worden: ontkoppeling GUI/Domein logica: Sproutcore/Knockout?
  * - [ ] Interne werking Shizzle Selector
  * - [x] Volgorde van inladen scripts, gedrag bij dynamische script tags in DOM tree
  * - [ ] Garbarge collection details
  * - [ ] `:checked` van jQuery werkt precies niet 100% in envJS - `.click()` wel. Hoe komt dat??
