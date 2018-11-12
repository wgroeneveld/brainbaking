---
title: 'Een introductie in C(++) Build Systemen'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Zie ook [labo 1: (herhaaldelijk) compileren](/teaching/cpp/labo-1#compiling)

Een greep uit de mogelijkheden, schematisch samengevat:

{{<mermaid>}}
graph LR;
    compiler[compiler rechtstreeks uitvoeren]
    make[Makefiles roepen compiler aan]
    scons[SCons files roepen compiler aan]
    cmake[CMake files genereren Makefiles]
    qmake[QMake files genereren Makefiles]
    shell[Eigen script roept compiler aan]
    qmake --> make
    cmake --> make
    scons --> compiler
    make --> compiler
    shell --> compiler
{{< /mermaid >}}

## Hoe compileer ik één file?

We gebruiken de UNIX GNU gcc compiler om C soure files om te zetten in binaries. Het simpelste om iets te compileren is:

> `g++ [bestand.cpp] -o [output.bin]`

Het programma uitvoeren doe je dan met `./output.bin`. Normaal gezien kent het OS de execute flag automatisch toe, anders moet je nog `chmod +x output.bin` uitvoeren.

Dit kan je makkelijk automatiseren met een shell script door de compilatie en de executie in twee regels onder elkaar te plaatsen. De C(++) wereld voorziet echter flexibelere tools die dit voor je kunnen vergemakkelijken.

## Hoe vergemakkelijk ik het compileren van één project?

Gebruik daarvoor `Makefile` bestanden. Een Makefile is platte tekst die informatie bevat over je bronbestanden, libraries, binaries, ... zodat je met één enkel commando:

> `make`

Een aantal instructies kan ontketenen. Een Makefile is opgesplitst in verschillende **blokken**. Elke blok bevat één _keyword_ gevolgd door `:`, met op de volgende regels (voorafgaand met tab!) de uit te voeren instructies. Bijvoorbeeld:

```
.DEFAULT_GOAL := all

CC=gcc

clean:
    rm -rf *.o
    rm -rf *.out

compile:
    $(CC) -c main.c -o main.o

link:
    $(CC) -o main.out main.o

all: clean compile link
```

Bovenstaande Makefile bevat de volgende blokken:

1. clean
2. compile
3. link
4. all

Merk op dat als géén blok als argument op `make` voorzien is, dat dan de "all" block uitgevoerd wordt (`.DEFAULT_GOAL`, eerste regel). Op die manier kan je met het commando `make compile` de compilatiestap uitvoeren, maar met `make` of `make all` een hele reeks aan stappen. 

Makefiles verzorgen dus het uitvoeren van de compilatie, zodat wij nooit meer rechtstreeks `g++` of `gcc` moeten uitvoeren. 

Deze configuratiebestanden komen niet zonder nadelen:

1. De syntax is erg cryptisch.
2. Makefiles kunnen énorm groot, en dus verwarrend, worden.

[Meer info over Makefiles](ftp://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_2.html).

## Hoe vergemakkelijk ik het maken van een Makefile?

Om tekortkomingen van de archaïsche Makefile bestanden goed te maken zijn er nieuwe tools ontwikkeld die Makefiles genereren. Er zijn twee grote varianten voorzien: CMake en QMake.

### A. Gebruik CMake

CMake genereert `Makefile` bestanden door middel van `CMakeLists.txt` configuratie bestanden. Hierin **beschrijf** je je project, met een eenvoudigere syntax, waarna CMake het genereren van de Makefile uit handen neemt. Dit wil zeggen dat je nog steeds 2 stappen dient uit te voeren: het genereren, én het uiteindelijk uitvoeren van de Makefile zelf. **Make blijft dus je comipler aanroepen!**. 

Een typisch `CMakeLists.txt` bestand ziet er als volgt uit:

```
cmake_minimum_required(VERSION 3.10)
project(mijn_project)
SET(CMAKE_CXX_STANDARD 11)

add_executable(mijn_binary main.cpp bla.h bla.cpp)
```

De volgende eigenschappen zijn beschreven:

1. Welke compiler toolchain gebruik je? (C++ STD. 11 of hoger)
2. Hoe heet je project? (mijn_project)
3. Welke source en header files moeten gecompileerd worden? (main.cpp bla.h bla.cpp)
4. Hoe heet je binary? (mijn_bindary)

Extra bestanden compileren is een kwestie van bestanden toe te voegen aan het lijstje. 

CMake is de standaard build tool in CLion. Je kan met CMake ook eenvoudig **subprojecten** maken, bijvoorbeeld een productie stukje in /src en een test stukje in /test. Download een [CMake voorbeeld project met unittesten](/teaching/cpp/labo-7-unittest.zip) hier. 

[Meer info over CMake files](https://cmake.org/cmake-tutorial/).

### B. Gebruik QMake

Qt heeft zijn eigen Makefile generatie systeem dat `QMake` heet. Dit voornamelijk om de tussencompilatie stap te voorzien omdat Qt eigen keywords bij "verzonnen" heeft in de C++ standaard, zoals `signals:` en `slots:`. Omdat QMake deel is van een product is het nooit een goed idee om hier voor te kiezen als je geen Qt project gaat aanmaken. Uiteraard is QMake de standaard build tool in Qt Designer/Creator. 

QMake gebruikt projectfiles om de configuratie in op te slaan. Een voorbeeld projectfile (gegenereerd):

```
#-------------------------------------------------
#
# Project created by QtCreator 2018-08-22T11:10:02
#
#-------------------------------------------------

QT       += core gui widgets

TARGET = qt-labo-11-player
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    playercanvas.cpp

HEADERS += \
        mainwindow.h \
    playercanvas.h

FORMS += \
        mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
```

Deze bestanden worden beheerd door de IDE, niet door jezelf. Dat betekent dat toevoegingen niet manueel dienen te gebeuren. 

[Meer info over qmake project files](http://doc.qt.io/archives/qt-4.8/qmake-project-files.html).

## Hoe vergemakkelijk ik het compileren zonder Makefiles?

QMake en CMake bouwen nog steeds verder op het `Makefile` model. Er zijn echter buildsystemen die hier volledig los van staan, waarvan de populairste SCons is.

### A. Gebruik SCons

In SCons beschrijf je je project met **python**! Er is gekozen voor een bestaande programmeertaal, in plaats van weeral een configuratie taaltje te verzinnen. Dit maakt SCons bijzonder flexibel: loopen over files in het systeem om ze te pipen naar een compiler, of een zipfile maken als distributiestap, zijn simpele zaken die met bovenstaande tools moeilijker te realiseren zijn. 

SCons verwacht één `SConstruct` bestand. Een voorbeeld `SConstruct` file:

```
env = Environment(CXX = 'g++')

gtest = env.SConscript('lib/gtest/SConscript', 'env')
src = env.SConscript('src/SConscript', 'env')
out = env.SConscript('test/SConscript', 'env gtest src')

# output is an array with path to built binaries. We only built one file - run it (includes gtest_main).
test = Command( target = "testoutput",
                source = str(out[0]),
                action = str(out[0]) )
AlwaysBuild(test)
```

SCons vereist een python interpreter (en wat python kennis), en valt daarom buiten de scope van deze cursus. Voor de geïnteresseerden: lees ook [SCons building in practice](/post/scons-building/).

[Meer info over SCons](https://scons.org/doc/production/HTML/scons-man.html).