+++
title = "Introduction to JavaScript"
subtitle = "Writing JS, Pre-ES5 era."
archived = true
draft = false
tags = [
    "javascript"
]
date = "2013-10-01"
+++
# Javascript Inleiding 

### Primitives 

#### Soorten  

In javascript zijn er slechts 3 primitives:

  1. `string` (geassocieerd object: `String`)
  2. `boolean` (geassocieerd object: `Boolean`)
  3. `number` (geassocieerd object: `Number`)

Primitives zijn **immutable**! Toekennen van properties maakt ook een tijdelijk object aan, dus dit heeft geen nut.

##### Soort afchecken 

Aangezien JS loosely typed is, kunnen we nooit weten wat er nu in `var variabele;` steekt op een bepaald moment in de code.<br/><br/>
Om dit op te lossen kan men `typeof` gebruiken, een functie die een string teruggeeft wat het type van die variabele is.

Typeof retourneert in het geval van een object, de string `object`, in alle andere gevallen de bovenstaande primitive namen.

#### Object coercing 

-> *(Lees eerst het stuk over objecten etc aub!)*

Elk van de primitives worden door Javascript automatisch geconverteerd naar hun object representatie wanneer men properties of functies hierop probeert toe te passen. Bvb:

```javascript
var someString = "someString";

someString.indexOf("String"); // indexOf() wordt op new String("someString") opgeroepen
```

Direct nadat dit geëvalueerd wordt schiet de garbage collector aan de gang en wordt het tijdelijk object verwijderd. 

```javascript
var tekst = "dit is tekst jong";
tekst.length = 3; // -> String object created & garbage-collected
console.log(tekst); // dit is tekst jong (old primitive value)
```

Het object dat wordt aangemaakt bijhouden en daar de lengte van afkappen is zelfs gevaarlijk:

```javascript
var s = new String("ss");
s.length = 1;

for(var i = 0; i < s.length; i++) {
  console.log(s[i]); // prints only once 's'
}
console.log(s); // prints 'ss'??
```

Als we weten dat een object aangemaakt wordt zodra we een property oproepen, vraagt een mens zich af, hoe zit dat met `number`s? De `.` accessor wordt hier gebruikt om komma's voor te stellen... Wel, aangezien elk object ook values van properties kan retourneren via de `[]` operator (zie later), werkt dit dus wel:

```javascript
21.54["toFixed"]() // returns 22, way cool!
```

Zie [Mozilla MDC Docs: JS Reference: Number](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Number) voor wat mogelijke functies zijn op `Number`. 

### Objecten en Functies 

Douglas Crockford:

> An object is a dynamic collection of properties.

As opposed to "*instances of classes*".

Een *functie* in JS kan net zoals andere waarden toegekend worden aan een variabele. Een functie ís in feite een waarde. Dit is anders in bijvoorbeeld Java, een "functie" (method) is een syntax block code die uitgevoerd kan worden. Wanneer een functie aan een property van een object gekoppeld is spreken we van een method op dat object. 

Een object bevat properties. Een functie is een rij van expressies die één waarde retourneert voor dezelfde input te evalueren. Bekijk een "functie" als zijn mathematische beschrijving: `f(x)`. 

#### Object Literals 

Een object definiëren gaat heel makkelijk: 

```javascript
var Ezel = new Object();
Ezel.poten = 4;
Ezel.balk = function() {
   console.log("iaia met mijn " + this.poten + " poten");
};
```

Zodra een `Object` gemaakt wordt, kunnen eender welke property keys toegekend worden met eender welke variabele. Dit kan ook op een *associatieve* manier, bijvoorbeeld `Ezel["poten"] = 4;`. 

Bekijk het volgend stukje code:

```javascript
var Ezel = {
  poten: 4,
  balk: function() {
    console.log("iaia met mijn " + this.poten + " poten");
  }
};
```

Hier wordt een object door middel van een **literal** gedefiniëerd. De correcte manier om de ezel te laten balken is `Ezel.balk()`. Merk op dat `Ezel` een gewoon object met wat simpele properties is, bekijk het als een map. Dit is een instantie van `Object`: `typeof Ezel` retourneert dit. 

##### JSON en Object Literals 

