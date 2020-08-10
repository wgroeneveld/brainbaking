---
title: 'SES Taken in Java'
subtitle: '2de kans'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

Deze taken fungeren als vervanger voor taak 1, 2, 3 in eerste kans. Een alternatieve taak voor taak 4, 5 in functie van backtracking/verdeel en heers zal los hiervan **ook nog worden uitgedeeld**. Samen met onderstaande taken vormt dit opnieuw `50%` van de punten voor het vak in tweede kans. 

**Deadline**: Zie toldeo - vrijdag 14/08/2020, 12u 's middags.

### Opgave 1: TDD

ESA heeft een robot op Mars geplaatst om te zoeken naar de meest geschikte plaats om een marsbasis op te bouwen. De robot krijgt telkens een sequentie van instructies die leiden naar een nieuwe plaats. Elke instructie is een letter: `'S'` (stap vooruit), `'L'` (draai links) of `'R'` (draai rechts). 

Elke instructiesequentie komt in de buffer van de robot terecht en wordt, voor hij kan worden uitgevoerd, teruggestuurd naar de aarde om deze te controleren en te corrigeren. Er komen immers vaak communicatiefouten voor. De enige mogelijke correcties zijn verwisselingen binnen de buffer. ESA heeft ons gevraagd om een programma te schrijven om de nodige correcties te bepalen.  Een correctie wordt aangegeven door de plaatsen in de buffer waarvoor de inhoud moet verwisseld worden.  Daartoe worden de plaatsen in de buffer genummerd als A, B, C, ... 

Een correctie BF verwisselt de inhouden van plaats B en plaats F. Een rij correcties, bv. `ACBE`, verwisselt de inhouden van A en C, daarna de inhouden van B en E. Als er meerdere mogelijkheden bestaan om de ontvangen sequentie te
transformeren (enkel via verwisselingen!), neem dan de kortste (= minst aantal verwisselingen.) Bij een gelijk aantal verwisselingen neem dan de alfabetisch eerste (AB komt voor BA dus nemen we AB, een rij die begint met BD komt voor een rij die begint met DF.)

#### Invoer

De eerste regel van de invoer bevat het aantal te verbeteren instructies. Daarna volgen per geval telkens 2 regels. De eerste regel bevat de instructies die de robot ontvangen heeft  en de tweede regel bevat de correcte instructielijst. Beiden bevatten minstens 2 instructies en maximum 26 instructies. De enige instructies die kunnen voorkomen zijn `'S'`, `'L'` en `'R'`.

<pre>
3
SLSLSR
SSLLRS
SS
RR
SSLLRR
SSLLRR
</pre>

#### Uitvoer

Voor elk geval antwoord je met één enkele regel. Deze bevat het volgnummer van het testgeval, gevolgd door één spatie, gevolgd door:

- indien geen verwisselingen nodig zijn: _correct_;
- indien geen correctie mogelijk is: _onmogelijk_;
- anders: de verwisselingen die in de buffer moeten gebeuren (kleinst aantal verwisselingen, bij gelijk aantal alfabetisch eerste.)

<pre>
1 BCEF
2 onmogelijk
3 correct
</pre>

Elke regel begint met een volgnummer vanaf 1, gevolgd door ...

#### Formaat

Gebruik dezelfde techniek als in [TDD Capita Opgave 1C](/teaching/ses/tdd-capita) door met `Scanner` van `stdin` data in te lezen. De input **zal opnieuw worden gepiped** naar je programma. Indien dit niet compileert/evalueert of de output is niet in het juiste formaat, resulteert dit automatisch tot een gefaald resultaat. 

Voorzie voor elk mogelijk scenario dat jij kan bedenken voor de opgave **de juiste unit testen**. Deze zullen mee in rekening worden gebracht bij de evaluatie. 

Maak voor deze opgave een nieuwe Github repository en lever de URL naar je master branch in. 

### Opgave 2: Patterns

https://github.com/ReactiveX/RxJava bevat de publieke repository van RxJava:

> a Java VM implementation of Reactive Extensions: a library for composing asynchronous and event-based programs by using observable sequences.

De code is geschreven in Java 8+ en de build tool of choice is - raad eens? Gradle. Wie avontuurlijk is ingesteld kan deze repository clonen en compilen met de gekende gradle commando's. De codebase is groter dan een gemiddeld studentenproject, en groter dan onze SESsy library demo-applicatie. Toch zijn patronen snel te herkennen na het bestuderen van enkele bronbestanden. 

Het doel van deze opgave is een kort **verslag in PDF vorm** te schrijven van **exact 3 pagina's**, over drie ontdekte patterns die je érgens in de source submap [/src/main/java/io/reactivex/rxjava3/internal/schedulers](https://github.com/ReactiveX/RxJava/tree/3.x/src/main/java/io/reactivex/rxjava3/internal/schedulers) ontdekte. 

Wat moet er in het verslag zitten - _voor elke pagina_:

- De naam van het ondekte patroon (één van de vijf design patterns die deel uitmaken van deze cursus);
- Een referentie naar het bronbestand met lijnnummer(s), waar je dit vond;
- Een duidelijke verklaring waarom jij denkt dat dit het desbetreffende patroon is. 


#### Formaat

Lever exact één bestand aan, enkel in `.pdf` formaat, met exact drie pagina's, waarvan op elke pagina één herkend patroon wordt beschreven dat uit bovenstaande broncode komt, in subdir `schedulers`. 

De layout is onbelangrijk. Graag de schrijfstijl verzorgen. 
Het is niet nodig hiervoor een Git repository aan te maken. 
