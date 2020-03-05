---
title: 'Test Driven Development'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

> <i class="fa fa-question-circle" aria-hidden="true"></i>
 Wat is de beste manier om het aantal bugs in code te reduceren?

## Test-Driven Development

TDD (Test-Driven Development) is een hulpmiddel bij softwareontwikkeling om minder fouten te maken en sneller fouten te vinden, door éérst een test te schrijven en dan pas de implementatie. Die (unit) test zal dus eerst **falen** (ROOD), want er is nog helemaal geen code, en na de correcte implementatie uiteindelijk **slagen** (GROEN). 

{{<mermaid>}}
graph LR;
    T{"Write FAILING<br/> test"}
    D{"Write<br/> IMPLEMENTATION"}
    C{"Run test<br/> SUCCEEDS"}
    S["Start Hier"]
    S --> T
    T --> D
    D --> C
    C --> T
{{< /mermaid >}}

Testen worden in opgenomen in een build omgeving, waardoor alle testen automatisch worden gecontroleerd bij bijvoorbeeld het compileren, starten, of packagen van de applicatie. Op deze manier krijgt men **onmiddellijk feedback** van modules die door bepaalde wijzigingen niet meer werken zoals beschreven in de test. 

### Een TDD Scenario

Stel dat een programma een notie van periodes nodig heeft, waarvan elke periode een start- en einddatum heeft, die al dan niet ingevuld kunnen zijn. Een contract bijvoorbeeld geldt voor een periode van _bepaalde duur_, waarvan beide data ingevuld zijn, of voor gelukkige werknemers voor een periode van _onbepaalde duur_, waarvan de einddatum ontbreekt:

```java
public class Contract {
    private Periode periode;
}

public class Periode {
    private Date startDatum;
    private Date eindDatum; 
}
```

We wensen aan de `Periode` klasse een methode toe te voegen om te controleren of periodes overlappen, zodat de volgende statement mogelijk is: `periode1.overlaptMet(periode2)`.

#### 1. Schrijf Falende Testen

Voordat de methode wordt opgevuld met een implementatie dienen we na te denken over de mogelijke gevallen van een periode. Wat kan overlappen met wat? Wanneer geeft de methode `true` terug, en wanneer `false`? Wat met lege waardes? 

- Het standaard geval: beide periodes hebben start- en einddatum ingevuld, en de periodes overlappen. 

```java
@Test
public void overlaptMet_biedePeriodesDatumIngevuld_overlaptIsTrue() {
    var jandec19 = new Periode(new Date(2019, 01, 01), 
            new Date(2019, 12, 31));
    var maartnov19 = new Periode(new Date(2019, 03, 01),
            new Date(2019, 11, 31));

    assertThat(jandec19.overlaptMet(maartnov19), is(true));
}
```

- Beide periodes hebben start- en einddatum ingevuld, en periodes overlappen niet. 

```java
@Test
public void overlaptMet_biedePeriodesDatumIngevuld_overlaptNietIsFalse() {
    var jandec19 = new Periode(new Date(2019, 01, 01), 
            new Date(2019, 12, 31));
    var maartnov20 = new Periode(new Date(2020, 03, 01),
            new Date(2020, 11, 31));

    assertThat(jandec19.overlaptMet(maartnov20), is(false));
}
```

- ... Er zijn nog tal van mogelijkheden, waarvan voornamelijk de extreme gevallen belangrijk zijn om **de kans op bugs te minimaliseren**. Immers, gebruikers van onze `Periode` klasse kunnen onbewust `null` mee doorgeven, waardoor de methode onverwachte waardes teruggeeft. 

De testen compileren niet, omdat de methode `overlaptMet()` nog niet bestaat. Voordat we overschakelen naar het schrijven van de implementatie willen we eerst de testen zien ROOD kleuren, waarbij wel de bestaande code nog compileert:

```java
public class Periode {
    private Date startDatum;
    private Date eindDatum; 
    public boolean overlaptMet(Periode anderePeriode) {
        throw new UnsupportedOperationException();
    }
}
```

De aanwezigheid van het skelet van de methode zorgt er voor dat de testen compileren. De inhoud, die een `UnsupportedOperationException` gooit, dient nog aangevuld te worden in stap 2. Op dit punt falen alle testen (met hopelijk als oorzaak de voorgaande exception).

