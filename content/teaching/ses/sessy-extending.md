---
title: 'SESsy Library WebApp'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

## SESsy Library Uitbreiden

**Lees eerst** [de installatieinstructies](/teaching/ses/sessy).

Met de SESsy Library WebApp kunnen verstokte lezers (en mensen die boeken nooit terugbrengen) de database van de lokale bibliotheek raadplegen, en eventueel boeken uitlenen. Het is een simpele webapplicatie met een embedded server die standaard op poort `8080` draait, met een minimale front-end interface:

<center>
    <img src="/img/teaching/ses/sessy.png" class="bordered" />
</center>

De codebase bevat echter nog heel wat lijntjes `TODO` commentaar die door de luie ontwikkelaars nooit zijn geïmplementeerd. Het is aan jullie om de applicatie verder af te werken, en deze tekortkomingen handig weg te werken. Uiteraard weten jullie ondertussen dat de twee hoekstenen van goede softwareontwikkeling _test-driven development_ en _design patterns_ zijn. Pas deze concepten ook bij het uitbreiden van deze applicatie toe. 

IntelliJ biedt hiervoor het "TODO window" aan (CMD-6 of CTRL-6). Elke regel commentaar die begint met `// TODO doe dit of dat` verschijnt automatisch in dit venster. 

### Opgave 1

Neem een kijkje in de klasse `BookLendService`. De uitleen- en teruggeeffuncties zijn sterk vereenvoudigd:

```java
public void lend(Book book, User user) {
    book.borrow();
}
```

Waarbij de `borrowed` flag op `true` of `false` wordt gezet. Er ontbreekt hier nog heel wat logica:

1. Mag de gebruiker die binnen komt als parameter dit boek wel uitlenen? In het geval van teruggeven, mag dat? Als die user `null` is - dus niet ingelogd - wat gebeurt er dan?
2. Moeten we valideren of het `book` object correct is - zijnde, is dat ISBN nummer wel aanwezig in onze database? Ik kan niet aan de lokale bib vragen een boek uit te lenen als het er nooit is geweest. Ik kan ook geen boek 'terugbrengen' om het cadeau te geven. 
3. Het veranderen van de staat van het object wordt momenteel niet gepersisteerd. Dat betekent dat de volgende keer als we zoeken naar boeken, plots het boek terug beschikbaar is. De `BooksRepository` interface moet dus worden aangesproken, maar die is momenteel nog niet geïnjecteerd. 

Voorzie ook een `BookLendServiceTests` klasse in de `src/test/java` map, in de juiste package subfolder. Denk na over het gebruik van unit- of integratietesten. Het spreekt voor zich dat je je implementatie best ook eens manueel, volledig geïntegreerd, test door de applicatie op te starten. 

### Opgave 2

De unit testen voor de klasse `BorrowBooksResource` zijn niet allemaal zuivere _unit_ testen: sommigen leunen ook op de implementatie van `BookLendService` (wat het eerder integratietestem maakt). De kans is groot dat enkele testen kapot zijn door de implementatie van opgave 1. De TODO in deze klasse spreekt voor zich: gebruik Dependency Injection om de service te injecteren. 

Mockito maakt het erg eenvoudig om dynamisch implementaties van interfaces te genereren, maar onze service is geen interface. Gewone klassen testen is minder evident voor het framework. Voorzie daarom een interface bovenop de standaard implementatie die de methodes `lend()` en `bringBack()` bevat, zodat we gedrag kunnen beschrijven in onze unit testen voor de borrow books resource. 

### Opgave 3

De gebruikersgroep '_slechte uitleners_' zijn echt, echt slecht. Ze luisteren nooit, en zorgen er nog ooit voor dat onze bibliotheek failliet gaat. We willen bij deze strengere maatregelen hanteren wat betreft het uitlenen van boeken:

1. Slechte Uitleners mogen nooit meer dan 2 boeken tegelijkertijd uitlenen. Dit is momenteel onmogelijk om na te gaan, want een boek bevat slechts een `boolean`. Dat wil zeggen dat we dan ook onze trouwe klanten, de goede uitleners, straffen. We kunnen een extra veld introduceren of de boolean veranderen van data type, zodat we weten elk boek wordt bijgehouden door welke gebruiker. 
2. Anoniempjes, dus de niet-ingelogde gebruikers, willen we een beperkte view op de database aanbieden. Reeds uitgeleende boeken mogen niet meer worden getoond in de resultaten van de zoek pagina. Welke klasse(n) dien je daarvoor te wijzigen? Welke edge cases (lees: testgevallen) kan je daarvoor verzinnen?

<center>
    <img src="/img/teaching/ses/sessy-uitgeleend.png" class="bordered" /><br/>
    <em>Dit uitgeleend boek mag niet meer verschijnen voor anonieme gebruikers.</em>
</center>

Vergeet niet dat wijzigingen in de `Book` datastructuur grote gevolgen hebben voor de rest van de applicatie! De database, aangedreven door `BooksRepository`, zal ook moeten wijzigen. Een `String` in Java is een `VARCHAR` in SQL. 

De front-end Javascript code gaat steeds uit van een `borrowed` flag die wordt gecontroleerd om de gele "uitgeleend" waarschuwing weer te geven. Je kan indien gewenst deze code in `Zoeken.vue` wijzigen, of de boolean laten staan en aan- of uitzetten naargelang de waarde van het nieuwe String veld. Bijvoorbeeld:

```java
public void setBorrowedBy(String user) {
    this.borrowedBy = user;
    this.borrowed = user != null ? true : false; // of lege String checken
}
```

Ik zeg altijd:

> `./gradlew test` is uw vriend!
