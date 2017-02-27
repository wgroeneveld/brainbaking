+++
title = "testing"
draft = false
tags = [
    "code",
    "javascript",
    "testing"
]
date = "2013-03-12"
+++
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

Zie [async]({{< relref "async.md" >}})

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