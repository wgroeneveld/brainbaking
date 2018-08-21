---
title: 'Installatieinstructies op Linux'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

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

* CLion
* CMake 3.12.x (nog niet in de package tool)

### DevkitPro installeren

Zie [labo 3](/teaching/cpp/labo-3)

### Wijzigingen in het Bash profiel

In je `.bashrc` bestand in de home folder `~` voeg je het volgende toe:

<pre>
export DEVKITPATH="/opt/devkitpro/devkitARM/bin"
export CMAKE_HOME="/opt/cmake-3.12.1-Linux-x86_64"
export GTEST_DIR="/home/wouter/Development/googletest/googletest"
PATH="$DEVKITPATH:$CMAKE_HOME/bin:$PATH"
</pre>
