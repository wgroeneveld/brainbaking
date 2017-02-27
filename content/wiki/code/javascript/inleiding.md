+++
title = "inleiding"
draft = false
tags = [
    "code",
    "javascript",
    "inleiding"
]
date = "2013-03-12"
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
  * `this` wordt gebruikt om keys aan te spreken! Waarom? zie **[scoping]({{< relref "scoping.md" >}})**.
  * De functie bevat gewone statements met `=` en niet met `:`. Dit is geen object maar een functie!

:exclamation: De functie die net aangemaakt is kan nu als constructor dienen. Die werd intern ook aan de Ezel `prototype` property gekoppeld:

```javascript
Ezel.prototype.constructor
```

De correcte manier om de ezel te laten balken is `new Ezel().balk()`.<br/><br/>
Meer info over hoe `new` werkt om de ezel instance de poten en de balk functie toe te kennen: zie [code/javascript/inheritance]({{< relref "wiki/code/javascript/inheritance.md" >}}).

##### Functies zijn objecten 

> Functions are first class Objects!

Bewijs: (Uitleg: zie [inheritance]({{< relref "inheritance.md" >}}))

```javascript
Function.prototype.__proto__ ##### Object.prototype;
(function fn(){}).__proto__ ##### Function.prototype;
```

Dus functies zijn *ook* associatieve maps, dus `(function(){}).bla = 3;` werkt perfect! Zie [scoping]({{< relref "scoping.md" >}}), deel "Object/Class Member variables".

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

:exclamation: Uitzondering: een formeel argument met naam `arguments` heeft voorrang op lang-defined `arguments`. Bad practice... 

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

Obj.x ###### undefined // false, so it must exist as a key, right?
Obj.u ###### undefined // whoops, true? oplossing: gebruik '#####'
Obj.un ##### undefined // whoops, still true? value kan ook undefined zijn natuurlijk!
```

#####= Varargs #####=

```javascript
function f() {
  return arguments[0] + arguments[1];
}
f(1, 2) // ###### 3
```

Indien er geen argumenten gespecifiëerd zijn, zijn ze allemaal *optioneel*! Dit wil zeggen dat een functie aangeroepen kan worden zonder het aantal argumenten 100% te laten overeen komen. 

###### anonymus functions en recursie ######

`arguuments` heeft nog een speciale property: `arguments.callee(...)` dat de huidige functie voorstelt, hiermee kan je jezelf aanroepen! 

:exclamation: Dit gaat een syntax error geven bij ECMA Script standaard 5 in *strict* mode

###### verplicht alle argumenten invullen ######

```javascript
function f(x, y, z) {
  if(arguments.length != arguments.callee.length) {
    throw new Error("kapot wabezig");
  }
}
f(1, 2) // ###### 3
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

Zie [scoping]({{< relref "scoping.md" >}})

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
if(x.two ###### null) {
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

:exclamation: `undefined` is een window-scope variabele die initiëel de value `undefined` heeft, dit is dus géén keyword, pas op!

#####= By Value versus By Reference #####=

^ Type ^ Copied by ^ Passed By ^ Compared by ^
| number | Value | Value | Value |
| boolean | Value | Value | Value |
| string | Immutable | Immutable | Value |
| object | Reference | Reference | Reference |