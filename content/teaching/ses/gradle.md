---
title: 'Java Gradle projecten'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

## Helps teams build, automate and deliver better software, faster.

Tenminste, toch volgens de [gradle.org](https://gradle.org) website.

### Wat is dat, een build tool?

Gradle is een build tool die de automatisatie van releasen, builden, testen, configureren, dependencies en libraries managen, ... eenvoudiger maakt. Kort gezegd: het maakt het leven van een ontwikkelaar eenvoudiger. In een config bestand genaamd `build.gradle` schrijft men met Groovy, een dynamische taal bovenop de JVM, op een descriptieve manier hoe Gradle de applicatie moet beheren. 

Andere bekende build tools:

- `Maven`, `Ant` (in XML) voor Java
- `(C/Q)Make` (custom config) voor C/C++
- `yarn`, `grunt`, `gulp`, (in JS) ... voor JS
- `nuget` (custom config, XML) voor .NET

Naast het beheren van compilaties, verzorgt Gradle ook libraries. Het is dus ook een _dependency management_ systeem, zoals Composer voor PHP of Node Package Manager voor NodeJS. 

#### Ontleding van een Gradle config file

De meest eenvoudige buildfile is terug te vinden in de [singleton oefening](/teaching/ses/singleton.zip):

<pre>
plugins {
    id 'java'
}

group 'be.kuleuven.ses'
version '1.0-SNAPSHOT'

sourceCompatibility = 1.10

repositories {
    mavenCentral()
}

dependencies {
    testImplementation group: 'org.junit.jupiter', name: 'junit-jupiter-api', version: '5.5.2'
    testImplementation group: 'org.hamcrest', name: 'hamcrest-library', version: '2.2'
}
</pre>

Hier onderscheiden we de volgende zaken:

1. Het project is een java 10 project (er zijn ook nog andere talen op de JVM)
2. Het project komt van `be.kuleuven.ses`, versie `1.0-SNAPSHOT`.
3. Dependencies downloaden via de [standaard maven central](https://mvnrepository.com/repos/central) (ingebouwde URL).
    - Hiervan moet Gradle `junit-jupiter-api 5.5.2` downloaden voor de testen
    - Hiervan moet Gradle `hamcrest-library 2.2` downloaden voor de testen

Dependencies vallen (meestal) in twee categorieën:

1. `implementation` (productie dependencies)
2. `testImplementation` (test dependencies)

Merk op dat een typisch gradle project **geen jars** mee zipt, zoals de oefeningen. Die worden dus automatisch door deze tool gedownload, en in de juiste map geplaatst. 

Voor het [SESsy Library](/teaching/ses/sessy) project wordt ook Gradle gebruikt, en is de config file iets ingewikkelder, door de inclusie van eigen "tasks". (te raadplegen op <i class='fa fa-github'></i> [Github](https://github.com/KULeuven-Diepenbeek/sessylibrary/blob/master/build.gradle))

#### Ontleding van een Gradle project mappenstructuur

Als we kijken naar de bestanden- en mappenstructuur van [singleton oefening](/teaching/ses/singleton.zip), vinden we dit terug:

<pre>
build/
src/
    main/
        java/
            be/
                package1/
                    ClassMain
                    ClassZ
    test/
        java/
            be/
                package1/
                    ClassMainTest
                    ClassZTest
resources/
    css/
    js/
gradle/
    wrapper/
        gradle-wrapper.jar
        gradle-wrapper.properties
build.gradle
gradlew.bat
gradlew
settings.gradle
</pre>

Hier onderscheiden we de volgende zaken:

1. Broncode (`.java` bestanden) in `src/main/java` en `src/test/java`, met productie- en testcode gescheiden. 
2. Gecompileerde code (`.class` bestanden) in de `build/` (of ook wel `out`) folder.
2. Eventueel `resources` voor webapps e.d. (images, css, ...)
3. `gradle` map, en executable (`gradlew.bat` win en shell script voor unix)
4. `gradle` settings en build file.

Wat gebeurt er nu precies als je `gradlew.bat` uitvoert? 

1. Download de juiste versie van Gradle zelf (!! dus installatie is **niet nodig**), afhankelijk van de specificaties in de properties file.
2. Download de juiste libraries om het project te kunnen runnen. 

Aan deze wrapper kan je commando's meegeven. Bijvoorbeeld, `gradlew.bat test`:

<pre>
Wouters-Air:singleton wgroeneveld$ ./gradlew test

> Task :test FAILED

ShoppingCartResourceTest > get_fromMultipleResources_shouldNotIncreaseDBHandleVarCount FAILED
    java.lang.AssertionError at ShoppingCartResourceTest.java:25

2 tests completed, 1 failed

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':test'.
> There were failing tests. See the report at: file:///Users/jefklak/development/brainbaking/content/teaching/ses/singleton/build/reports/tests/test/index.html
</pre>

Dit is **exact hetzelfde** als in IntelliJ de testen uitvoeren met de knop 'Run':

<img src="/img/teaching/ses/intellij_run_test.png" />

### Waarom een build tool gebruiken?

De grootste voordelen hiervan zijn onder andere:

- Een kleine voetafdruk van de broncode (repository). Het is niet nodig om jars als libraries in een `lib/` folder zelf bij te houden: Gradle doet dit immers voor jou. 
- Een project _bootstrappen_ in luttele seconden: download code, voer de Gradle wrapper uit, en alles wordt vanzelf klaargezet (de juiste Gradle versie, de juiste library versies, ...)
- Platform-onafhankelijk processen besturen die altijd op dezelfde manier werken: een taak uitvoeren op mijn PC doet exact hetzelfde als bij jou, dankzij de beschrijving van de stappen in de config file. 

Het is bijvoorbeeld bij de oefeningen eenvoudig om een test library als `junit` mee te leveren, zonder de bestanden zelf aan te leveren, dankzij het regeltje `testCompile group: 'junit', name: 'junit', version: '4.12'` in de dependencies block. 

### Gradle en Maven integratie

Gradle voorziet een plugin genaamd '_maven-publish_' die deze bestanden automatisch aanmaakt. Activeer de plugin en voeg een `publishing` tag toe met de volgende properties:

<pre>
plugins {
    id 'java'
    id 'maven-publish' // toevoegen!
}

publishing {
    publications {
        maven(MavenPublication) {
            groupId = project.group.toString()
            version = version
            artifactId = 'projectnaam'

            from components.java
        }
    }
    repositories {
        maven {
            url = "/Users/wgroeneveld/development/java/maven-repo"
        }
    }
}
</pre>

Deze uitbreiding voegt de target `publish` toe aan Gradle. Dus: `./gradlew publish` publiceert de nodige bestanden in de aangegeven folder. Een Gradle project die daar gebruik van wenst te maken dient enkel een tweede Maven Repository plaats te definiëren:

<pre>
repositories {
    mavenCentral()
    maven {
        url = "/Users/wgroeneveld/development/java/maven-repo"
    }
}
</pre>

### Gradle en JUnit integratie

JUnit 5 splitst de test library op in een aantal submodules, waarvan er twee belangrijke zijn die we nodig hebben om te testen:

1. `junit-jupiter-api` - nodig om testen te SCHRIJVEN (de API waar `@BeforeEach` e.a. in zitten)
2. `junit-jupiter-engine` - nodig om testen UIT TE VOEREN (cmdline interface)

Aangezien Gradle verschillende test bibliotheken ondersteund, zoals ook TestNG, dient men in de Gradle build file ondersteuning voor elk framework te activeren. Dit is _enkel nodig bij cmdline uitvoeren van de testen_. Als je beslist om enkel binnen IntelliJ testen uit te voeren, verzorgt IntelliJ zelf dit, en is de jupiter-engine ook niet nodig. 

<pre>
test {
    useJUnitPlatform()
    testLogging.showStandardStreams = true
}

dependencies {
    // for WRITING tests, this will suffice:
    testImplementation group: 'org.junit.jupiter', name: 'junit-jupiter-api', version: '5.5.2'
    // for RUNNING tests (cmdline, without IntelliJ), this is also needed:
    testImplementation group: 'org.junit.jupiter', name: 'junit-jupiter-engine', version: '5.5.2'
}
</pre>

Optionele test libraries zoals Hamcrest en Selenium/WebDriver kunnen daarna ook worden toegevoegd onder de `testImplementation` groep.

### Welke Task moet ik uitvoeren?

`./gradlew tasks --all` voorziet een overzicht van alle beschikbare taken voor een bepaald Gradle project, opgesplitst per fase (build tasks, build setup tasks, documentation tasks, help tasks, verification tasks). Plugins voorzien vaak extra tasks, zoals bovenstaande maven plugin. 

Belangrijke taken zijn onder andere:

- `test`: voer alle unit testen uit. Een rapport hiervan is beschikbaar op build/reports/tests/test/index.html.
- `clean`: verwijder alle binaries en metadata.
- `build`: compile en test het project.
- `publish`: (maven plugin) publiceert naar een repository.
- `jar`: compile en package in een jar bestand
- `javadoc`: (plugin) genereert HTML javadoc. Een rapport hiervan is beschikbaar op build/docs/javadoc/index.html.

Onderstaande screenshot is een voorbeeld van een Unit Test HTML rapport voor de SESsy library:

<center>
    ![Gradle test report](/img/teaching/ses/gradle-testreports.png)
</center>

### Ik wil meer output bij het uitvoeren van mijn tasks!

De standaard output geeft enkel weer of er iets gelukt is of niet:

<pre>
Wouters-Air:sessylibrary wgroeneveld$ ./gradlew shadowjar

BUILD SUCCESSFUL in 9s
3 actionable tasks: 1 executed, 2 up-to-date
</pre>

Meer informatie kan met de volgende parameters:

- `--info`, output LogLevel `INFO`. Veel irrelevante info wordt ook getoond.
- `--warning-mode all`, toont detail informatie van warning messages
- `--stacktrace`, toont de detail stacktrace bij exceptions

### De Gradle (wrapper) Upgraden

Indien de Gralde wrapper een oudere versie aanmaakt (< v6), update met `gradle wrapper --gradle-version 6.0.1`. Gradle versie `6` of groter is vereist voor JDK `13` of groter. 

### Meer links en tutorials:

- Officiële Gradle [docs](https://docs.gradle.org/current/userguide/userguide.html).
- Officiële Gradle [guides: creating a new build](https://guides.gradle.org/creating-new-gradle-builds/)
- [Gradle cheatsheet voorbeeld config file](https://gist.github.com/jahe/59557d507f43574b0d96)
- [Gradle common commands](https://www.polyglotdeveloper.com/cheatsheet/2015-01-08-Gradle-cheatsheet/)