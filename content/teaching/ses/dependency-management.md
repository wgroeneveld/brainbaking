---
title: 'Dependency Management'
accent: "#008eb3"
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

Lees ook: [Meer uitleg over de Gradle build tool](/teaching/ses/gradle/).

## Wat is een 'dependency'?

Een dependency, of _afhankelijkheid_, is een externe bibliotheek die wordt gebruikt tijdens de ontwikkeling van een toepassing. Tijdens het vak 'Software ontwerp in Java' zijn reeds de volgende externe libraries gebruikt:

1. [JavaFX](https://openjfx.io)
2. [Google Gson](https://github.com/google/gson)
3. [JUnit](https://junit.org/junit5/)

Het vertrouwen op zo'n library houdt in dat een extern bestand, zoals een `.jar` of `.war` bestand, download en koppelt wordt aan de applicatie. In Java koppelen we externe libraries door middel van het `CLASSPATH`: een folder die de compiler gebruikt om te zoeken naar klassen. 

Serialisatie met behulp van Gson kan op deze manier:

```java
public class Main {
    public static void main(String[] args) {
        Gson gson = new Gson();
        System.out.println(gson.toJson(1));
    }
}
```

Bovenstaande `Main.java` compileren zonder meer geeft de volgende fout:

<pre>
Wouters-MacBook-Air:java wgroeneveld$ javac Main.java
Main.java:3: error: cannot find symbol
        Gson gson = new Gson();
        ^
  symbol:   class Gson
  location: class Main
</pre>

De klasse `Gson` is immers iets dat we niet hebben zelfgemaakt, maar wensen te importeren via het `import com.google.gson.*;` statement. Er is een manier nodig om de [gedownloade library](https://mvnrepository.com/artifact/com.google.code.gson/gson/2.8.6) te linken met onze bestaande code: `javac -cp gson-2.8.6.jar Main.java`.

De dependency in bovenstaand voorbeeld is `gson-2.8.6.jar`. Een gemiddelde Java applicatie heeft **meer dan 10 dependencies!** Het beheren van deze bestanden en de verschillende versies (major, minor, revision) geeft vaak conflicten die beter beheerd kunnen worden door tools dan door de typische vergeetachtigheid van mensen. 

## Wie beheert dependencies?

### De ontwikkelaar (manueel)

De eenvoudigste manier om een library te gebruiken is de volgende procedure te volgen:

1. Navigeer naar de website van de library en download deze in een bepaalde map, zoals `/lib`.
2. Importeer de juiste klasses met het `import` statement.
3. Compileer de code door middel van het `-cp dependency1.jar` argument.

Voor kleine programma's met enkele libraries is dit meer dan voldoende. Het kost echter redelijk veel moeite om de juiste versie te downloaden: stap 1 kost meestal meer dan 5 minuten werk. 

### De tools (automatisch)

#### Apache Maven

[Maven](https://en.wikipedia.org/wiki/Apache_Maven) is een build tool van de Apache Foundation die zowel de manier waarop de software wordt gecompileerd als zijn afhankelijkheden beheert. Maven is de voorloper van Gradle en bestaat reeds 15 jaar. 

Een Maven project heeft een `pom.xml` bestand (Project Object Model), waarin in XML formaat wordt beschreven hoe de structuur er uit ziet, welke libraries men gebruikt, en zo voort:

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0</version>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
```

Maven is erg populair in de Java wereld, waardoor er verschillende servers zijn die deze `pom` bestanden samen met hun libraries beheren, zoals de [Central Maven Repository](https://mvnrepository.com) en de [Google Maven Repository](https://maven.google.com/web/index.html) mirrors. De syntax van het configuratiebestand is echter erg onoverzichtelijk, en er zijn ondertussen betere alternatieven beschikbaar, zoals Gradle.

#### Gradle

**Belangrijk**: neem dit eerst door - [Meer informatie over Gradle](/teaching/ses/gradle/). 

Gradle is net zoals Maven een automatisatie tool voor de Java wereld (en daarbuiten), die verder bouwt op de populariteit van Maven door bijvoorbeeld compatibel te zijn met de Repository servers, maar de grootste pijnpunten wegneemt: een slorig configuratiebestand in XML, en complexe command-line scripts.

De volgende procedure volg je als je Gradle dependencies laat beheren:

1. Zoek op de [Maven Repository](https://mvnrepository.com) website naar de gewenste library. 
2. Voeg één regel toe in je `gradle.build` bestand, in het dependencies stuk:

<pre>
dependencies {
    implementation 'com.google.code.gson:gson:2.8.6'
}
</pre>

Bij het uitvoeren van `gradlew` download Gradle automatisch de juiste opgegeven versie. Gradle bewaart lokale kopies van libraries in een submap van je home folder: `~/.gradle`.

Voordelen van het gebruik van deze methode:

1. Het zoeken van libraries beperkt zich tot één centrale (Maven Repository) website, waar alle verschillende versie revisies duidelijk worden vermeld.
2. Het downloaden van libraries beperkt zich tot één centrale locatie op je harde schijf: 10 verschillende Java projecten die gebruik maken van Gson vereisen linken naar dezelfde gradle bestanden. 
3. Het beheren van dependencies en versies beperkt zich tot één centraal configuratiebestand: `build.gradle`. Dit is (terecht) een **integraal deel van het project**! 

#### Custom Repository URLs voorzien

Veelgebruikte libraries zijn eenvoudig te vinden via de [Central Maven Repository](https://mvnrepository.com). Wanneer echter een eigen library werd gecompileerd, die dan in andere projecten worden gebruikt, schiet deze methode tekort: interne libraries zijn uiteraard niet op een publieke server gepubliceerd. 

Gradle voorziet gelukkig genoeg een eenvoudige manier om [repository websites toe te voegen](https://docs.gradle.org/current/userguide/declaring_repositories.html), met de volgende eenvoudige syntax:

<pre>
repositories {
  mavenCentral()
}
</pre>

`mavenCentral()`, `jcenter()`, en `google()` zijn ingebouwde repositories. Eigen Maven folders en URLs toevoegen kan ook, evenals een lokale folder:
<a name="flatdir"></a>

<pre>
repositories {
    maven {
        // dit kan zowel een folder als HTTP(s) URL zijn
        url "/Users/wgroeneveld/development/java/maven-repo"
    }
    flatDir {
        dirs 'lib'
    }
}
</pre>

#### Transitieve dependencies 

Er zijn twee types van dependencies: **directe** (1) en **transitieve** (2). Een directe dependency is een afhankelijkheid die het project nodig heeft, zoals het gebruik van Gson, waarbij dit in de `dependencies {}` config zit. Een _transitieve_ of indirecte dependency is een dependency van een dependency. In de oefening hieronder maken we een project (1) aan, dat een project (2) gebruikt, dat Gson gebruikt. In project 1 is project 2 een directe dependency, en Gson een transitieve. In Project 2 is Gson een directe dependency (en komt project 1 niet voor):

{{<mermaid>}}
graph LR;
    A[Project een]
    B[Project twee]
    C[Gson]
    A --> B
    B --> C
    A -.-> C
{{< /mermaid >}}

Het is **geen goed idee** om bij fouten in uitvoering de zachte link (stippellijn) te veranderen in een harde, door dit als directe dependency toe te voegen. Gradle [biedt hier alternatieven voor](https://docs.gradle.org/current/userguide/dependency_management.html#controlling_transitive_dependencies). Het voor de hand liggende alternatief is van de library ook een Maven module te maken en deze te uploaden naar een (lokale) repository. 

#### Publiceren naar een Maven Repository

Klik op '[View All](https://mvnrepository.com/artifact/com.google.code.gson/gson/2.8.6)' bij de Gson module op de MVN Central Repo om te inspecteren welke bestanden typisch worden aangeleverd in een Maven repository:

1. De library zelf, in een bepaalde versie.
2. Eventueel de javadoc en/of sources als aparte jars.
3. Een `.pom` XML bestand.
4. metadata als `md5` checksums.

Het XML bestand beschrijft welke afhankelijkheden deze module op zich heeft. Zo kan een hele **dependency tree** worden opgebouwd! Het beheren van _alle_ afhankelijkheden is complexer dan op het eerste zicht lijkt, en laat je dus beter over aan deze gespecialiseerde tools. Google heeft voor Gson enkel Junit als test dependency aangeduid:

```xml
<dependencies>
<dependency>
<groupId>junit</groupId>
<artifactId>junit</artifactId>
<scope>test</scope>
</dependency>
</dependencies>
```

Grote projecten kunnen makkelijk afhankelijk zijn van tientallen libraries, die op hun beurt weer afhankelijk zijn van libraries. Een typische grote webapplicatie geschreven in java heeft de volgende dependency tree, die opgevraagd kan worden via Gradle of Maven:

<center>
    <img src="/img/teaching/ses/deptree.png" />
</center>

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

## <a name="oef"></a>Labo oefeningen

Neem dit eerst door: [Meer informatie over Gradle](/teaching/ses/gradle/). 

### Opgave 1

Ontwerp een eenvoudige library genaamd '_scorebord_' die scores kan bijhouden voor bordspelletjes. Deze library kan kan gebruikt worden door toekomstige digitale Java bordspellen. In een Scorebord kan je spelers toevoegen door middel van een naam en een score. Er is een mogelijkheid om de huidige score van een speler op te vragen, en de winnende speler. Deze gegevens worden met behulp van Gson in een `JSON` bestand bewaard, zodat bij het heropstarten van een spel de scores behouden blijven. <br/>De API (publieke methodes) van de library ziet er zo uit:

```java
class Speler {
    public String getNaam() { }
    public int getScore() { }
}
public class Scorebord {
    public void voegToe(String x, int huidigeScore) { }
    public int getTotaleScore(String x) { }
    public String getWinnaar() { }
}
```

De klasse `Speler` is een intern hulpmiddel om te serialiseren. <br/>
Extra methodes toevoegen mag altijd. De constructor van het scorebord leest automatisch de score van de vorige keer in, als dat bestand bestaat. Denk bij de implementatie aan een collectie om spelers en hun scores bij te houden. Maak via IntelliJ een nieuw **Gradle - Java project**. Groupid: `be.kuleuven`. Arifactid: `scorebord`. Vergeet niet op 'refresh' te drukken wanneer je een dependency toevoegt (linksboven op onderstaande screenshot):

<center>
    <img src="/img/teaching/ses/gradle-refresh.png" />
</center>

Met het commando `gradle jar` creëer je het bestand `scorebord-1.0-SNAPSHOT.jar` in de `build/libs` folder. 

Tip: indien de Gralde wrapper een oudere versie aanmaakt (< v6), update met `gradle wrapper --gradle-version 6.0.1`. Gradle versie `6` of groter is vereist voor JDK `13` of groter. 

### Opgave 2

Maak een nieuw Gradle project aan genaamd '_scorebord-darts_', dat bovenstaand scorebord project als een library gaat gebruiken. Bewaar de jar file lokaal in een 'lib' folder en instrueer Gradle zo dat dit als `flatDir` repository wordt opgenomen ([zie boven](#flatdir)). Het tweede project heeft als Artifactid `scorebord-darts`. De klasse `DartsGame` ziet er zo uit:

```java
public class DartsGame {
    private String player = "jos";
    public void throwDart() {}
}
```

Als de dependencies goed liggen, kan je een nieuw `Scorebord` aanmaken, en herkent IntelliJ dit met CTRL+Space:

<center>
    <img src="/img/teaching/ses/gradle-dependency-used.png" />
</center>

Maak een `Main` klasse met een `public static void main(String[] args)` methode, waarin een darts spel wordt opgezet, en een aantal keer ter test wordt 'gegooid'. Druk de totale score en de winnaar af, dat opgevraagd kan worden via het spelbord. Krijg je deze klasse opgestart? 

<pre>
> Task :Main.main() FAILED
Exception in thread "main" java.lang.NoClassDefFoundError: com/google/gson/Gson
    at be.kuleuven.scorebord.Scorebord.<init>(Scorebord.java:24)
    at be.kuleuven.DartsGame.<init>(DartsGame.java:11)
    at be.kuleuven.Main.main(Main.java:6)
Caused by: java.lang.ClassNotFoundException: com.google.gson.Gson
    at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:583)
    at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178)
    at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:521)
    ... 3 more

Caused by: java.lang.ClassNotFoundException: com.google.gson.Gson

Execution failed for task ':Main.main()'.
> Process 'command '/Library/Java/JavaVirtualMachines/jdk-11.0.2.jdk/Contents/Home/bin/java'' finished with non-zero exit value 1
</pre>

Dit werkt _niet_ omdat we een library gebruiken (ScoreBord), die op zijn beurt een library gebruikt (Gson), die niet in onze huidige Gradle file is gedefiniëerd. Om dit op te lossen dienen we over te schakelen naar een lokale Maven repository, die ook transitieve dependencies automatisch inlaadt. Verwijder de `flatDir` en voeg een lokale maven URL toe. Publiceer in het scorebord project naar diezelfde URL volgens de instructies van de `maven-publish` plugin.

### Opgave 3 (extra)

Bovenstaande screenshot geeft aan dat IntelliJ methodes herkent van de `Scorebord` klasse. Er is echter geen javadoc voorzien die uitlegt wat welke parameter doet. Voorzie javadoc bij alle publieke methodes. Dit moet ook mee worden verpakt in het `jar` bestand, zodat het ander project deze kan herkennen. Probeer uit te zoeken wat je hier voor moet doen in het `build.gradle` bestand.

### Opgave 4 (extra)

Genereer met behulp van Gradle van de [SESsy library](/teaching/ses/sessy) een dependency tree en inspecteer welke dpendencies transitief zijn en welke direct. 

## Denkvragen

- Hoe zou je transitieve dependencies handmatig kunnen beheren? Wat zijn de voor- en nadelen?
- Wat gebeurt er als project1-1.0 afhankelijk is van lib1-1.0 en lib1-2.0, en lib1-1.0 van lib2-1.0 - een oudere versie dus? 
- Heb je altijd test dependencies nodig? Wat gebeurt er met een test dependency, libtest-1.0, van lib1-1.0, als project1-1.0 afhankelijk is van lib1-1.0?
- Als ik publiceer naar een lokale folder, welke bestanden zijn dan absoluut noodzakelijk voor iemand om mijn library te kunnen gebruiken? 
