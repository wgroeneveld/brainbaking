---
title: 'Een introductie tot design patterns'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

### Wat is dat, een patroon?

Patronen zijn voor het mensenlijk brein eenvoudig herkenbaar: we zien stukjes van iets die we al eens ergens anders gezien hebben. Blokjes op een bepaalde manier ingekleurd, gehaakte patroontjes van een dekbed, Fibonacci spiralen in bloemblaadjes en zaadjes, ... Wanneer we programmeren, geldt dit principe ook: blokken code die herbruikt worden om eenvoudige oplossingen te bieden voor complexe problemen. 

![](/img/teaching/creativepatterns.jpg "Een (creatief) patroon?")

Een _pattern_ is een herkenbaar en herhalende blok van eigenschappen die herbruikt kan worden. In het geval van softwareontwikkeling zijn patterns structuren in code die herbruikt worden om code eenvoudiger, beter leesbaar, en beter in onderhoud te maken. Deze structuren zijn in feite **pre-fab oplossingen** voor gelijkaardige problemen. 

#### Ingebouwde patronen

Een _constructor_ is een begrip in Java dat ook geclassificeerd kan worden als patroon, omdat het constant terugkomt bij de creatie van objecten en een hulpmiddel is dat een bepaalt probleem helpt oplossen: het voert stukjes code uit bij het aanmaken van een object.

```java
public class Appel {
    private int kcal;

    public Appel() {
        kcal = 160;
    }
}
```

Een nieuwe appel aanmaken, `Appel jonagold = new Appel();` stelt `kcal` automatisch gelijk aan `160`. Dit is uiteraard een ingebouwd principe dat deel uitmaakt van de programmeertaal zelf. Dit concept kunnen we verder doortrekken door patronen van oplossingen te maken die het ons makkelijker maakt om toekomstige gelijkaardige problemen aan te pakken. 

#### Model-View-Controller

Een van de meest populaire patronen is het Model-View-Controller (_MVC_) systeem. Dit patroon stelt dat om UI logica eenvoudig te scheiden van domein logica, men drie aparte lagen dient aan te maken. 

1. Het model, het belangrijkste, stelt ons domein voor: de objecten waar het om draait in de applicatie.
2. De view, de UI, is de presentatielaag die de gebruiker te zien krijgt als hij de applicatie hanteert. Achterliggend wordt er met model objecten gewerkt. 
3. De controller verbindt de UI met het model en onderliggende lagen. Events vanuit de UI worden hier bijvoorbeeld opgevangen. 

{{<mermaid>}}
graph TD;
    M[Model]
    V[View]
    C[Controller]
    C --> V
    V --> M
    C --> M
{{< /mermaid >}}

De controller kent zowel de view als het model. De view kent enkel het model. Het model kent niemand buiten zichzelf. Op die manier is het eenvoudig om in de applicatie te migreren naar nieuwe presentatie lagen, zoals van een typische client-server applicatie naar een moderne website, gehost op een (virtuele) server. Dit principe kan telkens opnieuw worden toegepast, voor ontelbare applicaties. Men spreekt hier dus van een herhalend patroon, dat kan helpen bij het oplossen van een probleem. 

### Types van patronen

Er zijn op elk niveau patronen in code te herkennen. Zoals de constructor aantoont, zijn er op niveau van de compiler en/of taal zelf verschillende patronen die we constant onbewust hanteren:

- klasse structuren
- constructors
- properties
- subklassen
- interfacing
- formatting
- threading
- ...

Dit zijn allemaal structuren die in elk programma terug komt. 

Op **applicatie niveau**, in de code zelf, zijn er eveneens talloze mogelijkheden. De meest populaire software engineering design patterns zijn beschreven in het boek [Design Patterns: Elements of Reusable Object-Oriented Software](https://en.wikipedia.org/wiki/Design_Patterns). <br/>
Op **enterprise niveau**, tussen applicaties in, onderscheiden we ook patronen, om bijvoorbeeld efficiënte te communiceren tussen verschillende partijen. Gegevensuitwisseling kan door middel van REST/SOAP/FTP/... Die vorm van berichtgeving is op zijn beurt weer _herbruikbaar_. 

Voor het vak Software Engineering Skills beperken we ons tot enkele voorbeelden van software design patterns op applicatie niveau. Een overzicht is terug te vinden op de [hoofdpagina van het vak](/teaching/ses). 

### Waarvoor staat het woord 'design'?

Het proces van idee tot software doorloopt verschillende stappen, in verschillende iteraties, waarvan één de _design_ stap:

{{<mermaid>}}
graph LR;
    I["Idee  "]
    D[Design]
    C[Code]
    T[Test]
    De[Deploy]
    I --> D
    I --> I
    D --> C
    D --> D
    C --> T
    C --> C
    T --> De
    T --> T
{{< /mermaid >}}

Nadenken over **het ontwerp** voordat je jezelf overgeeft aan het schrijven van code is een belangrijke stap, zoals we gezien hebben in het vak 'Software ontwerp in Java'. Tijdens het ontwerpen, of nadenken over de oplossing, houden ervaren ontwikkelaars ook al rekening met de welgende patronen. Het is dus belangrijk om te weten dat het gebruiken van patronen zich niet beperkt tot de code schrijven stap. 