#### 2. Schrijf Implementatie

Pas nadat er minstens 4 verschillende testen werden voorzien (standaard gevallen, edge cases, null cases, ...), kan aan met een gerust hart aan de implementatie worden gewerkt:

```java
public boolean overlaptMet(Periode anderePeriode) {
    return startDatum.after(anderePeriode.startDatum) && 
        eindDatum.before(anderePeriode.eindDatum);
}
```

#### 3. Voer Testen uit

Deze eerste aanzet verandert de deprimerende rode kleur van minstens één test naar GROEN. Echter, lang niet alle testen zijn in orde. Voer de testen uit na elke wijziging in implementatie totdat alles in orde is. Het is mogelijk om terug naar stap 1 te gaan en extra test gevallen toe te voegen. 

#### 4. Pas code aan (en herbegin)

De cyclus is compleet: red, green, refactor, red, green, refactor, ... 

Wat is **'refactoring'**?

> Structuur veranderen, zonder de inhoud te wijzigen. 

Als de `overlaptMet()` methode veel conditionele checks bevat is de kans groot dat bij elke groene test de inhoud stelselmatig ingewikkelder wordt, door bijvoorbeeld het veelvuldig gebruik van `if` statements. In dat geval is het verbeteren van de code, zonder de functionaliteit te wijzigen, een refactor stap. Na elke refactor stap verifiëer je de wijziging door middel van de testen. 

Voel jij je veilig genoeg om grote wijzigingen door te voeren zonder te kunnen vertrouwen op een vangnet van testen? Wij als docenten alvast niet.

## Unit Testing Basics

### Wat is Unit Testing

Unit testen zijn stukjes code die productie code verifiëren op verschillende niveau's. Het resultaat van een test is GROEN (geslaagd) of ROOD (gefaald met een bepaalde reden). Een collectie van testen geeft ontwikkelaars het zelfvertrouwen om stukken van de applicatie te wijzigen met de zekerheid dat de aanwezige testen rapporteren wat nog werkt, en wat niet. Het uitvoeren van deze testen gebeurt meestal in een IDE zoals IntelliJ voor Java, of Visual Studio voor C#, zoals deze screenshot:

<center>
    <img src="https://wgroeneveld.github.io/tdd-course/img/nunit.png"/><br/>
    <em>De visuele output van NUnit in C#.</em>
</center>

Elke validatieregel wordt apart opgelijst in één test. Als de `validate()` methode 4 regels test, zijn er minstens 4 testen geimplementeerd. In de praktijk is dat meestal meer omdat **edge cases** - uitzonderingsgevallen zoals `null` checks - ook aanzien worden als een apart testgeval. 

#### Eigenschappen van een goede test

Elke unit test is **F.I.R.S.T.**:

1. **Fast**. Elk nieuw stukje functionaliteit vereist nieuwe testen, waarbij de bestaande testen ook worden uitgevoerd. In de praktijk zijn er duizenden testen die per compile worden overlopen. Als elke test één seconde duurt, wordt dit wel erg lang wachten...  
2. **Isolated.** Elke test bevat zijn eigen test scenario dat géén invloed heeft op een andere test. Vermijd ten allen tijden het gebruik van het keyword `static`, en kuis tijdelijk aangemaakte data op, om te vermijden dat andere testen worden beïnvloed.
3. **Repeatable**. Elke test dient hetzelfde resultaat te tonen, of die nu éénmalig wordt uitgevoerd, of honderden keren achter elkaar. State kan hier typisch roet in het eten gooien. 
4. **Self-Validating**. Geen manuele inspectie is vereist om te controleren wat de status van de test is. Een falende foutboodschap is een duidelijke foutboodschap.
5. **Thorough**. Testen moeten alle scenarios dekken: denk terug aan _edge cases_, randgevallen, het gebruik van `null`, het opvangen van mogelijke `Exception`s, ...

### Het Raamwerk van een test

#### Test Libraries bestaande uit twee componenten

Een test framework, zoals JUnit voor Java, MSUnit/NUnit voor C#, of Jasmine voor Javascript, bevat twee delen: 

##### 1. Het Test Harnas

