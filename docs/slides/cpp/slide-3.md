Software ontwerp in C/C++: #3
=============================

<img src="/img/kul.svg" style="height: 80px;" />
<img src="/img/uhasselt.svg" style="width: 165px; height: 80px;"/>

---

## Wat is "Software Ontwerp"?

<img src="/slides/cpp/img/design.jpg" />

Euhm...

___

### "Ontwerp" in Software Ontwerp

Start op "papier" = modelleren:

<div class="mermaid" align="center" >
graph LR;
    A[Sollicitant]
    B[Vacature]
    C[Competenties]
    B --> C
    B -.-> A
</div>    

___

### Ontwerp uitwerken: analyses

<pre>
ANAL#002: vacature bevat vereiste competentiess

Beschrijving: een potentiële sollicitant moet matchen met de vereiste competenties
op een vacature. Het Een vacature kan één of meerdere competenties
bevatten. Een competentie beschrijft sterktepunten.

Context: (meer achtergrondinfo...)

Acceptatiecriteria:
- Bij het opstellen van een vacature kan je competenties toevoegen
- Een vacature kan meerdere competenties bevatten
- Sollicitanten beschikken ook over competenties
- Het matchen van een vacature op sollicitant gebeurt op basis daarvan
</pre>

Hoe uitwerken tot code? 

___

### Analyses uitwerken

1. Bespreek in team. Ontdek **kernwoorden** als:
  1. entiteiten
  2. acties
2. Stel je model op. Focus op **relaties**.
3. Converteer naar C++ klassen met dependencies.

---

## Hoe onderhoud ik een ontwerp?

<img src="/slides/cpp/img/broken-design.jpg" style="width: 60%" />

Zo niet...

___

## Met "Clean Code"!

https://wgroeneveld.github.io/cleancode-course/

> Clean code is code that is easy to understand and easy to change.

___ 

### Wat is **niet** clean?

```C
int process(MyThing* obj, continue = 0) {
  // printf("%s", starting the process");
  if(!obj->generate()) {
    return -1;
  }
  auto result = obj->generate();
  if(continue) {
    return result->generate();
  }
  return result;
}
```

WTF?

___

### Wat is **wel** clean?

```C
Book& getBookByISBN(int isbn) {
  auto book = search(isbn, this->books);
  if(!book) {
    throw std::runtime_error("book was not found");
  }
  return book;
}
```

___

<img src="/slides/cpp/img/wtf.png" />

---

## Verder gaan dan coderen

Software **ontwerp** is:

1. analyseren
2. coderen
3. testen
4. onderhouden
5. deployen
6. ...

___

## Software testen

1. Optie 1: Manueel
2. Optie 2: **Automatisch** - danku...

___

### Google Test

https://github.com/google/googletest

```C
#include "gtest/gtest.h"

int telOp(int a, int b) { return a + b; }

TEST(TelOpTest, SomIsAPlusB) {
  auto result = telOp(1, 2);
  EXPECT_EQ(3, result);
}
TEST(TelOpTest, KanMetNegatieveGetallenOverweg) {
  auto result = telOp(-1, 2);
  EXPECT_EQ(1, result);  
}
```
Compile `gtest` eerst zelf, daarna als ref linken!

___

### Testen uitvoeren: Cmdline

<pre>
  Wouters-MacBook-Air:unittest jefklak$ ./cmake-build-debug/unittest
[==========] Running 2 tests from 2 test cases.
[----------] Global test environment set-up.
[----------] 1 test from SuiteName
[ RUN      ] SuiteName.TrueIsTrue
[       OK ] SuiteName.TrueIsTrue (0 ms)
[----------] 1 test from SuiteName (0 ms total)

[----------] 1 test from AddTest
[ RUN      ] AddTest.ShouldAddOneAndTo
/Users/jefklak/CLionProjects/unittest/test.cpp:18: Failure
      Expected: add(1, 2)
      Which is: 3
To be equal to: 5
[  FAILED  ] AddTest.ShouldAddOneAndTo (0 ms)
[----------] 1 test from AddTest (0 ms total)

[----------] Global test environment tear-down
[==========] 2 tests from 2 test cases ran. (0 ms total)
[  PASSED  ] 1 test.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] AddTest.ShouldAddOneAndTo

 1 FAILED TEST
</pre>

___

### Testen uitvoeren: CLion

<img src="/img/teaching/clion_gtest.png" />

---

## Denken in OO-termen

* **Heeft-een** relatie
* **Is-een** relatie

___

### Hoe teken ik de relaties?

<div class="mermaid" align="center" >
graph LR;
    A[Boom]
    B[Blad]
    C[Eik]
    D[Bos]
</div>

___

### Juist ja.

<div class="mermaid" align="center" >
graph LR;
    A[Boom]
    B[Blad]
    C{Eik}
    D[Bos]
    A --> |heeft veel|B
    C -.-> |is een|A
    D --> |heeft veel|A
</div>

___

### Omvormen naar klassen en dependencies

```C
class Boom {
private:
  std::vector<Blad> bladeren;
};
class Bos {
private:
  std::vector<Boom> bomen;
};
class Blad {
};
auto eik = Boom();  // (nog) géén klasse maar een instance
```

Enkel **wat nodig is** omvormen!

```C
class Eik : public Boom {}; // zou kunnen...
```

___

## "Code Smells" herkennen

### Wat stinkt er hier zo?

Zie [Refactoring](https://www.goodreads.com/book/show/44936.Refactoring?ac=1&from_search=true) boek.

---

## OO design "patterns"

Zie [Design Patterns](https://www.goodreads.com/book/show/85009.Design_Patterns?ac=1&from_search=true) boek.

___

### Encapsulatie!

```C
  volatile OAM_ATTR* paddle_sprite = &OAM_MEM[1];
  paddle_sprite->attr0 = 0x4000; // 4bpp, wide
  paddle_sprite->attr1 = 0x4000; // 32x8 met wide shape
  paddle_sprite->attr2 = 2; // vanaf de 2de tile, palet 0
```

VS

```C
class Sprite {
private:
  SpriteSize size;
  int tileIndex;
public:
  save();     // Write to next available OAM_MEM
}
```

Géén GBA **internals exposen**: werk high-level.

---

## Conclusie: meer dan Syntax

### Wees geen programmeur...

Wees een **ingenieur**.

---

<!-- .slide: data-background="#008eb3" -->
## Oef... Nog bij de zaak?

> "_Zo wakker als iets_" - student Y
