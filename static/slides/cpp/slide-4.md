Software ontwerp in C/C++: #4
=============================

<img src="/img/kul.svg" style="height: 80px;" />
<img src="/img/uhasselt.svg" style="width: 165px; height: 80px;"/>

___

## Wat schaft de pot vandaag?

1. **Voorgerecht**: C++ Klassen, Templates, Inheritance, Operators, STL
2. **Hoofdschotel**: new, pointers, initialization, headers
3. **Nagerecht**: GUI Ontwerp in C++
4. **Dessert**: Dus wat was dat weer allemaal? 

---

# C++ Klassen

**!!** Slechts "enkele" zaken uitgelicht. <br/>
Meer **verplichte** kennis in [Syllabus](/teaching/cpp/) en in C++ Primer!

___

## Blueprint van een Java klasse

```Java
// student.java
public class Student {
    private int leeftijd;
    private String naam;

    public Student() { this.naam = ""; }
    public Student(int leeftijd, String naam) { 
        this.leeftijd = leeftijd;
        this.naam = naam;
    }

    public boolean isMeerderjarig() { return leeftijd >= 18; }
    public int getLeeftijd() { return leeftijd; }
    public String getNaam() { return naam; }
}
```

___

## Blueprint van een C++ klasse

```C
// student.h
#ifndef _STUDENT_H_     // <-- vergeet dit niet
#define _STUDENT_H_

class Student {
private:
    int leeftijd;
    std::string naam;
public:
    Student() : leeftijd(0), naam("") {}
    Student(int leeftijd, std::string naam) : leeftijd(leeftijd), naam(naam) {}

    int getLeeftijd() { return this.leeftijd; }
    std::string getNaam() { return this.naam; }
    bool isMeerderjarig();
};
#endif
// student.cpp
bool Student::isMeerderjarig() {
    return leeftijd >= 18;
}
```

___

### "Speciallekes":

* defines om multiple include miserie tegen te gaan
* Header/source files. _inline_ functies. 
* Plaatsing accessors, puntkomma na }
* Constructor initializatie member variabelen

...

### Nog meer "speciallekes":

* Copy constructors
* Operatoren

...

___

### Copy constructors

```C
class Student {
private:
    int leeftijd;
public:
    Student(int leeftijd) : leeftijd(leeftijd) {}
    Student(const Student& andere);
};
Student::Student(const Student& andere) {
    leeftijd = andere.leeftijd;
}
```


```C
Student jaak(20); 
Student lowie = jaak;
```

1. Wat als `Student(...)` niet voorzien is? 
2. Moet ik niet `new` gebruiken bij aanmaken van `jaak`?

___

### Operatoren


```C
class Student {
private:
    int leeftijd;
public:
    Student(int leeftijd) : leeftijd(leeftijd) {}
    friend bool operator>(const Student& student1, const Student& student2);
};
bool operator>(const Student& student1, const Student& student2) {
    return student1.leeftijd > student2.leeftijd;
}
```


```C
Student jaak(20), lowie(10); 
std::cout << "wie is ouder? " << jaak > lowie;
```

1. Wat als `operator>` niet voorzien is? 
2. Wat is die `const Student&` toch de hele tijd?

___

#### BFFs & forward definities

```C
// student.h
class Leerkracht;
class Student {
    friend class Leerkracht;
private:
    int punten;
public:
    void slijm(const Leerkracht& leerkracht) {  // const, zie onder
        punten = leerkracht.geefVeelPunten();
    }
}
// leerkracht.h
#include "student.h"
class Leerkracht {
private:
    int geefVeelPunten() const { return 20; }   // const nodig
public:
    void buis(const Student& student);
}
```

<img src="/img/teaching/bff.jpg" width="25%" />

---

## Templates

In Java: 

```Java
public abstract class Item {
    public abstract int getId();
}
public class Boek extends Item {
    public int getId() { return 1; }
}
public class Appel { }
public class Rugzak<T extends Item> {
    private List<T> items = new ArrayList<>();
    public void voegToe(T item) { items.add(item); }
}
```

Gebruik:

