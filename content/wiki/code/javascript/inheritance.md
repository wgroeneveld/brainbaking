+++
title = "inheritance"
draft = false
tags = [
    "code",
    "javascript",
    "inheritance"
]
date = "2013-03-12"
+++
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

######= Gewenst gedrag - wat waar plaatsen ######=

  * Indien ik een functie of een variabele heb die anders kan zijn naargelang de implementatie (definiëer de "naamgeving"), plaats deze dan in de **constructor** functie.
  * Indien ik een functie of een variabele heb die specifiek voor die functie is en niet gaat veranderen, plaats deze dan **in het concreet object** via `this.`. 
  * Indien ik een functie of een variabele heb die ik tijdelijk wens te gebruiken, plaats deze dan **in het concreet object** via `var` ((Maak slim gebruik van scope chaining om zaken te encapsuleren!)).

Typisch bevatten constructor functies ook *geen* return waarden ((dit retourneert dus impliciet `undefined`)) - we gebruiken deze functies toch altijd in combinatie met de `new` operator, dus kennen de nieuwe instantie van het object direct toe aan een variabele. 

############= prototype gebruiken als inheritance ############=

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

######= Properties overriden ######=

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

######= Built-in JS types extenden ######=

:exclamation: Extend **nooit** `Object.prototype`! Waarom? Omdat Eender welk object een instantie van `Object` is, dus zijn prototype heeft, en met een `for(x in prop)` deze property nu ineens toegankelijk is voor elk object. Een leeg object `{ }` wordt verwacht géén properties te hebben! 

```javascript
Object.prototype.hack = function() {}
for(x in {}) {
  console.log(x); // print "hack", zou hier niet in mogen komen
}
```

############ Checken op inheritance ############

Met Javascript kan men door middel van `typeof` controleren van welk type een variabele is. Dat komt neer op:

  * object (`{}`)
  * function (`function() {}`)
  * string (`""`)
  * number (`-47.2`)

Het is niet zo interessant om te gebruiken voor eigen inheritance. Daarvoor dient `instanceof`:

```javascript
ezeltje instanceof Vierpotige ###### true
ezeltje instanceof Ezel ###### true
new Vierpotige() instanceof Ezel ###### false
```

######= Zelf inheritance afchecken met prototype ######=

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

De betere oplossing: **`isPrototypeOf()`**! Zie [magic_properties]({{< relref "magic_properties.md" >}})

:exclamation: **`_ _proto_ _` is een __instance__ property, `.prototype` een constructor function property**

###### met properties ######

Door `hasOwnProperty()` te gebruiken kan je nagaan of een property overgenomen is of niet. Vanaf JS 1.5.

############= call als inheritance ############=

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

############= prototypal inheritance toepassen ############=

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

############ Een minder verbose manier om extra properties te definiëren ############

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

############= Prototype JS en Class.create ############=

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
  1. `Object.extend()` wordt gebruikt om alle keys van de parent te kopiëren naar de nieuwe lege functie. (zie [code/javascript/frameworks]({{< relref "wiki/code/javascript/frameworks.md" >}}))
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