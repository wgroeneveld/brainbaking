+++
title = "frameworks"
draft = false
tags = [
    "code",
    "javascript",
    "frameworks"
]
date = "2013-03-12"
+++
# Hoe objecten extenden 

:exclamation: Zie [Uitleg over Javascript werking met inheritance]({{< relref "wiki/code/javascript/inheritance.md" >}}) en [code/javascript/inleiding]({{< relref "wiki/code/javascript/inleiding.md" >}}).

## Prototype's Extend 

Op de vorige wijze werkt bijvoorbeeld Prototype's `Element.Extend` of `$` (naast de CSS Selector natuurlijk).

```javascript
// ignoring Prototype's initialize() constructor method
var Poes = Class.create({
  miauw: function() { return "prr"; }
});

var Hond = Class.create({
  blaf: function() { return "WOOF"; }
});

var kat = new Poes();
Element.extend(kat, Hond);

assertEquals(kat.blaf(), new Hond().blaf()); // hoo lee sjit
```

De bovenstaande code wordt intern gebruikt om **inheritance** te faken. <br/><br/>
Dat wil zeggen, een `Hond` die van een `Poes` afleidt, kan zo:

```javascript
var Hond = Class.create(Poes, {...});
```

Van de eerste parameter worden gewoon alle functie pointers gekopiëerd. Boem.

:exclamation: **Constructor overloading** - bestaat natuurlijk niet, dus een manier om dat te omzeilen is de pointer `$super` gebruiken die de superklasse zijn constructor aanroept. Dit gebeurt ook niet automatisch. Initialize wordt dus nooit overschreven. 

### Hoe werkt dit? 

Simpel: gebruik `for(key in map.prototype)` om te loopen over alle functie pointers. Copypasta. Done.<br/><br/>
Dit kan ook gebruikt worden om bestaande functies uit te breiden! (zoals String, Array, ...)

## Prototype's Pointer binding 

Probleem: stel dat een klasse wordt opgemaakt met de bovenstaande methode. De `this` pointer verwijst standaard naar de array die binnen de scope valt van uw code, dus vanuit een functie kan men een andere in dezelfde map oproepen. **MAAR** this wordt overschreven wanneer de functie als *closure* wordt meegegeven. Common examples zijn bvb. bij onload, bij each, bij ajax calls als onsuccess/failure/... events, ...

```javascript
Event.observe(window, "load", function() {
  klasse.doeIets(); // this binnenin doeIets() is nu window! BOOM
});
```

Om dit te omzeilen kan men eender welke functie pointer binnen eender welke method vervangen met `bind`. Vorige voorbeeld aangepast:

```javascript
Event.observe(window, "load", function() {
  klasse.doeIets(); // this binnenin doeIets() is nu zoals verwacht klasse zelf.
}.bind(klasse));
```

### Hoe werkt dit? 

bind is een extentie van Object (zie extend boven), dus oproepbaar op eender welke extended method. <br/><br/>
De rest van de magie is eigenlijk helemaal geen Prototype maar JS 1.3 methods `apply()` of `call()`. 

Bezie ze als reflection methods die als eerste argument de this pointer binnen pakken, en voor de rest bij call een lijst van argumenten (alles), en bij apply een array als 2de argument met alle argumenten (bvb `arguments` zelf). Dus:

```javascript
function wow(one, two) {
  console.log(this); // default output: window
  return one + two; 
}

var arr = {
  c = "cc"
};

wow.apply(arr.c, [10, 2]); // prints "cc", output = 12
wow.call(arr.c, 10, 2); // same
```

`apply(**this pointer**, **array argument**)`. 

Echt "reflectie" is het niet, de functiepointer is nodig om apply op te roepen. Het echte werk laten we aan `eval()` over.

:question: Interessant om te weten: `curry` werkt ook met `apply` om automatisch parameters in te vullen. 

### Binding en jQuery 

