---
title: 'Labo x: Design Patterns: Singleton'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## _"Singleton"_ - Design Pattern

### Doelstelling

* Vermijd de mogelijkheid tot meervoudige instantiatie van een bepaalde klasse. Er kan altijd maar één bepaalde instantie van bestaan.
* Voorzie een eenvoudige manier om vanuit eender waar in de code toegang te verkrijgen tot die éne instantie.
* Encapsuleer logica om deze instantie aan te maken, moest code dit raadplegen en dit toevallig de eerste keer zijn (_lazy initialization_).

[Dive Into Design Patterns: Singleton](https://sourcemaking.com/design_patterns/singleton)

### Voorbeeld

#### 1. Opzet

Een klassiek voorbeeld van een Singleton patroon is een database connectie, omdat het beheren van diezelfde connecties door diezelfde klasse gebeurt. Stel dat we een website hebben gemaakt met een winkelwagentje. 

```java
public class ShoppingCart {
    private int amountOfItems; // and getters/setters
    private int totalMOney;    // ...
}
```

En de DB accessor:

```java
public class DBHandle {
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
        return new DBHandle().getShoppingCart();    // oops!
    }
}
```

#### 2. Probleemstelling

Tien gebruikers die op de site terecht komen wensen allemaal hun winkelwagentje te raadplegen. Er zijn maar twee DB connecties beschikbaar, dit opgelegd door de database zelf. Iemand moet die dus beheren (locken, vrijgeven, locken, ... - dit heet _database pooling_). 

Als we twee instanties van `DBHandle` maken, kunnen er plots 2x2 connecties open worden gemaakt naar de database. Die zal dit ook blokkeren, wat resulteert in 2 klanten die een crash ervaren, en twee die hun winkelwagen kunnen raadplegen zonder verdere problemen.

{{<mermaid>}}
graph TD;
    A[ShoppingResource Inst1]
    B[ShoppingResource Inst2]
    C[DBHandle Inst1]
    D[DBHandle Inst2]
    A -->|nieuwe instance| C
    B -->|nieuwe instance| D
{{< /mermaid >}}

De `getCart()` methode mag dus in geen geval telkens een nieuwe `DBHandle` aanmaken. 

#### 3. Oplossing

We hebben in dit geval een _singleton_ instance nodig:

```java
@Path("/shoppingcart")
public class ShoppingResource {
    @GET
    public ShoppingCart getCart() {
        return DBHandle.getInstance().getShoppingCart();
    }
}
```

Waarbij de klasse `DBHandle` wordt uitgebreid tot:

```java
public class DBHandle {
    private static DBHandle instance;

    public static DBHandle getInstance() {
        if(instance == null) {
            instance = new DBHandle();
        }
        return instance;
    }

    private DBHandle() {
    }

    public ShoppingCart getShoppingCart() {
        // SELECT * FROM ...
    }
}
```

{{<mermaid>}}
graph TD;
    A[ShoppingResource Inst1]
    B[ShoppingResource Inst2]
    C[DBHandle Inst]
    A -->|zelfde instance| C
    B -->|zelfde instance| C
{{< /mermaid >}}

Op die manier is het aanmaken van een `DBHandle` instance beperkt tot de klasse zelf, door de `private` constructor. In de statische methode wordt er eerst gecontroleerd of de instantie `null` is of niet. In principe zou er maar één keer tijdens de uitvoering van het programma de `new DBHandle()` regel worden uitgevoerd[^conc].

[^conc]: Dit klopt niet helemaal als we kijken naar concurrency problemen, waarbij twee gebruikers op exact hetzelfde tijdstip de methode aanroepen. Dit laten we buiten beschouwing voor dit vak.

### Eigenschappen van dit patroon

* Definiëer de enige instantie als een ontoegankelijke `static` variabele, die door één enkele `public static` methode wordt bewaakt.
* Singleton klassen hebben enkel een `private` constructor om te voorkomen dat dit nog elders kan worden aangemaakt.
* Er wordt meestal een `null` check gedaan, zodat de code die de getter aanroept dit niet opnieuw moet doen. Dit voorkomt onnodige duplicatie op verschillende plaatsen in de codebase. 

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom).

### Opgave 1

Hierin is bovenstaande voorbeeld verwerkt, maar nog zonder Singleton... Voer de unit testen uit in `src/main/test`: het resultaat zijn gefaalde testen (ROOD), omdat `DBHandle` verschillende keren wordt aangemaakt. Zorg er voor dat alle testen slagen (GROEN) door het singleton patroon te implementeren! 

### Opgave 2

Pas ook `ShoppingCartResource` aan naar een singleton. Is dat nodig om de database niet te overbelasten, als de andere klasse reeds een singleton is, of niet? 

### Opgave 3

[sessy library](/teaching/ses/sessy): 

1. identificeer welke klassen een kans maken om een Singleton te worden. Denk aan bovenstaande voorbeeld. 
2. Pas het patroon toe waar jij denkt dat het nodig is. 

## Denkvragen

* Dit patroon klinkt aanlokkelijk: eenvoudig, lost problemen op, dus waarom niet overal toepassen. Denk eens na over de verantwoordelijkheden van objecten. Waarom zou je zo veel mogelijk moeten **vermijden** om dit patroon toe te passen? Wie mag wel `DBHandle.getInstance()` aanroepen, en wie niet? 
* Wat gebeurt er als 10 mensen tegelijkertijd de eerste keer de `getInstance()` methode aanroepen? Hoe kunnen we dit oplossen? 