Een 'harnas' is het concept waar alle testen aan worden opgehangen. Het harnas identificeert en verzamelt testen, en het harnas stelt het mogelijk om bepaalde of alle testen uit te voeren. De ingebouwde Test UI in IntelliJ fungeert hier als visueel harnas. Elke test methode, een `public void` methode geannoteerd met `@Test`, wordt herkent als mogelijke test. Bovenstaande screenshot van NUnit in C# is een visuele weergave van de resultaten, verzameld door dit systeem.

Gradle en het JUnit harnas verzamelen data van testen in de vorm van HTML rapporten.

##### 2. Het Assertion Framework

Naast het harnas, die zorgt voor het uitvoeren van testen, hebben we ook een _verificatie framework_ nodig, dat fouten genereert wanneer nodig, om te bepalen of een test al dan niet geslaagd is. Dit gebeurt typisch met **assertions**, die vereisten dat een argument een bepaalde waarde heeft. Is dit niet het geval, wordt er een `AssertionError` exception gegooid, die door het harnas herkent wordt, met als resultaat een falende test. 

Assertions zijn er in alle kleuren en gewichten, waarbij in de oefeningen de statische methode `assertThat()` wordt gebruikt, die leeft in ` org.hamcrest.MatcherAssert`. Hamcrest is een plugin library die ons in staat stelt om een _fluent API_ te gebruiken in plaats van moeilijk leesbare assertions:

```java
@Test
public void testWithDefaultAssertions() {
    var result = doStuff();
    AssertEquals(result, 3);    // arg1: expected, arg2: actual
}
@Test
public void testWithHamcrestMatchers() {
    var result = doStuff();
    assertThat(result, is(3));
}
```

Het tweede voorbeeld leest als een vloeiende zin, terwijl de eerste `AssertEquals()` vereist dat als eerste argument de expected value wordt meegegeven - dit is vaak het omgekeerde van wat wij verwachten! 