jQuery's context verandert automatisch. Dit wil zeggen dat "this" binnen een bepaalde closure automatisch het object wordt waar bijvoorbeeld over geloopt wordt. 

  1. Binnen de meeste callback methods ('success' van `$.ajax` bvb) is this het callback object
  2. Binnen each is this het ide element in de array waar over geloopt wordt

jQuery biedt niet by default ondersteuning om dit te veranderen met binding, **behalve** in sommige uitzonderlijke gevallen zoals `$.ajax`. Hier kan je een `context` aan meegeven, waardoor this in de context verandert. Bijvoobeeld:

```javascript
function SomeClass() {
  this.doeIets = function() {
    $.ajax({
      url: "bla.json",
      dataType: "json",
      context: this,
      callback: function(data) {
        // this is nu de instantie van SomeClass dankzij context
        // anders zou this data zijn.
      }
  }
}

var someInstance = new SomeClass();
someInstance.doeIets();
```

# JS Error Handling 

Javascript heeft een globale event error handler, `window.onerror`. Die manueel overschrijven is natuurlijk niet de bedoeling.

### in jQuery 

```javascript
$(window).error(function(){
  // do stuff!
});
```

Om broken images te hiden, bijvoorbeeld:

```javascript
$("img").error(function(){
  $(this).hide();
});
```

# JS Framework Conflicten 

## jQuery vs Prototype 

### each looping 


De `this` pointer binnen de each loop van jQuery wordt gebruikt om naar het huidig element te refereren. <br/><br/>

**Prototype**
```javascript
["a", "b", "c"].each(function(item, index) {
  console.log("looping at #" + index + " with item " + item);
});
```

`this` is hier de `window` context.
zie http://www.prototypejs.org/api/enumerable/each

**jQuery**
```javascript
$(["a", "b", "c"]).each(function() {
  console.log("looping with item " + this);
});
```

Exact dezelfde each kan ook gebruikt worden zoals bij Prototype met extra argumenten.<br/><br/>
Let wel op dat jQuery niet zelf aangemaakte Arrays wrapt/Extent, dat ge zelf doen met `$(j)`<br/><br/>
Ook this binnen een jQuery each loop wordt niet extended maar is het DOM Element zelf. 

Zie http://api.jquery.com/jQuery.each/

:exclamation: **Mixed use** - let op bij loops waarbij this overschreven wordt met Prototype's `bind()` method! Zie boven.<br/><br/>


# Data binding 

Interessant artikel over Knockout JS vs Backbone:

  * http://www.ifandelse.com/?p=70
  * http://news.ycombinator.com/item?id=1810665

## JavascriptMVC 

Zie

  1. http://www.ajaxvoices.com/aggregator/sources/39
  2. http://javascriptmvc.com/

## Knockout JS 

Zie http://knockoutjs.com/

> Simplify dynamic javascript UI by applying the Model-View-viewModel pattern.

Nadeel: templates moeten geïnclude worden binnen dezelfde `HTML` pagina. Gelukkig genoeg zijn er andere template engines die verder bouwen op `jQuery.tmpl`: <br/><br/>
https://github.com/ashbylane/Knockout.js-External-Template-Engine auto-include als de template naam naam.html is en in dezelfde dir leeft als uw main page. 

## Backbone JS 

http://documentcloud.github.com/backbone/

Stricter MVC, zien dat uw view opnieuw gerenderd wordt bij een update van het model:

```javascript
model.bind("change", this.render);
```

Dit is meestal genoeg. Het grootste verschil tussen backbone en knockout is dat knockout `data-` attributen (HTML5) gebruikt, en alles in de view steekt, terwijl dit bij backbone meer apart steekt. (Backbone is explicieter en vereist ook wat meer boilerplating maar is meer gescheiden)

# Andere handige JS frameworks 

  * http:*documentcloud.github.com/underscore/ - *underscore JS// utility functies zoals `Array.flatten` ea.
  * http://www.sproutcore.com/
