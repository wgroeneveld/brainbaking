---
title: 'Labo x: Design Patterns: Decorator'
accent: "#008eb3"
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## _"Decorator"_ - Design Pattern

### Doelstelling

* Voeg dynamisch functionaliteit toe als alternatief voor klassieke overerving. 
* Gedraagt zich zoals het stukje 'ingepakte' functionaliteit, maar voert extra handelingen uit. 
* Wordt in Java altijd via `interface` implementaties uitegevoerd.

[Dive Into Design Patterns: Decorator](https://sourcemaking.com/design_patterns/decorator)

### Voorbeeld

#### 1. Opzet

Stel dat we in een fabriek op plaats X een auto samenstellen. De wagen is een zeer eenvoudige Volkswagen Golf, zonder opties. Op een andere locatie, plaats Y, hebben wij als bedrijf ook fabrieken die sportauto's bouwen (Volkswagen Scirocco) en op plaats Z luxe wagens (Volkswagen Passat). 

```java
public interface Car {
    public void assemble(); // build stuff
}
```

Fabriek X:

```java
public class VWGolf implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget the steering wheel!");
    }
}
```

Fabriek Y:

```java
public class VWScirocco implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget lots of turbo!");
    }
}
```

Fabriek Z:

```java
public class VWPassat implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget all the leather!");
    }
}
```

{{<mermaid>}}
graph TD;
    A["VW Golf"]
    B["VW Scirocco"]
    C["VW Passat"]
    Z{Car}
    Z --> A
    Z --> B
    Z --> C
{{< /mermaid >}}

#### 2. Probleemstelling

De General Manager belt: hij meldt ons vrolijk dat we zijn opgekocht door Geely, een Chinese autofabriekant. De heren in China wensen een mooie combinatie te maken tussen langs de ene kant **luxe**, en langs de andere kant pure **kracht**. Een combinatie van de technologie van fabriek Y en Z, dus. Dit mag _enkel op aanvraag_ gebeuren, en is dus niet simpelweg een nieuwe variant van een VW assemblage, maar een dynamische combinatie, waarbij soms meer luxe en soms meer kracht wordt gevraagd. Dat hangt natuurlijk van de klant af. 

We zullen dus een custom optie voorzien:

{{<mermaid>}}
graph TD;
    A["VW Golf"]
    B["VW Scirocco"]
    C["VW Passat"]
    D["Custom Car Decorator"]
    Z{Car}
    Z --> A
    Z --> B
    Z --> C
    B --> D
    C --> D
{{< /mermaid >}}

#### 3. Oplossing

Deze custom oplossing is nog steeds een implementatie van de interface `Car`:

```java
public class CustomCarDecorator implements Car {
    private final List<Car> carsToAssemble;

    public CustomCarDecorator(Car... carTypes) {
        this.carsToAssemble = Arrays.asList(carTypes);
    }

    @Override
    public void assemble() {
        for(Car car : carsToAssemble) {
            car.assemble();
        }
    }
}
```

Op deze manier kunnen we zoveel auto types als de klant wenst doorgeven aan de `CustomCarDecorator` instantie, die netjes in de bestaande fabriek logica past, gegeven de volgende fabriek klasse:

```java
public class Factory {
    public Car create(Car car) {
        car.assemble();  // works, since it's an interface
        paint(car);
        return car;
    }

    private void paint(Car car) {
        System.out.println("painting...");
    }
}
```

Dit werkt enkel en alleen omdat we met een **interface** werken! 

### Eigenschappen van dit patroon

* Een Decorator verandert het contract van de interface niet. De interface wordt uitgebreid, zijnde dat bovenstaande `CustomCarDecorator` extra dingen doet ten opzichte van de standaard VW Golf/andere implementaties. 
* Een Decorator kan je gebruiken om extra functionaliteiten toe te voegen zonder aan de klasse structuur grote wijzigingen door te voeren. Gebruik hiervoor, zoals de `List<Car> carsToAssemble` member variable, **Compositie**, en niet **Inheritance**. 
* Een Decorator verandert de flow van de functionaliteit niet: dat doet een _Strategy_ - een decorator voorziet enkel een ander uitzicht. Denk aan een doos in een doos stoppen: daar kan ook stiekem nog een extra doos in worden geplaatst. Maar het blijven dozen.

## <a name="oef"></a>Labo oefeningen

* [Download het IntelliJ decorator-oef1.zip project hier](/teaching/ses/decorator.zip). Dit bevat bovenstaande wagenpark voorbeeld. Hier dien je de volgende dingen nog aan te wijzigen:
    - Voorzie in de `main()` methode een nieuwe decorator instantie en geef die mee met de factory. Kijk in de output wat er gebeurt.
    - Maak een nieuwe auto implementatie aan, `VWPolo`. Geef de decorator een Golf en Polo mee. Nu maken we plots iets hoger niveau budget wagens!
    - Voorzie een eigen, statische decorator klasse, genaamd `PoloGolfDecorator`, die altijd bovenstaande wagens (Polo en Golf) combineert. Wat zit er in de klasse? Hoe implementeer je `assemble()`?
* Werk verder op oef1: bouw een nieuwe `Factory` in Zweden. Deze Factory in Zweden kan veel meer kleuren op het chassis spuiten dan de klassieke Factory. (Verzin iets anders in het `println()` statement). Wat als een klant een combinatie van deze factory, en de klassieke wenst? Maak een Decorator voor de factories in plaats van de wagens. Test deze in de `Main` klasse.

## Denkvragen

* Stel dat de klant altijd een combinatie van twee bepaalde auto's wenst. Wanneer beslissen we om dit permanent op te nemen in ons repertroire, en er een "echte" subklasse van te maken, en wanneer houden we het nog op een decorator? 
* Op welk patroon trekt dit patroon nog? Waarom? Zie [/teaching/ses](labo noties index) pagina.
* Kan je dit ook zonder interfaces doen? Denk na over implementaties in andere programmeertalen. 
