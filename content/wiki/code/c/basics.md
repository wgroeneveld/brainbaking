+++
title = "basics"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "c",
    "basics"
]
date = "2013-12-02"
+++
# C(++) Basics 

## Scope 

C++ heeft block level scope, net als Java, alleen is het mogelijk om een variabele binnen een for loop dezelfde naam te geven als een die buiten die block gedefiniëerd is, terwijl dat in Java niet gaat:

```c
int j;
for(int i = 0; i < 10; i++) {
  int j = i + 1; // compile fout in java
}
```

### Pointer scope  

[auto_ptr](https://en.wikipedia.org/wiki/Auto_ptr) kan gebruikt worden om een pointer automatisch te verwijderen met `delete` wanneer deze scope verliest - alle andere zaken moet je zelf opkuisen. 
:exclamation: Dit is deprecated in C++ 11, gebruik [unique_ptr](https://en.wikipedia.org/wiki/Smart_pointer#unique_ptr)

Voorbeeld van wikipedia:

```c
#include <iostream>
#include <memory>
using namespace std;
 
int main(int argc, char **argv)
{
    int *i = new int;
    auto_ptr<int> x(i);
    auto_ptr<int> y;
 
    y = x;
 
    cout << x.get() << endl; // Print NULL
    cout << y.get() << endl; // Print non-NULL address i
 
    return 0;
}
```

## overloading: 'virtual' 

In java wordt by default het diepste gedefiniëerde element opgeroepen, in C++ ben je verplicht `virtual` te gebruiken als "optimalisatie" wordt dit standaard niet gedaan... Voorbeeld:

```c
class Simple
{
public:
	Simple() : someMember(3) {}
	virtual int guessNumber();
	int someMember;
};
```

```c
#include "simplecpp.h"

int Simple::guessNumber()
{
	return 5;
}
``` 

Als je nu `guessNumber()` wil overschrijven in een subklasse kan dit:

```c
#include "simplecpp.h"

class Complexer : public Simple
{
public:
	Complexer() {}
	int guessNumber();
};
```

Merk op, te overschrijven method heropsommen in header file... (??) - hier hoeft geen `virtual` meer bij dan.

```c
#include "complexer.h"

int Complexer::guessNumber()
{
	return 10;
}
```

Wat is hier de uitkomst van:

```c

#include "complexer.h"
#include <iostream>

int main()
{
	Simple* simple = new Complexer();
	std::cout << simple->guessNumber();
	delete simple;
}
```

10. Haal `virtual` weg. 5. <br/><br/>
Definiëer `Complexer` zo:

```c
Complexer* complexer = new Complexer();
```

En het is altijd 10.

## Initialisatie 

(Voorbeelden van bovenstaande)

```c
#include "complexer.h"
#include <iostream>

int main()
{
	Simple simpleInitialized; // oops, I created something?
	// Simple simpleInitialized = NULL; cannot convert from 'int' to 'Simple' (#define NULL 0)

	Simple* simplePtr;

	std::cout << "<br/>n initialiezd: " << simplePtr->someMember;
	// Run-Time Check Failure #3 - The variable 'simplePtr' is being used without being initialized

	delete simplePtr;
}
```

Wat is hier speciaal aan?

  1. In C++ wordt altijd een object aangemaakt als je ze declareert. In Java niet!
  2. In C++ is `NULL` gedefiniëerd als `#define NULL 0` - je kan dus niet zomaar iets toekennen hieraan. In C++ 11 heb je `nullptr`
  3. Je kan wel een pointer declareren zonder een waarde toe te kennen, en dit geeft dan een run-time fout (zou bvb een `NullPointerException` gooien in java)

## Typecasting 

Uitgebreide uitleg: zie http://www.cplusplus.com/doc/tutorial/typecasting/

In C++ is één impliciete conversie mogelijk door middel van de constructor, bijvoorbeeld:

```c
class Something
{
 public:
   Something(int i) : myVar(i) {}
 private:
  int myVar;
}

int getal = 10;
Something something = getal; // use constructor
```

Om dit tegen te gaan kan je altijd het `explicit` keyword gebruiken, zodat je dit moet doen:

```c
Something something = Something(getal); // expliciet oproepen constructor
```

Je kan `staic_cast<Type>(var)` gebruiken om explicit constructors aan te roepen, zo kunnen ze dan toch nog gecast worden. 

## C++ 11 goodies 

Algemeen: [How C++ 11 helps boost your productivity](http://www.informit.com/articles/article.aspx?p=1910142)

  1. [Lambdas](http://www.codeproject.com/Articles/277612/Using-lambdas-Cplusplus-vs-Csharp-vs-Cplusplus-CX) zijn mogelijk
  2. `nullptr`
  3. `auto` keyword, zoals `var` in C# - dit is typesafe en door de compiler zelf bepaald. 
  4. 100% multithreading support, zie [code/c/threading]({{< relref "wiki/code/c/threading.md" >}})