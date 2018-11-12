---
title: 'Software ontwerp in C/C++'
accent: "#008eb3"
disableComments: true
disableList: true
---

<span style="float: right;">
    <img src="/img/kul.svg" /><br/>
    <img src="/img/uhasselt.svg" style="width: 165px;"/>
</span>
Laatste aanpassingen voor academiejaar _2018 - 2019_.

## _Cursus notities_

De hoorcolleges en labo's lopen door elkaar. De theorie die aangeraakt wordt in de slides van de hoorcolleges vindt zijn weg in de tekst van de verschillende labo's. 

### Hoorcolleges

1. [Introductie in C/C++: context, ecosysteem](/teaching/cpp/slides-1/)
2. [Pointers in C, dynamisch geheugen in C++](/teaching/cpp/slides-2/)
3. [Introductie in Object-Georiënteerd denken in C++](/teaching/cpp/slides-3/)
4. [Een introductie in GUI ontwerp met Qt, Samenvatting, examen info](/teaching/cpp/slides-4)

### Labo noties

1. [Introductie in C](/teaching/cpp/labo-1)
2. [Pointers in C en C++](/teaching/cpp/labo-2)
3. [GBA Programming in C: een introductie](/teaching/cpp/labo-3)
4. [GBA Programming in C: tilesets, een simpel spel](/teaching/cpp/labo-4)
5. [Introductie in C++](/teaching/cpp/labo-5)
6. [C++ Class Inheritance, operators en templates](/teaching/cpp/labo-6)
7. [Software ontwerpen: denken en testen voor coderen](/teaching/cpp/labo-7)
8. [GBA Programming in C++: een abstractielaag](/teaching/cpp/labo-8)
9. [GBA Programming in C++: scrolling backgrounds](/teaching/cpp/labo-9)
10. [GUI ontwerp met C++ in Qt: een introductie](/teaching/cpp/labo-10)
11. [GUI ontwerp met C++ in Qt: een GBA spel porten naar Qt](/teaching/cpp/labo-11)

### Extra informatie

- [Een introductie in C(++) Build Systemen](/teaching/cpp/buildsystems)
- [Installatieinstructies Tools](/teaching/cpp/installaties)
- [Project opdracht](/teaching/cpp/project)
- Evaluatiecriteria schriftelijk examen

## Syllabus

- **Lesgever**: Wouter Groeneveld - <a href="mailto:wouter.groeneveld@kuleuven.be">wouter.groeneveld@kuleuven.be</a>
- **Kantoor**: [Quadri gebouw](https://www.ucll.be/studeren/student-aan-ucll/campussen/campus-diepenbeek), 1.06 
- **Verplicht handboek**: [C++ Primer](https://www.goodreads.com/book/show/768080.C_Primer), Stanley B. Lippman

#### Cursusbeschrijving

C is oorspronkelijk ontwikkeld om hardware heel gericht te kunnen aansturen. Later, en zeker met de toevoeging van C++, is C/C++ ook gebruikt voor gewone software. Tegenwoordig wordt die rol eerder overgenomen door Java en .NET en is het belang van C en C++ (terug) verschoven naar de ingebedde systemen.

Vanuit die optiek is het niet meer dan logisch om studenten elektronica/ict vaardigheden in C/C++ te laten verwerven. Vanuit dezelfde verbredende visie doen we dit met Linux als (cross-platform) ontwikkelplatform en met embedded systemen als doelplatform.

C++ wordt aangebracht vanuit de kennis van Java, zoals verworven in eerdere opleidingsonderdelen. Er wordt dan ook geregeld gewezen op de verschillen en gelijkenissen tussen C++ en Java. Een aantal concepten zijn gelijkaardig met (lichtjes) andere syntax, maar er zijn ook fundamenteel andere dingen, zoals pointers, friends, virtuele functies, operator overloading, destructors, STL, ... Voor de GUI wordt gewerkt met QT.

In een latere faze van de oefeningen maakt de student kennis met crosscompilatie zodat de oefening kan draaien op een single board "computer" zoals een Gameboy Advance.

- Imperatief programmeren in C
    - Controlestructuren, functies, arrays
    - Pointers en reference variabelen.
- Object-Georiënteerd programmeren C++ 
    - Operatoren, virtuele functie, abstracte klasse, uitzonderingen, sjablonen, containers.
    - De STL bibliotheek
    - C++ 11 lambda's
- Het gehele C/C++ Ecosysteem: makefiles, builden, linken. 
- Software ontwerpen met domein modellen. 
- Vergelijking tussen C/C++ en Java.
- Cross-platform-ontwikkeling voor Single Board Computers.
- Kennismaking met het Qt framework voor GUI ontwerp in C++.

#### Vereiste voorkennis

- Basiskennis van een Object-Geörienteerde programmeertaal als Java of C#
- Basiskennis van het UNIX systeem, werken met commandline

#### Doelstellingen

Zie ook [Studiegids UHasselt](https://www.uhasselt.be/studiegids)
    
De context en het overzicht worden aangereikt in het hoorcollege.

Als practicum wordt een grotere probleemstelling als project uitgewerkt. Alle aan te leren aspecten van C++ komen in dit project aan bod. Studenten kunnen facultatief buiten het practicum extra thematische oefeningen oplossen.

#### Beoordeling en evaluatie

Zowel in de eerste als de tweede examenkans is er een project (thuiswerk) en een schriftelijk examen. De verdeling tussen beide is afhankelijk van de omvang van de taak en wordt meegedeeld wanneer de taak wordt opgegeven.

Overdracht van het punt op de taak naar de tweede examenkans en een volgend academiejaar vanaf 12/20.

Overdracht van het punt op het examen naar de tweede examenkans vanaf 10/20. Er is geen overdracht naar een volgend academiejaar.

#### Meer leermiddelen

Een interessante vergelijkende cursus met nadruk op computer architectuur: [Computer Systems and Architecture](http://cs.umw.edu/~finlayson/class/spring18/cpsc305/) aan de Universiteit Mary Washington. 

##### C in-depth

* [The C Programming Language](https://www.goodreads.com/book/show/515601.The_C_Programming_Language?from_search=true)

##### Embedded GBA Programming in C

* [Tonc: principles of GBA programming](https://www.coranac.com/tonc/text/toc.htm)
* [GBA Programming for beginners](http://www.loirak.com/gameboy/gbatutor.php)

##### C++ in-depth

* [Effective Modern C++](https://www.goodreads.com/book/show/22800553-effective-modern-c)
* [Bjarne Stroustrup's C++ Style and Technique FAQ](http://www.stroustrup.com/bs_faq2.html)

##### Qt GUI Programming

* [Qt Examples and Tutorials](http://doc.qt.io/qt-5/qtexamplesandtutorials.html)
* [Qt Class reference](http://doc.qt.io/qt-5/classes.html)

#### Kalender

Zie [collegeroosters UHasselt](http://collegeroosters.uhasselt.be).
