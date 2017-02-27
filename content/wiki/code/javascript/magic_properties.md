+++
title = "magic_properties"
draft = false
tags = [
    "code",
    "javascript",
    "magic_properties"
]
date = "2013-03-12"
+++
# Javascript Magic properties 

:exclamation: Waarschuwing: deze properties zijn normaal gezien **niet toegankelijk** en dienen enkel om uw algemene kennis van Javascript te verbreden. Deze "magic" properties zijn meestal *exposed* in Mozilla Firefox of via de Firebug plugin. Sommigen hiervan worden overgenomen in de nieuwe versie van javascript, [versie *1.8.5*](https://developer.mozilla.org/en/JavaScript/New_in_JavaScript/1.8.5) die de ECMA Standaard v5 implementeert. Dit is voor de volgende versie van Chrome en FF4.

### magic properties via Firefox 

#### Intern prototype object 

-> `_ _proto_ _`

**Deprecated**: gebruik `Object.getPrototypeOf` in de plaats. Wordt deel van ECMA5, *reeds geïmplementeerd vanaf FF3.5*.

Wat is hier mogelijk mee? We kunnen zo makkelijker via inheritance een "shadowed" functie aanroepen:

```javascript
function Dier() { }
Dier.prototype.eet = function(extra) {
  console.log("omnom " + extra);
}
function Aap() { }
Aap.prototype = new Dier();
Aap.prototype.eet = function() {
  Object.getPrototypeOf(this).eet("banaan");
  // without getPrototypeOf, you'd have to explicitly call it via Dier.prototype.eet
}
new Aap().eet();
```

Zie
  * Mozilla API: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/proto
  * http://ejohn.org/blog/objectgetprototypeof/

#### Keys van objecten retourneren 

```javascript
Object.keys({1: 1, 2: 2}) ###### [ "1", "2"] 
```

Beschikbaar via Firebug, en in Node JS. Wordt deel van ECMA5.

Een andere manier is via de magic property `_ _count_ _`.