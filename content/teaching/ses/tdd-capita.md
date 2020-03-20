---
title: 'Test Driven Development met algoritmes: Capita Selecta'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## Test-First Een algoritme ontwerpen

Neem eerst de volgende noties terug door:

- [Test Driven Development](/teaching/ses/tdd) principes

Dit labo gaan we ons focussen op het praktisch gebruik van TDD en unit testen ter ondersteuning van het opbouwen van een algoritme, ter oplossing van een probleem. Alle TDD concepten zijn reeds uitgelegd in het [Test Driven Development](/teaching/ses/tdd) labo. We gaan onmiddellijk verder met de oefeningen:

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom). Lege projecten, maak zelf in een nieuwe map voor elke opgave een Gradle project aan. 

### Opgave 1

#### Deel A

Leo wil graag een boodschap versturen naar Marie, die aan de andere kant van de straat woont. Het probleem is dat Leo zijn berichten vaak worden onderschept door de vervelende buurman Jos. Jos moeit zich graag met het leven van anderen, waar Leo en Marie een stokje voor willen steken. 

Ze spreken telefonisch met mekaar af een gedeelde geheime sleutel te gebruiken om geschreven berichten te versleutelen, zodat Jos ze niet meer kan lezen. Dit gaat als volgt:

> Alle letters worden 3 posities naar rechts opgeschoven in het alfabet.

Dit wordt ook wel '_ROT-3_ encryption' genoemd. Enkele voorbeelden:

1. "jos is een loser" wordt "_mrv lv hhq orvhu_"
2. "Ik hou van jou, Marie!" wordt "_Ln krx ydq mrx, Pdulh!_"
3. "???" blijft "_???_"
4. "" blijft ""

Speciale tekens blijven ongewijzigd. 

Schrijf **eerst unit testen** voor alle mogelijke gevallen die je kan bedenken, gebaseerd op de voorbeelden, voor de methode `String encrypt(String s)`. Pas wanneer alle gevallen door testen zijn bedekt, mag je aan de implementatie beginnen. Re-run de testen tussendoor om jezelf ervan te verzekeren dat je vooruitgang boekt (RED-GREEN-REFACTOR).

#### Deel B

Na enkele dagen puzzelen heeft Jos ontdekt welk geheim systeem Leo en Marie er op na houden! Marie doet een voorstel tot verstrenging van het systeem, waar Leo onmiddellijk mee akkoord gaat. De extra regel geldt als volgt:

> Na de ROT-3 verwisselen we de posities voor elk paar karakters in het bericht. 

Enkele voorbeelden:

1. "jos is een loser" wordt "_rm vvlh qho vruh_"
2. "Ik hou van jou, Marie!" wordt "_nLk xry qdm xr ,dPlu!h_"
3. "???" blijft "_???_"
4. "?!?" wordt "_!??_"
5. "jup" wordt "_xms_"
6. "" blijft ""

Pas de testen aan en schrijf testen bij waar nodig. Verander dan pas de implementatie. Merk op dat bij een oneven aantal karakters, het laatste karakter niet van plaats wisselt.

#### Deel C

