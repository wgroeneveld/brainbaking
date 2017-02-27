+++
title = "pitfalls"
draft = false
tags = [
    "code",
    "javascript",
    "pitfalls"
]
date = "2013-03-12"
+++
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