+++
title = "scoping"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "scoping"
]
date = "2013-03-12"
+++
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