Nu de `encrypt()` methode correct werd geïmplementeerd, kunnen we ons bezig houden met de manier waarop het programma boodschappen in- en uitleest. Een systeem dat ook wordt gebruikt bij de [Vlaamse Programmeerwedstrijd](https://www.vlaamseprogrammeerwedstrijd.be/), is het inlezen via de standard input `stdin` en uitlezen via standard output `stdout`.  Je kan hiervoor het volgende gebruiken:

```java
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // ...
        System.out.println("output");
```

Lees in de [Scanner Javadoc](https://docs.oracle.com/javase/7/docs/api/java/util/Scanner.html) hoe je de volgende regels van `stdin` inleest. 

De input is een bestand (bewaren als `voorbeeld.invoer`) ([downloadlink](/teaching/ses/encryption-voorbeeld.txt)) dat er zo uit ziet:

<pre>
5
jos is een loser
Ik hou van jou, Marie!
???
?!?
jup
</pre>

De eerste regel beschrijft het aantal regels die versleuteld moeten worden. Voor elke regel dien je de `encrypt()` regels van deel B toe te passen. Dit wordt weggeschreven naar `stdout` met behulp van `System.out.println()`.

De output ziet er zo uit:

<pre>
1 rm vvlh qho vruh
2 nLk xry qdm xr ,dPlu!h
3 ???
4 !??
5 xms
</pre>

Elke regel begint met een volgnummer vanaf 1, voor elke versleutelde zin, gevolgd door een spatie. Vanaf dan volgt de versleutelde tekst, volgens dezelfde regels als deel B. 

Om het Java programma te kunnen draaien en testen kan je (in Unix) het inputbestand lezen via het pipe commando: `cat voorbeeld.invoer | java -cp . Main`. Vergeet niet het programma eerst te compileren met `javac Main.java`.

Valideer je programma aan de hand van de voorbeeld invoer hierboven. De unit testen van deel B kan je herbruiken. 

- Als het programma de verwachte output genereert, kan je je oplossing laten valideren tegen veel meer input: [download encryption-input.txt hier](/teaching/ses/encryption-input.txt).
- Als je zelf wilt kijken hoe deze input werd gegenereerd: [download EncryptionGenerate.java hier](/teaching/ses/EncryptionGenerate.java).


### Opgave 2

Kristien is een modebewuste vrouw die graag - en regelmatig - nieuwe schoenen koopt. Het probleem is van praktische aard: de schoenenkast geraakt te vol. Ze heeft de opdracht gegeven aan haar man om nieuwe schoenenkasten te bouwen met de juiste afmetingen. Op die manier is ze ervan overtuigd dat er nog wel een paar of twee aangeschaft kan worden (waar ze waarschijnlijk gelijk in heeft). 

Maak een Java programma dat uit de standard input `stdin` leest welke schoenen Kristien heeft. Het programma schrijft naar standard output `stdout` de uitkomst, namelijk wat de afmetingen van de kast zijn zodat alle schoenen netjes passen. Hanteer dezelfde methode als deel C van opgave 1.

De input is een bestand dat er zo uit ziet ([downloadlink](/teaching/ses/schoenen-voorbeeld.txt)):

<pre>
3
5
36
37
35
36
38
2
38
38    
2
36
36
</pre>

De eerste regel beschrijft het aantal kasten dat gevuld moeten worden. Voor elke kast dicteert de eerste regel het aantal schoenen, en de volgende regels de schoenmaat voor elke schoen in die kast. Bovenstaande input zegt dus: er zijn 3 kasten, in kast 1 zitten 5 schoenen met maat `36, 37, 35, 36, 38`, in kast 2 zitten 2 schoenen met maat `38, 38`, ...

Schoenen met exact dezelfde maat strikt kleiner dan maat 38 kunnen op elkaar geplaatst worden om plaats te besparen, met een maximum van 2. Dat betekent dat voor bovenstaand voorbeeld, de eerste kast er zo zou uit zien: `35, 36/36, 37, 38`. (De schoenen mogen dus verhuisd worden van volgorde)

De output ziet er zo uit:

<pre>
1 15x146
2 10x76
3 15x36
</pre>

Elke regel begint met een volgnummer vanaf 1, voor elke kast, gevolgd door een spatie. Vanaf dan volgen de afmetingen van de kast, gescheiden met 'x', waarvan bij kast 1 `15` de hoogte van de kast is (dit is altijd ofwel `10`, ofwel `15` als er schoenen op elkaar werden geplaatst), en `146` de lengte van de kast is. 

De lengte van de kast bereken je door de schoenmaten op te tellen: `35 + 36 + 37 + 38`. Maat `36` tellen we in de lengte maar éénmalig omdat ze op elkaar liggen. In de tweede kast moeten de schoenen naast elkaar liggen omdat ze te groot zijn, terwijl in de derde kast dit wel op elkaar kan. 

Om het Java programma te kunnen draaien en testen kan je (in Unix) het inputbestand lezen via het pipe commando: `cat voorbeeld.invoer | java -cp . Main`. Vergeet niet het programma eerst te compileren met `javac Main.java`.

Valideer je programma aan de hand van de voorbeeld invoer hierboven. Schrijf uiteraard eerst unit testen. 

- Als het programma de verwachte output genereert, kan je je oplossing laten valideren tegen veel meer input: [download schoenen-input.txt hier](/teaching/ses/schoenen-input.txt).
- Als je zelf wilt kijken hoe deze input werd gegenereerd: [download SchoenenGenerate.java hier](/teaching/ses/SchoenenGenerate.java).