[HamCrest Matchers API Documentation](http://hamcrest.org/JavaHamcrest/javadoc/)

#### Arrange, Act, Assert

De body van een test bestaat typisch uit drie delen:

```java
@Test
public void testMethod() {
    // 1. Arrange 
    var instance = new ClassToTest(arg1, arg2);

    // 2. Act
    var result = instance.callStuff();

    // 3. Assert
    assertThat(result, is(true));
}
```

1. **Arrange**. Het klaarzetten van data, nodig om te testen, zoals een instantie van een klasse die wordt getest, met nodige parameters/DB waardes/...
2. **Act**. Het uitvoeren van de methode die wordt getest, en opvangen van het resultaat.
3. **Assert**. Het verifiëren van het resultaat van de methode.

#### Setup, Execute, Teardown

Wanneer de **Arrange** stap dezelfde is voor een serie van testen, kunnen we dit veralgemenen naar een `@Before` methode, die voor het uitvoeren van bepaalde of alle testen wordt uitgevoerd. Op dezelfde manier kan data worden opgekuist na elke test met een `@After` methode - dit noemt men de _teardown_ stap. 

JUnit 4 en JUnit 5 verschillen hierin op niveau van gebruik. Vanaf JUnit 5 werkt men met `@BeforeEach`/`@BeforeAll`. Raadpleeg [de documentatie](https://junit.org/junit5/docs/current/user-guide/) voor meer informatie over het verschil tussen each/all en tussen v4/v5. Voorbeelden van JUnit 5 testen zijn terug te vinden in de [SESsy Library applicatie](/teaching/ses/sessy).

### Soorten van Testen

Er zijn drie grote types van testen:

<center>
    <img src="https://wgroeneveld.github.io/tdd-course/img/testniveaus.png" /><br/>
    <em>De drie soorten van testen.</em>
</center>

#### 1. Unit Testing (GROEN)

Een unit test test zaken op _individueel niveau_, per klasse dus. De methodes van de `Periode` klasse testen zijn unit testen: er zijn geen andere klasses mee gemoeid. De meeste testen zijn unit testen. Hoe kleiner het blokje op bovenstaande figuur, hoe beter de **F.I.R.S.T. principes** kunnen nageleefd worden. Immers, hoe meer systemen opgezet moeten worden voordat het assertion framework zijn ding kan doen, hoe meer tijd verloren, en hoe meer tijd de test in totaal nodig heeft om zijn resultaat te verwerken. 

#### 2. Integration Testing (ORANJE)

Een integratie test test het _integratie_ pad tussen twee verschillende klasses. Hier ligt de nadruk op _interactie_ in plaats van op individuele functionaliteit, zoals bij de unit test. We willen bijvoorbeeld controleren of een bepaalde service wel iets wegschrijft naar de database, maar het schrijven zelf is op unit niveau bij de database reeds getest. Waar wij nu interesse in hebben, is de interactie tussen service en database, niet de functionaliteit van de database. 

Typische eigenschappen van integration testen:

- Test geïntegreerd met externen. (db, webservice, ...)
- Test integratie twee verschillende lagen.
- Trager dan unit tests.
- Minder test cases.

##### Test Doubles

Stel dat we een `Service` en een `Repository` klasse hebben gemaakt, waarvan de tweede gegevens wegschrijft naar een database. Als we de eerste klasse willen testen, willen we niet weer een verbinding opstellen, omdat dit te traag is (1), én omdat dit al getest is (2):

```java
public class Repository {
    public void save(Customer c) {
        // insert into ... 
    }
}
public class Service {
    private Repository repository;

    public void updateCustomerWallet(Customer c, double balance) {
        c.setBalance(balance);
        repository.save(c);
    }
}
```

Hoe testen we de `updateCustomerWallet()` methode, zonder de effectieve implementatie van `save()` te moeten gebruiken? Door middel van _test doubles_.

<center>
    <img src="https://wgroeneveld.github.io/tdd-course/img/testdouble.jpg" style="width: 75%; border: 1px solid black;" /><br/>
    <em>I'll Be Back.</em>
</center>

Zoals Arnie in zijn films bij gevaarlijke scenes een stuntman lookalike gebruikt, zo gaan wij in onze code een `Repository` lookalike gebruiken, zodat de `Service` dénkt dat hij `save()` aanroept, terwijl dit in werkelijkheid niet zo is. Daarvoor moet de repository een interface zijn. We passen in principe een design pattern toe, waarbij in de service een repository instantie wordt geïnjecteerd:

```java
public interface Repository {
    void save(Customer c);
}
public class RepositoryDBImpl implements Repository {
    @Override
    void save(Customer c) {
        // insert into...
    }
}
public class RepositoryForTesting implements Repository {
    @Override
    public void save(Customer c) {
        // do nothing!
    }
}
public class Service {
    private Repository repository;
    public Service(Repository r) {
        this.repository = r;
    }
}
```

In de test wordt een instantie van `RepositoryForTesting` in service gebruikt in plaats van de effectieve `RepositoryDBImpl`. De test klasse _gedraagt_ zich als een `Repository`, omdat deze de betreffende interface implementeert. De `Service` klasse weet niet welke implementatie van de interface binnen komt: daar kan bij het integration testing handig gebruk van worden gemaakt.

Een werkend voorbeeld hiervan is terug te vinden in de [SESsy library applicatie](/teaching/ses/sessy). 

#### 3. End-To-End Testing (ROOD)

Een laatste groep van testen genaamd _end-to-end_ testen, ofwel **scenario testen**, testen de héle applicatie, van UI tot DB. Voor een webapplicatie betekent dit het simuleren van de acties van de gebruiker, door op knoppen te klikken en te navigeren doorheen de applicatie, waarbij bepaalde verwachtingen worden afgetoetst. Bijvoorbeeld, klik op 'voeg toe aan winkelmandje', ga naar 'winkelmandje', controleer of het item effectief is toegevoegd.

Typische eigenschappen van end-to-end testen:

- Test hele applicatie!
- Niet alle limieten.
- Traag, moeilijker onderhoudbaar.
- Test integratie van alle lagen.

Een werkend voorbeeld hiervan is terug te vinden in de [SESsy library applicatie](/teaching/ses/sessy).

De SESsy applicatie maakt gebruik van **WebDriver**, een interface die **Selenium** aanstuurt die browsers automatiseert. Op die manier kan men eenvoudig commando's doorsturen zoals surf naar daar, klik hier op, wacht x seconden, verifieer dat hier dat staat, ... Dit is één test scenario in totaal. 

<center>
    <img src="/img/teaching/ses/selenium.png" class="bordered" />
</center>

In plaats van dit in (Java) code te schrijven, is het echter ook mogelijk om de [Selenium IDE](https://selenium.dev/selenium-ide/) extentie voor Google Chrome of Mozilla Firefox te gebruiken. Deze browser extentie laat recorden in de browser zelf toe, en vergemakkelijkt het gebruik (er is geen nood meer aan het vanbuiten kennen van zulke commando's). Dit wordt in de praktijk vaak gebruikt door software analisten of testers die niet de technische kennis hebben om te programmeren, maar toch deel zijn van het ontwikkelteam. 

## <a name="oef"></a>Labo oefeningen

Download de startprojecten via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom). 

### Opgave 1

De Artisanale Bakkers Associatie vertrouwt op uw technische bekwaamheid om hun probleem op te lossen. 
Er wordt veel Hasseltse [Speculaas](https://en.wikipedia.org/wiki/Speculaas) gebakken, maar niemand weet 
precies wat de **beste** Speculaas is. Schrijf een methode die _speculaas_ beoordeelt op basis van de ingrediënten. 
De methode, in de klasse `Speculaas`, zou er zo uit moeten zien:

```java
    public int beoordeel() {
        // TODO ...
    }
```

De functie geeft een nummer terug - hoe hoger dit nummer, hoe beter de beoordeling en hoe gelukkiger de bakker. Een speculaas kan de volgende ingrediënten bevatten: kruiden, boter, suiker, eieren, melk, honing, bloem, zout. Elke eigenschap is een nummer dat de hoeveelheid in gram uitdrukt.

Het principe is simpel: hoe meer ingrediënten, hoe beter de beoordeling.

Kijk naar een voorbeeld test hoe de methodes te hanteren. Er zijn al enkele testen voorzien. Die kan je uitvoeren met IntelliJ door op het groen pijltje te drukken, of met Gralde: `./gradlew.bat test` (Op Unix: `./gradlew test`). Dit genereert een **test rapport** HTML bestand in de `build/test` map.

We zijn dus geïnteresseerd in **edge cases**. Probeer alle mogelijkheden te controleren. Denk bij het testen aan de volgende zaken:

- Hoe zit het met een industriële speculaas, zonder kruiden of boter? 
- Wat doet de funcite beoordeel als het argument `null` is?
- Wat als een speculaas wordt meegegeven zonder ingrediënten?

### Opgave 2

#### A. Misluke login pogingen

Er is een foutje geslopen in de login module, waardoor Abigail nog steeds kan inloggen, maar Jos plots niet meer. De senior programmeur in ons team heeft de bug geïdentificeerd en beweert dat het in een stukje _oude code_ zit, 
maar hij heeft geen tijd om dit op te lossen. Nu is het aan jou.

```java
import java.util.regex.Pattern;
import static java.util.regex.Pattern.CASE_INSENSITIVE;

public static boolean control(String username) {
    Pattern pattern = Pattern.compile("^(?=[a-z]{2})(?=.{4,26})(?=[^.]*\\.?[^.]*$)(?=[^_]*_?[^_]*$)[\\w.]+$", CASE_INSENSITIVE);
    return pattern.matcher(username).matches();
}
```

Deze functie geeft `true` terug als Abigail probeert in te loggen, en `false` als Jos probeert in te loggen. Hoe komt dit? Schrijf éérst een falende test!

#### B. URL Verificatie fouten

Een tweede bug wordt gemeld: URL verificatie features werken plots niet meer. Deze methode faalt steeds, ook al zijn er reeds unit testen voorzien. Het probleem is dat **HTTPS** URLs met een SSL certificaat niet werken. Je onderzocht de URL verificatie code en vond de volgende verdachte regels:

```java
import java.util.regex.Pattern;
import static java.util.regex.Pattern.CASE_INSENSITIVE;

public static boolean verifyUrl(String url) {
    Pattern pattern = Pattern.compile("http:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)", CASE_INSENSITIVE);
    return pattern.matcher(url).matches();
}
```

De code blijkt reeds **unit testen** te hebben, dus schrijf éérst een falende test (in `VerifierTests`).

### Opgave 3

Werk een volledige implementatie van `Periode.overlaptMet()` uit, zoals hierboven uitgelegd. 

### Opgave 4

Dit is een vervolgopgave van de code van **Opgave 1**. Werk verder op dat bestaand project.

Een verkoopster werkt in een (goede) speculaasfabriek. De verkoopster wilt graag 2 EUR aanrekenen per speculaas die de fabriek produceert. 
Echter, als de klant meer dan 5 stuks verkoopt, mag er een korting van 10% worden aangerekend. 

```java
    public double verkoop() {
        var gebakken = speculaasFabriek.bak();
        // TODO ...
    }
```

Je ziet aan bovenstaande code dat de speculaasfabriek instantie wordt gebruikt. We hebben dus eigenlijk **geen controle** op de hoeveelheid speculaas die deze fabriek produceert.

### Unit testen

Hoe kunnen we dan toch nog testen wat we willen testen? Mogelijke scenario's:

1. De fabriek produceert niets. De klant betaalt niets.
2. De fabriek produceert minder dan 5 speculaasjes. De klant betaalt per stuk, 2 EUR.
3. De fabriek produceert meer dan 5 stuks. De klant krijgt 10% korting op zijn totaal.

### Hoe controleer ik het gedrag van de fabriek?

Mockito is verreweg het meest populaire Unit Test Framework dat bovenop JUnit wordt gebruikt om heel snel Test Doubles en integratietesten op te bouwen. 

<center>
    ![Mockito logo](/img/teaching/ses/mockito.png)
</center>

Gebruik dus hiervoor Mockito, en injecteer een `mock(SpeculaasFabriek.class)` in de verkoopster (de setter is reeds voorzien). 

Lees op [https://site.mockito.org](https://site.mockito.org) **hoe** je het framework moet gebruiken. (Volledige [javadoc](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)) Denk aan de volgende zaken:

- Hoe include ik Mockito als een dependency in mijn project?
- Hoe gebruik ik de API om een Test Double/mock aan te maken?
- Hoe valideer ik verwachtingen die ik heb van deze Test Double?

### Opgave 5

Gebruik Selenium IDE om een test scenario op te nemen van de SESsy applicatie. Start deze eerst lokaal, en vertrek vanuit het localhost base address [http://localhost:8080/#/](http://localhost:8080/#/). Hanteer de volgende scenario's:

1. Als anoniempje, zoek op 'art', klik op detail, klik op uitlenen. Verifieer dat er een waarschuwingsboodschap verschijnt dat je niet kan uitlenen.
2. Als slechte uitlener, zoek op 'art', klik op detail, klik op uitlenen. Verifieer dat er een boodschap verschijnt dat het gelukt is, en dat de knop veranderde naar 'Terugbrengen?'. Klik op terugbrengen. Verifieer dat er een boodschap verschijnt dat het gelukt is. 
3. Als anoniempje, log in (een van beide rollen). Verifieer dat login naar logout verandert. Logout. Verifieer dat logout naar login verandert. 

**Bewaar dit scenario, opgenomen met de Selenium IDE, in bestand _opgave5.html_** in de root van deze repository. 

Je zal voor deze opgave dus de lokale [SESsy applicatie](/teaching/ses/sessy) moeten starten, en de Selenium (Google Chrome) plugin moeten installeren. 

## Denkvragen

- Wat doe je met opgenomen test materiaal in Selenium IDE? Hoe integreeg je dit in een build systeen? Met andere woorden, hoe zorg je er voor dat deze testen automatisch draaien, telkens er iets in de code wordt gewijzigd?
- Hoe vertaal je de Selenium IDE commando's naar WebDriver Java commando's?

## Extra leermateriaal

Lees de volgende artikels om een beter inzicht te krijgen in de capaciteiten van de Test-Driven benadering:

- [The Art of Agile Development: Test-Driven Development](https://www.jamesshore.com/Agile-Book/test_driven_development.html)
- [Benefits of TDD: Wikipedia](https://en.wikipedia.org/wiki/Test-driven_development)
- [Let's Play: TDD Screencasts](https://www.jamesshore.com/Blog/Lets-Play)
- [HamCrest Matchers API Documentation](http://hamcrest.org/JavaHamcrest/javadoc/)
- [Integration Testing: Mocks Aren't Stubs (Martin Fowler)](http://martinfowler.com/articles/mocksArentStubs.html)
