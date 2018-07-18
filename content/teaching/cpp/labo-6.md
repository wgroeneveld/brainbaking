---
title: 'Labo 6: C++ Class Inheritance, operators en templates'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++ met Qt](/teaching/cpp)<br/>
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
    int voedingswaarde() override {        return 15;    }
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

`typeid()` leeft in de `<typeinfo>` header. [Een alternatief](https://en.wikipedia.org/wiki/Run-time_type_information) is dynamische pointers casten en kijken of het al dan niet `NULL` is. Voor de rest zijn de grootste verschillen - buiten de syntax:

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

Kijk eens goed naar het volgend voorbeeld:

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

## Labo oefeningen
<a name="oef"></a>

## Denkvragen
