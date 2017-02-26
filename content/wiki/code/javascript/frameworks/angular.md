+++
title = "angular"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "frameworks",
    "angular"
]
date = "2013-05-22"
+++
# Angular 

Testing: zie [code/javascript/testing/angular]({{< relref "wiki/code/javascript/testing/angular.md" >}})

#### Caching in HTTP 

`IE8` cachet by default alle XHR requests en daar kan je niet zomaar iets aan veranderen. Een unieke URL elke keer callen is een oplossing (met `new Date().getTime()` bijvoorbeeld), maar je kan ook aan de server kant de `Cache-Control` header parameter op `no-cache` zetten. 

Zie issue https://github.com/angular/angular.js/issues/1418

### Hoe werkt ... under the hood? 

####  dependency injection 

Zie http://www.alexrothenberg.com/2013/02/11/the-magic-behind-angularjs-dependency-injection.html

TLDR: ze gebruiken `toString()` om argument namen te parsen, zodat de volgorde niet uitmaakt wat het normaal wel doet in de magische array `arguments`! 

#### Het watchen van variabelen en objecten 

In de `$digest()` loop, die constant draait (een achterwaardse loop, zie de [source code](http://ajax.googleapis.com/ajax/libs/angularjs/1.0.6/angular.js), zoek voor bijvoorbeeld `$$watchers`, dat is de array van te watchen objecten), wordt er constant gekeken naar het object en gekeken of dat niet hetzelfde is als de "laatste". Met "laatste" bedoelen we een kopie van het object, zodat we altijd een pointer naar de actuele referentie hebben. 

<img style='float: left; width: nolink|px;' src='/img//code/javascript/frameworks/concepts-runtime.png'>

Het werkt eigenlijk ongeveer zoals `ObjectObserver` van https:*github.com/rafaelw/ChangeSummary - in nieuwe browsers zoals Chrome Canary kan er "native" gekeken worden naar object veranderingen door `Object.observe()` te gebruiken - zie het [html5rocks artikel](http:*updates.html5rocks.com/2012/11/Respond-to-change-with-Object-observe). 

Een belangrijke link: http://docs.angularjs.org/guide/concepts
