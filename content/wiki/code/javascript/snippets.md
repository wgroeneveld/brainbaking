+++
title = "snippets"
draft = false
tags = [
    "code",
    "javascript",
    "snippets"
]
date = "2013-03-12"
+++
# Losse Javascript Snippets 

## Interessante links 

http://javascript.crockford.com/prototypal.html

## Text Width 

Nut: Bereken tekst breedtes op een browser scherm onafhankelijk van de container waar hij in zit.
Waarom: `$("bla").getWidth()` gaat altijd rekening houden met de bovenliggende container style! 
Dit voegt eerst een lege span toe aan de body, haalt de width op en smijt de span terug weg. 

```javascript
String.prototype.getTextWidth = function() {
        var sensor = $j(document.createElement("span"));
        sensor.append(this.toString());
        $j("body").append(sensor);
        var width = sensor.width();
        sensor.remove();
        return width;
} 

// usage:
"zever".getTextWidth()
```

##Verander element dimensies 

Normaal gezien kan dit perfect:<br/><br/>
`$j("#div").width()` en `.height()`
maar natuurlijk werkt dit niet in **IE**. Daar moet je letterlijk de CSS properties van width en height aanpassen:<br/><br/>
`$j("#div").css({width: x, height: y})`

Dit geeft geen fout in Explorer maar doet gewoonweg niets, dus opletten!

## Makkelijk String naar Boolean converteren 

```javascript
String.prototype.toBoolean = function() {
return (/^true$/i).test(this);
};

"lala".toBoolean() ###### false;
"true".toBoolean() ###### true;
```

############= Currying & Applying ############=

Zonder **Prototype JS** (built-in `curry` functie, voor jQuery zijn er plugins)

```javascript
(function() {

	var slice = Array.prototype.slice;
	
	Function.prototype.curry = function() {
		if(!arguments.length) return this;
		
		var curryArgs = slice.call(arguments, 0);
		var myFunction = this;
		
		return function() {
			var functionArgs = slice.call(arguments, 0);
			myFunction.apply(this, curryArgs.concat(functionArgs));
		}
	};
	
	Function.prototype.applyArgs = function(thisObj, args) {
		return this.apply(thisObj, slice.call(args, 0));
	};

})();
```