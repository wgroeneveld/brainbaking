---
title: 'Continuous Integration & Deployment'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

Begeleidende screencast:

{{< vimeo 400180594 >}}

## 1. Continuous Integration (CI)

Het softwareontwikkel proces is een continu proces: als een eerste versie van het product klaar is, en wordt overgemaakt aan klanten, volgt het onderhoud en een mogelijke volgende versie. Elke wijziging maakt potentiëel dingen kapot (geminimaliseerd met [TDD](/teaching/ses/tdd)), of introduceert nieuwe features. Dat betekent dat bij _elke wijziging_, een computer het hele build proces moet doorlopen om te controleren of er niets stuk is. Dit noemen we het "_integreren_" van nieuwe code, vandaar de naam.

### 1.1. De CI Server

In de praktijk worden aparte servers verantwoordelijk gesteld om regelmatig de hele codebase te downloaden, alles te compileren, en testen uit te voeren. Als iets niet compileert, of een test faalt, rapporteert dit systeem via diverse kanalen aan de ontwikkelaars. Niemand wilt dit in de achtergrond op zijn eigen machine een tweede build systeem geïnstalleerd hebben, die CPU kracht afsnoept van je eigen IDE. De volgende Figuur verduidelijkt de flow:

<center>
    <img src="/img/teaching/ses/devops.jpg" /><br/>
    <em>Het Continuous Integration build systeem (<a href="https://devopscube.com/continuous-integration-delivery-deployment/" target="_blank">bron</a>).</em>
</center>

Dit hele proces verloopt volledig automatisch: niemand drukt op een "build" knop, maar door middel van ingecheckte code wijzigingen (1) start dit systeem. De CI server haalt wijzigingen op (2), build (3) en test (4) om te kunnen rapporteren of dit lukte of niet (5), via verschillende kanalen (6).

De Source Control server, zoals Github.com of een lokale `git` server, werd reeds besproken in labo '[versiebeheer](/teaching/ses/versiebeheer)'. Er zijn voor Java verschillende populaire CI software systemen:

