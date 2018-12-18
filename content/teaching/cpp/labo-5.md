---
title: 'Labo 5: Weg met C, Hallo C++'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## De ++ in C++

De introductie van C++ in 1985 geeft de ervaren C programmeur enkele extra mogelijkheden om zijn of haar code te structureren. C++ wordt nog steeds omschreven als een _"general purpose"_ low-level taal op [Wikipedia](https://en.wikipedia.org/wiki/C%2B%2B):

> C++ is a general-purpose programming language. It has imperative, object-oriented and generic programming features, while also providing facilities for low-level memory manipulation.

"Object-oriented" en "generic" zijn de sleutelwoorden hier. De C++ taal is geschreven als een extensie van C waarbij high-level features gebruikt kunnen worden om code te structureren. Kenners van Java voelen hun hier waarschijnlijk iets meer thuis (abstracts, classes, generics, grote STL bibliotheek, overloading) en dat verbaast niemand: de Java taal is sterk beïnvloed door C++.

### Dingen die opvallen: wel in C++(11), niet in C

Enkele belangrijke zaken die onmiddellijk opvallen:

- de aanwezigheid van `bool`
- los van `std::string` (bovenop `char`) en `std::wstring` (bovenop `wchar_t`), Extra Integral types:
  - `wchar_t`, `char16_t`, `char32_t` (voor Unicode)
- [Zelf te definiëren operaties](https://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B):
  - [scope resolutie](https://en.wikipedia.org/wiki/Scope_resolution_operator) `::` en namespaces
  - `<<`, `>>` streams
- `class` en alles wat daar mee te maken heeft
  - `new`, `delete` in plaats van `malloc()` en `free()`
- `nullptr` in plaats van `NULL`,
- [smart pointers](https://en.wikipedia.org/wiki/Smart_pointer#unique_ptr) voor auto garbage collection
- `auto` als _type inference_ zoals `var` in C#, `decltype` in plaats van `typeof`
- Exception handling

## Classes in C++

### Terug naar de is_oud opgave van [labo 1](/teaching/cpp/labo-1), maar dan in C++

Het is tijd om `malloc()` en `struct` achterwege te laten:

```C++
#include <iostream>

class Persoon {
private:
    int leeftijd;
public:
    Persoon(int leeftijd);
    bool isOud() const {
        std::cout << "checking leeftijd van persoon " << leeftijd << std::endl;
        return leeftijd > 60;
    }
    int getLeeftijd() const { return leeftijd; }
};

Persoon::Persoon(int leeftijd) {
    this->leeftijd = leeftijd;
}

int main() {
    auto jaak = new Persoon(70);
    std::cout << "is jaak oud? " << jaak->isOud() << std::endl;
}
```

Dat ziet er al heel wat properder uit:

- We hebben een constructor gebruikt om een persoon aan te maken met leeftijd, zoals we kennen vanuit Java. De `this` pointer verwijst naar de huidige instance van de klasse.
- We hebben methodes (inline) gedeclareerd in de klasse Persoon.
- Jaak aanmaken hoeft geen type definitie als `Persoon *` met C++11's `auto` keyword. Leer auto goed kennen en gebruiken: [overtuig jezelf](http://www.acodersjourney.com/2016/02/c-11-auto/)!

Type inference is in combinatie met top-level `const` en references niet zo triviaal, zie p.68.

### De Klasse structuur

Een klasse definiëren is niet meer dan een beschrijving van een structuur. Binnen de `class` accolades `{ }` leven niet alle declaraties van de functies in de klasse zelf! Dit is nog een erfenis van C. Elke klasse heeft zijn eigen scope en functies declareren doe je na de definitie met de scope operator `::`:

```C
class Getal {
  private:
   int getal;
  public:
   int get() const { return getal; }
   void telOpMet(int ander);
   void vermenigvuldigMet(int ander);
};

void Getal::telOpMet(int ander) {
  this->getal += ander;
}
void Getal::vermenigvuldigMet(int ander) {
  this->getal *= ander;
}
```

#### De locatie van klassen

Twee van de drie methodes staan buiten de klasse definitie. We maken hier typisch twee files voor aan:

1. getal.h waar de klasse definitie in leeft
2. getal.cpp waar de methode declaraties in leven

Verschillende andere source files kunnen de Getal klasse gebruiken met `#include "getal.h"`. De klasse kan maar 1x gedefiniëerd worden, en 2x de header includen in je programma geeft een compilatiefout:

<pre>
Wouters-MacBook-Air:c-course-gba wgroenev$ g++ -std=c++11 dubbel.cpp getal.o
In file included from dubbel.cpp:4:
./getal.h:1:7: error: redefinition of 'Getal'
class Getal {
      ^
./getal.h:1:7: note: previous definition is here
class Getal {
      ^
1 error generated.
</pre>

Dit lossen we op met een preprocessor constructie in de getal.h header file:

```C
#ifndef _GETAL_H_
#define _GETAL_H_

class Getal { };

#endif
```

#### Inline functies

Waarom is de eerste methode in de body gedeclareerd? Dit is een `inline` functie ([zie doc](https://isocpp.org/wiki/faq/Inline-Functions)). Dit zijn typisch one-liners die vaak aangeroepen worden en door de compiler geoptimaliseerd _kunnen_ worden: de aanroep instructie vervangen door de implementatie, zoals de preprocessor doet met `#define`.

Wanneer schrijven we een inline functie?

1. **Duidelijkheid**: Als de functie zeer klein is en die in de header file kan leven zodat gebruikers hiervan ondubbelzinnig kunnen zien wat dit doet.
2. **Optimalisatie** kàn ook.

#### In-class initialization

Sinds C++ 11 kan je ook default values meegeven aan data members in de definitie van de klasse zelf. Dit klinkt belachelijk omdat zoiets in Java vanaf het begin al kon. In de private sectie van de Getal klasse kunnen we dus `int getal = 5;` zetten. Als er geen constructor deze member initialiseert wordt getal op 5 gezet.

#### "this" en Constante functies

De magische `this` variabele wordt impliciet aangemaakt zodra je een methode van een instantie op een klasse uitvoert. This is het adres van de locatie van diezelfde instantie:

```C
auto g = new Getal();

g->telOpMet(5);
// compiler interpretatie: Getal::telOpMet(&g, 5);
```

Het `const` keyword achter de get methode verandert de `this` pointer naar een constante pointer. Op die manier kan de body van de methode geen wijzigingen doorvoeren, enkel opvragen. (Zie p. 258)

### (auto-generated) Constructoren

Een klasse instantiëren roept de (default) constructor aan. Als er geen eigen gedefiniëerde constructor aanwezig is, genereert de compiler die voor u, net als in Java. Zodra je één constructor definiëert, zal C++ geen enkele zelf genereren.

```C
class Getal {
  private:
    int *x;
  public:
   Getal(int x) : x(new int(x)) {}
};
auto g = new Getal(5);  // ok: eigen constructor aangeroepen
auto g = new Getal();   // error: Too few arguments, expects 1
```

De default constructor is makkelijk zelf te voorzien met `Getal() {}` maar met `Getal() = default;` zeggen we tegen de compiler dat hij expliciet wél eentje moet genereren.

Merk op dat we hier een _memory leak_ introduceren door `*x` niet zelf op te kuisen! Als een klasse _resources_ zoals pointers bevat is het de bedoeling dat deze zelf verantwoordelijk is voor de opkuis. Dit gebeurt in de destructor prefixed met `~`:

```C
class Getal {
  private:
    int *x;
  public:
   Getal() = default;
   ~Getal() { delete x; }
   Getal(int x) : x(new int(x)) {}
};
```

Java heeft geen destructors omdat objecten op de heap leven en door de Garbage Collector opgeruimd worden zonder invloed van de programmeur. Er is wel een `finalize` die je zelf kan aanroepen om resources op te kuisen. In C# wordt ook de `~Object(){}` notatie gebruikt, maar dat is ook een soort van finalizer en geen échte destructor.

Een derde soort constructor, de "copy constructor", wordt ook door C++ voorzien en aangeroepen wanneer de expressie `getal1 = getal2` geëvalueerd wordt. De compiler maakt een nieuwe `Getal` instance aan en kopiëert alle velden over.

Dit is echter helemaal niet wat we willen als we _resources_ als members hebben zoals `*x`: de pointer wordt gekopiëerd maar niet de inhoud. Beide getal instances verwijzen dan dezelfde `x` waarde:

Wat is de output van dit programma?

```C
int main() {
    auto g = new Getal(5);
    auto g2 = g;
    g2->x = new int(10);
    cout << *(g2->x) << endl;   // ?
    cout << *(g->x) << endl;    // ?
}
```

Oeps. Voorzie in dat geval je eigen copy constructor met `Getal(const Getal& other) : x(new int(*(other.x))) {}`. Copy constructors kan je ook defaulten.

### Methodes in Klassen en Reference types

Herinner je uit [labo 2](/teaching/cpp/labo-2) reference type definities zoals `int &getal`. Deze notatie ga je veel tegen komen in C++ methode argumenten. Objecten die meegegeven worden zijn bijna altijd reference types in plaats van pointers. Waarom legt de [C++ FAQ](https://isocpp.org/wiki/faq/references#refs-vs-ptrs) uit:

> Use references when you can, and pointers when you have to.
References are usually preferred over pointers whenever you don’t need “reseating”. This usually means that references are most useful in a class’s public interface. References typically appear on the skin of an object, and pointers on the inside.

Zo kunnen we in Getal methodes toevoegen die andere Getal instanties gebruiken:

```C
// getal.h
class Getal {
  void telOpMet(const Getal &ander);
}
// getal.cpp
void Getal::telOpMet(const Getal &ander) {
  this->getal += ander.getal;
}
// dubbel.cpp, in main
auto g = new Getal();
auto nieuwGetal = new Getal();
nieuwGetal->telOpMet(*g);
```

We moeten g _dereferencen_ om als reference mee te kunnen geven. `const` wordt hier gebruikt om zeker te zijn dat het binnenkomende getal niet gewijzigd kan worden. Alternatief kunnen we `new` twee keer weglaten: `auto g = Getal();` en dan `nieuwGetal.telOpMet(g);`.

### Wanneer gebruik ik "new" en wanneer niet?

Een pointer naar een object in het geheugen aanmaken (en geheugen reserveren) met `new` vereist dat je die *zelf opkuist* met `delete`! Als je dit niet doet blijft dat geheugen bezet en krijg je wat men noemt "memory leaks": hoe langer men je programma gebruikt, hoe meer geheugen het (ongewenst) in beslag neemt.

Om dat te vermijden gebruik je best binnen functies nooit `new`:

```C
void telOpAutoClean() {
  auto g = Getal(3);
  g.telOpMet(5);
  // block eindigt: g wordt opgekuist
}
void telOpManualClean() {
  auto g = new Getal(5);
  g->telOpMet(5);
  // block eindigt: g blijft bestaan!
  delete g;
}
```

`Getal(3)` zonder new ziet er vreemd uit als je talen als C# en Java gewoon bent, maar de constructor wordt evenzeer aangeroepen en een object wordt evenzeer voor je geïnstantieerd.

#### De Stack

Lokale variabelen worden op de **stack** bewaard. De stack bevat een tijdelijke workspace aan geheugen wanneer functies aangeroepen worden, die automatisch opgeruimd worden als die functies klaar zijn met hun werk. De Stack is een LIFO lijst.

#### De Heap

De heap is geheugen dat opzij gezet wordt voor dynamische allocatie. Zodra je een pointer aanmaakt komt dit op de heap terecht en ben je zelf verantwoordelijk voor het opruimen hiervan. In Java zijn instance variabelen en objecten deel van de heap, in C++ is dat wat complexer.

{{<mermaid>}}
graph TD;
    subgraph De Stack
      D[Getal ptr_getal = new Getal]
      C[Getal getal = Getal]
      A[int main]
      B[void telOp]
      B --> A
      C --> B
      D --> B
    end
    subgraph De Heap
      E[Getal geheugen]
      D -.-> E
    end
{{< /mermaid >}}

Het adres in `ptr_getal` leeft op de stack binnen de `telOp()` methode, maar het geheugen waar het naar verwijst leeft op de heap. Het adres verdwijnt als alles van telOp weggegooid wordt in de stack - maar het getal geheugen blijft bestaan totdat iemand met `delete` de opkuis doet.

De dotted pijl van ptr_getal naar getal in de heap verdwijnt en is nooit meer toegankelijk: dit noemt men "_leaking_". Moderne C++ programma's maken zelden gebruik van "raw pointers" (`*`) en laten de compiler en het OS beslissen of zaken op de stack of de heap moeten komen.

#### Smart pointers in C++ 11

In plaats van zelf geheugen te managen - we hebben immers wel wat beters te doen - laten we dat over aan de taal door "smart pointers" te gebruiken. Dit zijn STL wrappers (zie onder) die een object encapsuleren. Als een block stopt, kuist deze smart variabele je wrapped object zelf ook op:

```C
unique_ptr<Getal> g (new Getal());                // zonder auto
auto nieuwGetal = unique_ptr<Getal>(new Getal()); // met auto
nieuwGetal->telOpMet(*g);
```

We komen later nog op de template `<>` notatie terug. Neem hier aan dat dit werkt als Generics in Java.

Zie p.470 of [Smart pointers in modern C++](https://docs.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp).

Vergeet niet dat smart pointers niet werken in combinatie met variabelen op de stack (dus altijd `new` gebruiken). Stel dat een klasse een referentie naar een `unique_ptr` heeft die automatisch de pointer zou moeten opkuisen:

```C
class Holder {
  public:
   unique_ptr<Iets> autoDeleted;
   Holder() {
    Iets iets("1");
    this->autoDeleted = unique_ptr<Iets>(&iets);
   }
}
```

De deconstrutor van de holder gaat automatisch de waarde die autoDeleted vasthoudt terug vrijgeven, maar de variabele `iets` bestaat al niet meer omdat die enkel op de stack binnen de constructor functie leeft. `&iets` verwijst nu naar "niks" en dit crasht.

## De C++ Standard Library

Merk op dat in bovenstaande Persoon klasse `printf()` verdwenen is. In C++ gebruiken we streams: `cout` als `stdout` en `cin` als `stdin`. Deze leven in de `std` namespace zodra je `iostream` include. Laat de ".h" suffix achterwege bij het includen van systeembibliotheken van C++. Laat het maar aan de compiler over om de systeembestanden te zoeken tijdens het linken.

De Standard Template Library [STL](https://en.wikipedia.org/wiki/Standard_Template_Library) is een bibliotheek die meegeleverd wordt bij de meeste moderne C++ compilers waar `iostream` in leeft. Deze implementeert de nieuwe standaarden, zoals C++11. Compilers vragen soms wel een flag om te kiezen met welke library er gelinkt wordt: `g++ -std=c++11`.

STL bevat een hoop dingen die je het leven makkelijker maakt: strings (gek genoeg nog steeds geen deel van de taal zelf), collecties, streams, IO, ... Bekijk het als de .NET library voor de C# taal of de meegebakken `java.*` klassen en methodes voor Java. "Part II: The C++ Library (p. 307)" behandelt deze zaken in het handboek.

In plaats van constant `std::cout` te moeten typen kunnen we alles wat in die namespace zit ook "importeren" zoals een Java `import java.io.*` met `using namespace std;`. `cout` is een instantie van de klasse `ostream`.

## Initialisatie van objecten

In C++ kan je op twee manieren aan objecten een waarde toekennen (Zie p.43). Het is belangrijk om de verschillende nuances te kunnen onderscheiden omdat met objecten verschillende constructoren gemoeid zijn.

#### Direct initialization

`int x(5)` of `Getal g(5)`

Hiervoor is een **constructor** (met argument) nodig.

Waarom zou je `()` doen in plaats van `=`? Omdat impliciete conversie enkel via direct initialization gebeurt. Stel, ik wil een string in de constructor aanvaarden. Strings met quotes in C++ zijn nog steeds char arrays vanuit C. Dit gaat niet:

```C
// C++
class Groet {
public:
  Groet(std::string s) {}
  void zegIets() {};
};
Groet heykes = "sup";  // error: no conversion from const char[3] to Groet
Groet heykes("sup"):   // ok: impliciete conversie
Groet hekyes = "sup"s; // ok: char[] zelf omgezet, zie strings sectie
Groet heykes;          // ok: heykes is nieuw leeg Groet object op stack
heykes.zegIets();      // ok
```

Vergeet niet dat het verschil tussen C++ en Java op gebied van initialisatie groot is! In Java zijn objecten na hun declaratie altijd `null`:

```Java
// Java
class Groet {
  public Groet(String s) {}
  public void zegIets() {}
}
Groet heykes("sup");  // error: impliciete conversie gaat nooit lukken
Groet heykes;         // ok: heykes verwijst naar null
heykes.zegIets();     // error: NullPointerException
heykes = new Groet(); // ok: object op heap aangemaakt
heykes.zegIets();     // ok
```

#### Copy initialization

`int x = 5` of `Getal g = Getal(5)` of `int x = { 5 }`

Hiervoor is een **copy constructor** nodig.

Merk op dat gebruik van accolades `{ }` eigenlijk copy initialisatie doorvoert, evenals single return statements als `return 3 + 4`. Dit kan je omzetten naar direct initialization met `int retval(3 + 4); return retval;`.

Constructors en copy constructors hoeven niet zelf aangemaakt te worden: C++ voorziet defaults. Een lege constructor maakt een leeg object aan. Een lege copy constructor voert eenm ember-wise (shallow) copy door. Als je die toch wil maken doe je dat zo:

```C
class Punt {
  private:
   int x, y;
  public:
   Punt() : x(1), y(1) { }                              // default
   Punt(const Punt& other) : x(other.x), y(other.y) { } // copy
}
```

## Strings

``std::string`` in `#include <string>` is de vervanger van de rudimentaire `char*` in C++. Met strings kan je zoals in Java dingen doen als:

* Grootte opvragen met `.size()` of `.empty()`
* Concatenaties doorvoeren met de `+` operator
* Karakters opvragen met `[]`
* Vergelijkingen uitvoeren met `<(=)`, `>(=)`

De grootte van een strings is niet een `int` maar een `std::size_type` "companion type" om STL op eender welke machine op dezelfde manier te kunnen gebruiken (p.88). Dat is een van de nadelen van C(++) doordat we voor een specifiek systeem compileren.

### Karakters individueel behandelen

Gebruik de C++ 11 _range for_ notatie die we van C# en Java kennen:

```C
auto str = string("sup");
for(auto c : str) {
  cout << c;
}
```

Als c een reference is kan je in de loop zelf de karakters ook wijzigen.

## Collecties: Vector

In plaats van met vaste array waardes te werken kunnen we ook lijsten gebruiken. STL voorziet er een aantal, waarvan `vector` de belangrijkste is - Java's `ArrayList` tegenhanger. Vanaf C++ 11 kan je die ook snel initialiseren met copy initialization:

```C
vector<string> tekst = { "roe", "koe", "zei", "de", "duif" }; // lijst van 5 strings
vector<string> leeg;        // lege lijst van strings, grootte 9
tekst = leeg;               // copy constructor gebruikt; tekst is nu ook leeg
tekst[0] = "nul";           // segmentation fault: tekst heeft size 0
tekst = vector<string>(1);  // lege lijst van strings, grootte 1
tekst[0] = "nul";           // ok
```

p.98 of [cppdocs](https://en.cppreference.com/w/cpp/container/vector) bevat basis manipulaties voor vectoren, zoals:

* elementen toevoegen met `push_back()`
* loopen over elementen met `for(auto i : v)`
* grootte controleren met `size()` en `empty()` zoals `std::string`
* correct gebruik van iterators `begin()` en `end()`

## <a name="oef"></a>Labo oefeningen

1. [bibliothecaris labo 2 redux](/teaching/cpp/labo-2/#oef): herimplementeer de bibliothecaris oefening in C++. Let op de verplichte aanwezigheid van:
  * een klasse `Bibliotheek` die een lijst van boeken (als simpele string) bevat
  * een klasse `Bibliothecaris` die de operaties op de bibliotheek uitvoert
  * `cin >> var` om de boeken van de gebruiker in te lezen.
  * sorteerfuncties van STL
2. [Orc labo 1 redux](/teaching/cpp/labo-1/#oef): herimplementeer het Orc model in een C++ klasse (opgave 2 en 3). Let op met memory leaks als orcs dood gaan! Hoe ziet de oude C functie `Orc vecht(Orc aanvaller, Orc verdediger)` er nu uit?
3. _Extra_: maak een `Dierentuin` klasse. Een dierentuin kan verschillende _dieren_ (`Dier` klasse) ontvangen (`ontvang()` functie). Elk dier heeft een grootte en een naam: Neushoorn(40), Giraf(25), Poema(10). Elke dierentuin heeft x beschikbare ruimte. Wat doet het bestuur van je dierentuin als het te ontvangen dier te groot is? <br/>Bijvoorbeeld: dierentuin(20), leeuw(15) en panda(10). 15 + 10 > 20.
4. _Extra_: We starten met een taxi bedrijf dat chauffeurs in dienst neemt en wagens koopt om mee rond te rijden. Welke klassen denk je nodig te gaan hebben, en waarom? Teken eerst een model en trek pijlen die relaties voorstellen. Voorzie ook het concept "klant", die kan vervoerd worden. Welke methodes ga je voorzien in je klassen?

Vergeet het volgende niet:

* [C++ Style Guide](https://google.github.io/styleguide/cppguide.html) te volgen en gebruik _camelCasing_ voor C++ in plaats van snake casing voor C!
* C++ online compileren kan op [rextester.com](http://rextester.com/l/cpp_online_compiler_clang).
* [C++ Style and Technique FAQ](http://www.stroustrup.com/bs_faq2.html)

## Denkvragen

1. Kan je je een situatie inbeelden waarin het gebruik van raw pointers in een methode van een klasse toch aangewezen is?
2. Wat is het fundamenteel verschil tussen een struct in C en een class in C++?
3. Wat betekent de foutboodschap "Segmentation fault" precies?
4. Wanneer wordt een copy constructor aangeroepen? Leg aan de hand daarvan het verschil tussen initialisatie en toekenning uit.
