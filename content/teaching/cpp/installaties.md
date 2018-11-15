---
title: 'Installatieinstructies op Linux'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Onderstaande instructies gaan uit van Ubuntu als besturingssysteem. Windows of OSX is ook mogelijk, alle tools zijn platformonafhankelijk. Voor Windows installeer je [Cygwin](http://www.cygwin.com/install.html) als compiler toolchain. 

## Basisvereisten

De volgende tools worden verwacht geïnstalleerd te worden via de package tool `apt-get` bij Ubuntu:

* build-essential als gcc/g++ build tools (preinstalled?)
* git
* qt5-default en daarna qtcreator

Optionele editors (VSCode, Subl) zijn ook via de package tool te installeren. `sublime-text` (vereist toevoegen van [een repository](https://www.sublimetext.com/docs/3/linux_repositories.html)).

De volgende tools worden verwacht gedownload te worden via git:

* Google Test (zie [labo 7](/teaching/cpp/labo-7))
* gba-sprite-engine (zie [opdracht](/teaching/cpp/project))

De volgende tools worden verwacht manueel te downloaden:

* [CLion](https://www.jetbrains.com/clion/download/)
* CMake 3.12.x (nog niet in de package tool)

[CLion](https://www.jetbrains.com/clion/download) is **gratis voor studenten**: registreet je via de [JetBrains Student](https://www.jetbrains.com/student/) pagina met je studenten e-mail adres om een licentiesleutel toegestuurd te krijgen. 

### gcc Compiler installeren

#### Voor Windows

Gelieve [Deze instructies](https://warwick.ac.uk/fac/sci/moac/people/students/peter_cock/cygwin/part2/) te volgen om [Cygwin 64-BIT](https://www.cygwin.com/install.html) te installeren, samen met alle "devel" opties. Dit kan een tijdje duren. Daarna kan je je installatie valideren met `gcc -v`. 

Voeg de bin folder van je Cygwin installatie toe aan `%PATH%` om in eender welke console toegang te hebben tot de toolchain. Vanaf dan kan je je terminal naar keuze gebruiken in plaats van enkel Cygwin zelf - bijvoorbeeld [Cmder](http://cmder.net).

Hier zit ook een CMake versie in (3.6), maar die is te oud voor ons - zie verder. 

#### Voor Linux

Geen speciale actie vereist, compiler built-in.

#### Voor OSX

Installeer de XCode toolchain via de Mac Appstore. Daarna kan je je installatie valideren met `gcc -v`.

### CMake installeren

Voor OSX via Homebrew: `brew install cmake`. <br/>
Voor Windows is er [een installer voorzien](https://cmake.org/download/).

#### CMake voor Ubuntu

Ubuntu's `apt-get` package manager heeft niet altijd **de laatste versie** van CMake in zijn repository - wij moeten 3.12 of hoger hebben. Als alternatief kan je op [https://cmake.org/download/](https://cmake.org/download/) de binaries downloaden (shellscript) en dit "ergens" installeren. Aangeraden is een `$CMAKE_HOME` omgevingsvariabele te maken en die toe te voegen aan je `$PATH`. In CLion kan je via [CLion settings](https://www.jetbrains.com/help/clion/configuring-cmake.html) (File - Settings - Build, Execution, Deployment, Toolchains) een andere CMake executable kiezen. 

#### CMake voor Windows

De 64-BIT installer is hier te downloaden: [https://cmake.org/download/](https://cmake.org/download/) - wij moeten 3.12 of hoger hebben. Aangeraden is een `%CMAKE_HOME%` omgevingsvariabele te maken. 

* Kies tijdens de installatie **niet** voor "Add CMake to the system PATH for all users** - dat heb je al toegevoegd met de Cygwin installatie.
* Installeer op een **dezelfde locatie** als de Cygwin folder, bijvoorbeeld  C:\Development\Cygwin64. Dit is belangrijk om de bestaande versie van CMake bij Cygwin te overschrijven. 

Het kan zijn dat `cmake` niet voldoende is of je compilers niet kan vinden maar de VC++ versie probeert (nmake, cl). In dat geval `cmake -G "Unix Makefiles" -DCMAKE_SH="CMAKE_SH-NOTFOUND"` als commando hanteren. Als er tijdens het compileren iets misloopt, controleer dan even in het gegenereerde `CMakeCache.txt` bestand of CMake de juiste compilers gevonden heeft. 

In CLion kan je via [CLion settings](https://www.jetbrains.com/help/clion/configuring-cmake.html) (File - Settings - Build, Execution, Deployment, Toolchains) een andere CMake executable kiezen. 

### Google Test compileren

Deze stappen zijn onafhankelijk van je gekozen besturingssysteem, zodra je de basis gcc toolchain én CMake gecompileerd hebt. 

Volg de volgende stappen na een `git clone https://github.com/google/googletest`:

* Download en compileer googletest:
  * `cd googletest/googletest`
  * Maak een build directory: `mkdir build` **in de map googletest**
  * Build cmake: `cd build && cmake ./../`
  * Build google test: `make`. Dit geeft `libgtest.a` en `libgtest_main.a`   
* Integreer googletest in je CLion project met CMake:
  * Include de gtest headers met `include_directories()`
  * Link de libraries met `target_link_libraries()`
  * Voorzie een omgevingsvariabele `$GTEST_DIR`.

### DevkitPro installeren

De "DevkitPro" toolchain installeren levert je een aantal cross-compilers en linkers op die een C source file omzetten ine en GBA binary. Zie [installatie instructies](https://devkitpro.org/wiki/Getting_Started) per OS. Via de meegeleverde package manager `pacman` kan je op OSX de package `gba-dev` installeren. 

#### Windows specifiek

Voor Windows is er een installer voorzien. Vink enkel als "components to install" GBA development aan. Er is 300MB voor nodig omdat er weer een virtuele omgeving voor bij komt (msys). 

Vergeet geen omgevingsvariabele `%DEVKITPATH%` aan te maken en deze toe te voegen aan je `%PATH%`; zie verder.

#### Ubuntu specifieke installatie

Voor Ubuntu moet je eerst de devkitpro-pacman `.deb` file installeren die je [hier op Github](https://github.com/devkitPro/pacman/releases) kan vinden. Het `pacman` commando is dan het `dkp-pacman` commando om verwarring met `apt` te vermijden. Installeer alle gba dev tools met `sudo dkp-pacman -S gba-dev`. De compilers zijn dan geïnstalleerd in `/opt/devkitpro/devkitARM/bin` dus voeg die folder toe aan je `$PATH`.

### Wijzigingen in het Bash profiel

In je `.bashrc` bestand in de home folder `~` voeg je het volgende toe:

<pre>
export DEVKITPATH="/opt/devkitpro/devkitARM/bin"
export CMAKE_HOME="/opt/cmake-3.12.1-Linux-x86_64"
export GTEST_DIR="/home/wouter/Development/googletest/googletest"
PATH="$DEVKITPATH:$CMAKE_HOME/bin:$PATH"
</pre>

Bovenstaande variabelen worden onder andere verwacht aanwezig te zijn op systeem niveau in de gba sprite engine. Voor windows pas je dit aan in het "System Configuration" scherm en klik je op "Environment Variables" om wijzigingen door te voeren (admin rechten vereist). 