[JSON](http://www.json.org/js.html) ((JavaScript Object Notation)) is een subset van JavaScript, dus door de JS Compiler op te roepen met `eval()` is het heel eenvoudig om JSON Strings te evalueren. Een JSON Object is in feite een JS Object Literal:

```javascript
var JSONObj = {
  "bindings": [
    { "key": "value1", "key2": "value2" },
    { "key": "value3", "key2": "value4" }
  ]
}
```

Dat object kan via een string opgebouwd worden door `eval()` te gebruiken, maar dit is **gevaarlijk** aangezien van een externe webserver ook JS functies in dat data object kunnen zitten! Gebruik daarvoor altijd een JSON Parser, zoals de built-in `JSON.parse()`. 

Om de omgekeerde weg uit te gaan, van object naar string, gebruik `JSON.stringify()`. Meer uitleg, zie bovenstaande link.

#### Functie Literals 

Een functie definiëren gaat op drie manieren:

  1. `function bla() { ... }` - de normale manier, een **function statement**. 
  2. `var bla = function() { ...}` - een **function literal**, ofwel een *lambda function* (Lisp referentie). In feite een closure die toevallig toegekend wordt aan variabele `bla`. 
  3. `var bla = new Function("", "...")` met als eerste argument de argumenten van de functie, allemaal in `string` vorm. 

De onderstaande code definiëert bijvoorbeeld in lambda-stijl een functie genaamd Ezel:

```javascript
var Ezel = function() {
  this.poten = 4;
  this.balk = function() {
    console.log("iaia met mijn " + this.poten + " poten");
  }
};
```

Merk de verschillen op met het bovenstaande:

  * `function()` staat voor `{`.
  * `this` wordt gebruikt om keys aan te spreken! Waarom? zie scoping.
  * De functie bevat gewone statements met `=` en niet met `:`. Dit is geen object maar een functie!

!! De functie die net aangemaakt is kan nu als constructor dienen. Die werd intern ook aan de Ezel `prototype` property gekoppeld:

```javascript
Ezel.prototype.constructor
```

De correcte manier om de ezel te laten balken is `new Ezel().balk()`.<br/><br/>
Meer info over hoe `new` werkt om de ezel instance de poten en de balk functie toe te kennen: zie inheritance.

##### Functies zijn objecten 

> Functions are first class Objects!

Bewijs: (Uitleg: zie inheritance)

```javascript
Function.prototype.__proto__ == Object.prototype;
(function fn(){}).__proto__ == Function.prototype;
```

Dus functies zijn *ook* associatieve maps, dus `(function(){}).bla = 3;` werkt perfect! Zie scoping, deel "Object/Class Member variables".

##### De kracht van closures 

In Javascript is élke functie een *closure*! In sommige andere talen kan enkel een closure "deep bindings" uitvoeren (= scope chain bijhouden, zie scoping deel), of een functie opnieuw retourneren. In JS is er geen verschil tussen een literal function en een gewone, buiten de notatie - een literal bind een anonieme functie aan een variabele. Zoiets kan dus perfect:

```javascript
a = function() {
  var aGetal = 10;
  return function() {
    var bGetal = 20;
    return function() {
      var cGetal = 30;
      
      return aGetal + bGetal + cGetal;
    }
  }
}

a()()() // 60
```

Merk op dat de `()` operator een functie uivoert, en hier alles 3x genest is, maar toch de binnenste functie een referentie naar `aGetal` kan gebruiken, gedefiniëert in de buitenste functie! Lees hierover meer in het scoping gedeelte.

##### Declaratie van functie literals 

In javascript worden variabelen die met `var` gedeclareerd worden **altijd** vooraan geplaatst, ook impliciet. Dit wil zeggen dat wanneer ik een function literal definieer, eigenlijk het volgende gebeurt:

```javascript
function x() {
  alert("yo");
  var b = function() { };
} // is for the JS parser equal to:

function xParsed() {
  var b;
  alert("yo");
  b = function() { };
}
```

Wanneer je `b()` probeert uit te voeren vóórdat b effectief geïnitialiseerd is, ontploft de boel. Let hier dus op, en gebruik als dit niet mogelijk is geen literal. Bij naamgevingen binnen een scope geldt een volgorde:

  1. Language-defined (`this`, `arguments`)
  2. Formal-defined (arguments)
  3. Function-defined
  4. Variable-defined

Dat wil zeggen dat wanneer je twee keer x probeert toe te kennen aan een getal én een functie, heeft de functie voorrang. 

!! Uitzondering: een formeel argument met naam `arguments` heeft voorrang op lang-defined `arguments`. Bad practice... 

##### Itereren over properties van objecten #####

Vergeet niet dat in Javascript alle objecten (zowel object literals als instanties van functies) zich gedragen als een {{< wp "Associative array" >}} - en dat we dus ook kunnen lopen over alle keys:

```javascript
var N = { one: 1, two: 2 };
for(key in N) {
  console.log(key + " represents as value: " + N[key]); 
}
```

Om de value van een bepaalde key op te halen kan je natuurlijk ook `eval('N.' + key)` gebruiken - alle wegen leiden tot Rome...

##### Controleren of een key in een object/array beschikbaar is 

Dit kan op enkele manieren:

  1. `'key' in object` ((Opgelet: `in` kan misleidend effect hebben bij gebruik in combinatie met prototypal inheritance, zie later!))
  2. `object.hasOwnProperty('key')` -> gaat wel `false` retourneren bij overgenomen keys vanuit prototypes. Zie later.
  3. nogmaals itereren (er zijn betere ideeën, dit is de neiging die veel mensen hebben, te procedureel denken!)

Wat géén goede manier is:

```javascript
var Obj = {
  x: 'x',
  u: null,
  un: undefined
};

Obj.x === undefined // false, so it must exist as a key, right?
Obj.u == undefined // whoops, true? oplossing: gebruik '#####'
Obj.un == undefined // whoops, still true? value kan ook undefined zijn natuurlijk!
```

#####= Varargs #####=

```javascript
function f() {
  return arguments[0] + arguments[1];
}
f(1, 2) // == 3
```

Indien er geen argumenten gespecifiëerd zijn, zijn ze allemaal *optioneel*! Dit wil zeggen dat een functie aangeroepen kan worden zonder het aantal argumenten 100% te laten overeen komen. 

###### anonymus functions en recursie ######

`arguuments` heeft nog een speciale property: `arguments.callee(...)` dat de huidige functie voorstelt, hiermee kan je jezelf aanroepen! 

!! Dit gaat een syntax error geven bij ECMA Script standaard 5 in *strict* mode

###### verplicht alle argumenten invullen ######

```javascript
function f(x, y, z) {
  if(arguments.length != arguments.callee.length) {
    throw new Error("kapot wabezig");
  }
}
f(1, 2) // == 3
```

Het is natuurlijk makkelijker om `!= 3` hardcoded te plaatsen, maar dit kan extracted worden naar een aparte functie.

###### Function overloading ######

Overloading bestaat niet in JS aangezien de tweede definitie van de functie de eerste overschrijft (de property "functienaam" in het object, zeg maar). <br/><br/>
Het is wel mogelijk om één functie te maken die delegeert, zie http://ejohn.org/blog/javascript-method-overloading/

Maak handig gebruik van het feit dat de `.length` property ook op functies opgeroepen kunnen worden! (Telt enkel de gedefiniëerde)

```javascript
(function x(y, z) {}).length ###### 2; // y and z
```

#####= this Keyword #####=

Zie scoping

#####= Aspect Oriented Programming in JS #####=

Via AOP kan men net voor of na een bepaalde functie gedrag toevoegen zonder dat een component dat die functie aanroept daar weet van heeft. Het is zo makkelijk om bijvoorbeeld logging toe te voegen. In Java wordt Spring AOP gedaan via proxy beans die van dezelfde interface afleiden en daarna delegeren, of via AspectJ die rechtstreeks bytecode wijzigt. 

In Javascript kan dat makkelijker, omdat we de referentie naar een functie gewoon kunnen "vast" pakken. Stel dat ik voordat de ezel balkt wil loggen "ik ga balken":

```javascript
var oldBalkF = Ezel.prototype.balk; // vereist dat balk via `prototype` werd toegevoegd
Ezel.prototype.balk = function() {
  console.log("ik ga balken! ");
  oldBalkF.call(this);
}
new Ezel().balk(); // print log eerst
```

Hier merken we twee dingen op:

  1. In de nieuwe balk functie kan **niet** zomaar `oldBalkF()` uitgevoerd worden dan is mijn `this` referentie naar de ezel instantie weer weg.
  1. De `window` scope werd vervuild door oldBalkF, die nog steeds toegankelijk is. Hier zijn twee oplossingen voor:
    1. `delete oldBalkF;` na de `call` instructie (extra werk)
    1. Gebruik een anonieme functie die direct uitgevoerd wordt die de scope bewaakt! 

#####= undefined #####=

Refereren naar een property in een object dat niet bestaat, geeft ons de speciale waarde `undefined`.<br/><br/>
Merk op dat dit *niet hezelfde* is als `null`. Toch zijn ze gerelateerd:

```javascript
var x = {
  one: 1
};
if(x.two == null) {
   3;
}
```

Dit geeft 3 omdat `x.two ##### undefined` en `null ###### undefined`. Aangezien `null` in een if test by default `true` retourneert, kan de if test korter: `if(x.two) { ... }`. 

Zo is het makkelijk om optionele argumenten van functies na te gaan:

```javascript
function count(one, two, three) {
  if(!two) two = 0;
  if(!three) three = 0;
  return one + two + three;
}
```

!! `undefined` is een window-scope variabele die initiëel de value `undefined` heeft, dit is dus géén keyword, pas op!

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

##### De oplossing #####

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

##### jQuery 1.6: Deferred en piping #####

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

# Javascript Inheritance 

> JavaScript uses prototypal inheritance. This means that Javascript does not distinguish between classes/prototypes and instances and, therefore, we can add our desired behavior directly to the instance.

## "new" operator 

Zie http://unitstep.net/blog/2008/01/24/javascript-and-inheritance/ <br/><br/>
Gegeven de volgende functie:

```javascript
function X(bla) {
  this.x = bla;
  console.log("doeiets");
  this.ding = function() { return this.x; };
}
```

Wat gebeurt er bij de klassieke manier van een "klasse" initialiseren? Zo:

```javascript
new X("argument").ding()
```

Omdat geen klassen bestaan, wordt er eigenlijk een "leeg" object aangemaakt en het prototype van het bestaand object aangepast door `call` te gebruiken:

```javascript
var johnDoe = function(){};
X.call(johnDoe, "dinges")
johnDoe.ding()
johnDoe.x ###### "dinges"
```

Wat gebeurt hier?

  1. `function(){}` is een *closure*, dus een *function*, zonder inhoud. 
  2. de `call` functie roept een functie aan en vervangt de `this` referentie (**context**) door het meegegeven argument
  3. Bijgevolg wordt in `X()`, `this.x = bla` gedaan, dat wil zeggen dat vanaf nu onze anonieme closure de property `x` **bevat**, samen met alle functies die binnen `X` gedefinieerd zijn.

Merk op dat "bevat" impliceert dat het object johnDoe natuurlijk nu ook geheugen toegekend krijgt om de variabele "x" op te slaan. Dit in contrast met *prototypal inheritance*, zie volgend stuk.

Eender welke functie heeft een `prototype`. Een "lege" functie bevat een dynamische "constructor" (de functie zelf) met lege body:

```javascript
(function(){}).prototype
```

##### Gewenst gedrag - wat waar plaatsen #####

  * Indien ik een functie of een variabele heb die anders kan zijn naargelang de implementatie (definiëer de "naamgeving"), plaats deze dan in de **constructor** functie.
  * Indien ik een functie of een variabele heb die specifiek voor die functie is en niet gaat veranderen, plaats deze dan **in het concreet object** via `this.`. 
  * Indien ik een functie of een variabele heb die ik tijdelijk wens te gebruiken, plaats deze dan **in het concreet object** via `var` ((Maak slim gebruik van scope chaining om zaken te encapsuleren!)).

Typisch bevatten constructor functies ook *geen* return waarden ((dit retourneert dus impliciet `undefined`)) - we gebruiken deze functies toch altijd in combinatie met de `new` operator, dus kennen de nieuwe instantie van het object direct toe aan een variabele. 

##### prototype gebruiken als inheritance #####

-> Meer informatie inclusief grafen met uitgebreide uitleg hoe prototype en constructors werken: zie http://joost.zeekat.nl/constructors-considered-mildly-confusing.html

Aangezien we aan objecten hun functions kunnen via `.prototype`, is het niet moeilijk om een object zich te laten gedragen als zijn "ouder". Neem bijvoorbeeld een dier object, en een concrete ezel implementatie die een extra functie "balk" definiëert. 

```javascript
function Vierpotige() {
   this.aantalPoten = 4;
   this.eetIets = function() {
     console.log("omnomnom");
   }
}

function Ezel() {
  this.balk = function() {
    console.log("IEE-AA enzo");
  }  
}

Ezel.prototype = new Vierpotige();
var ezeltje = new Ezel();
ezeltje.eetIets(); // aha! outputs 'omnom' en 'als ezel fret ik ook nog gras enzo'
```

Wat gebeurt hier precies?

  1. Vierpotige bevat een property aantalPoten en een functie eetIets. 
  2. de constructor functie Vierpotige wordt aangeroepen zodra een Ezel aangemaakt wordt, zodat properties en functies overgenomen worden.
  3. een nieuwe ezel eet iets via een prototype functie van een lege Vierpotige.

:exclamation: **Opgelet** Vierpotige.prototype bevat enkel de constructor functie zelf en *NIET* "eetIets", daarom dat we Ezel.prototype gelijk stellen aan een nieuwe lege vierpotige. Dit zou niet werken:

```javascript
Ezel.prototype = Vierpotige.prototype;
new Ezel().eetIets() // kapot
```

Tenzij we eetIets definiëren via `Vierpotige.prototype.eetIets = function() { ... }` - *maar* dan kan `aantalPoten` niet meer vanaf een ezel accessed worden. 

Nu de prototype property van Ezel en Vierpotige gelijk zijn, kunnen we het prototype uitbreiden met een functie en die direct op ons nieuw ezeltje toepassen:

```javascript
Vierpotige.prototype.verteer = function() {
  console.log("ist wc bezet??")
}
ezeltje.verteer()
```

:exclamation: **Waarschuwing** het prototype van `Vierpotige` aanpassen past ook elke `Ezel` instantie aan, dit is énorm gevaarlijk als er publieke properties zoals `aantalPoten` gedefiniëerd zijn! Want in tegenstelling tot wat velen denken, worden properties **niet** gekopiëerd! Dus dit zou het aantal poten van ALLE ezels aanpassen:

```javascript
dier = new Vierpotige();
Ezel.prototype = dier;
new Ezel().aantalPoten ###### 4; // true
dier.aantalPoten = 2;
new Ezel().aantalPoten ###### 4; // false
```

##### Properties overriden #####

Prototypal inheritance werkt omdat JS bij elke property lookup kijkt in welk object die referentie gedefiniëerd is. Is dat het huidig object, neem dan die waarde. Indien neen, kijk in het `prototype` object. Indien neen, kijk in het `prototype` object van dat object, en zo maar door tot op `Object` niveau. We kunnen zo ook een property van een prototype zelf overriden, door ander gedrag te definiëren, of zelfs de super aan te roepen:

```javascript
Vierpotige.prototype.eetIets = function() {
  console.log("vierpotige eten");
}
Ezel.prototype.eetIets = function() {
    Vierpotige.prototype.eetIets(); // "super"
    console.log("als ezel fret ik ook nog gras enzo");
}
```

##### Built-in JS types extenden #####

:exclamation: Extend **nooit** `Object.prototype`! Waarom? Omdat Eender welk object een instantie van `Object` is, dus zijn prototype heeft, en met een `for(x in prop)` deze property nu ineens toegankelijk is voor elk object. Een leeg object `{ }` wordt verwacht géén properties te hebben! 

```javascript
Object.prototype.hack = function() {}
for(x in {}) {
  console.log(x); // print "hack", zou hier niet in mogen komen
}
```

##### Checken op inheritance #####

Met Javascript kan men door middel van `typeof` controleren van welk type een variabele is. Dat komt neer op:

  * object (`{}`)
  * function (`function() {}`)
  * string (`""`)
  * number (`-47.2`)

Het is niet zo interessant om te gebruiken voor eigen inheritance. Daarvoor dient `instanceof`:

```javascript
ezeltje instanceof Vierpotige == true
ezeltje instanceof Ezel == true
new Vierpotige() instanceof Ezel == false
```

##### Zelf inheritance afchecken met prototype #####

###### met constructors ######

Dit is een zeer beperkte manier dat geen rekening houdt met "inheritance":

```javascript
function instanceOf(One, Two) {
  return One.constructor ###### Two;
}

instanceOf(Ezel, Vierpotige) // true
```

Aangezien elk object een `.constructor` property heeft die afgeleid werd vanuit de constructor functie die aangeroepen werd, kan men op deze manier een simpele check afwegen. Een praktischer voorbeeld is `(typeof (new Date()) ###### object) && (new Date().constructor ###### Date)`.

###### met __proto__ ######

Het `instanceof` keyword kijkt natuurlijk naar de `prototype` properties van beide objecten om te controleren of object a van object b komt. Dit kan men ook zelf doen:

```javascript
function instanceOf(One, Two) {
  return One.prototype.__proto__ ###### Two.prototype;
}

instanceOf(Ezel, Vierpotige) // true
```

Hoe kan dit kloppen?

  1. Herinner u dit statement: `Ezel.prototype = new Vierpotige();`. Dit stelt de `prototype` van Ezel gelijk aan die van een vierpotige. Het enige wat in de `prototype` van Vierpotige steekt is de `verteer()` functie, de rest werd via de constructor functie overgekopiëerd! 
  2. De magic property `_ _proto_ _` wordt intern gezet zodra een prototype wordt toegekend aan een object. Aangezien Ezel zelf ook prototype functies heeft specifiek voor ezels, kunnen we die van Vierpotige niet overriden, maar wel gebruiken. 

:exclamation: Bekijk iets toevoegen via `.property` als iets toevoegen aan het algemeen prototype object, en iets rechtstreeks toevoegen via een key als iets toevoegen op een instance van dat prototype object. In andere dynamische talen stelt `property` de `metaClass` voor, maar JS werkt enkel met functies.

De betere oplossing: **`isPrototypeOf()`**! Zie magic properties.

:exclamation: **`_ _proto_ _` is een __instance__ property, `.prototype` een constructor function property**

###### met properties ######

Door `hasOwnProperty()` te gebruiken kan je nagaan of een property overgenomen is of niet. Vanaf JS 1.5.

##### call als inheritance #####

De klassieke inheritance structuur zoals in Java en C++ kan beter benaderd worden door `call` te gebruiken. Herbekijk onze ezels:

```javascript
function Vierpotige() {
   this.aantalPoten = 4;
   this.eetIets = function() {
     console.log("omnomnom");
   }
}

function Ezel() {
  Vierpotige.call(this);
  this.balk = function() {
    console.log("IEE-AA enzo");
  }
}

var ezeltje = new Ezel();
ezeltje.eetIets(); // aha! outputs omnom
```

Door als eerste statement in de constructor functie van `Ezel` een `call` te plaatsen naar onze "parent", *kopiëren* we alle keys en values die daarin gedefiniëerd staan. In tegenstelling tot prototypal inheritance kost dit dus veel meer geheugengebruik, en is dit beperkter om uit te breiden. We linken eigenlijk impliciet twee functies aan elkaar door waarden over te nemen, maar iets aanpassen aan `Vierpotige` gaat de `Ezel` op geen ekele manier doen veranderen.

##### prototypal inheritance toepassen #####

In plaats van `new` overal te gebruiken zonder te weten wat hierachter ligt, kan men `create` ook gebruiken:

```javascript
if (typeof Object.create !###### 'function') {
    Object.create = function (o) {
        function F() {}
        F.prototype = o;
        return new F();
    };
}
newObject = Object.create(oldObject);
```

Zie http://javascript.crockford.com/prototypal.html

##### Een minder verbose manier om extra properties te definiëren #####

Zie http://howtonode.org/prototypical-inheritance - 

```javascript
Object.defineProperty(Object.prototype, "spawn", {value: function (props) {
  var defs = {}, key;
  for (key in props) {
    if (props.hasOwnProperty(key)) {
      defs[key] = {value: props[key], enumerable: true};
    }
  }
  return Object.create(this, defs);
}});
```

Op die manier kan je `BaseObj.spawn({'extraProp': 'extraValue'});` gebruiken, zonder de relatieve verbose manier van extra properties te moeten gebuiken die `Object.create` [handhaaft](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/create#Classical_inheritance_with_Object.create).

##### Prototype JS en Class.create #####

Javascript frameworks proberen altijd inheritance makkelijker te maken voor klassieke OO developers door functies te modelleren als klassen. In [Prototype JS](http://www.prototypejs.org/api/class) kan men zoiets doen:

```javascript

var Animal = Class.create({
  initialize: function() {
    this.something = "wow";
  },

  speak: function() {
    console.log(this.something);
  }
});

var Snake = Class.create(Animal, {
  hiss: function() {
    this.speak();
  }
});
```

Snake leidt af van Animal, en de `initialize()` functies stellen de constructor functies voor. Wat gebeurt er dan achter de schermen bij `Class.create({...})`?

  1. Net zoals hierboven wordt de constructor functie via `apply` aangeroepen (zelfde als call). Enkel wordt als `this` een lege functie toegevoegd.
  1. `Object.extend()` wordt gebruikt om alle keys van de parent te kopiëren naar de nieuwe lege functie. 
  1. De `prototype` property van de parent wordt net zoals hierboven gezet op de nieuwe "klasse". 
  1. Speciale gevallen zoals een "lege constructor" functie indien nodig, intern bijhouden wat sub- en superklassen van elkaar zijn, etc. 

In essentie komt het neer op "*syntax sugaring*" zodat het klassieke OO model gebruikt kan worden - terwijl er onderliggend iets anders gebeurt.<br/><br/>
Meer info over deze implementatie: http://code.google.com/p/inheritance/

############= Multiple inheritance ############=

Perfect mogelijk, of slechts delen van object A en alles van B voor object C gebruiken (**mixins**!). Simpelweg alles van de ene `prototype` property naar de andere overzetten wat nodig is:

######= Methode 1 ######=

```javascript
function A(){};
A.prototype.a = function() { return "a"; }
A.prototype.c = function() { return "a"; }
function B(){};
B.prototype.b = function() { return "b"; }

function C(){};
for(prop in B.prototype) {
  C.prototype[prop] = B.prototype[prop];
}
C.prototype.a = A.prototype.a;
C.prototype.c = function() { return "c"; }

var c = new C();
c.a() ###### "a";
c.b() ###### "b";
c.c() ###### "c";
```

######= Methode 2 ######=

Creeër de illusie om constructor(s) aan te roepen in een constructor functie van een ander object:

```javascript
function B() {
  this.b = function() { return "b"; }
}
function C() {
  this.c = function() { return "c"; }
}
 
function A() {
  this.a = function() { return "a"; }
  this.super = B;
  this.super2 = C;
  this.super(); // kopiëer de b functie in A, maar inherit niet!
  this.super2();
}


var a = new A();
a.a() ###### "a";
a.b() ###### "b";
a.c() ###### "c";
```

######= Problemen met mixins ######=

:exclamation: Dit is géén authentieke multiple inheritance. Hier zijn twee problemen aan gekoppeld:

  1. Zodra via `B.prototype` een nieuwe functie toegevoegd wordt, zal C deze **niet** overpakken omdat `C.prototype` niet *gelijk* gesteld werd aan die van A of B
  1. En bijgevolg dus ook de `instanceof` operator naar de zak is:

```javascript
c instanceof C ###### true
(c instanceof B || c instanceof A) ###### false
```

Als dit echt nodig is kan men zoiets zelf implementeren door weer te loopen via `for(prop in x.prototype) { ... }` en te checken of alle keys voorkomen in een object. 

Zie Mozilla Dev center: [Details of the Object Model](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Details_of_the_Object_Model#No_Multiple_Inheritance)

# Javascript Scoping 

### Toplevel Scope 

Een stuk Javascript in een HTML pagina, zonder eender welke functie te definiëren, werkt altijd op **top-level scope**. Dat stelt het `window` object voor, waar we ook resolutie gegevens en dergelijke kunnen uithalen. Dus simpele variabelen declareren om in HTML te kunnen gebruiken werkt altijd op de globale scope:

```javascript
var customerEmail = document.getElementById("username") + "@" + document.getElementById("domain") + ".com";
window.customerEmail // what did I do?? (null@null.com if unknown IDs)
```

Om te vermijden dat we alles op het `window` object "dumpen", schrijven we nette functies die zaken zoals tijdelijke variabelen en private stukken code *encapsuleren*. 

#### Variabele declaratie 

Variabelen definiëren gaat met `var` (zoals hierboven), máár *globale* (window-scope) variabelen kunnen gedeclareerd worden zonder dit. Pas hiermee op:

```javascript
woot = "leet";
function yo() {
  woot = "omg"; // whoops, I changed a global var
  meerWoot = "leet";
  var wootwoot = "one!!1";
}

yo();
window.woot ##### "leet" // false
window.meerWoot ##### "leet" // true
window.wootwoot ##### undefined // true
```

Dit verklaart de nood om `var` te gebruiken om *lokale* variabelen te definiëren.<br/><br/>
Merk op dat hier `wootwoot` énkel binnen de functie `yo()` leeft, dus via de Javascript *Garbage Collector* weggesmeten wordt zodra die functie volledig geëvalueerd is. 


#####= Nested en Block scope #####=

Functies in functies in functies zijn perfect mogelijk, en de binnenste functies hebben toegang tot de scope van alle anderen.

:exclamation: In tegenstelling tot Java e.a. beschikt JS **niet over block scope**. Dit wil zeggen:

```javascript
var f1 = 10;
function f() {
  console.log(f1); // 10? Nope, undefined!
  var f1 = 1;
  function z() {
    var z1 = 2;
    if(f1 ###### 1) {
       var z2 = 2;
    }
    
    return z1 + z2; // z2 nog steeds toegankelijk
  }
}
```

Waarom logt dit `undefined`, terwijl op global scope aan f1 10 toegekend wordt? Omdat een tweede variabele genaamd f1 in de *body* van de functie gedeclareerd wordt, wordt die versie gebruikt, **ook al is deze nog niet toegekend!**. Wow.

JS Is dus buiten de *lexicale scoping* ook nog eens *function-level scoped*.

Een duidelijker voorbeeld via http://www.adequatelygood.com/2010/2/JavaScript-Scoping-and-Hoisting:

```c
#include <stdio.h> 
int main() { 
    int x = 1; 
    printf("%d, ", x); // 1 
    if (1) { 
        int x = 2; 
        printf("%d, ", x); // 2 
    } 
    printf("%d<br/>n", x); // 1 
}
```

Print logischerwijze 1, 2, 1, juist? Doe hetzelfde eens in javascript:

```javascript
var x = 1; 
console.log(x); // 1 
if (true) { 
    var x = 2; 
    console.log(x); // 2 
} 
console.log(x); // 2
```

*BOOM*. <br/><br/>
Dit komt doordat `if` statements geen nieuwe scope introduceren, enkel `function` definities! Een oplossing is een anonieme functie gebruiken en die direct evalueren:

```javascript
function foo() { 
    var x = 1; 
    if (x) { 
        (function () { 
            var x = 2; 
            // some other code 
        }()); 
    } 
    // x is still 1. 
}
```

##### Scope chain #####

Elke JS Executie context heeft een **scope chain** toegekend. Dit is een lijst van objecten waar de interpreter door gaat om een variabele x op te kunnen zoeken (Dit proces heet *variable name resolution*). Men begint met de huidige context van de functie die opgeroepen wordt. Indien variabele x daar niet gedefiniëerd is, ga een scope hoger, en zo voort. 

In *top-level* JS (op window scope) bevat de scope chain slechts één object, het "globaal" object. (`window`)

##### Event handler scope chain #####

Bij het uitvoeren van events in de DOM Tree zitten er buiten `window` nog enkele andere objecten op de scope chain: het object dat het event zelf triggerde. Het is dus mogelijk om rechtstreeks vanuit een `onclick` event van een `input` tag, een ander `form` element aan te spreken zonder dit eerst te resolven via de klassieke `getElementById()`:

```html
<head>
<script>
function load() {
  document.getElementById("text").onclick = function() {
     alert(anders.value);
  }
}
</script>
</head>
<body onload="load();">
<input type######"text" id"text" value="blabla" />
<input type######"text" id"anders" value="blieblie" />
</body>
```

merk op dat `anders.value` mogelijk is doordat het DOM element text mee op de scope chain zit. <br/><br/>
Dit is vanzelfsprekend serieus verwarrend en **bad practice**, Firebug waarschuwt hier ook voor:

> Element referenced by ID/NAME in the global scope. Use W3C standard document.getElementById() instead.

Dit kan serieuze problemen met zich mee brengen, zeker wanneer mensen niet goed weten hoe javascript te gebruiken en bijvoorbeeld for loopjes schrijven door variabelen op toplevel scope te introduceren:

```html

<head>
<script>
function Iets(e) {
  return function() {
    alert(j); // DOM Element: Div met id "j", al hebben we nergens j gedefiniëerd!!! 
    
    // j = 0: BOOM in IE: Object doesn't support this property or method
    // reden => in IE is dit een readonly property, Gecko parsers zijn lakser hierin
    for(j = 0; j < 10; j++) {
      // whatever
    }
    
    alert(j); // 10
  }
}
</script>
</head>

<body>
<h2>Javascript event scopechain voorbeeld</h2>

<div id######"j" onclick"Iets()()">
 Klik hierop aub
</div>
</body>

```

##### Scope tijdelijk aanpassen #####

```javascript
with(window.screen) {
  console.log(width);
}
```

Al is `var screen = window.screen; screen.width` natuurlijk even makkelijk. 

#####= Private Member variables #####=

:exclamation: "Functies en variabelen in objecten zijn overal en altijd toegankelijk". **DIT IS FOUT**! Bekijk het volgende voorbeeld (zie [private members](http://www.crockford.com/javascript/private.html) docs):

```javascript
function Func(param) {
   this.publicMember = param;
   var privateMember = 10;
   var me = this;
   
   this.publicFunction = function() {
      console.log(this.publicMember);
   };
   
   // could be function privateFunction() {
   var privateFunction = function() {
      console.log(privateMember);
      console.log(this.publicMember); // BOOM
      console.log(me.publicMember);   // OK
   };
}

new Func(10).privateFunction() // BOEM
```

Zodra we `this` gebruiken om members in een constructor functie te steken wordt het publiek. Zodra we gewoon variabelen definiëren, ook al zijn het closures zoals `privateFunction`, is dit *niet* toegankelijk voor de buitenwereld! Dit wil zeggen dat het zelfs niet toegankelijk is voor `.prototype`-toegevoegde functies.

Merk op dat we aan `privateMember` kunnen zonder `this` te gebruiken om naar iets te refereren. Dit komt omdat die members in de context van het object zitten.<br/><br/>
Een probleem dat zich voordoet is dat de `this` pointer binnen private functions natuurlijk weer gereset wordt tot op `window` scope. Om dit op te lossen kunnen we een private variabele voorzien die refereert naar `this`, daarvoor dient `me`.

###### Private, Public en prototype functies ######

Een **private** functie is een functie die in de constructor functie gedefiniëerd is als *member variabele*, en dus geldig is binnen de context van die functie. <br/><br/>
Een **privileged** functie is een functie die in de constructor functie gedefiniëerd is met de *this accessor*. Deze functies kunnen private functies aanroepen omdat ze binnen de context van de constructor functie leven, en zijn ook aanroepbaar van buitenaf.<br/><br/>
Een **public** functie is een functie die in het *prototype* leeft van een object((privileged en public zijn in feite gelijk, onderscheid wordt gemaakt om public variables te scheidden)). Private members zijn hier niet toegankelijk, privileged wel. Een voorbeeld (vervolg):

```javascript
Func.prototype.publicThing = function() {
   alert(this.publicMember);
   return this.privateMember; // BOOM
};
```

#####= Object/Class Member variables #####=

In typische OO talen zoals Java en C++ kunnen ook "statics" gedefiniëerd worden die enkel op klasse niveau leven. Zoiets is heel simpel te realiseren met Javascript, door een property op de constructor functie zelf te steken:

```javascript
function Const() {
   this.c = "const";
   c = "globalConst";
}

Const.C = "C";


c ###### "globalConst"; // remember, window scope
new Const().c ###### "const";
new Const().C != undefined
```

Dit noemen we "class" properties, in plaats van "instance" properties.

#####= Anonieme functies gebruiken om members private te maken #####=

Probleem: publieke functies die aan een object hangen met `this.functie = function() { ... }` zijn toegankelijk. Ik wil iets groeperen zonder `window` scope te vervuilen. Hoe kan ik één functie opsplitsen zonder de andere te *exposen*?<br/><br/>
Oplossing:

```javascript
var Stuff = (function() {

  function doeStap1() {
    console.log("private things in here");
    return 3;
  }
  
  function doeStap2Met1(een) {
    return een * 2;
  }

  return {
    doeStuff: function() {
      return doeStap2Met1(doeStap1());
    }
  }

})()
console.log(Stuff); // outputs Object met "doeStuff" key
console.log(Stuff.doeStuff()); // 6
```

>In JavaScript, as opposed to statically scoped languages, all variables are scoped to the function in which they're defined (not the "block" as defined by curly braces). The above code snippet creates an anonymous function and immediately executes it. This has the effect of creating a scope in which variables can be defined, and anything in the containing scope is still accessible. 

Zie http://trephine.org/t/index.php?title=Aspect_Oriented_JavaScript

Wat gebeurt er?

  1. Wrap een lege functie in Stuff, waar x aantal functies in zitten die wat werk doen.
  1. In plaats van dat toe te kennen aan Stuff, evalueer direct de nieuwe functie met `(function() { ... })()`. Wat terugkomt is een closure functie die `doeStuff` definieert, de rest is niet zichtbaar. 

#####= Expliciet objecten binden met call/apply #####=

Neem als voorbeeld terug de ezel. Die zal bij het balken "iaia met mijn 4 poten" op de console afdrukken. Zodra de balk functie aangeroepen wordt, *bind* Javascript de ezel aan het `this` keyword, zodat poten correct opgezocht kan worden. Stel nu dat ik een spin wil laten balken, zonder de spin de balk functie te laten refereren/mixen vanuit de ezel:

```javascript
var Spin = function() {
  this.poten = 8;
};
var tarantula = new Spin();
new Ezel().balk.call(tarantula); // iaia met mijn 8 poten
```

Wat gebeurt hier?

  1. Ik maak een nieuw object aan met ook een poten property
  1. balk gebruikt de poten property maar ik wil mijn spin gebruiken in plaats van de 4 poten van de ezel!
  1. gebruik `call` om balk uit te voeren, en geef als argument mijn spin mee, zodat de balk functie gebind wordt op mijn spin in plaats van de nieuwe ezel instantie

Het is ook mogelijk om zonder argument `call` uit te voeren:

```javascript
var poten = 100;
new Ezel().balk.call(); // iaia met mijn 100 poten
```

Hoezo 100? `this` wordt dan `window`, de hoogst mogelijke scope, en daar is net toevallig ook een poten variabele op gedefiniëerd. Als dat niet zo was gaf dit als output "iaia met mijn undefined poten".

##### Impliciete unbound objecten #####

Het vorige voorbeeld toont aan hoe je expliciet `this` kan "unbinden". Dit gebeurt ook regelmatig intern impliciet, bijvoorbeeld met `setTimeout` of met events zoals `blabla.onclick`. <br/><br/>
De oplossing hiervoor is **closures** gebruiken. Bekijk dit voorbeeld:

```javascript
function SomeClass() {
  this.message = "hallo";

  this.startLooping = function() {
    setInterval(this.doeBijInterval, 1000);
  };
  
  this.doeBijInterval = function() {
    console.log(this.message);  // BOOOEEMM
  }
}
 
new SomeClass().startLooping();
```

Wat loopt hier mis? ((Buiten het feit dat setInterval niet altijd mag uitgevoerd worden, er moet een guard clause rond, setInterval retourneert een id!))<br/><br/>
doeBijInterval wordt hier om de seconde uitgevoerd, en this.message wordt afgedrukt. `this` verwijst op dat moment *niet* meer naar de instantie van SomeClass! 

De oplossing, een closure meegeven aan `setInterval` die kan werken op de instance:

```javascript
function SomeClass() {
  this.message = "hallo";

  this.startLooping = function() {
    var instance = this; // OK, SomeClass instance
    setInterval(function() {
      instance.doeBijInterval(); // this = window scope, gebruik de instance var.
    }, 1000);
  };
  
  this.doeBijInterval = function() {
    console.log(this.message);  // Da werkt ofwa
  }
}
 
new SomeClass().startLooping();
```

##### loop closures #####

Een ander voorbeeld waar het mis kan gaan (ref. http://trephine.org/t/index.php?title=JavaScript_loop_closures !):

```javascript
var list = [ 'a', 'b', 'c' ];
for (var i######0, llist.length; i<l; i++) {
  var item = list[i];
  setTimeout( function(){ alert(item); }, 1000 ); // print 3x 'c'
}
```

Hoe kan dit 3x 'c' afdrukken en niet 'a', 'b', 'c'?

  1. In de lus ken ik aan item de huidige index van de array toe.
  1. Voer een functie uit die een seconde in de toekomst uitegevoerd wordt. [NOG NIET]. Repeat lus tot klaar.

Zodra de events verwerkt worden, is item reeds de laatste in de rij. Oei. De oplossing, weeral closures:

```javascript
var list = [ 'a', 'b', 'c' ];
for (var i######0, llist.length; i<l; i++) (function(item){
  setTimeout( function(){ alert(item); }, 1000 );
})(list[i]);
```

Hier wordt een anonieme functie aangemaakt die *direct* geëvalueerd wordt met `list[i]` als parameter, zodat elke closure uniek gebonden is aan de juiste parameter.<br/><br/>
Zie AOP hieronder voor meer uitleg over anonieme functies.

#####= Samenvatting: module pattern #####=

Wanneer we alle bovenstaande technieken toepassen, krijgen we typisch in Javascript iets zoals dit:

```javascript
var MyGlobalNewModule = (function(module) {
    var privateVar = 3;
    function privateFn() {
      privateVar += 3;
    }
    
    // decorate or use module here if wanted.
    return {
      publicProperty: "hello",
      publicFn: function() {
        return privateFn() - 2;
      }
    };
})(GlobalModule);
```

Wat zit hier in verwoven?

  1. private variables en functions zitten in de anonieme functie scope
  1. andere modules zijn toegankelijk via een argument, en *niet* via de directe variabele
  1. publieke functies worden *exposed* via een object dat teruggegeven wordt. 

Zo werken bijvoorbeeld de API en plugins van __jQuery__.

:exclamation: Anonieme functies declareren en uitvoeren kan op twee manieren in JS: via `(function() { ... })()` en via `(function() { ... }())`. Merk het verschil in **haakjes** op. Het resultaat is exact hetzelfde, er is alleen een semantisch verschil, namelijk dat bij de eerste expressie de haakjes de *functie expressie* vasthoudt, en bij de tweede expressie de *call expressie* (het resultaat van de functie)

Zie [stackoverflow](http://stackoverflow.com/questions/3783007/is-there-a-difference-between-function-and-function) voor meer uitleg - schematisch:

```

               CallExpression
                |         |
       FunctionExpression |
                |         |
                V         V
    (function() {       }());
    ^                      ^
    |--PrimaryExpression --|
```

VS

```
          PrimaryExpression
                |
         FunctionExpression
                |
                V
    (function() {       })();
    ^                      ^
    |--  CallExpression  --|

```

# Testing JS Code 

## Testen schrijven  

### Klassieke Unit testen 

Frameworks gebruiken zoals jQuery's [QUnit](http://docs.jquery.com/Qunit) die het makkelijk maken modulair te testen:

```javascript
test("dit zou dat moeten doen blabla", function() {
  equal(expected, actual);
  ok(someThingExpectedToBeTrue);
});
```

Mocking van bijvoorbeeld `$` mogelijk via [MockMe](http://johanneslink.net/projects/mockme.html), een door Mockito geïnspireerde Javascript Object spy API. Iets van:

```javascript
when(f)('in').thenReturn('out');
assertEqual('out', f('in'));
```

:exclamation: Vereist `Prototype JS`, en `JsUnit` om de `assert` functions te kunnen gebruiken

### Gedrag testen met Jasmine 

Inspiratie van de *Ruby* community gehaald, met name **RSpec**-based.<br/><br/>
Frameworks gebruiken zoals [Jasmine](http://pivotal.github.com/jasmine/) ((Niet afhankelijk van andere JS Frameworks, vereist geen DOM dus geen Envjs nodig serverside!)):

```javascript
describe("Rekenmasjien", function() {
  it("should add one number", function() {
    var calc = new Calc(0);
    expect(calc.increase()).toEqual(1);
  });
});

```

Krachten:
  * Schrijf code door *expectations* ([Matchers vbs](https://github.com/pivotal/jasmine/wiki/Matchers)) op te bouwen, in dezelfde trand als `FESTAssert`. 
  * Bundel expectations in een suite ("beschrijvend")
  * Schrijf makkelijk extenties om eigen expectation functions op te bouwen als de standaard API niet volstaat
  * `beforeEach()` en `afterEach()` functions binnen suites
  * Snel disablen van testen via `xit()` (`@Ignore` zogezegd)
  * **mocking** en **spying** heel eenvoudig mogelijk: zie https://github.com/pivotal/jasmine/wiki/Spies
  * Plugins voor reporting, custom matching, ... 

Zwakheden:
  * Async testen vereist `waitsFor()` ea. Zie onder
  * Vereist specRunner.html files, standaard altijd in een browser runnen. **Genereer specRunners**! 

Betere matchers speciaal voor jQuery ea zijn beschikbaar: https://github.com/velesin/jasmine-jquery

##### Aynschrone code testen 

Zie async stuff

##### Jasmine integreren met jsTestDriver 

Zie http://skaug.no/ingvald/2010/10/javascript-unit-testing.html

Er is een **Jasmine adapter** beschikbaar: https://github.com/ibolmo/jasmine-jstd-adapter

Het kan ook handig zijn om een **Junit XML Reporter** te gebruiken om bijvoorbeeld voor Hudson het makkelijker te maken om de test output files te verwerken. Er zijn reeds enkele reporter plugins zoals deze beschikbaar, hier: https://github.com/larrymyers/jasmine-reporters

:exclamation: Integratie met Hudson, EnvJS en Rhino ea: zie eigen junit test runner: https://github.com/jefklak/jasmine-junit-runner

### Andere JS Test frameworks 

Interessante links:

  1. http://tddjs.com/
  2. [Stack overflow: Looking for a better Javascript unit test tool](http://stackoverflow.com/questions/300855/looking-for-a-better-javascript-unit-test-tool)
  3. 

## Testen automatiseren 

### Distributed testing in-browser 

#### jsTestDriver 

http://code.google.com/p/js-test-driver/

Wat doet dit?
  * Een jar dat een **server** opstart die een browser bestuurt en bepaalde __JS__ files (uw testen en uw productiecode) automatisch inlaadt en uitvoert
  * Bevat een API met asserts
  * Reportgeneratie met plugins voor eclipse om ze JUnit-like te tonen
  * Integratie met build etc mogelijk
  * Integratie met Jasmine mogelijk: https://github.com/ibolmo/jasmine-jstd-adapter

**jsTestDriver integreren met Hudson**

Zie http://cjohansen.no/en/javascript/javascript_continuous_integration_with_hudson_and_jstestdriver

Het komt eigenlijk hierop neer: maak een nieuw target, voer extern dit commando uit:

```
java -jar test/JsTestDriver-1.2.2.jar <br/>
  --config jsTestDriver.conf <br/>
  --server http://localhost:4223 
  --tests all --testOutput . --reset
```

Dit neemt aan dat de server reeds gestart is, kan met een shell script op de Hudson server bak: `java -jar test/JsTestDriver-1.2.2.jar --port 4223`. 

#### JsUnit Server 

http://www.jsunit.net/documentation/index.html

Wat doet dit?
  * Een jar dat een **Jetty Server** opstart die een browser bestuurt en bepaalde __HTML__ files inlaadt en uitvoert, waar testen in zitten
  * Afhankelijk van `Prototype JS` om asserts uit te voeren
  * Integratie met ant zeer eenvoudig

#### TestSwarm 

Zie http:*swarm.jquery.org/ en https:*github.com/jquery/testswarm/wiki

### Headless testen 

#### Mogelijkheid 1: EnvJS 

*EnvJS* is een *gesimuleerde* browser omgeving geschreven in JS. Zie http://www.envjs.com/

__Voordeel__: heel snel

__Nadeel__: `Java` ofzoiets nodig om JS te evalueren (**Rhino** of **V8** in C++ van Google), plus kan onregelmatigheden vertonen met hevig gebruik maken van UI frameworks -> dit zou moeten werken allemaal, maar het blijft een gesimuleerde omgeving.

:exclamation: Zie https://github.com/jefklak/jasmine-junit-runner

Integreren met hudson als extern commando:

```
java -cp lib/envjs/js.jar:lib/envjs/jline.jar org.mozilla.javascript.tools.shell.Main -opt -1 -f lib/envjs/envjs.bootstrap.js -f test.js
```

`test.js` heeft dan maar 1 regel die naar de juiste specRunner.html gaat met `window.location`. 

#### Mogelijkheid 2: Qt Webkit widget 

*Webkit* is een opensource web renderer, en er is een implementatie in `Qt` beschikbaar (vereist libs geïnstalleerd te hebben). Zie http://trac.webkit.org/wiki/QtWebKit

__Voordeel__: gedrag volledig in een "echte" website rendered, in plaats van via een omweg. Aangezien het een Qt Widget is, hoeft het niet expliciet op het scherm gerendered te worden (dit pollt gewoon totdat bvb *"Jasmine tests run"* ofzoiets van tekst verschijnt, om dan de HTML te retourneren als resultaat. 

__Nadeel__: Qt libs vereist, nog altijd niet volledig "headless", aparte widget spec runner in de achtergrond die draait. 

Zie http://johnbintz.github.com/jasmine-headless-webkit/ (Implementatie in Ruby met nogal veel nadruk op gems ea... Handig?)

[Phantom JS](http://www.phantomjs.org/) is een full stack headless browser implementatie gebaseerd op WebKit (C++/Python implementatie). 

# Pitfalls 

:exclamation: Gebruik aub **[JSLint](http://www.jslint.com)** om onderstaande "probleempjes" makkelijker te kunnen tracen en aanpassen.

[Strict mode](https://developer.mozilla.org/en/JavaScript/Strict_mode) in ECMA5 is ook iets héél handig.

-> Meer (al dan niet grappige) pitfalls/weetjes: http://www.wtfjs.com/

### Objecten 

Javascript gebruikt intern de `toString()` functie wanneer objecten als keys worden toegekend. Dit wil zeggen dat eigenlijk de string representatie als key gebruikt wordt. Bijvoorbeeld:

```javascript
var obj = {};
var key1 = new Object();
var key2 = new Object();

obj[key1] = "hi";
obj[key2] = "yo";

console.log(obj[key1]);  // ##### yo???
```

#####= arguments #####=

##### arguments on-the-fly veranderen #####

Zonder `use strict` (ES5) kan je een binnenkomend argument ook toekennen aan een andere waarde. Hierdoor verandert de waarde van `arguments[0]`! De `arguments` lijst houdt dus een pointer bij naar de variabele die de value van het argument vasthoudt, en niet naar de value zelf. In strict mode wel. Voorbeeld:

```javascript
function bla(a) {
  a = 5;
  console.log(arguments[0]);
}
bla(1); // 5, in strict mode 1
```

##### arguments is geen array #####

Snel "effe" lopen over alle argumentjes: 

```javascript
function aha() {
  arguments.forEach(function(itm) { // syntax error ???
    console.log(itm);
  });
}
aha(1, 2, 3);
```

Inderdaad: `Array.isPrototypeOf(arguments) ##### false`. Dus de `.length` property werkt op een andere manier, en van die hidden `.callee` dingen (die niet werken in strict mode) zitten er ook op...

Oplossing: 

```javascript
function aha() {
  var args = Array.prototype.slice.call(arguments);
  args.forEach(function(itm) {
    console.log(itm);
  });
}
aha(1, 2, 3);
```

#####= Falsey values #####=

De volgende values evalueren allemaal naar `false` in bvb een `if()` block:

  1. `null`
  2. `0` als `number`
  3. `""` als `string`
  4. `false` als `boolean`
  5. `undefined`
  6. `NaN`

Deze dingen lukken ook niet:

```javascript
if(new Boolean(false)) {
   alert("ik ben false jong!"); // oei tis nie waar hé?
}
```

Mogelijke Oplossingen:
  1. gebruik altijd `.valueOf()` van de object counterparts van alle primitives!
  2. gebruik `Boolean(false)` (zonder new), zie [Mozilla Boolean Dev docs](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Boolean)

Lees hier meer over in [The secret life of Javascript Primitives](http:*javascriptweblog.wordpress.com/2010/09/27/the-secret-life-of-javascript-primitives/) en [the value of valueOf](http:*javascriptweblog.wordpress.com/2010/05/03/the-value-of-valueof/).

#####= Typecasting #####=

^ code ^ resultaat ^
| [] + 23 | de string "23" |
| [1, 2] + 23 | de string "1, 223" |
| false + 23 | het getal 23 |
| true + 23 | het getal 24 |
| "kadootje" + 23 | de string "kadootje23" |
| undefined + 23 | NaN |
| null + 23 | het getal 23 |

#####= Parsing #####=

`parseInt("08")` neemt automatisch aan dat de waarde naar octal values omgezet moet worden. Dit evalueert naar het getal `0`.<br/><br/>
Oplossing: `parseInt("08", 10)` - het tweede argument geeft de eenheid aan (10 = decimaal).

#####= de wereld breken (undefined) #####=

`undefined` is een toplevel variabele die als value de primitive value `undefined` heeft. <br/><br/>
Zodra je `undefined` (de variabele) toekent aan iets anders, is die primitive value weg en is alles naar de zak. Voorbeeld:

Dit is opgelost in ECMA5 door sommige properties al dan niet writable te maken. `undefined` is daar dus readonly. Check dit in Firefox 4:

```javascript
var undefinedProps = Object.getOwnPropertyDescriptor(window, "undefined")
undefinedProps.writable ##### false; // locked down!
```

#####= Javascript en puntkomma's #####=

Geen enkele lijn hoeft een `;` te bevatten, javascript voegt deze automatisch toe bij het evalueren. Dit kan ook miserie veroorzaken:

```javascript
function geefIets() {
  return 
  {
     iets: "wow"
  };
}

geefIets(); // undefined: unreachable code!
```

Los dit op door de accolade na de return te plaatsen in plaats van de newline. 

#####= ECMA5: map, forEach, filter: de 3 parameters #####=

Sinds ECMA5 is het héél handig om bijvoorbeeld voor een array van strings elk element individueel te manipuleren en een nieuwe array terug te geven.<br/><br/>
Stel, ik wil `string`s naar `number`s omvormen:

```javascript
["1", "2", "3"].map(parseInt); // returns [1, NaN, NaN ] ???
```

Whoops? `parseInt` heeft als tweede variabele de eenheid (decimaal, hexa, ...) en alle array manipulatie functies geven altijd 3 argumenten mee: het element, de index en de array zelf. Conflict! 

Oplossing: closures! 

#####= Arrays zijn "speciale" associatieve objecten #####=

Dit zegt de [http:*bclary.com/2004/11/07/#a-15.4ECMAScript specificatie](http:*bclary.com/2004/11/07/#a-15.4ECMAScript specificatie):

> Array objects give special treatment to a certain class of property names. A property name P (in the form of a string value) is an array index if and only if **ToString(ToUint32(P)) is equal to P and ToUint32(P) is not equal to 2^32 - 1**. Every Array object has a length property whose value is always a nonnegative integer less than 2^32. The value of the length property is numerically greater than the name of every property whose name is an array index; whenever a property of an Array object is created or changed, other properties are adjusted as necessary to maintain this invariant. Specifically, whenever a property is added whose name is an array index, the length property is changed, if necessary, to be one more than the numeric value of that array index; and whenever the length property is changed, every property whose name is an array index whose value is not smaller than the new length is automatically deleted. This constraint applies only to properties of the Array object itself and is unaffected by length or array index properties that may be inherited from its prototype.

Dat wil zeggen dat:

  1. zodra de `.length` property gewijzigd wordt, er verschillende dingen gebeuren:
    1. Indien kleiner wordt: alle properties kleiner dan de lengte worden automatisch verwijderd
    2. Indien groter wordt: allemaal nieuwe elementen met `undefined` als value (*impliciet*!)
  2. Alle "integer" values (zie geweldige formule) zijn "speciale" properties die de `length` property ook aanpassen.

Wat gebeurt er als ik de `length` property boven het maximum zet?

```javascript
var arr = [1];
arr.length = Math.pow(2, 32) - 1; // max allowed
arr.length++; // RangeError: invalid array length (na lang denken van de parser)
```

:exclamation: de `length` property wordt gebruikt door utility functies zoals `push`, `concat` etc, dus als deze niet correct werkt zoals hierboven beschreven gebeuren en vreemde dingen! 

Meer info: zie [How to subclass an Array](http://perfectionkills.com/how-ecmascript-5-still-does-not-allow-to-subclass-an-array/)