---
title: 'Continuous Integration & Deployment'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## 1. Continuous Integration (CI)

Het softwareontwikkel proces is een continu proces: als een eerste versie van het product klaar is, en wordt overgemaakt aan klanten, volgt het onderhoud en een mogelijke volgende versie. Elke wijziging maakt potentiëel dingen kapot (geminimaliseerd met [TDD](/teaching/ses/tdd)), of introduceert nieuwe features. Dat betekent dat bij _elke wijziging_, een computer het hele build proces moet doorlopen om te controleren of er niets stuk is. Dit noemen we het "_integreren_" van nieuwe code, vandaar de naam.

### De CI Server

In de praktijk worden aparte servers verantwoordelijk gesteld om regelmatig de hele codebase te downloaden, alles te compileren, en testen uit te voeren. Als iets niet compileert, of een test faalt, rapporteert dit systeem via diverse kanalen aan de ontwikkelaars. Niemand wilt dit in de achtergrond op zijn eigen machine een tweede build systeem geïnstalleerd hebben, die CPU kracht afsnoept van je eigen IDE. De volgende Figuur verduidelijkt de flow:

<center>
    <img src="/img/teaching/ses/devops.jpg" /><br/>
    <em>Het Continuous Integration build systeem (<a href="https://devopscube.com/continuous-integration-delivery-deployment/" target="_blank">copyright</a>).</em>
</center>

Dit hele proces verloopt volledig automatisch: niemand drukt op een "build" knop, maar door middel van ingecheckte code wijzigingen (1) start dit systeem. De CI server haalt wijzigingen op (2), build (3) en test (4) om te kunnen rapporteren of dit lukte of niet (5), via verschillende kanalen (6).

De Source Control server, zoals Github.com of een lokale `git` server, werd reeds besproken in labo '[versiebeheer](/teaching/ses/versiebeheer)'. Er zijn voor Java verschillende populaire CI software systemen:

- [Jenkins](https://jenkins.io/solutions/java/)
- [TeamCity](www.jetbrains.com/teamcity)
- [Bamboo](https://www.atlassian.com/software/bamboo)
- [Travis](https://travis-ci.org)

In deze systemen zijn configureerbaar en beschikken over een UI, zoals bijvoorbeeld zichtbaar in de [TeamCity screencast](https://www.jetbrains.com/teamcity/documentation/). Betalende systemen zoals TeamCity en Bamboo zijn erg uitgebreid, maar wij gaan werken met Travis. Travis CI is eenvoudig configureerbaar door middel van een `.yml` bestand en integreert naadloos (en gratis) met Github. 

### De flow van een CI server

De [SESsy library](/teaching/ses/sessy) git repository bevat een [.travis.yml](https://github.com/KULeuven-Diepenbeek/sessylibrary/blob/master/.travis.yml) bestand dat de Travis server instrueert wat te doen op welk moment:

<pre>
language: java

jdk:
  - openjdk11

env:
  - NODE_VERSION="12.10.0"

notifications:
  email: false

before_install:
  - nvm install $NODE_VERSION
  - nvm use $NODE_VERSION
  - pushd frontend
  - npm install
  - mkdir dist
  - popd

install:
  - ./gradlew check
  - ./gradlew frontendSync --stacktrace
  - ./gradlew shadowJar
</pre>

#### 1. Checkout Code

`git clone [repository]` (met de juiste branch). Klaar. 

#### 2. Setup Environment

Elke build op Travis begint met een _clean_ besturingssysteem (standaard Linux) en gegeven basistools. Dat betekent dat als bepaalde versies van `node` of Java nodig zijn, deze eerst moeten worden geïnstalleerd. Travis voorziet openJDK versies - de Oracle versies moeten zelf worden afgehaald. Voor SESsy library is ook `node` vereist die de frontend kan builden. 

In `before_install` plaats je uit te voeren instructies die voor de `install` stap worden uitgevoerd. 

#### 3. Build Code

Gebruik [Gradle](/teaching/ses/gradle) Tasks:

1. `check` - installeert de juiste Gradle versie, compileert en test.
2. `frontendSync` - build met `node` de frontend en kopiëert naar `src/main/resources`.

#### 4. Test Code

Deel van `./gradlew check`.

#### 5. Package Code & Upload Artifact

`./gradlew shadowJar` - package alles, inclusief dependencies, in één grote jarfile.

Zodra één stap mis gaat (zoals een falende test), worden volgende stappen niet uitgevoerd. Als alles goed gaat is de output van het builden de binary die we _het artifact_ noemen, die de huidige buildstamp draagt (meestal een datumcode).

Alle gebuilde artifacts kunnen daarna worden geupload naar een repository server, zoals de Central Maven Repository, of onze eigen artifact server, waar een historiek wordt bijgehouden. 

#### 6. Publish Results

Op hat dashboard van [https://travis-ci.org](https://travis-ci.org) kan je de gepubliceerde resultaten (live) raadplegen:

<center>
    <img src="/img/teaching/ses/travis.png" />
</center>

## 2. Continuous Deployment (CD)

Automatisch code compileren, testen, en packagen, is slechts één stap in het continuous development proces. De volgende stap is deze package ook automatisch _deployen_, of _installeren_. Op deze manier staat er altijd de laatste versie op een interne development website, kunnen installaties automatisch worden uitgevoerd op bepaalde tijdstippen, ... 

Populaire CD systemen:

- [Octopus Deploy](https://octopus.com)
- [Codeship](https://codeship.com)
- Eigen scripts gebaseerd op CI systemen
- Cloud deployment systemen (Amazon AWS, Heroku, Google Apps, ...)

De `shadowJar` task genereert één `jar` bestand die uitvoerbaar is (`java -jar [filename].jar`), en onze DropWizard server lokaal opstart op poort `8000`. Eender welke server kan dit programma dus op eenvoudige wijze uitvoeren. 

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom). 

### Opgave 1

#### 1.1 De Calculator app

Ontwerp een command-line interface programma, getiteld 'calculator', dat twee argumenten inleest die terecht komen in de `main()` methode, en de sommatie ervan afdrukt:

`java -cp . Calculator 1 4` print `5` in `stdout`.

Uiteraard gebruiken we hier Gradle voor. Zet de berekening in een aparte methode, die ook _getest_ werd. Voorzie dus ook Enkele eenvoudige unit testen in `src/main/test`. 

#### 1.2 De app builden op Travis

Nadat de code voor 1.1 werd gecommit en gepushed op je Git repository, is de volgende stap dit project automatisch te builden op een server, zoals Travis. Om dit te activeren moeten er twee stappen worden uitgevoerd:

1. Activeer je repository door op [travis-ci.org](travis-ci.org) in te loggen met je Github account, de repository terug te zoeken in de lijst door op `+` te drukken links, en de slider naar rechts te zetten, zodat Travis changes detecteert. 
2. Voorzie een `.travis.yml` bestand waarin staat beschreven op welke manier je project moet worden gebuild. 

### Opgave 2

## Denkvragen

- Waarom is het belangrijk om gebuilde artifacts van de CI server bij te houden? 
- Wat zijn de voordelen van het werken met een CI en CD systeem, ten opzichte van alles met de hand (of met eigen gemaakte scripts) in te stellen? 

## Extra Leermateriaal

- [Martin Fowler on Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html)