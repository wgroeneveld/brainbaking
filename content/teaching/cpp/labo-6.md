---
title: 'Labo 6: C++ Class Inheritance, operators en templates'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## C++ Classes revisited

Nu je een [basis van klassen](/teaching/cpp/labo-5) hebt opgedaan in C++ gaan we erving introduceren. Gegeven de volgende modellen:

{{<mermaid>}}
graph TD;
  A[Dier]
  B[Viervoeter]
  C[Hond]
  D[Kat]
  E[Vlinder]
  F[Vlees]
  G[Groenten]
  H[Voedsel]
  B --> A
  C --> B
  D --> B
  E --> A
  F --> H
  G --> H
{{< /mermaid >}}

Gegeven de volgende acceptatie criteria:

1. Elk dier kan een aantal centimeter *bewegen*. 
  * Bij viervoeten hangt dit van de snelheid van het dier af in combinatie met het aantal poten. 
  * Een kat beweegt sneller dan een hond maar is na 2x moe. 
  * Een vlinder beweegt liniair met de grootte van zijn vleugels. 
2. Elk dier eet **voedsel**. 
  * Een hond eet alles.
  * Een kat eet enkel vlees.
  * Een vlinder eet enkel groenten.

Een voorbeeldimplementatie in Java zou dit kunnen zijn:

```Java
public abstract class Voedsel { }
public class Vlees extends Voedsel { }
public class Groenten extends Voedsel { }

public abstract class Dier {
    public abstract boolean kanEten(Voedsel voedsel);
    public abstract int beweeg();
}
public abstract class Viervoeter extends Dier {
    protected int aantalPoten = 4;
}
public class Hond extends Viervoeter {
    @Override
    public boolean kanEten(Voedsel voedsel) {
        return true;
    }
    @Override
    public int beweeg() {
        return 10 * aantalPoten;
    }
}
public class Kat extends Viervoeter {
    private int aantalKeerBewogen; 
    @Override
    public boolean kanEten(Voedsel voedsel) {
        return voedsel instanceof Vlees;
    }
    @Override
    public int beweeg() {
        aantalKeerBewogen++;
        int velocity = aantalKeerBewogen >= 2 ? 5 : 15;
        return velocity * aantalPoten;
    }
}
public class Vlinder extends Dier {
    private int vleugelGrootte = 4;
    @Override
    public boolean kanEten(Voedsel voedsel) {
        return voedsel instanceof Groenten;
    }
    @Override
    public int beweeg() {
        return 2 * vleugelGrootte;
    }
}
```

De noties van `abstract`, de `@Override` annotatie en access modifiers bestaan natuurlijk ook in C++ - zie hoofdstuk 15. Bovenstaande Java code omgezet naar C++:

```C
class Voedsel {
    virtual int voedingswaarde() = 0;
};
class Vlees : public Voedsel {
    int voedingswaarde() override { return 10; }
};
class Groenten : public Voedsel {
    int voedingswaarde() override { return 15; }
};

class Dier {
public:
    virtual bool kanEten(const Voedsel& voedsel) = 0;
    virtual int beweeg() = 0;
};
class Viervoeter : public Dier {
protected:
    int aantalPoten;

public:
    Viervoeter() : aantalPoten(4) {}
};
class Hond : public Viervoeter {
public:
    int beweeg() override {
        return 10 * aantalPoten;
    }
    bool kanEten(const Voedsel &voedsel) override {
        return true;
    }
};
class Kat : Viervoeter {
private:
    int aantalKeerBewogen;
public:
    bool kanEten(const Voedsel &voedsel) override {
        return typeid(voedsel) == typeid(Vlees);
    }

    int beweeg() override {
        aantalKeerBewogen++;
        int velocity = aantalKeerBewogen >= 2 ? 5 : 15;
        return velocity * aantalPoten;
    }
};
class Vlinder : Dier {
private:
    int vleugelGrootte;
public:
    Vlinder() : vleugelGrootte(4) {}

private:
    bool kanEten(const Voedsel &voedsel) override {
        return typeid(voedsel) == typeid(Groenten);
    }

    int beweeg() override {
        return 2 * vleugelGrootte;
    }
};
```

