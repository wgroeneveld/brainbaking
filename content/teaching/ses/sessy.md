---
title: 'SESsy Library WebApp'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

## SESsy Library: Een geïntegreerde oefening

Download Locatie: op <i class='fa fa-github'></i> Github via [https://github.com/wgroeneveld/sessylibrary](https://github.com/wgroeneveld/sessylibrary). Zie `README.md` op de hoofdpagina. _SESsy_ library is:

> A Library Management Simulation WebApp for the 'SES' (Software Engineering Skills) course

### Installatie

Download via bovenstaande Github link, of met `git clone`. Dit is een ["Gradle" project](/teaching/ses/gradle), die de build van ons Java ecosysteem verzorgt. Dat wil zeggen dat het Gradle systeem automatisch libraries (`jar` bestanden) download van een centrale repository, moesten die nodig zijn. Het enige wat jij moet installeren is Java:

#### Minimum Vereisten

* Java 11
* Gradle 5.6.x of hoger

Installeer Gradle en de lokale dependencies door middel van de [Gradle wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html). Voer in de sessylibrary map `gradlew.bat` (of `./gradlew` voor Unix) uit. Dit download automatisch de juiste versie van Gradle. 

#### Het project builden

**Command-line**: `gradlew.bat shadowjar`. <br/>
Het resultaat is `sessylibrary-1.0-SNAPSHOT-all.jar` in de `build\libs` folder.

Met IntelliJ: open het project (selecteer de root folder), en klik op 'build'. Alternatief kan je met IntelliJ de `gradle.build` file openen en de juiste task starten door in de Gutter op het groene start knopje te klikken.

#### Het project (de server) opstarten

**Command-line:** Na het builden van de jar, uitvoeren (in de root folder) met `java -jar build\libs\sessylibrary-1.0-SNAPSHOT-all.jar server app.yml`.

Met IntelliJ: Menu Run -> Run... Kies voor klasse `be.kuleuven.sessylibrary.SessyLibApplication` en geef als program arguments (NIET VM options) "server app.yml" in. Klik op Apply/Run.

De applicatie staat nu live op [http://localhost:8080](http://localhost:8080)!

### Componenten

#### Backend

[DropWizard](http://www.dropwizard.io/en/stable/) Java RESTful API that integrates Jetty/Jackson/... functionality in a nice all-in-one package. 
This means executing the jar automatically bootstraps a webserver, and REST calls can be easily added using `javax.ws` annotations. See `be.kuleuven.sessylibrary.api` classes for examples.

#### Frontend

[VueJS](https://vuejs.org) Progressive single-page JS framework that calls the above API endpoints and is served from the very same webserver thanks to the `dropwizard-assets` module. 

The compiled vuejs webpage should be copied to `src/main/resources/assets` - `index.htm` is served at `/`.

Students **do not need to edit** the frontend part of this application and may consider this as a 'given'. 

Building and running the Frontend source:

1. `npm install` in the frontend subdir
2. `npm run serve` in the frontend subdir

Your project should be running at `http://localhost:8080` now.

### Meer lezen

* [DropWizard: Getting Started](https://dropwizard.io/en/stable/getting-started.html) 
* [Gradle User Guide](https://docs.gradle.org/current/userguide/)
* [VueJS Guide](https://vuejs.org/v2/guide/)
* [Bootstrap VueJS Components](https://bootstrap-vue.js.org/docs/components/)