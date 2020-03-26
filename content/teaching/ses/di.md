---
title: 'Design Patterns: Dependency Injection'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## _"Dependency Injection (DI)"_ - Design Pattern

Begeleidende screencast:

{{< vimeo 398530942 >}}


### Doelstelling

* Promoot _modulariteit_ door afhankelijkheden te injecteren, zodat aparte modules eenvoudig inplugbaar zijn in andere productiecode. Op deze manier worden modules ook makkelijker tesbaar.
* Promoot _Inversion of Control_: een client die services aanroept zou niet mogen weten hoe services worden aangemaakt - deze zou moeten worden 'geinjecteerd'.

[Wikipedia: Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)

### Voorbeeld

#### 1. Opzet

Als we verder gaan op het voorbeeld van de [singleton](/teaching/ses/singleton), zien we dat een database handle nodig is om shopping cart gegevens op te halen. Hoe deze database wordt aangemaakt, daar heeft een typische API geen kaas van gegeten: daar komt meestal een connection string bij kijken met gebruikersnaam, wachtwoord, en IP adres naar de juiste DB server. 

De DB accessor:

```java
public class DBHandle {
    private String connectionString;

    // comes from some config file
    public DBHandle(String connectionString) {
        this.connectionString = connectionString;
    }

    public ShoppingCart getShoppingCart() {
        // SELECT * FROM ...
    }
}
```

Met als REST endpoint:

```java
@Path("/shoppingcart")
public class ShoppingResource {
    @GET
    public ShoppingCart getCart() {
        String conStr = ConfigurationManager.getConfig('dbconnection');
        return new DBHandle(conStr).getShoppingCart();
    }
}
```

#### 2. Probleemstelling

Elke Resource klasse die een `DBHandle` instance wenst, zal ook via de `ConfigurationManager` het constructor argument moeten ophalen, om een instantie te kunnen aanmaken. Dit is uiteraard **niet** de juiste manier en introduceert veel duplicatie. Nu is de shopping resource "in control", terwijl we in dat geval de Database de controle willen geven: **Inversion of Control** dus.

#### 3. Oplossing

Een mogelijke oplossing is een Singleton maken. Maar dan hebben we nog steeds:

```java
@Path("/shoppingcart")
public class ShoppingResource {
    @GET
    public ShoppingCart getCart() {
        return DBHandle.getInstance().getShoppingCart();
    }
}
```

Als we deze methode willen testen, door `getCart()` op te roepen, spreken we steeds de échte database aan, wat duidelijk niet het gewenste gedrag is. We willen in dat geval de database **injecteren**. Een tweede stap is om de implementatie te verbergen achter een interface. 

```java
@Path("/shoppingcart")
public class ShoppingResource {
    private final DBHandle dbHandle;

    public ShoppingResource(DBHandle handle) {
        this.dbHandle = handle;
    }

    @GET
    public ShoppingCart getCart() {
        return dbHandle.getShoppingCart();
    }
}
```

Nu weet deze klasse niet meer hoe hij de database aanmaakt: hij krijgt dit slechts toegeschoven via de constructor. Uiteraard hebben we het probleem verlegt: wie maakt deze resource klasse aan? Om dit probleem op te lossen zijn er typische Dependency Injection frameworks beschikbaar die objecten in een pool aanmaken en zo injecteren. Voorbeelden hiervan zijn:

- [Google Guice](https://github.com/google/guice)
- [Spring Framework](https://spring.io)

Als `DBHandle` een interface is, kunnen we op een eenvoudige manier een dummy implementatie maken en dit injecteren in de klasse ter test:

```java
public class DummyDBHandle implements DBHandle {
    public boolean called;
    @Override
    public ShoppingCart getShoppingCart() {
        called = true;
        return null;
    }
}

public class ShoppingResourceTest {
    @Test
    public void getCart_callsGetShoppingCartFromDb() {
        DummyDBHandle dbHandle = new DummyDBHandle();
        ShoppingResource resource = new ShoppingResource(dbHandle);
        resource.getCart();

        assertThat(dbHandle.called, is(true));
    }
}
```

Merk op dat de `connectionString` van de `DBHandle` ook via de constructor als argument wordt doorgegeven: dit is evenzeer een vorm van Dependency Injection. 

### Eigenschappen van dit patroon

* Geef de verantwoordelijkheid van het _aanmaken_ van een object af. Een instantie wordt geinjecteerd door middel van een constructor of setter. 
* Maak van objecten geïsoleerde(re) stukjes code die makkelijker testbaar zijn dan hard gekoppelde objecten. 

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom). 

### Opgave 1

* Er staan twee TODO items: verwijder eerst de `new DBHandle()` vanuit de resource klasse, en injecteer het via een constructor argument. Pas dan de unit test aan om de compile fouten te fixen.
* Gebruik een interface om bovenstaande `DummyDBHandle` in het project te introduceren. Dat wil zeggen, hernoem `DBHandle` naar `DBHandleImplementation`, en maak een nieuwe interface genaamd `DBHandle`. Nu kan je de tweede unit test zoals hierboven toevoegen. 

### Opgave 2

In plaats van manueel te injecteren, kunnen we deze zaken ook overlaten aan gespecialiseerde frameworks, zoals Google Guice. Bovenstaand project heeft als Gradle dependency een link naar Guice. Neem een kijkje in de `ShoppingCartGuiceResource` klasse, en probeer dit principe toe te passen op de andere resouce klasse. `@Inject` verzogt het DI systeem, zonder zelf ergens objecten aan te maken, behalve in de config klasse. 

Zie ook [Google Guice: getting started](https://github.com/google/guice/wiki/GettingStarted). 

### Opgave 3

[sessy library](/teaching/ses/sessy): 

1. Welke klassen worden reeds geïnjecteerd, en op welke manier? (Constructor injectie, setter injectie, ...)
2. identificeer welke klassen in een DI systeem kunnen worden opgenomen. 
3. Introduceer een DI systeem: hetzij door Google Guice te gebruiken, hetzij door zelf te injecteren. Waar wordt DI reeds toegepast?

## Denkvragen

* Dependency Injection kan via de constructor, via setters (of direct op het veld via reflectie). Wat zijn de voor- en nadelen van via de constructor te werken, ten opzichte van via setters? 
* Denk je dat de `GuiceConfigModule` klasse op termijn niet te groot en verwarrend wordt, als dit constant wordt uitgebreid met nieuwe instanties die geregistreerd worden bij Guice? Wat zou je dan doen om dit tegen te gaan? 