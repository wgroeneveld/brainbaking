---
title: 'Software Management Skills'
accent: "#008eb3"
disableList: true
---
&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## De chaos van het Werk

De technische kant van het ontwikkelproces is slechts één kant van de medaille. De keerzijde bestaat uit het werk beheren en beheersen, zonder ten prooi te vallen aan de grillen van de klant of de chaos van de organisatie ervan. 

Stel, een gemeente vraagt om een nieuwe website te ontwikkelen voor de lokale bibliotheek. Er wordt een vergadering ingepland met stafhouders om samen met jou te beslissen wat de vereisten zijn. Ze dachten aan een mooie visuele website (1) waar men ook on-line kan verlengen (2) en het profiel raadplegen (3). De website moet uiteraard de gebruiker laten weten of een boek is uitgeleend of niet (4), en nieuwe aanwisten verdienen een aparte pagina (5). Men wil kunnen inloggen met de eID (6), én met een speciale bibkaart (7). Een bezoek aan de bib zelf levert je nog meer eisen op: het personeel wilt immers de nadruk leggen op andere zaken dan de stafhouders. 

Hoe ga je te werk om dit te beheren en tot een succesvol einde te brengen? Er is een raamwerk nodig om:

1. Werk overzichtelijk in kaart te brengen
2. Werk in te schatten en op te delen in beheersbare deeltaken
3. Werk eenvoudig te kunnen verdelen
4. Werk zichtbaar te maken: wie met wat bezig is, wanneer het klaar is, ...
4. De klant in elke stap van het proces zo nauw mogelijk te betrekken

## A. Werk managen: Scrum

De alsmaar populair wordende term '_scrum_' komt vanuit de Amerikaanse sport rugby, waar men letterlijk de koppen bij elkaar steekt om nog een laatste peptalk uit te delen voordat de chaos van de wedstrijd zelf losbarst:

<center>
    <img src="/img/teaching/ses/scrum-rugby.jpg" style="width: 80%;" />
    <br/>Een 'Scrum' bespreking ([Bron](https://en.wikipedia.org/wiki/Scrum_(rugby))).
</center>

Het principe van deze coördinatie is gemuteerd naar de softwareontwikkeling, waar het Scrum framework een oplossing kan bieden voor ons beheer probleem, waarvan alle 5 bovenstaande punten van het probleem op een structurele manier worden aangepakt. 

### Een Werk 'raamwerk'

Een **agile software development** methodologie is een methodologie om snel te kunnen ingrijpen op veranderingen. Klanten zijn van nature erg wispelturig en weten vaak zelf niet goed wat ze willen. Daarom is een ontwikkelmethode die sneller van richting kan veranderen tegenwoordig veel waardevoller dan een log systeem waarbij veel analysewerk op voorhand wordt verricht, om daarna alles te ontwikkelen. Een voorbeeld van zo'n klassiek log systeem is het _waterval model_. Een voorbeeld van zo'n modern agile systeem is _scrum_.

De volgende Figuur representeert het Scrum principe in de technische wereld:

<center>
    <img src="/img/teaching/ses/scrum-swdev.gif" />
</center>

Het Scrum principe verdeelt de ontwikkeltijd in een aantal **iteraties**, waarbij een iteratie een vooropgestelde tijd is, meestal 14 of 30 dagen, die een vaste kadans bepaalt waarin teams software ontwikkelen. Elke iteratie gebeurt er hetzelfde: bepalen wat te doen binnen die iteratie, de ontwikkeling ervan, en het vrijgeven van een nieuwe versie van het al dan niet volledig afgewerkt product. 

De introductie van itererende blokken waar taken van de backlog worden genomen en verwerkt, biedt de mogelijkheid tot veranderen. Tussen elke iteratie in kan er worden bijgestuurd door functionaliteit op de (product) backlog te verwijderen, toe te voegen, of te wijzigen. 

#### 1. De Backlog

De _backlog_ is een grote lijst van zaken die moeten worden ontwikkeld voordat de klanten tevreden zijn (een '**story**''). Men begint met één grote _product backlog_ waar op een hoog niveau alle eisen in zijn beschreven. Voor elke sprint van x dagen (30 in de Figuur), beslist het team welke items van deze backlog naar de _sprint backlog_ worden verplaatst: dit zijn de zaken die het team denkt te kunnen verwerken in één sprint. 

Een product backlog bevat _stories_ die nog niet goed geanalyseerd en beschreven zijn, waarvan moeilijk te zeggen valt hoeveel werk dit effectief kost. Wanneer dit in een iteratie terecht komt, wordt dit nauwer bekeken door het team. De betere beschrijving leidt tot een accurate inschatting, en mogelijks zelfs meerdere backlog items. 

Het volgende filmpje verduidelijkt de rol van de backlog in het team: 

{{< youtube zEHHjNEiCtI >}}

#### 2. Taken

Een _sprint backlog_ item wordt typisch door ontwikkelaars nog verder opgesplitst in kleinere taken om het werk beter te kunnen verdelen. Bijvoorbeeld, de mogelijkheid tot inloggen met eID kan bestaan uit (1) authenticatiestappen en het inlezen van een kaart, en (2) het UI gedeelte waar de gebruiker mee interageert. Misschien beschikt al één teamlid over authenticatie kennis, maar nog niemand weet hoe de UI aan te pakken. In dat geval is taak (1) sneller gedaan dan taak (2). 

Als alle taken zijn opgesplitst, worden er **inschattingen** gemaakt van elke taak, ten opzichte van een _referentie taak_. Inschattingen zijn relatieve getallen in Fibonacci nummers: 1, 2, 3, 5, 8, ... Hoe moeilijker of groter de taak, hoe vaker teams verkeerde inschattingen maken, en hoe meer impact dit heeft op de planning, vandaar de snel groeiende nummers. De referentie taak heeft een vast nummer in de rij, zoals bijvoorbeeld `2`. Merk op dat dit nummer dus niets te maken heeft met een concreet aantal (uren, dagen) werk.

Stel dat een simpel loginscherm reeds werd ontwikkeld. Men schat dan de moeilijkhei van het authenticeren van eID in ten opzichte van het werk aan het loginscherm: zou dat veel minder werk kosten, of meer? Minder werk: `1`. Meer werk: veel moeilijker of een beetje? Veel: `5` of meer. Een beetje: `3`.

#### 3. Een iteratie

Elke iteratie bestaande uit bijvoobeeld 30 dagen kan een team een bepaald aantal ingeschatte punten verwerken, zoals `30`. Men kiest een aantal taken waarvan de som van de inschatting niet dit maximum overschrijdt, en men begint aan de iteratie. 

Elke dag is er 's morgens een **scrum stand-up**: een korte, rechtstaande vergadering, waarin iedereen vertelt:

1. Wat hij of zij gisteren gedaan heeft
2. Wat hij of zij vandaag gaat doen
3. Met welke problemen hij of zij kampt

Op die manier is onmiddellijk iedereen op de hoogte. Dit noemt men ook wel een _scrum_ meeting, geïnspireerd op de Rugby scrum. Als men merkt dat collega's problemen hebben kan er dan beslist worden om taken weg te laten, toe te voegen, enzovoort. 

### Werk visualiseren

Een van de belangrijkste redenen om voor een agile methodologie te kiezen als Scrum, is de mogelijkheid tot het **visualiseren** van werk. Een team van 6 mensen kan daardoor ten allen tijden in één oogopslag zien aan welke taken wordt gewerkt, welke taken/stories in de iteratie zijn opgenomen, en waar het schoentje knelt:

<center>
    <img src="/img/teaching/ses/scrumbord.png" class="bordered" /><br/>
    Het Scrumbord ([bron](http://agilecomplexificationinverter.blogspot.com/2013/11/elements-of-effective-scrum-task-board.html)).
</center>

Elke story wordt een '_swimlane_' toegewezen: een horizontale band, die wordt opgedeeld in een aantal kolommen. Wanneer alle taken van één story van links naar rechts zijn verhuisd, weet het team dat die bepaalde functionaliteit (de story) klaar is voor de eindgebruikers. De taken kunnen worden gecategoriseerd met behulp van kleurcodes (technische opzet, database werk, UI werk, scherm x, y, ...) De kolommen zelf variëren van team tot team. Een voorbeeld:

- (Task) Todo
- Doing (in progress in bovenstaande Figuur)
- To Review/To Test/Done

Een taak die van Doing naar Done wordt verschoven is daarom niet volledig afgewerkt. Het kan zijn dat de ontwikkeling af is, maar dit nog moet worden nagekeken door een technische collega (to review), of worden getest door de customer proxy (to test), of worden uitgerold naar een interne test- of acceptatieomgeving (to deploy). 

In het volgende filmpje komen verschillende implementaties van persoonlijke scrumborden aan bod, om je een idee te geven van de aanpasbaarheid van zulke borden:

{{< youtube ptezCdBTu6c >}}

Hier wordt het woord _kanban_ gebruikt om aan te geven dat werk wordt gevisualiseerd - maar niet noodzakelijk een deel is van agile softwareontwikkeling of van scrum. Zoals je kan zien is het dus ook een effectieve manier om voor jezelf TODO/DOING/DONE items (school taken, hobby's, ...) op te hangen en dus visueel te maken. 

## B. Teams managen: Rolverdelingen

Werk verdelen en managen is niet het enige sterkte punt van Scrum. Een efficiënt team opbouwen dat in staat is om verschillende rollen op te nemen is nog een van die punten. Om bovenstaande stories en taken als onderdeel daarvan zo goed mogelijk te kunnen afwerken, dient het werk verdeeld te worden. Hieronder volgt een kort overzicht van de vaakst voorkomende rollen.

### De Product Owner

Een Scrum team is sterk klant-georiënteerd, waarbij stories hoofdzakelijk het gevolv zijn van de vraag van de klant. Ook welke stories in welke iteratie worden opgenomen is het gevolg van de wil van de klant. In de praktijk heeft de klant, een ander bedrijf dus, nauwelijks tijd om het ontwikkelproces op de voet op te volgen. 

Daarom dat de _product owner_ (PO) die belangrijke taak van de klant overneemt. Een Product Owner is een domein expert van het ontwikkelbedrijf die het overzicht bewaart: hij of zij weet welke stories nog moeten volgen, kan wijzigingen laten doorvoeren, en kent het product vanbinnen en vanbuiten. De PO overlegt vaak met de klant zelf en vertegenwoordigt de belangen van de klant bij het ontwikkelbedrijf.

### De Customer Proxy

Stories zijn niet meer dan kleine briefjes waar in een paar zinnen staat beschreven welke grote blokken functionaliteit de klant verwacht. Voordat dit kan worden opgesplitst in deeltaken dient er een grondige analyse uitgevoerd te worden. Dit gebeurt door de _customer proxy_, vaak ook gewoon analist genoemd. 

De customer proxy is, zoals het woord zegt, een vervanger voor de klant, die expert is in bepaalde deeldomeinen. De Product Owner bewaart het overzicht op een hoog niveau, van het héle product, en de Customer Proxy is expert in bepaalde deeldomeinen. Ontwikkelaars en proxies discussiëren en beslissen vaak samen de werking van bepaalde delen van het product, waarbij de proxy de belangen van de klant hierin verdedigt. Er zijn typisch meerdere proxies aanwezig in één team, terwijl er maar één product owner is. 

### De Ontwikkelaar

Stories worden opgesplitst in taken door de proxy en ontwikkelaar, die de functionele en technische gebundelde kennis gebruiken om problemen op te delen in kleinere, en makkelijker verwerkbare, deelproblemen. De ontwikkelaar is verantwoordelijk voor de implementatie van taken, en kan daardoor taken van todo naar doing en done verhuizen op het scrumbord. 

### De Team leider

Ontwikkelen en analyseren loopt nooit van een leien dakje. Een leider zorgt er voor dat het team zo weinig mogelijk last heeft van eender welke vorm van afleiding. Dat betekent zowel te veel druk van de klant als mogelijke administratieve taken die het bedrijf eist van elke werknemer. Een goede team leider is een onzichtbare die er voor zorgt dat iedereen zijn werk kan doen. 

Een tweede taak van de team leider is het opvolgen van vooruitgang van de sprint. Het zou kunnen dat ingeschatte stories meer werk kosten dan initiëel gepland, of dat er een gaatje is om extra werk op te nemen. Dit wordt gevisualiseerd door middel van een '**burndown chart**', een grafiek die het aantal nog te behandelen taken afbeeldt op de resterende tijd in dagen of uren:

<center>
    <img src="/img/teaching/ses/burndown.png" /><br/>
    Een voorbeeld _burndown chart_ ([bron](https://de.wikipedia.org/wiki/Burn-Down-Chart)).
</center>

Pieken _boven_ de groene ideaallijn betekent onverwacht extra werk die niet werd ingepland, waarbij de team leider mogelijk moet ingrijpen. Dalingen _onder_ de groene lijn betekent vlot werk met mogelijkheid tot iets extra buiten de sprint. De team leider overlegt vaak met de Product Owner om de verwachtingen zo goed mogelijk bij de ideaallijn gealigneerd te krijgen. 

Trends in burndown charts evalueren is een belangrijke vaardigheid voor elk lid van het team. Iedereen kan in één oogopslag onmiddellijk zien of het team meer werk heeft gedaan dan initieel ingepland, nog op schema ligt, of erg achter hinkt. Pieken en dalingen in de grafiek zijn duidelijke tekenen van onder- of overschattingen van de story's. In bovenstaande grafiek krijgt het team bijvoorbeeld na dag 4 (X-as) een zware dobber te verwerken dat meer tijd kost dan eerst gedacht, die pas na dag 9 wordt opgelost. Tussen dag 11 en 15 verloopt alles op cruise snelheid - het gaat zelfs lichtjes beter dan verwacht. De grafiek 'remaining effort' is de belangrijkste.

<center>
    <img src="/img/teaching/ses/burndown2.png" /><br/>
    Een tweede voorbeeld _burndown chart_ ([bron](http://www.makhfi.com/Scrum/)).
</center>

Het effect is erg uitgesproken op de tweede grafiek. Op dag 3 valt het team volledig stil (de oorzaak is natuurlijk niet af te lezen, dit kan zowel liggen aan technische problemen als aan bijvoorbeeld ziekte van een aantal programmeurs), wat de scherpe piek verklaart. De rest van de iteratie zwoegt het team om het verloren werk in te halen, wat pas na dag 10 uiteindelijk bijna lukt. 

Deze informatie is erg belangrijk omdat het kan worden gebruikt om toekomstige sprints in te plannen. Grafieken worden ge-extrapoleerd om een betere inschatting te kunnen maken van het toekomstige werk. Een consistent goed presterend team - de remaining effort lijn ligt onder de remaining time - kan in de toekomst bijvoorbeeld meer werk aan binnen dezelfde iteratie. Het is dan aan de team leider om dit naargelang in te plannen.

_Lees meer over de burndown chart via het extra leermateriaal._

## <a name="oef"></a>Labo oefeningen

### Opgave 1

Een oefening in teamspirit en problem solving: [The Marshmellow Challenge](https://www.tomwujec.com/marshmallowchallenge). Vorm groepen van 3 tot 4 mensen. Elke groep krijgt exact _18 minuten_ om de challenge tot een goed einde te brengen. 

**Voor academiejaar 2019 - 2020**, gezien het afstandsonderwijs, vervalt de fysieke vorm van deze opgave. Bestudeer in de plaats daarvan het onderstaande filmpje van de auteur van The Challenge. Denk ondertussen na over de volgende thema's:

- Hoe werken team dynamics? 
- Wie zou je welke verantwoordelijkheden geven, moest je zelf The Challenge ondernemen? Waarom?
- Wat houdt een team tegen om een hogere toren te bouwen dan een ander team?

{{< youtube H0_yKBitO8M >}}

### Opgave 2

**Voor academiejaar 2019 - 2020** vervalt deze opgave in zijn geheel.

Werk in teams van 5 mensen: 1 product owner, 1 teamleider, 1 customer proxy, 2 ontwikkelaars. Er zijn twee sprints van telkens 30 minuten voorzien, die jullie kunnen inplannen naar eigen goeddunken. De docent fungeert als klant en zal jullie meedelen welk product dient ontwikkeld te worden. Denk aan de volgende stappen om het ontwikkelen tot een goed einde te brengen:

1. Verzin stories gebaseerd op de vraag van de klant. 
2. Schat stories in en verdeel ze in iteraties.
3. Knip stories op in taken, die op post-its op het scrumbord verschijnen. 
4. Werk taak per taak af. Houd de totale verlopen tijd per story bij om een ruwe burndown chart te kunnen schetsen. Dit helpt jullie bij de planning van de tweede iteratie.

Denk aan de juiste taken voor de juiste rollen! 

## Denkvragen

- Wat is het voordeel van taken of stories relatief ten opzichte van een referentiestory in te schatten, in plaats van een hoeveelheid in tijd zoals dagen of uren te gebruiken? 
- Wat is het verschil in taak tussen de Product Owner en de Customer Proxy?
- Hoe lang moet een ideale iteratie volgens jou zijn, in dagen? Beargumenteer.
- Waarvoor kan een burndown chart gebruikt worden? Bedenk minstens drie verschillende mogelijkheden en beargumenteer. 

## Extra Leermateriaal

- [Ken Schwaber, Jeff Sutherland: What is Scrum?](https://www.scrum.org/resources/what-is-scrum/)
- [Dusan Kocurek: Understanding the Scrum Burndown Chart](http://www.methodsandtools.com/archive/scrumburndown.php)
- [Martin Fowler: Agile Software Guide](https://martinfowler.com/agile.html)

