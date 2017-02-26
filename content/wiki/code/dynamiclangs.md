+++
title = "dynamiclangs"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "dynamiclangs"
]
date = "2013-03-12"
+++
# Dynamic Languages: Constructs vergelijken 

Deze pagina vergelijkt verschillende dynamische talen in een poging om een overzicht te maken tussen de alsmaar groeiende lijst. De meest gebruikte features van zulke talen worden hieronder opgelijst.

## Het verschil tussen MOPs en Prototypal inheritance 

:exclamation: Javascript heeft géén **Meta Object Protocol** (MOP) dat de taal dynamisch maakt, maar bouwt verder op prototypes. Dat wil zeggen dat het klassieke inheritance systeem niet bestaat in Javascript, maar wel nagebootst kan worden door objecten te laten afleiden van objecten. De vergelijkingstabellen hieronder tonen hoe Javascript zich kan *gedragen* als een klassieke OO taal, dat wil niet automatisch zeggen dat dit de beste manier is om JS te gebruiken!

De volgende dynamische talen beschikken wel over een MOP:

  1. Groovy
  2. Python
  3. Ruby
  4. Smalltalk dialecten
  5. LISP dialecten (bvb. Runtime MOPs via `CLOS`)
  6. Perl 6
  7. OpenC++ (bvb. Compiletime MOPs door C++ te parsen en analyseren)