- [Jenkins](https://jenkins.io/solutions/java/)
- [TeamCity](www.jetbrains.com/teamcity)
- [Bamboo](https://www.atlassian.com/software/bamboo)
- [Travis](https://travis-ci.org)

In deze systemen zijn configureerbaar en beschikken over een UI, zoals bijvoorbeeld zichtbaar in de [TeamCity screencast](https://www.jetbrains.com/teamcity/documentation/). Betalende systemen zoals TeamCity en Bamboo zijn erg uitgebreid, maar wij gaan werken met Travis. Travis CI is eenvoudig configureerbaar door middel van een `.yml` bestand en integreert naadloos (en gratis) met Github. 

### 1.2. De flow van een CI server

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

Automatisch packagen en installeren van programma's stopt hier niet. Een niveau hoger is het automatisch packagen en installeren van _hele omgevingen_: het virtualiseren van een server. Infrastructuur automatisatie is een vak apart, en wordt vaak uitgevoerd met behulp van tools als Puppet, Docker, Terraform, Ansible of Chef. Dit valt buiten de scope van deze cursus. 

### 2.1. De flow van deployment en releases beheren

Nieuwe features in productie plaatsen brengt altijd een risico met zich mee. Het zou kunnen dat bepaalde nieuwe features bugs veroorzaken in de gekende oude features, of dat het (slecht getest) systeem helemaal niet werkt zoals men verwachtte. Om dat zo veel mogelijk te vermijden wordt er een release plan opgesteld waarin men aan '**smart routing**' doet. 

Stel, onze [SESsy bibliotheek webapplicatie](/teaching/ses/sessy) is toe aan vernieuwing. We wensen een nieuw scherm te ontwerpen om efficiënter te zoeken. We zijn echter niet zeker wat de gebruikers gaan vinden van deze nieuwe manier van werken, en beslissen daarom om slechts een _aantal gebruikers_ bloot te stellen aan deze radicale verandering. Dat kan op twee manieren:

1. _Blue/green releasing_: Een 'harde switch' in het systeem bepaalt welke personen (bijvoorbeeld op regio of IP) naar versie van het zoekscherm worden begeleid. 
2. _Canary releasing_: Een load balancer verdeelt het netwerkverkeer over verschillende servers, waarvan op één server de nieuwe versie is geïnstalleerd. In het begin gaat `90%` van de bezoekers nog steeds naar de oude versie. Dit kan gradueel worden verhoogd, totdat de oude server wordt uitgeschakeld. 

Onderstaand schema verduidelijkt dit idee.

<center>
  ![](/img/teaching/ses/releasing.png)<br/>
  ([bron](https://blog.getambassador.io/deploy-and-release-decouple-for-speed-and-safety-a8c99a9b4d7b))
</center>

De juiste logging en monitoring tools zorgen ervoor dat we een idee krijgen over het gebruik van het nieuwe scherm (groen, versie B). Gaat alles zoals verwacht, dan wordt de switch weggehaald in geval (1), of wordt de loadbalancer ge-herconfigureerd zodat het hele verkeer naar de nieuwe site gaat in geval (2). Ook deze aanpassingen zijn volledig geautomatiseerd. Na verloop van tijd valt de oude versie (blauw, versie A) volledig weg, en kunnen we ons concentreren op de volgende uitbreidingen. 

Het groene vlak, de 'Ambassador/API gateway', kan aanzien worden als:

- Een fysiek aparte machine, zoals een loadbalancer. 
- Een publieke API, die de juiste redirects verzorgt.
- Een switch in de code, die binnen dezelfde toepassing naar scherm 1 of 2 verwijst. 

Versie A en B hoeven dus niet noodzakelijk aparte versies van applicaties te zijn: dit kan binnen dezelfde applicatie, softwarematig dus, worden ingebouwd. 


## <a name="oef"></a>Labo oefeningen

### Opgave 1

Omwille van privacy instellingen tussen Travis en de KULeuven-Diepenbeek organisatie op Github, wordt voor deze opgave verwacht dat je een **nieuwe repository** zelf aanmaakt vanaf nul, via [Github.com](https://github.com). Geef de repository de naam `ses-ci-opgave`, zoals in onderstaande screenshot:

<center>
  ![](/img/teaching/ses/ci-newrepo.png)
</center>

Het is belangrijk dat de repository **public** is, anders kan Travis je project niet builden. 

#### 1.1 De Calculator app

Ontwerp een command-line interface programma, getiteld 'calculator', dat twee argumenten inleest die terecht komen in de `main()` methode, en de sommatie ervan afdrukt:

`java -cp . Calculator 1 4` print `5` in `stdout`.

Uiteraard gebruiken we hier Gradle voor. Zet de berekening in een aparte methode, die ook _getest_ werd. Voorzie dus ook Enkele eenvoudige unit testen in `src/main/test`. 

#### 1.2 De app builden op Travis

Nadat de code voor 1.1 werd gecommit en gepushed op je Git repository, is de volgende stap dit project automatisch te builden op een server, zoals Travis. Om dit te activeren moeten er twee stappen worden uitgevoerd:

1. Activeer je repository door op [travis-ci.org](https://travis-ci.org) in te loggen met je Github account, de repository terug te zoeken in de lijst door op `+` te drukken links, en de slider naar rechts te zetten, zodat Travis changes detecteert. Zie screenshot hieronder.
2. Voorzie een `.travis.yml` bestand waarin staat beschreven op welke manier je project moet worden gebuild. 

<center>
  ![](/img/teaching/ses/ci-enabletravis.png)
</center>

Het verschil tussen de `.org` en `.com` websites is dat de eerste enkel publieke repositories kan behandelen, terwijl de laatste (in BETA) ook private repositories aankan. Vergewis je ervan om enkel via de eerste, [travis-ci.org](https://travis-ci.org), je opgave repository te activeren. 

Welke stappen denk je dat Travis zou moeten ondernemen op je project te builden? Is enkel builden voldoende? Wat als er een test faalt? Stel dat we de gebuilde jar ergens willen uploaden, hoe gaan we dan tewerk? Raadpleeg de documentatie om jezelf te bekwamen in de Yaml syntax:

- [Customizing the build - Travis](https://docs.travis-ci.com/user/customizing-the-build/)
- [Building a Java Project - Travis](https://docs.travis-ci.com/user/languages/java/)

### Opgave 2

Er duikt plots een onvoorziene periode van boekenschaarste op! Om niet te veel paniek te veroorzaken, willen we gebruik maken van blue/green releasing om het uitleensysteem van [SESsy library](/teaching/ses/sessy) gradueel te wijzigen. 

De klasse `BorrowBooksResource` is het _entry point_ voor alle calls naar `/borrow`, zoals de `@Path` annotatie aanduidt. Deze klasse zal voortaan moeten dienen als API gateway die gebruikers omleidt, ofwel naar het gebruikelijke uitleenproces, ofwel naar een methode die niet meer toestaat dat boeken worden uitgeleend, onafhankelijk van de ingelogde gebruiker of het type boek. 

Maak twee nieuwe klasses aan, `BorrowBooksOriginalResource` (1) met de originele `borrow()` implementatie, en `BorrowBooksNotAllowedResource` (2), die altijd een status `FORBIDDEN` teruggeeft. Kennis van patterns is een pluspunt hier. 

Denk na over hoe je de bestaande klasse `BorrowBooksResource` gaat aanpassen om bepaalde gebruikers naar ofwel (1) ofwel (2) te leiden. Je kan bijvoorbeeld een aantal boeken (op basis van ISBN) wel of niet toestaan, of gebaseerd op de sessie een aantal gebruikers wel of niet toestaan. Neem een kijkje in `request.getSession()`: wat is bruikbaar, en wat niet?

## Denkvragen

- Waarom is het belangrijk om gebuilde artifacts van de CI server bij te houden? 
- Wat zijn de voordelen van het werken met een CI en CD systeem, ten opzichte van alles met de hand (of met eigen gemaakte scripts) in te stellen? 
- Version control en continuous delivery zijn klassiek gezien vijanden van database migratie (of omgekeerd). Toch is het mogelijk om een database systeem ook automatisch te up- of downgraden, met bijvoorbeeld https://flywaydb.org. Hoe gaat zoiets in zijn werk?

## Extra Leermateriaal

- [Martin Fowler on Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html)
- [Martin Fowler on Canary Releases](https://martinfowler.com/bliki/CanaryRelease.html)
- [Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation](https://www.amazon.com/dp/0321601912?tag=duckduckgo-d-20&linkCode=osi&th=1&psc=1)