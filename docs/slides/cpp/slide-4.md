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
class Student {
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

* Copy constructoren
* Operatoren

...

___

#### Copy constructoren

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


___

#### Operatoren


```C
class Student {
private:
    int leeftijd;
public:
    Student(int leeftijd) : leeftijd(leeftijd) {}
    friend bool operator>(const &Student student1, const &Student student2);
};
bool operator>(const Student& student1, const Student& student2) {
    return student1.leeftijd > student2.leeftijd;
}
```


```C
Student jaak(20), lowie(10); 
std::cout << "wie is ouder? " << jaak > lowie;
```

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
    void slijm(const Leerkracht& leerkracht) {
        punten = leerkracht.geefVeelPunten();
    }
}
// leerkracht.h
#include "student.h"
class Leerkracht {
private:
    int geefVeelPunten() { return 20; }
public:
    void buis(const Student& student);
}
```

<img src="/img/teaching/bff.jpg" width="25%" />

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
Groet heykes("sup"):   // ok: impliciete conversie
Groet hekyes = "sup"s; // ok: char[] zelf omgezet
Groet heykes;          // ok: heykes is nieuw leeg Groet object op stack
```

`x = y` gebruikt copy constructor voor zelfde type.

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

### Meer opletten met class members (pff):

```C
class Student {
private:
    Leerkracht favorieteLeerkracht;
public:
    Student() {}
};
Student braveke; // maakt OOK Leerkracht instance aan??
```

**Oeps!**

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

**Geen goed idee**; C++ is pass-by-value! Dus **reference** meegeven:

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

## Tip 1: leer lezen & begrijpen

[https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite.h](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/engine/include/libgba-sprite-engine/sprites/sprite.h)

___

## Tip 2: leer... lezen & begrijpen

[https://brainbaking.com/teaching/cpp/labo-5/](https://brainbaking.com/teaching/cpp/labo-5/)

___

## Tip 3

<img src="/img/teaching/homework.jpg" />

---

## C++ en GUI design met Qt

---

## Conclusie - Hoe leer je dit vak? 

---

<!-- .slide: data-background="#008eb3" -->
## Oef... Da wast ofwa?

<img src="/img/teaching/wast.jpg" />

> "_Kleine wasjes..._" - ons "poes"
