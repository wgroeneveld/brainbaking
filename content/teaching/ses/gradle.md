---
title: 'Java Gradle projecten'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

## Helps teams build, automate and deliver better software, faster.

Tenminste, toch volgens [gradle.org](https://gradle.org) ([docs](https://docs.gradle.org/current/userguide/userguide.html)).

### Wat is dat, een build tool?

Gradle is een build tool die de automatisatie van releasen, builden, testen, configureren, dependencies en libraries managen, ... eenvoudiger maakt. Kort gezegd: het maakt het leven van een ontwikkelaar eenvoudiger. In een config bestand genaamd `build.gradle` schrijft men met Groovy, een dynamische taal bovenop de JVM, op een descriptieve manier hoe Gradle de applicatie moet beheren. 

#### Ontleding van een config file

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
    testCompile group: 'junit', name: 'junit', version: '4.12'
    testCompile group: 'org.hamcrest', name: 'hamcrest-library', version: '2.2'
}
</pre>

Hier onderscheiden we de volgende zaken:

1. Het project is een java 10 project (er zijn ook nog andere talen op de JVM)
2. Het project komt van `be.kuleuven.ses`, versie `1.0-SNAPSHOT`.
3. Dependencies downloaden via de [standaard maven central](https://mvnrepository.com/repos/central) (ingebouwde URL).
    - Hiervan moet Gradle `juni 4.12` downloaden voor de testen
    - Hiervan moet Gradle `hamcrest-library 2.2` downloaden voor de testen

Merk op dat een typisch gradle project **geen jars** mee zipt, zoals de oefeningen. Die worden dus automatisch door deze tool gedownload, en in de juiste map geplaatst. 

#### Ontleding van een Gradle project mappenstructuur

Als we kijken naar de bestanden- en mappenstructuur van [singleton oefening](/teaching/ses/singleton.zip), vinden we dit terug:

<pre>
src
    main
        java
            be.package1
                ClassMain
                ClassZ
    test
        java
            be.package1
                ClassMainTest
                ClassZTest
resources
    css
    js
gradle
    wrapper
        gradle-wrapper.jar
        gradle-wrapper.properties
build.gradle
gradlew.bat
gradlew
settings.gradle
</pre>

Hier onderscheiden we de volgende zaken:

1. `src`, in `src/main/java` en `src/test/java`, met productie- en testcode gescheiden. 
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

<img src="/img/teaching/intellij_run_test.png" />
