+++
title = "async"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "async"
]
date = "2014-07-23"
+++
# Async coding in JS 

[Asynchronous programming in JS: APIs interview](http://www.infoq.com/articles/surviving-asynchronous-programming-in-javascript) (infoQ)

## Het probleem 

Alle events in javascript zijn asynchroon. Dat wil zeggen dat we geen idee hebben wanneer de eigenlijke code uitgevoerd is, en we een **callback closure** moeten meegeven, die verder werkt als de asynchrone code uitgevoerd is. 

Dit is oké voor 1-2 asynchrone calls. Maar stel u voor dat we 4+ async calls moeten maken om werk gedaan te krijgen. Typisch dingen zoals:

  * setTimeouts
  * animaties (jQuery ea)
  * AJAX calls (REST, naar domein logica, bewaren, opvragen, veranderen, ...)

### Een integratietest schrijven in JS 

In *Java* kunnen we gewoon wat methods oproepen die data persisteert, daarna de eigenlijke *asserts* schrijven en eventueel in de `@After` met JUnit data cleanup uitvoeren:

```java
DomainObj obj = new DomainObjPersister()
   .withA()
   .withLala("lala")
   .persist();

ChildObj child = new ChildObjPersister()
   .withParent(obj)
   .persist();

assertThat(child.getStuff()).isNotEmpty();
```

Om `child` te kunnen persisteren moeten we `obj` als parent meegeven, dus die call moet eerst uitgevoerd zijn. Alle persisters gaan naar de database. Dit zou in javascript zoiets zijn=
<img style='float: left; width: nolink&|px;' src='/img//code/javascript/kill-it-with-fire.gif'>

```javascript
$.ajax('/domain/obj/store', {
  success: function(obj) {
    $.ajax('/domain/child/store', {
      success: function(child) {
        assertThat(child.getStuff()).isNotEmpty();
      }, ...
    });
  },
  type: 'PUT',
  dataType: 'json',
  data: JSON.stringify({ key: 'value', key2: 'value2' })
});
```

Dus een callback wrappen in een callback wrappen in een callback. 

#### Async event loop hulpjes 

Zie ook [Philip Roberts: Help, I'm stuck in an event-loop](http://vimeo.com/96425312)

<img style='float: left; width: nolink |px;' src='/img//code/javascript/476470428_960.jpg'>

Tooltje om event loop te visualiseren zodat je ziet wat er gebeurt. Breaken in chrome helpt natuurlijk ook, gewoon naar de call stack kijken... 

#### Asynchroon testen in Jasmine 

Met **Jasmine** is het (beperkt) mogelijk om te wachten tot dat een stukje werk uitgevoerd is voordat de assertions afgegaan worden. <br/><br/>
Dit kan op de volgende manier:

```javascript

it("should be green, right??", function() {
  var asyncCallFinished = false;
  function callback(someObj) {
    asyncCallFinished = true;
  }
  doAsyncCall(callback);

  waitsFor(function() {
    return asyncCallFinished ##### true;
  });

  runs(function() {
     expect(stuff).toBeLotsBetter();
  });

});

```

Pitfalls:

  * Ge moet closure scope gebruiken om een variabele bij te houden om te controleren of de async call klaar is in een callback
  * Ge moet `waitsFor()` gebruiken, intern pollt Jasmine waarschijnlijk gewoon...
  * Ge moet eigenlijke assertions wrappen in `runs()` omdat `waitsFor()` direct retourneert en opzich async is. 

De assertion functiepointers die meegegeven worden met `runs()` worden intern opgeslaan en bijgehouden totdat de closure van `waitsFor()` `true` retourneert. Daarna wordt ook alles pas meegegeven met de Jasmine reporter (logging, output etc). Redelijk omslachtig, aangezien 3+ async calls dan `waitsFor()` moeten wrappen. Geen oplossing. 

##### Asynchroon testen met QUnit #####

```javascript
asyncTest("should be green, right??", function() {  
  var stuff = gogo();
  function callback(obj) {
    equal(obj.stuff, 2);
    start();
  }
  
  doAsyncCall(callback);

});
```

Pitfalls:

  * In de callback van uw async stuk code moeten zoals verwacht uw assertions zitten
  * Ge moet een speciale test method gebruiken, `asyncTest()`
  * Ge moet na uw assertions `start()` aanroepen (??)

#####== De oplossing #####==

https://github.com/willconant/flow-js e.a. (of iets zelfgemaakt in die aard). 

Herneem bovenstaande integratietest code in javascript, maar dan met flow.js geschreven:

```javascript
flow.exec(
  function() {
    $.ajax('/domain/obj/store', {
      success: this,
      type: 'PUT',
      dataType: 'json',
      data: JSON.stringify({ key: 'value', key2: 'value2' })
    });  
  },
  function(obj) {
    $.ajax('/domain/child/store', {
      success: this, ...
    }); 
  },
  function(child) {
    assertThat(child.getStuff()).isNotEmpty();
  }
);
```

Pitfalls:

  * Error handling wordt opgefreten - gebruik Firebug's **debug on all errors** knop in de console. (anders mechanisme maken dat ze doorgooit van closure1 naar 2 ea)
  * `curry()` gaat niet lukken aangezien de `this` pas in de closure zelf de juiste waarde krijgt. 
  * `this` moet meegegeven worden als callback, dus te intensief gebruik makend van `this` pointer in eigen code kan BOEM geven.

flow.js geeft het resultaat van closure1 mee als argument aan closure2 (via `arguments`) en zo maar door, dat is mega handig.

##### Synchrone code code combineren met asynchrone in flow.js #####

Enige minpunt is dat de callback `this()` moet expliciet aangeroepen worden om van closureX naar closureY over te stappen! <br/><br/>
Los dit op met een utility functie:

```javascript
flow.sync = function(work) {
  return function() {
    this(work.apply(this, Array.prototype.slice.call(arguments, 0)));
  }
}
```

Zodat we dit kunnen doen:

```javascript
flow.exec(
  function() {
    asyncStuff(this);
  },
  flow.sync(function(resultfromPrev) {
    console.log("lol"); // no this() required afterwards
  }),
  function(resultFromSyncStuff) {
    doMoreAsyncStuff(this);
  }
);
```

##### In een asynchrone closure parallel werken #####

Gebruik `this.MULTI()` als callback ipv `this` (zie voorbeeld hieronder)

##### flow.js combineren met Jasmine #####

Om de smeerlapperij van `waitsFor()` weg te werken kunnen we ook `flow.exec` gebruiken. 

:exclamation: De laatste stap gaat **altijd** een `runs()` moeten bevatten voor de reporter om aan te duiden dat assertions uitgevoerd worden, aangezien de `exec()` functie direct retourneert. Dus moeten we 1x wachten, totdat de hele "flow" gedaan is. We kunnen dit combineren met BDD en een mini-DSL hierrond schrijven. Resultaat:

```javascript
function when() {
	var flowDone = false;
	var slice = Array.prototype.slice;
	var argsArray = slice.call(arguments, 0);
	var laatsteArgumenten;
	
	argsArray.push(function() {
		laatsteArgumenten = slice.call(arguments, 0);
		flowDone = true;
	});
	
	flow.exec.apply(this, argsArray);
	waitsFor(function() {
		return flowDone ##### true;
	});
	
	return {
		then: function(assertionsFn) {
			runs(function() {
				assertionsFn.apply(this, laatsteArgumenten);
			});
		}
	};
}
```

Voorbeeldcode:

```javascript

describe("plaatsen domein", function() {
	it("wanneer ik alle plaatsen ophaal, kan ik hier domeinspecifieke functies aan opvragen", function() {
		var plaatsen;
		when(
			function() {
				DOMEIN.plaatsRepository.bewaarPlaats(plaats, this.MULTI());
				DOMEIN.plaatsRepository.bewaarPlaats(anderePlaats, this.MULTI());
			},
			function() {
				DOMEIN.plaatsRepository.haalPlaatsenOp(this);
			}
		).then(
			function(opgehaaldePlaatsen) {
				opgehaaldePlaatsen.forEach(function(plaats) {
					expect(plaats.geefMeting).toBeDefined();
				});
			}
		);
	});
});
```

Merk op dat de closure meegeven in `then()` (slechts 1 mogelijk voor assertions) als **argument** het resultaat van de laatste closure in `when()` meekrijgt! 

#####== jQuery 1.6: Deferred en piping #####==

Vanaf **jQuery 1.6** is het mogelijk om met `$.Deferred` te werken, dat het mogelijk maakt om een closure uit te voeren op het moment dat "werk" gedaan is. Met werk bedoelen we:

  1. fx: `.animate` ea
  2. http: `.ajax` ea
  3. custom code die zelf een `$.Deferred` object retourneren

##### Promising stuff #####

Alle async operaties worden aan een *queue* toegevoegd van het jQuery element zelf. Je kan op eender welk moment vragen aan dat queue object, dat wanneer alle items zijn verwerkt er iets speciaals uigevoerd wordt:

```javascript
$('#blink').fadeOut().promise().done(function() {
  console.log('done blinking!');
});
```

Dit kan dus ook met `$.ajax`. 

##### Zelf Deferred code schrijven #####

Maak een deferred object aan door `$.Deferred()` aan te roepen. Op dat moment kan je `done()` hierop zoals in het vorige voorbeeld aanroepen. Bijvoorbeeld:

```javascript

function startStuff() {
  var df = $.Deferred();
  setTimeout(1000, function() {
    console.log('done async call');
    df.resolve();
  });
  return df.promise();
}

startStuff().done(function() {
  console.log('really really done with "start stuff"!');
});
```

##### Multiple elements in queue: piping #####

Stel dat eerst element #1 animatie triggert, dan #2, en daarna nog logica dient te gebeuren. Dit kan ook met `$.Deferred`, door `.pipe()` te gebruiken om verder te breiden aan de queue. 

```javascript
$("button").bind( "click", function() {
	$("p").append( "Started...");
	var div1 ###### $("#div1"), div2  $("#div2");

	var df = $.Deferred();
	df.pipe(function() {
		return div1.fadeOut("slow")
	}).pipe(function() {
		return div2.fadeOut()
	}).done(function() {
		$("p").append( "  --  DONE");
	});
	df.resolve(); 
});
```

:exclamation: Pas op, in de `.pipe()` functie moet een nieuw **promised object** geretourneerd worden! Dat nieuw object wordt als return value van de vorige pipe gebruikt. Op die manier wordt er dus *chaining* toegepast. 