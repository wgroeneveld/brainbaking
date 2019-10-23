---
title: 'Installatieinstructies op Linux'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Onderstaande instructies gaan uit van Ubuntu als besturingssysteem. Windows of OSX is ook mogelijk, alle tools zijn platformonafhankelijk. Voor Windows installeer je [MinGW 64](https://sourceforge.net/projects/mingw-w64/) als compiler toolchain. 

## Basisvereisten

De volgende tools worden verwacht geïnstalleerd te worden via de package tool `apt-get` bij Ubuntu:

* build-essential als gcc/g++ build tools (preinstalled?)
* git

Optionele editors (VSCode, Subl) zijn ook via de package tool te installeren. `sublime-text` (vereist toevoegen van [een repository](https://www.sublimetext.com/docs/3/linux_repositories.html)).

De volgende tools worden verwacht gedownload te worden via git:

* Google Test (zie [labo 7](/teaching/cpp/labo-7))
* gba-sprite-engine (zie [opdracht](/teaching/cpp/project))

De volgende tools worden verwacht manueel te downloaden:

* [CLion](https://www.jetbrains.com/clion/download/)<br/>Vanaf CLion 2018.1 bevat deze reeds CMake 3.12.x.

[CLion](https://www.jetbrains.com/clion/download) is **gratis voor studenten**: registreet je via de [JetBrains Student](https://www.jetbrains.com/student/) pagina met je studenten e-mail adres om een licentiesleutel toegestuurd te krijgen. 

### gcc Compiler installeren

#### Voor Windows

Download en installeer [MinGW 64](https://sourceforge.net/projects/mingw-w64/). **Cygwin geeft problemen** met UNIX paden en de cross compiler! In Cygwin stelt de windows dir `C:\Development\github` bijvoorbeeld `/cygdrive/c/Development/github` voor. Die forward slashes gecombineerd met de cygdrive prefix kan de GBA cross-compiler niet interpreteren. 

1. Dubbelklik op `mingw-w64-install.exe`
2. Kies bij de installatie settings bij Architecture voor **x86_64**
3. Verander je destination folder naar believen

Start MinGW met de shortcut die geplaatst werd in je destination folder. Daarna kan je je installatie valideren met het commando `gcc -v` in de geopende terminal. 

**Opgelet** voor mensen die switchen van Cygwin naar MinGW: de bin folder van je Cygwin installatie mag _niet_ toegevoegd zijn aan `%PATH%`. Je krijgt dan de volgende foutboodschap:

<pre>
sh.exe was found in your PATH, here:
C:/Program Files/Git/user/bin/sh.exe
For MinGW make to work correctly sh.exe must NOT be in your path.
</pre>

Verwijder je oude Cygwin `%PATH%` variabele via start - "Omgevingsvariabelen voor uw account bewerken" - zoek "Path" in de lijst, klik op Bewerken - verwijder de referentie naar je Cygwin pad. 

##### MinGW integratie in CLion

Ga naar bestand - settings - klik op "Build, Execution, Deployment" - klik op Toolchains:

<img src="/img/teaching/clion_settings_mingw.png" class="bordered" />

Kies in de "Environment" dropdown voor "MinGW" en zet het pad juist naar je installatie folder van MinGW64. Merk op dat onder "C++ Compiler" Een foutboodschap kan verschijnen "For MinGW make to work correctly..." - dit mag je negeren. De C en C++ compilers zelf mag je leeg laten en komen van de CMake instellingen.

Vanaf dan zal CLion bij het builden de MinGW omgeving gebruiken om CMake en Make uit te voeren.

#### Voor Linux

Geen speciale actie vereist, compiler built-in.

#### Voor OSX

Installeer de XCode toolchain via de Mac Appstore. Daarna kan je je installatie valideren met `gcc -v`.

### CMake installeren

**Opgelet** Wij hebben CMake `3.12` of recenter nodig. Deze versie komt reeds bij CLion `2018.1` of later. Dat betekent dat als je een recente versie van CLion installeert, je _CMake niet meer manueel hoeft te installeren!_ Sla onderstaande stappen dus over indien je CLion installatie recent genoeg is. 

#### CMake voor OSX

Voor OSX via Homebrew: `brew install cmake`. 

#### CMake voor Ubuntu

Ubuntu's `apt-get` package manager heeft niet altijd **de laatste versie** van CMake in zijn repository - wij moeten 3.12 of hoger hebben. Als alternatief kan je op [https://cmake.org/download/](https://cmake.org/download/) de binaries downloaden (shellscript) en dit "ergens" installeren. Aangeraden is een `$CMAKE_HOME` omgevingsvariabele te maken en die toe te voegen aan je `$PATH`. In CLion kan je via [CLion settings](https://www.jetbrains.com/help/clion/configuring-cmake.html) (File - Settings - Build, Execution, Deployment, Toolchains) een andere CMake executable kiezen. 

#### CMake voor Windows

Voor Windows is er [een installer voorzien](https://cmake.org/download/). De 64-BIT installer is hier te downloaden: [https://cmake.org/download/](https://cmake.org/download/) - wij moeten 3.12 of hoger hebben. Aangeraden is een `%CMAKE_HOME%` omgevingsvariabele te maken. 

1. Kies tijdens de installatie **wel** voor "Add CMake to the system PATH for all users". 
2. Verander je destination folder naar believen

Het kan zijn dat `cmake` niet voldoende is of je compilers niet kan vinden maar de VC++ versie probeert (nmake, cl). In dat geval `cmake -G "Unix Makefiles" -DCMAKE_SH="CMAKE_SH-NOTFOUND"` als commando hanteren. Als er tijdens het compileren iets misloopt, controleer dan even in het gegenereerde `CMakeCache.txt` bestand of CMake de juiste compilers gevonden heeft. 

### Google Test compileren

Deze stappen zijn onafhankelijk van je gekozen besturingssysteem, zodra je de basis gcc toolchain én CMake gecompileerd hebt. 

Volg de volgende stappen na een `git clone https://github.com/google/googletest`:

* Download en compileer googletest:
  * `cd googletest/googletest`
  * Maak een build directory: `mkdir build` **in de map googletest**
  * Build cmake: `cd build && cmake ./../`. <br/>Vergeet niet op Windows de `-G` optie mee te geven (zie boven)
  * Build google test: `make`. Dit geeft `libgtest.a` en `libgtest_main.a`   
* Integreer googletest in je CLion project met CMake:
  * Include de gtest headers met `include_directories()`
  * Link de libraries met `target_link_libraries()`
  * Voorzie een omgevingsvariabele `GTEST_DIR`.

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