`typeid()` leeft in de `<typeinfo>` header. [Een alternatief](https://en.wikipedia.org/wiki/Run-time_type_information) is dynamische pointers casten (zie onder). Voor de rest zijn de grootste verschillen - buiten de syntax:

* C++11's `override` na een methode wordt ook door de compiler gebruikt om te controleren of wat je override wel een virtuele methode is. In Java is `@Override` enkel ter documentatie.
* `abstract` op een klasse bestaat niet. Daarvoor moet je een "pure virtuele methode" (`= 0`) aanmaken. 
* Access modifiers bij een te overerven klasse beslissen of de methodes van die superklasse publiek zijn of niet. Dit bestaat niet in Java.
* Methodes die je overschrijfbaar wil maken moet je prefixen met `virtual`. In Java zijn alle methodes virtual. 

Als je de access modifiers in de klasse definitie vergeet wordt `private` aangehouden. Voor een struct is dit standaard `public`.

Wat is de output van het volgende programma?

```C
int main() {
    Groenten g; // vergeet niet dat dit in Java null zou zijn.
    Vlees v;
    Kat k;

    std::cout << "kan een kat groenten eten? " << k.kanEten(g);
    std::cout << "kan een kat vlees eten? " << k.kanEten(v);
}
```

En wat is de output van `Dier d;`? Juist: error: variable type 'Dier' is an abstract class.

### Extra Flexibiliteit

* Gebruik `final` als suffix als een subklasse deze virtuele methode niet meer mag overschrijven. Kan op klasse of methode niveau. 
* Gebruik de `::` operator als je toch een virtual base methode wil aanspreken die reeds overschreven is: `kat.Dier::iets()` waarbij iets zowel op Kat als op Dier gedefiniëerd is.
* Gebruik `friend` als prefix om een klasse instantie toegang te geven tot private fields van de andere. Kan op klasse of methode niveau. Zie [InternalsVisibleTo](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.compilerservices.internalsvisibletoattribute?view=netframework-4.7.2) C# AssemblyInfo.
* Gebruik `using Base::member` als prefix om bepaalde members toch public access te geven als alles als private gedeclareerd is. 

De method shadowing regels volgen ongeveer dezelfde als die van Java: een non-virtual functie met dezelfde naam en argumenten kan een functie hiden van een superklasse. 

#### Extra (ongewenste) flexibiliteit: static VS dynamic binding

Kijk eens goed naar het volgende voorbeeld:

```C
class A {
public:
    virtual int a() { return 3; }
};
class B : public A {
public:
    int a() { return 5; }
};

int main() {
    A b = B();
    std::cout << b.a() << std::endl;
}
```

Wat is de output? 3, en niet 5, ook al is het type van b een instantie van klasse B. Huh? Calls naar virtuele functies _kunnen_ at run-time resolved worden, maar dat "hoeft" niet (zie p.604). De enige uitzondering hier is het gebruik van pointers: met `A* b = new B();` geeft `b->a()` wél 5 terug.

`typeid(b).name()` blijft "1A" teruggeven omdat de variabele als type A gedeclareerd is. 

#### Upcasten en downcasten

C++ voorziet een hele resem aan cast methodes die in het licht van klassen en subklassen nodig kunnen zijn:

1. `dynamic_cast<T>(t)`: downcaster in gebruik. Geeft `nullptr` terug indien niet gelukt. Dit is Java's aangenomen `instanceof` manier. 
2. `static_cast<T>(t)`: impliciete conversie ongedaan maken (zie elders). Als je bijvoorbeeld weet dat een `void*` eigenlijk een `Punt*` is.Dit kan fouten at compiletime geven.
3. `reinterpret_cast<T>(t)`: pointer conversies in lijn van C. Dit kan fouten at runtime geven. 
4. `const_cast<T>(t)`: verwijdert of voegt `const` speficier toe. 

De C-style cast `(Punt*) pt` wordt aanzien als bad practice in de C++ wereld.

## Operatoren en klassen mixen

C++ biedt zoals verwacht zelfs op operator niveau flexibiliteit: je kan je eigen operatoren implementeren in klassen (p.552). Op die manier kan je bijvoorbeeld twee 2D punten met elkaar optellen: `punt1 + punt2`. In Java zal je een methode moeten maken: `punt1.plus(punt2)` dat een nieuw punt teruggeeft. 

Alle mogelijke operatoren kunnen overloaded worden, behalve `::`, `.*`, `.` en `?:`. Dit brengt ook potentiële problemen met zich mee! Stel je voor dat `->` overloaded is en je klasse zich heel anders gedraagt dan een standaard pointer reference. With great power comes great responsibility... 

Een voorbeeld:

```C
class Punt {
  private:
    int x, y;
  public:
    Punt(int theX, int theY) : x(theX), y(theY) {}
    Punt operator +(const Punt& other) {
      return Punt(x + other.x, y + other.y);
    }
    friend ostream& operator<<(ostream& os, Punt& punt);
}
ostream& operator<<(ostream& os, Punt& punt) {
  os << "(" << punt.x << "," << punt.y << ")";
  return os;
}

int main() {
  Punt a(1, 2);
  Punt b(3, 4);

  std::cout << a + b << endl; // print (4,6)
}
```

Operators kan je ook rechtstreeks aanroepen met `punt.operator+(other)`. Ze zijn niet verplicht om member te zijn van de klasse zelf maar ik zie geen reden om dingen die samen te horen niet samen te zetten. Een duidelijke uitzondering zijn IO operators! (p.557)

Andere veelgebruikte operatoren:

* `<<` als `toString()` in Java naar stdout.
* `==` als `equals()` in Java. Vergeet niet `!=` ook te implementeren dan!
* `=` als in-assignment om `{ }` te gebruiken. 
* `[]` als lijst-accessor.

### Conversion operators

Een conversie tussen twee types gebeurt impliciet als de compiler een match kan vinden. Je kan de compiler een handje helpen door er zelf in je klasse bij te definiëren: `operator int()` (zonder return type). Vanaf dan compileert `Punt p; p + 5;` in combinatie met de plus operator! 

Impliciete conversies zijn niet altijd wenselijk, daarvoor dient de prefix `explicit` (ook toepasbaar op constructoren). Expliciete conversies doe je zelf met `static_cast<int>(p)` - gegeven dat de operator geïmplementeerd is natuurlijk.

## Templating: "generics"

Herinner je de STL `vector` klasse. Deze collectie kan integers opslaan, of Punt instances, door tussen `<>` een type mee te geven: `vector<Punt> punten;`. Er is een template voor gedefiniëerd. Stel dat ik de punt klasse wens uit te breiden met de mogelijkheid niet alleen integers maar ook doubles als coordinaten te gebruiken:

```C
template<typename T> class Punt {
  private:
   T x, y;
  public:
   Punt(T theX, T theY) : x(theX), y(theY) {}
};
Punt<double> pt(1.2, 3.4);
Punt<int> pt2(3, 5);
```

Templates kunnen ook op functie niveau gedefiniëerd worden, als losstaande functie en als deel van een klasse genaamd member templates. (p.672)

#### Hercompilatie van templates 

De C++ compiler maakt voor elk template argument in je code (hier `double` en `int`) een aparte versie van de `Punt` klasse. In Java wordt dat weggecompileerd en dienen generics enkel als syntaxtisch hulpmiddel. Dit heeft wel als negatief gevolg dat de binary erg groot kan worden als die vol zit met duplicate versies van `Punt`!

Er zijn mogelijkheden tot compiler- en objectoptimalisatie met het keyword `extern`. Aanschouw het volgende schema met bijhorende code:

```C
// header.h
#ifndef _header_h
#define _header_h
template<typename T> T punt(T t) {
    return t;
}
#endif
// source1.cpp 
#include "header.h"
void punt1() {
  auto pt = punt<int>(5);  // template<int> compiled
}
// source2.cpp
#include "header.h"
void punt2() {
  auto pt = punt<int>(4);  // template<int> compiled - opnieuw!!
}
```

{{<mermaid>}}
graph TD;
  subgraph source code
    H[header.h<br/> template definitie van Punt]
    A[source1.cpp<br/> gebruik Punt van int]
    B[source2.cp<br/> gebruik Punt van int]
    A --> H
    B --> H
  end
  subgraph object output
    O[source1.o<br/> compilatie Punt van int]
    P[source1.o<br/> compilatie Punt van int]
  end
{{< /mermaid >}}

Als we een source file compileren én proberen te linken vinden we geen `main()` functie:

<pre>
Wouters-MacBook-Air:cmake-build-debug jefklak$ g++ -std=c++11 source1.cpp
Undefined symbols for architecture x86_64:
  "_main", referenced from:
     implicit entry/start for main executable
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
</pre>

Vergeet de `-c` optie dus niet. Door de symbol table van de machine code van source1.o te inspecteren krijgen we inzicht in de zonet gecompileerde bytes. Op Unix kan dit met `nm`:

<pre>
  Wouters-MacBook-Air:cmake-build-debug jefklak$ nm source1.o | c++filt
0000000000000070 short EH_frame0
0000000000000020 S int punt<int>(int)
00000000000000b0 S int punt<int>(int) (.eh)
0000000000000000 T punt1()
0000000000000088 S punt1() (.eh)
</pre>

Je ziet op adres `00000000000000b0` de nieuwe functie die als `<int>` gecompileerd is. Dit zit dubbel en ook in source2.cpp! Dit lossen we op door in één van de twee cpp bestanden `extern template int punt(int x);` toe te voegen zodat de compiler dit niet opnieuw behandelt:

<pre>
Wouters-MacBook-Air:cmake-build-debug jefklak$ nm source1.o | c++filt
0000000000000040 short EH_frame0
                 U int punt<int>(int)
0000000000000000 T punt1()
0000000000000058 S punt1() (.eh)
</pre>

De `U` duidt aan dat dit een onbekende functie is die naderhand (hopelijk) gelinkt zal worden en binnen een ander object leeft. [Lees meer](http://nickdesaulniers.github.io/blog/2016/08/13/object-files-and-symbols/) over interessante object files en symbolen. In de praktijk geldt dit ook voor STL klassen als `vector<int>`: externals worden meestal in een gedeelde header file geplaatst. 

Omdat een `Punt<double>` dus een andere klasse is dan een `Punt<int>` zijn ze niet compatibel met elkaar: het zijn twee unieke klassen. Dit is het grootste verschil tussen Templates in C++ en Generics in Java. De notatie `<T extends BaseClass>` is hierdoor niet nodig (maar kan wel met [`enable_if`](https://en.cppreference.com/w/cpp/types/enable_if)).

#### Herdeclaratie van templates

De constructor - of eender welke methode met `T` buiten de klasse template definiëren betekent dat we de template notatie zullen moeten herhalen want de compiler weet dan niet meer wat die `T` precies is:

```C
// in punt.h
template<typename T> class Punt {
  Punt(T theX, T theY);
}
// in punt.cpp
template<typename T> Punt<T>::Punt(T theX, T theY) : x(theX), y(theY) {
}
```

#### Type en non-type arguments

`typename` staat voor "dit is type T" en kan eender welk type zijn. Een constante expressie zoals `5` of een string `"hallo"` aanvaarden gaat zo ook: dat zijn immers ook types. 

Constante expressies met `unsigned` in de template definitie kunnen pointers, value references of integrale types zijn. In ons voorbeeld is het niet aangewezen om dit toe te passen: `Punt<3, 4> pt;` slaat enkel op iets als dit punt nooit kan muteren. 

#### Herhaling vermijden met typedef

Kan op twee manieren:

1. `typedef Punt<int> iPunt;`: `iPunt p;`
2. `template<typename T> using pt = Punt<T>;`: `pt<int> p;`

Waarbij optie twee meestal gebruikt wordt om verschillende template types te linken: nu heeft dit niet bijzonder veel nut. `typedef` kan niet refereren naar een template type.

#### Template default arguments

Als ik een template type wil van een klasse aangeven, maar dit in 80% van de gevallen een `int` gaat zijn kan ik deze defaulten:

```C
template<typename T = int> class Punt;
Punt<> pt;  // <> nog steeds verplicht. 
```

Zonder `<>` krijg je "error: use of class template 'Punt' requires template arguments".

Voor functies probeert de compiler automatisch het type te deduceren gebaseerd op het meegegeven argument (p.678). Dat wil zeggen dat we het type niet moeten meegeven en ook niet hoeven te defaulten:

```C
template<typename T> T puntFn(T t) {
    return t;
}
int pt = puntFn<int>(5);  // geldig
int pt = puntFn(5);       // ook geldig!
auto pt = puntFn(5);      // ook geldig!
```

#### Template variable arguments: packs

Wat nu als je verschillende argumenten nodig hebt die allemaal verschillende types hebben, waarvan je het type niet op voorhand weet? De altijd-aanwezige flexibiliteit in C++ lost dit probleem even voor je op met _variadic templates_:

```C
template <typename... Ts> void som(Ts... args) {}
```

Dankzij compiler deductie hoeven we niet alle templates aan te vullen als we hey aanroepen: `som(1, 2.0, true);` zou hetzelfde zijn als `som<int, double, bool>(1, 2.0, true);`. Om dit voorbeld te laten werken hebben we echter **recursie** nodig: een functie voor een basisgeval, en een functie voor de rest. Daarom heet dit "packing" en is `...` het unpacken van de template arguments.

```C
template<typename T> T som(T t) { return t; }
template<typename T, typename... TRest> T som(T first, TRest... args) {
  return first + som(args...);
}
auto result = som(1, 2.0, 3);
```

Zie [docs](https://en.cppreference.com/w/cpp/language/parameter_pack).

## Labo oefeningen
<a name="oef"></a>

1. Implementeer de volgende business criteria. Werk eerst een snel model uit op papier. Elke schuin gedrukte term verwacht ik terug te zien als een klasse of methode:
  1. Een _vacature_ bevat een onderwerp, een lijst van vereisten in de vorm van _diploma's_. 
  2. Een _sollicitant_ heeft een naam en ook _diploma's_: een _universitair_ heeft een bepaald diploma en een _doctor_ een andere. 
  3. Een sollicitant kan _solliciteren_ op een bepaalde vacature. Hij komt in aanmerking of niet (`bool` is OK), gebaseerd op de matchende diploma's. 
  4. We hebben een manier nodig om het _aantal sollicitanten_ van een vacature op te vragen (naar `stdout`). 
  5. We hebben een manier nodig om voor elke sollicitant snel zijn gegevens (naam en aantal diploma's) af te drukken. 
2. Breid de `Punt` klasse uit met de volgende vereisten:
  1. Er kunnen 2D of 3D punten bestaan
  2. De punten kunnen gehele of rationale getallen bevatten. 
  3. Ik kan punten converteren van 2D naar 3D of omgekeerd (met verlies)
  4. Ik kan punten met elkaar optellen.
3. _Extra_: Denk terug aan je dierentuin van [labo 5](/teaching/cpp/labo-5). Dieren moeten gevoed worden met de `bool voeder(const Voedsel &voedsel)` methode op dierentuin. De functie geeft `TRUE` terug indien het voedsel voldoende is voor alle dieren en `FALSE` indien het onvoldoende is. Voedsel heeft een `voedingswaarde`. Elk dier eet even veel in voedingswaarde als zijn gewicht. Verzin voedsel **subklassen** om alle edge cases te kunnen testen!
4. _Extra_: Dieren zijn carnivoren, herbivoren of omnivoren. Voedsel is ofwel plant- ofwel vleesgebaseerd. Wat doe je als je een carnivoor sla geeft, of een herbivoor een stukje kip? Hoe implementeer je deze specificaties?
5. _Extra_: Dieren zijn allergisch aan bepaald voedsel. Wat doe je als je een dier eten geeft dat het niet verdraagd? Wat doe je in je `voeder()` implementatie? Voorzie een methode `bool isAllergischAan(const Voedsel &voedsel)` in je Dier klasse. 

Tips: denk aan het thema: subklassen, operators, templates.

## Denkvragen

1. Welke operatoren buiten `->` overload je best niet, en waarom? Geef een voorbeeld. 
2. Hoe kan je `Punt` uitbreiden tot X dimensies? 
3. Wat is het fundamentele verschil tussen Generics in Java en Templates in C++?
4. Wat is polymorfisme in je eigen woorden? Hoe pas je dit toe in C++? 