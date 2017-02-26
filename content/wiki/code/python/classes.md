+++
title = "classes"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "python",
    "classes"
]
date = "2014-03-12"
+++
# Classes 

Handige links:

  * [special class methods like _ _getattr_ _ and _ _new_ _](http://www.diveintopython.net/object_oriented_framework/special_class_methods2.html)
  * [dive into python - native datatypes](http://www.diveintopython3.net/native-datatypes.html#tuples)
  * [Inside story on new style classes](http://python-history.blogspot.be/2010/06/inside-story-on-new-style-classes.html) - ter info: Python3 heeft **enkel** "newstyle" classes!

### Method overriding 

Is **niet mogelijk**. Gebruik default values!

```python
def func(i, j ###### 2, k  3):
    return i + j + k

func(1) # 6
func(1, 1) # 5
func(1, 1, 1) # 3
```

Wat wel gaat, evt met decorators, zie [Five-minute multimethods in Python](http://www.artima.com/weblogs/viewpost.jsp?thread=101605) - is `_ _call_ _` implementeren en dan met metaprogrammeren te loopen over alle methods en te kijken of de argumenten overeen komen met het type dat required is. Fancypancy! 

##### Opgelet met pitfalls 

**Nummer 1**: default variables worden herbruikt:

> When Python executes a “def” statement, it takes some ready-made pieces (including the compiled code for the function body and the current namespace), and creates a new function object. When it does this, it also evaluates the default values. [...] Another way to reset the defaults is to simply re-execute the same “def” statement. Python will then create a new binding to the code object, evaluate the defaults, and assign the function object to the same variable as before. But again, only do that if you know exactly what you’re doing.

Default als `arr ###### []` Gaat de array muteren. Heel handig voor memoization, heel verwarrend anders. Oplossing? `arr  None` en dan `arr ###### [] if arr  None`. 

Zie ook [Default parameter values in Python](http://effbot.org/zone/default-values.htm) voor in-depth uitleg.

**Nummer 2**: *Python’s nested scopes bind to variables, not object values*. 

```python
for i in range(10):
    def callback():
        print "clicked button", i
    UI.Button("button %s" % i, callback)
```

variabele `i` gaat altijd 9 zijn - wordt niet op value gebind. Oplossing is explicit binding door de functie definitie van `callback():` te veranderen naar `callback(i=i):`.

### Fields dynamisch definiëren 

`Thing(a######1, b2)` kan op een paar manieren gedefiniëerd worden.

##### fields expliciet declareren 

```python
class Thing:
   def __init__(self, a, b):
       self.a, self.b = a, b
```

##### dynamisch uw eigen dictionary updaten 

```python
class Thing:
   def __init__(self, **kwargs):
       self.__dict__.update(kwargs)
```

:exclamation: Dit is uiteraard heel gevaarlijk aangezien het al uw method bodies kan vervangen door een param value. BOEM. 

`* *name`(zonder spatie, wiki markup, nvdr) geeft alle argumenten in een [dict](http://docs.python.org/2/library/stdtypes.html#typesmapping) terug. `*name` gaat ook, geeft u een lijst van argumenten terug. Combinatie gaat ook, één ster moet voor de tweede komen. Zoiets is dus mogelijk: `def _ _init_ _(self, arg1, arg2, *allargs, * *allargsasdict)`.

##### Alles als een message passing systeem zien 

In Ruby is er een andere manier om `def name block end` te schrijven, hoe het geïnterpreteerd wordt: `self.class.send(:name, args) { block }`

```ruby
def opt_to_s opt={}
  opt.empty? ? '' : ' ' + opt.map {|e,v| "#{e}=<br/>"#{v}<br/>""}.join(', ')
end

[:html, :body, :h1].each do |el|
  start="<#{el}"
  fin="</#{el}>"
  self.class.send(:define_method, el) {|options={}, &blk| start + opt_to_s(options) + '>' + blk.call + fin}
end

# Now, we can neatly nest tags and content
html do
  body do
    h1 :class######>"bold-h1", :id>"h1_99" do
      "header"
    end
  end
end
 ######> "<body><h1 class<br/>"bold-h1<br/>", id=<br/>"h1_99<br/>">header</h1></body>"
```

Voilà, een DSL in no-time. Holy crap. [Bron: do you understand ruby's objects messages and blocks?](http://rubylearning.com/blog/2010/11/03/do-you-understand-rubys-objects-messages-and-blocks/)

### Superclassing 

Klassen aanmaken is niet al te moeilijk, maar een call uitvoeren naar de overridden method is iets minder evident: zie [super() in python docs](http://docs.python.org/2/library/functions.html#super)

Een voorbeeld van een custom http handler:

```python
class HttpHandler(SimpleHTTPRequestHandler):
	def readStatus(self):
		return {
			"Status": "blabla",
			"StartTime": ""
		}

	def do_GET(self):
		try:
			print('serving %s now' % self.path)
			if "status.json" in self.path:
				self.send_response(200)
				self.send_header('Content-type', 'text/json')
				self.end_headers()
				self.wfile.write(json.dumps(self.readStatus()).encode())
			else:
				SimpleHTTPRequestHandler.do_GET(self)

		except IOError:
			self.send_error(500, 'internal server error in server python source: %s' % self.path)

```

Wat is hier speciaal aan:

  * `super.do_GET(self)` => `SimpleHTTPRequestHandler.do_GET(self)`
  * eigen method aanroepen: `self.readStatus()` met de `self` prefix

#### Diamond inheritance 

`BaseClass.method()` is impliciet hetzelfde als `super().method()`, behalve dat je met `super` een argument kan meegeven, over welke superklasse het gaat. 

Zie ook [Things to know about Python's super()](http://www.artima.com/weblogs/viewpost.jsp?thread=236275)

### Closures en lambda's 

functies in functies aanmaken werkt perfect, "closed over" die lexicale scope, net zoals je zou verwachten zoals bijvoorbeeld in javascript:

```python
	def readBuildStatus(self):
		html = urllib.request.urlopen("http://bla/lastbuildstatus.htm").read().decode()
		def extractVersion():
			versionString = "Version: "
			versionIndex = html.find("Version: ")
			return html[versionIndex + len(versionString) : versionIndex + len(versionString) + len("YYYY.MM")]
		def extractStatus():
			return "Succeeded" if html.find("SUCCESS") != -1 else "Failed"
```

de twee andere methods lezen de `html` variabele uit. Hier hoef je geen `self.` prefix te gebruiken, binnen de `readBuildStatus()` functie zelf - hierbuiten zijn de closures verdwenen natuurlijk (out of scope).