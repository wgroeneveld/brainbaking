---
title: 'Design Patterns: Factory'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## _"Factory"_ - Design Pattern

Begeleidende screencast:

{{< vimeo 398548507 >}}

### Doelstelling

* Scherm het aanmaken van bepaalde objecten af door middel van overerving en logica, waarbij die logica éénmalig wordt geïmplementeerd, en op een centrale plaats staat. 
* Promoot een _modulair_ model door de verantwoordlijkheid van object creatie en object gebruik te scheiden. 

[Dive Into Design Patterns: Factory (method)](https://sourcemaking.com/design_patterns/factory_method)

### Voorbeeld

#### 1. Opzet

Stel, je wilt aan de kassa van een niet al te grote lokale cinema een film kopen. Stel, de persoon aan de kassa beslist de film, gebaseerd op je leeftijd. Er spelen die avond drie filmen: een kindvriendelijke, eentje voor tieners, en eentje gereserveerd voor volwassenen. 

{{<mermaid>}}
graph TD;
    A{Ticket}
    B[FamilyFilm]
    C[TeenageFilm]
    D[XRatedFilm]
    E[TicketSeller]
    F[Person]
    A --> B
    A --> C
    A --> D
{{< /mermaid >}}

Waarbij een persoon een bepaalde leeftijd heeft:

```java
public class Person {
    private final int age;

    public int getAge() {
        return age;
    }

    public Person(int age) {
        this.age = age;
    }
}
```

En de ticket verkoper een ticket verkoopt aan een persoon:

```java
public class TicketSeller {

    Ticket buyTicketFor(Person person) {
        return null;
    }
}
```

#### 2. Probleemstelling

De logica voor het aanmaken van de juiste `Ticket` subklasse moet op één centrale plaats staan. De ticket verkoper is hier ideaal voor, waarbij met wat simpele logica gebaseerd op `person.getAge()` de juiste film kan worden aangemaakt. We noemen in dat geval de methode `buyTicketFor()` een **factory method**. 

#### 3. Oplossing

Door te controleren op leeftijd kan men de juiste instantie aanmaken en teruggeven. Dit is de verantwoordelijkheid van de ticket seller. Het voordeel is dat je als "gebruiker" van deze klasse, die de methode `buyTicketFor()` aanroept, je niet hoeft af te vragen wat er achter de abstracte klasse `Ticket` zit. Het is een ticket, de code kan verder lopen.

We kunnen dit nog verder drijven door de ticket verkoper zelf ook te laten aanmaken door een "factory" die bijvoorbeeld de medewerkers van diezelfde lokale cinema inhuurt. Persoon x verkoopt je tickets op basis van je leeftijd, en persoon y op basis van hoeveel geld je op zak hebt. 

### Eigenschappen van dit patroon

* Implementaties (van Ticket) zijn verborgen via de Factory Method.
* Logica voor creatie staat op één centrale plaats. 

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom).

### Opgave 1

Het project bevat bovenstaande voorbeeld, maar nog niet alles is geïmplementeerd. Voer de unit testen uit in `src/main/test`: het resultaat zijn gefaalde testen (ROOD). Zorg er voor dat alle testen slagen (GROEN) door het factory patroon te vervolledigen! 

### Opgave 2

De eerste aanzet is genomen om een nieuw type van `TicketSeller` aan te maken, door reeds een interface te voorzien. Ontwikkel een `MoneyBasedTicketSeller`, die gebaseerd op het geld in je portefuille je het juiste ticket bezorgt. Dit betekent dat je in `Person` dus een nieuwe property nodig hebt. Voorzie ook een nieuwe test klasse, gebaseerd op `AgeBasedTicketSellerTest`.

### Opgave 3

[sessy library](/teaching/ses/sessy): 

1. identificeer waar het mogelijk zou zijn om een factory patroon toe te passen. Welke verschillende implementaties delen een gelijke noemer? Waar staat mogelijks creatie logica (dubbel)?
2. Pas dit toe door een nieuwe klasse te voorzien die de Factory methode implementeert. Vergeet de unit testen niet! 

{{<mermaid>}}
graph TD;
    A{Ticket}
    B[FamilyFilm]
    C[TeenageFilm]
    D[XRatedFilm]
    E{TicketSeller}
    F[AgeBasedTicketSeller]
    G[MoneyBasedTicketSeller]
    A --> B
    A --> C
    A --> D
    E --> F
    E --> G
{{< /mermaid >}}

## Denkvragen

* Wat is het verschil tussen een factory en een [facade](/teaching/ses/facade) patroon? Wanneer heb ik het ene of het andere nodig? 
* Is er een mogelijkheid om [Dependency Injection](/teaching/ses/di) en de Factory te combineren, zodat het keyword `new` niet meer wordt gebruikt in de factory klasse zelf? 