```Java
Rugzak<Boek> boekentas = new Rugzak<>();
boekentas.voegToe(new Boek());   // ok
boekentas.voegToe(new Appel());  // compilation error
```

"Generics" dus?

___

```C
class Item {
public:
    virtual int getId() = 0;
};
class Boek : public Item {
public:
    virtual int getId() { return 1; }
};
class Appel {};
template<typename T> class Rugzak {
private:
    std::vector<T const&> items;
public:
    void voegToe(const T& item);
};
template<typename T> void Rugzak<T>::voegToe(const T& item) {
    this->items->push_back(item);   // should use emplace_back
}
```

gebruik:

```C
Ruzak<Boek> boekentas;
Boek boek1;
Appel appel;
boekentas.voegToe(boek1);   // ok
boekentas.voegToe(appel);   // compilation error (parameter type mismatch)
```

Niet helemaal hetzelfde. 

___

### Grootste verschillen?

* `<? extends>` bestaat niet
* `Herhalen template<typename T>` in definities
* `g++` **kopieert** elke `<T>` implementatie opnieuw!

vb. [https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite_builder.h](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite_builder.h)

---

## STL

[http://www.cplusplus.com/reference/stl/](http://www.cplusplus.com/reference/stl/)

```C
#include <vector>   // <-- vergeet dit niet...
#include <string>

class Boeken {
private:
    std::vector<std::string> lijst;
public:
    void voegToe(std::string boek) {
        lijst.push_back(boek);
    }
    int getAantal() { return lijst.size(); }
};
```

of:

```C
using namespace std;
string sup = "yooo";
```

namespace include afgeraden in libraries!

___

#### Meer voorbeeldjes

* `std::cout << "hallo ik ben de c++ printf" << std::endl;`
* `std::shared_ptr<Student>(new Student());`
* `std::remove_if(vector.begin(), vector.end(), [](int &x) { return x > 10; }), vector.end())`
* `std::stringstream`
* ...

[https://github.com/wgroeneveld/gba-sprite-engine/blob/master/demos/demo3-foodthrowing/src/food_scene.cpp](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/demos/demo3-foodthrowing/src/food_scene.cpp)

---

## Object initialization

<img src="/img/teaching/trap.jpg" />

___

### Opletten geblazen:

```C
int getal(5);
int getal = 5;      // HUH?
```

**Direct** vs **Copy** initialization. Waarom? **Impliciete conversie**:

```C
class Groet {
public:
  Groet(std::string s) {}
};
Groet heykes = "sup";  // error: no conversion from const char[3] to Groet
Groet heykes("sup"):   // ok: direct constructor call
Groet hekyes = "sup"s; // ok: impliciete conversie string->Groet
Groet heykes;          // ok: heykes is nieuw leeg Groet object op stack
```

`x = y` gebruikt copy constructor voor zelfde type.

`"string"s` = conversie char[] -> std::string

___

### Class members in Java - no prob!

```Java
class Student {
    private Leerkracht favorieteLeerkracht;
    public Student() {}
}
Student braveke = new Student();    // favorieteLeerkracht = null
```

___

### Class members in C++ - opletten!

```C
class Student {
private:
    Leerkracht favorieteLeerkracht;
public:
    Student() {}
};
Student braveke; // maakt OOK Leerkracht instance aan (die niet NULL is)??
```

**Oeps!** Wat gebeurt er hier?

___

#### Oplossing 1 - Pointers:

```C
class Student {
private:
    Leerkracht* favorieteLeerkracht;
public:
    Student() {}
};
```

Zelf beheren! **Probleem**: wie beheert die leerkracht?

___

#### Oplossing 2 - "smart" Pointers:

```C
class Student {
private:
    std::shared_ptr<Leerkracht> favorieteLeerkracht;
public:
    Student() {}
};
```

Kan ook `unique_ptr` zijn - volledig eigen beheer. 

Merk op dat bij `Student jaak;` nog steeds de shared pointer member aangemaakt wordt!
<br/>(Dit is geen pointer van een shared pointer)

[https://github.com/wgroeneveld/gba-sprite-engine/blob/master/demos/demo1-basicfeatures/src/flying_stuff_scene.h](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/demos/demo1-basicfeatures/src/flying_stuff_scene.h)

___

#### Oplossing 3 - rechtstreeks in constructor

```C
class Student {
private:
    Leerkracht favorieteLeerkracht;
public:
    Student(Leerkracht favorieteLeerkracht) : favorieteLeerkracht(favorieteLeerkracht) {}
};
```

**Geen goed idee**; C++ is pass-by-value!

Dus, als **reference** (`&`) meegeven (liefst `const`):

```C
Student(Leekracht& favoriete)
```

___

### Opmerkingen bij aanmaken objecten

Java:

```Java
Student braveke;            // null
braveke = new Student();    // ok
```

C++:

```C
Student braveke;                // OEI tis al aangemaakt OFWA???
Student braveke(23);            // constructor call
auto braveke;                   // ERROR: kan niet automatisch type deducen
auto braveke = new Student();   // ok, = Student* maar ZELF opkuisen!
auto braveke = std::unique_ptr<Student>(new Student()); // ok
```

___

### Aanmaken: De Stack VS de heap

```C
class Boom {
private:
    Bos* bos;
public:
    void maakBosAan() {
        Bos bosje;          // stack
        this->bos = &bosje; // ??
    }
    void echo() {
        bos->oehoe();
    }
}
```

Waarom crasht `echo()`?<br/>
Zie [college 2](/teaching/cpp/slides-2)

---

## C++ en GUI design met Qt

<img src="/img/teaching/qt.svg" style="border: 0; width: 25%" />

demootje

---

## Conclusie - Hoe leer je dit vak? 

___

## Tip 1: leer lezen & begrijpen

[https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite.h](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite.h)

Weet je wat de code doet als je iets **kopieert** van Stack Overflow? 

___

## Tip 2: leer... lezen & begrijpen

[https://brainbaking.com/teaching/cpp/labo-5/](https://brainbaking.com/teaching/cpp/labo-5/)

___

## Tip 3: Ken de _toolchain_

* wat is `gcc` VS `arm-none-eabi-gcc` VS `g++`
* wat is `make` VS `cmake` VS `qmake`
* wat is compilen VS (static) linking VS binary builden

en

* Hoe installeer en gebruik ik toolchain 1/2
* Hoe werk ik efficiënt in **cmdline**

Google "crash course linux commands"

___

## Tip 4

<img src="/img/teaching/homework.jpg" />

Oefeningen in C++ Primer boek ook maken!

---

## Examen info

eind jan, 3h tijd. 

* Open boek
* **Begrijpen**, niet reproduceren
* Denkvragen oplossen! 
* **Scenario's**: model uitwerken, klasse skelet uitschrijven
* Basis **Syntax** uiteraard kennen

Data, meer info, ... via Toledo.

___

### Wat moet ik kennen?

- Syllabus: slides hoorcolleges + labo noties
- C++ Primer handboek
- Oefeningen van beiden.

<br/>

### Wat moet ik niet kennen?

- Qt API syntax
- GBA API & design => deel van project

___

## Project info

Deadline: 1 dag voor examen, 12h 's middags

- Groepen van 2 (3)
- Git, fork van `gba-sprite-engine`, C++11
- Volledige vrijheid in opdracht.
- Tijdsregistratie vereist (onderzoek)

Min. vereisten e.a.:
https://brainbaking.com/teaching/cpp/project/

___

### Project Evaluatie - elkaar evalueren?

Evaluatieformulier uitgedeeld, met criteria:

> Design (1), Clean Code (2), C++ Conventies (3), Complexiteit (4), Originaliteit (5), UI (6).

= zelfde als lesgevers hanteren. 

Presenteren aan elkaar in **3 minuten**!

Datum, plaats, ... via Toledo. 

___

### Totale Puntenverdeling

* `27%` evaluatie project mede-studenten
* `23%` evaluatie project docent
* `50%` evaluatie examen

---

<!-- .slide: data-background="#008eb3" -->
## Oef... Da wast ofwa?

<img src="/img/teaching/wast.jpg" />

> "_Kleine wasjes..._" - ons "poes"