[Ruby VS Javascript metaprogramming](http://fingernailsinoatmeal.com/post/292301859/metaprogramming-ruby-vs-javascript):

> The most interesting thing about the Javascript example is that it is exactly the same as the example of adding a dynamic method to a class. There is no difference because Javascript functions **are** closures. The ubiquity of closures in Javascript is extremely powerful and, makes metaprogramming very easy. 

Voor meer informatie, zie wiki entry over **[Javascript inheritance]({{< relref "wiki/code/javascript/inheritance.md" >}})**

# Vergelijkingstabellen 

## Dynamica van de taal: Metaprogramming 

### Methods toevoegen 

#### Op klasse niveau 

^ Javascript ^ Groovy ^
| ```javascriptString.prototype.isTrue = function() {
  return this ###### "true";
}``` | ```javaString.metaClass.isTrue = {
  delegate ###### "true"
}``` |

Javascript bevat enkele *common pitfalls* hierrond, zie [JS Inheritance]({{< relref "wiki/code/javascript/inheritance.md" >}}).

Groovy staat ook toe om *constructors* toe te voegen op deze manier. <br/><br/>
Methods "lenen" gaat ook met de **&.** operator in Groovy om de pointer naar een method vast te krijgen. In JS gewoon de "key" (methodnaam) als referentie gebruiken.

######= Op instance niveau ######=

^ Javascript ^ Groovy ^
| ```javascript"someString".isTrue = function() {
  return this ###### "true";
}``` | ```java"someString".metaClass.isTrue = {
  delegate ###### "true"
}``` |

Voor beide talen op exact dezelfde manier dus, op een *instance* zelf.((Groovy 1.6+ heeft dit standaard, anders uw metaClass nog correct aanpassen! Zie http://groovy.codehaus.org/Per-Instance+MetaClass ))

Als Groovy problemen geeft, kan het zijn doordat `ExpandoMetaClass` niet geconfigureerd staat voor *inheritance*:

```java
ExpandoMetaClass.enableGlobally()
```

############ Methods catchen ############

Met "catchen" wordt "*decoreren*" bedoeld. van alle calls op van method namen die niet bestaan en doe ermee wat je wilt.


^ Javascript ^ Groovy ^
| **niet** mogelijk | ```javaSomeClass.metaClass.methodMissing = { name, arguments ->
  switch(name) {
    case "bla": return "blaing eh"
    break;
  }
}
assert "blaing eh" ###### new SomeClass().bla()
``` |

Groovy kan ook **alle methods** opvangen, ook de bestaande, door de MOP hook `invokeMethod`, `get/setProperty`, `propertyMissing` etc te overriden - op `Object` of `metaClass` niveau, op deze manier:

```java
class SomeClass {
  def invokeMethod(String name, args) {
    switch(name) {
      case "bla": return "blaing eh"
      break;
      default:
        // delegate.invokeMethod name, arguments makes an infinite loop! it's a tarp!
        delegate.metaClass.getMetaMethod(name, arguments).invoke(delegate, arguments)      
    }
  }
}```

En ja, dat werkt [Ook met static methods in Groovy](http://groovy.codehaus.org/ExpandoMetaClass+-+Overriding+static+invokeMethod)!

:exclamation: Rhino en SpiderMonkey implementaties van JavaScript (Firefox' JS parser bijvoorbeeld) ondersteunen wel een magic missing method, genaamd `__noSuchMethod__` en een hele hoop andere nifty dingen zoals `__defineGetter__` en `__lookupSetter__`. Meer informatie in [deze blogpost](http://offthelip.org/?p=101) te vinden. Voorbeeld in Firefox+Firebug:

```javascript
SomeClass.prototype.__noSuchMethod__ = function(name, arguments) {
  console.log("calling method " + name + " with arguments " + arguments);
  if(name ###### "bla") {
    return "blaing eh";
  }
}
"blaing eh" ###### new SomeClass().bla() // true
```

Merk op dat in Groovy zoiets niet bestaat, we overriden **ender welke methodCall**, daarom dat in de `default` van het `switch` statement nog altijd een delegate invoke moet gebeuren!

############ Properties toevoegen ############

^ Javascript ^ Groovy ^
| ```javascriptvar gapingHoleInTheGalaxy = function() {}
gapingHoleInTheGalaxy.theSun = "extraHot"; // method 1
gapingHoleInTheGalaxy['theSun'] = "extraHot"; // method 2
gapingHoleInTheGalaxy.explode = function() {
  console.log("Explosion!")
}``` | ```javadef gapingHoleInTheGalaxy = new Expando()
gapingHoleInTheGalaxy.theSun = "extraHot" // method 1
gapingHoleInTheGalaxy['theSun'] = "extraHot" // method 2
gapingHoleInTheGalaxy.explode = {
  println "Explosion!"
}``` |

:exclamation: Groovy heeft een speciale klasse `Expando` die dynamisch toelaat om eender wat toe te voegen, zowel *closures* als *properties* op dezelfde manier. Enige nadeel: deze code kan niet gemengd worden met Java als byte code. Bij gewone klassen kan dit niet en moet dit via de `metaClass` gaan. Bij Javascript werkt dit omdat op eender welk moment het prototype van een object veranderd kan worden en er geen onderscheid is tussen closures en functions. 

Merk op dat hier de quotes nodig zijn om via de `[]` operator closures aan iets te hangen.

Het is wél mogelijk om properties via `metaClass` toe te voegen door de methodnaam de javaBean specificatie te laten volgen, bvb `metaClass.getBrol ###### {}` zodat men `def x  inst.brol` kan uitvoeren. 

############ Itereren over methods ############

^ Javascript ^ Groovy ^
| ```javascriptfor(propertyName in someInstance) {
  var propertyValue = someInstance[propertyName]
  if(typeof propertyValue ###### "function") {
    var retVal = eval("someInstance." + propertyName + "(args)"); // method 1
    retVal = propertyValue(args) // method 2
  } else {
    console.log(propertyName + " property with value " + propertyValue);
  }
}``` | ```javaString.metaClass.methods.each {
  def methodName = it.name // now what? methods are on class level
  def retVal = someInstanceOfString."${methodName}"
}
someInstanceOfString.properties.each {
  println "${it.key} property with value ${it.value}"
}``` |

############= Variable arguments ############=

############ varargs core ############

^ Javascript ^ Groovy ^
| ```javascriptfunction bla() {
  for(arg in arguments) { console.log(arg); }
}
bla(1, 2, 3);
``` | ```javadef bla(Object[] args) { // method 1
def bla(Object... args) { // classic Java 1.5 method 2
  args.each{ println it }
}
bla(1, 2, 3);
}``` |

Een map meegeven gaat altijd natuurlijk, om argumenten expressiever te maken, zoals configuratie: (Groovy vb.)

```java
def bla(Map args) {
  println args.stuff
}
bla(stuff: "wow", c: 3)
```

############ Argument spreading ############

^ Javascript ^ Groovy ^
| ```javascriptfunction bla(a, b) {
   return a + b + 2;
}
var args = [1, 2];
bla(1, 2) ###### bla.apply(this, args) // 5
``` | ```javadef bla(a, b) {
  a + b + 2
}
def args = [1, 2]
bla(1, 2) ###### bla(*args)
``` |

############ Fixed arguments ############

^ Javascript ^ Groovy ^
| ```javascriptfunction bla(a, b, c) {
  if(!c) var c = 0;
  console.log("a: " + a + ", b: " + b + ", c: " + c);
}
bla(1, 2)      // 1, 2, 0
bla(1, 2, 3);  // 1, 2, 3
``` | ```javadef bla(a, b, c = 0) {
  println "a: $a, b: $b, c: $c"
}
def blaWow = bla.curry(1)
blaWow(2)    // 5, 2, 0
bla(1, 2)    // 1, 2, 0
bla(1, 2, 3) // 1, 2, 3
``` |

Merk op dat bij JS er gecontroleerd moet worden of een variabele daadwerkelijk is ingevuld of niet. `curry` is niet standaard aanwezig maar kan eenvoudig geïmplementeerd worden, zoals deze snippet van het *Prototype* framework:

```javascript
  function curry() {
    if (!arguments.length) return this;
    var __method ###### this, args  slice.call(arguments, 0);
    return function() {
      var a = merge(args, arguments);
      return __method.apply(this, a);
    }
  }
```

Dit roept in essentie de eigenlijke method op (met `apply`) met een aantal parameters predefined. 

############= String interpolatie ############=

^ Javascript ^ Groovy ^
| **niet** mogelijk | ```javadef dinges = "mijn dingetje"
"$dinges is a dong" ###### "mijn dingetje is a dong"
``` |

JS extentie om dit mogelijk te maken: zie [Prototype JS interpolate](http://www.prototypejs.org/api/string/interpolate), bvb:<br/><br/>
`"#{dinges} is a dong".interpolate({dinges: "mijn dingetje"}) ###### "mijn dingetje is a dong"`<br/><br/>
Merk op dat dit eenvoudig een regex door de string laat lopen.

Merk op dat bij Groovy dit zeer krachtig is en hele expressies in strings kunnen gegoten worden zoals `"bla ${this.method} jong"`. Ook methods aanroepen zoals this."${methodName}" werkt. 

############ Template parsing ############

Grotere brokken tekst interpoleren werkt via *templates*. In Prototype JS is er een `Template` klasse [aanwezig](http:*www.prototypejs.org/api/template), in Groovy zit een uitgebreide en uitbreidbare [template engine](http:*groovy.codehaus.org/Groovy+Templates):

^ Javascript ^ Groovy ^
| ```javascriptvar myTemplate = new Template('The TV show #{title} was created by #{author}.');
var show = {title: 'The Simpsons', author: 'Matt Groening', network: 'FOX' };
myTemplate.evaluate(show);``` | ```javadef string = "The TV Show ${title} was created by ${author}."
def myTemplate = new groovy.text.SimpleTemplateEngine().createTemplate(string)
def show = [ title: "The Simpsons", author: "Matt Groening", network: "FOX" ]
myTemplate.make(show).toString()
``` |

############= Evaluatie van expressies ############=

^ Javascript ^ Groovy ^
|```javascriptvar y = 20;
var X = function() {
  this.y = 10;
  this.boem = function() {
    console.log(eval("10 * this.y")); // 100, without "this" = 200 (window scope)
  }
}
new X().boem()``` | ```javaclass X {
  def y = 20
  def boem = {
    def y = 10 
    println Eval.x(y, "10 * y") // 100
  }
}
new X().boem()``` |

Groovy voorziet gemakkelijkheidshalve een paar methods op `Eval` zoals `Eval.me` (zonder params), x/xy/xyz. Wanneer iets uitgebreidere evaluatie nodig is gebruiken we `GroovyShell`:

```java
def binding = new Binding(x: 10, y: 100)
def shell = new GroovyShell(binding)
def retVal = shell.evaluate('''
  def local = "uncatchable"
  catchable = x * y
  10
''')
assert retVal ###### 10
assert binding.catchable ###### 100 // method 1
assert binding.getVariable("catchable") ###### 100 // method 2
```

Alles wat geëvalueerd wordt zit binnen een `Script` klasse, daarom dat het `def` keyword niet nodig is, en enkel dient om lokale variabele te instantiëren. Merk op dat het zelfs zo mogelijk is om nieuwe klassen in te laden, of om Groovy code te evalueren met `GroovyShell` binnen Java klassen! 

############= Scope chain aanpassen ############=

Dit is voor beide talen niet 100% hetzelfde: Groovy maakt het mogelijk om objecten te extenden on-the-fly met `use`, terwijl Javascript de lexicale scope chain kan aanpassen met `with`.

^ Javascript ^ Groovy ^
|```javascriptwith(window.screen) {
  console.log(width);
}``` | ```javadir = new File("/tmp")
use(ClassWithEachDirMethod.class) {
  dir.eachDir {
    println it
  }
}
``` |
