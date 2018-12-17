---
title: 'Labo 1: Classificaties, gedrag en beschrijvingen'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in Java](/teaching/java)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## Classificaties van een ontdekkingsreiziger

Om tot de definitie van een `Class` - al dan niet in een programmeertaal als Java - te bekomen, denken we even terug naar **classificaties** waar het woord "class" ook in terug komt. Stel je voor dat je Charles Darwin bent, met het schip _The Beagle_ op ontdekkingsreis doorheen de wereld. In je reizen kom je verschillende vreemde, tot nu toe ongekende wezens tegen, die je op een of andere ingenieuze wijze tracht op te delen in verschillende categorieën - of classificaties. 

Geleedpotigen, viervoeters, zoogdieren, insecten, koudbloedig, warmbloedig, ... Dit zijn allemaal voorbeelden van diagrammen waar een heel aantal dieren in geplaatst kunnen worden. Op diezelfde manier kunnen wij ook tegen **objecten** in de programmeerwereld aan kijken, in plaats van dieren. 

Stel je voor dat wij een "Mens" classificatie hebben. Jos is een mens, maar Jaak natuurlijk ook. Beiden behoren tot deze categorie. 

{{<mermaid>}}
graph TD;
    A[Mens]
    B{Jos}
    C{Jaak}
    A --> B
    A --> C
{{< /mermaid >}}

In Java definiëren we een categorie, of een klasse, als volgt:

```java
class Mens {

}
```

`class` is het keyword dat gebruikt wordt om aan te duiden dat je op het punt staat een nieuwe categorie te definiëren. Het woord daarna is de naam van die categorie, altijd beginnend met een Hoofdletter. De "body" van de klasse, tussen `{` en `}` bevat eigenschappen van deze categorie - hier komen we later op terug. 

Jos en Jaak zijn twee Mensen. Het zijn dus **instanties** die elk hun eigen, unieke mensheid met hun mee dragen. In Java:

```java
var jos = new Mens();
var jaak = new Mens();
```

We schrijven: `var` (Maak een _variabele_ aan), "jos" (de naam - lokale variabelen beginnen altijd met kleine letter), is een nieuwe "Mens" _instantie_. Een variabele duidt aan dat dit een tijdelijke naam is voor "iets", die kan wijzigen. We kunnen op eender welk moment beslissen dat het label "jos" verwijst naar een nieuwe waarde met `jos = new Mens();` of zelfs `jos = jaak;`. Het begrip "jos", binnen je applicatie, kan wijzigen van interpretatie, en verwijst momenteel naar één mens in de groep van mensen. 

### Het vergrootglas van Charles

Charles beslist op een gegeven moment de Mens beter onder de loep te nemen, en ontdekt dat alle mensen blijkbaar twee handen en twee voeten hebben. Dit zijn _eigenschappen_ van de Mens, die we in de definitie van de klasse kunnen verwerken:

```java
class Mens {
    int aantalVoeten = 2;
    int aantalHanden = 2;
}
```

Hij kan echter in zijn reis geen enkele mens terugvinden waarvoor bovenstaande aantal niet 2 zou zijn.[^1] Sommige eigenschappen verschillen van mens tot mens: de lengte, het gewicht, de haarkleur. Sommige eigenschappen verschillen niet en zijn voor elke mens gelijk: een neus, twee handen, twee voeten.

```java
class Mens {
    static final int aantalVoeten = 2;
    static final int aantalHanden = 2;
    int lengte, gewicht;
}
```

Het keyword `static` betekent dat deze eigenschap gedeeld is over alle mensen. Het keyword `final` betekent dat deze variabele, niet meer variabel is: de waarde ligt vast, na initiële toekenning van de waarde 2. 

### Gedrag opmerken

Darwin is geen stommerik; zijn notities beschrijven niet enkel classificaties maar voornamelijk hoe dieren zich **gedragen**. Gedrag beschrijft hoe iets zou moeten werken, ook al weet je niet hoe dit intern exact in elkaar steekt. Ik eet als ik honger heb, en dan is mijn honger weg. Waar die honger vandaan komt, of welke chemische reacties in mijn maag voortkomen uit mijn maaltijd weet ik niet: ik weet enkel dat mijn honger dan stopt. 

Hetzelfde geldt voor de Giraf. Charles heeft de volgende bevindingen genoteerd:

1. Een giraf die eucalyptus eet, gaat dood
2. Een giraf die meer dan 2kg eet, wordt moe en reageert trager
3. Een giraf die minder dan 2kg eet, hervindt zijn energie en reageert sneller
4. Een giraf die niets eet, reageert helemaal niet meer. 

Dit kunnen we ook modelleren in Java.

```java
class Giraf {

}
```

Welke **acties** heeft Charles Darwin opgemerkt? Het _eten_ - dit is een _methode_ in Java termen. Een methode, of functie, is iets wat uitgevoerd kan worden, en input en/of output kan hebben. Een methode kan variabelen van de klasse - of andere klassen - wijzigen. Het eten heeft duidelijk invloed op de giraf: ze reageert sneller of trager. We identificeren dus de methode `eet()`.

```java
class Giraf {
    int snelheid = 2;
    boolean dood = false;

    void eet(String voedsel, int aantalInKg) {

    }
}
```

De implementatie van `eet()` kennen we niet: Charles heeft enkel van buitenaf **waarnemingen** genoteerd. Diezelfde waarnemingen kunnen we in Java in de vorm van Testen ook noteren:

```java
class GirafTest {
    @Test
    public void wanneerGirafEucalyptusEetGaatZeDood() {

    }

    @Test
    public void wanneerGirafMeerDan2KgEetReageertZeTrager() {

    }

    @Test
    public void wanneerGirafMinderDan2KgEetReageertZeSneller() {

    }

    @Test
    public void wanneerGirafNietsEetReageertZeNietMeer() {

    }
}
```

Deze testen worden in een aparte klasse, `GirafTest`, geschreven. De code wordt gescheiden van de implementatie, in aparte folders geplaatst:

<pre>
src/
  be/
    kul/
      Giraf.java
test/
  be/
    kul/
      GirafTest.java
</pre>

Deze testen dienen als vangnet wanneer we de eet methode implementeren, zodat we zeker geen dingen vergeten die vastgesteld werden. De IDE (IntelliJ, BlueJ, ...) maakt het mogelijk om deze testen uit te voeren, en die kleuren rood of groen: gefaald of geslaagd. Op die manier beschikken wij over **onmiddellijke feedback** tijdens de ontwikkeling van onze software. 

Wat zit er nu in de test methode? 

```java
    @Test
    public void wanneerGirafMeerDan2KgEetReageertZeTrager() {
        var giraf = new Giraf();
        giraf.eet("Eikenbladjes", 3);

        assertEquals(1, giraf.snelheid);
    }
```

Merk op dat we als voedsel type tekst meegeven en als hoeveelheid een getal in kg.

1. Maak een giraf instantie aan. De naam maakt niet uit, we noemen deze dus `giraf` met kleine letter. 
2. Roep de methode op die we willen testen, met de juiste argumenten. (Meer dan 2kg eten)
3. Controleer het gewenste resultaat. In dit geval reageert ze trager, dus zou de snelheid variabele verminderd worden (initiële waarde = 2).

Aangezien de `eet()` methode nog leeg is (`{}`), gaat deze test FALEN - de snelheid van de giraf blijft immers op 1 staan. Nadat alle testen (voor de juiste reden) gefaald zijn, kunnen wij als ontwikkelaar aan de slag om de vaststelling van Charles effectief te implementeren:

```java
class Giraf {
    int snelheid = 2;
    boolean dood = false;

    void eet(String voedsel, int aantalInKg) {
        if(aantalInKg == 0) {
            snelheid = 0;
        } else if(aantalInKg <= 2) {
            snelheid = 3;
        } else {
            snelheid = 1;
        }
    }
}
```

## Een wiskundig voorbeeld

Beschrijvingen van gedrag beperkt zich niet tot de dierenwereld of typische classificaties: dit geldt evenzeer voor abstracte begrippen! Eender welk stukje code kan beschreven worden in een aantal regels. Deze regels worden geïmplementeerd in de vorm van testen. 

Stel dat we een punt willen roteren rond een circel in een bepaald assenstelsel. We hebben nog geen idee hoe we dit moeten implementeren, maar we weten wel al waar dit punt zou uitkomen bij rotaties van 0, 90, 180, 270 en 360° gegeven een middelpunt en de coördinaten van een startpunt. 

<center>
    <img src="/img/teaching/java/circle.png" /><br/>
    <em>Een punt roteren rond een cirkel.</em>
</center>

Gegeven:

1. Assenstelsel van een scherm waarbij linksboven (0, 0) voorstelt.
2. Middelpunt C(5, 5) (in plaats van 0, 0)
3. Vertrekpunt D(5, 10): onderaan de y as op de tekening)

Met als initiële waarden:

* 0° = 360° rotatie: E(5, 10), dezelfde waarde als D. 
* 90° rotatie: E(10, 5). x-as verlengd, y-as halverwege.
* 180° rotatie: E(5, 0). 
* 270° rotatie: E(0, 5). 

Om deze vaststellingen in een test te kunnen gieten, hebben we een klasse en een actie daarop (roteren) nodig, voorgesteld als 2D vectoren:

```java
class Vector {
    int x, y;

    Vector(int x, int y) {
        this.x = x;
        this.y = y;
    }

    Vector rotateAround(Vector center, int degrees) {
        // return ??
    }
}
```

De methode `rotateAround` aanvaardt een middelpunt (C) en een aantal graden, en geeft een nieuwe `Vector` instantie terug. Merk op dat deze een _constructor_ methode bevat zodat het onmiddellijk toekennen van de x en y waarden vergemakkelijkt wordt: `var c = new Vector(5, 5);` - 1 statement, in plaats van deze 3: `var C = new Vector(); c.x = 5; c.y = 5;`.

De vastgestelde test cases met hun verwachte uitkomst:

```java
class VectorTest {
    Vector c, d;

    @Before
    public void setUp() {
        c = new Vector(5, 5);
        d = new Vector(5, 10);
    }

    @Test
    public void rotateZeroDegreesReturnsOriginal() {
        var e = d.rotateAround(c, 0);

        assertEquals(e.x, 5);
        assertEquals(e.y, 10);
    }

    @Test
    public void rotate360DegreesReturnsOriginal() {

    }

    @Test
    public void rotate90DegreesEndsRightOfOriginal() {
        var e = d.rotateAround(c, 90);

        assertEquals(e.x, 10);
        assertEquals(e.y, 5);
    }

    @Test
    public void rotate180DegreesEndsAboveOfOriginal() {

    }

    @Test
    public void rotate270DegreesEndsLeftOfOriginal() {

    }
}
```

Merk op dat C en D voor elke test case hetzelfde zijn. In plaats van deze telkens te herdefiniëren, opteren we hier voor een _instantie variabele_: een variabele gedeeld over de klasse `VectorTest`. Een lokale variabele kan enkel binnen één methode gebruikt worden (lokaal), zoals `var e`. 

Als de testen zoals verwacht allemaal falen, kunnen we beginnen met een oplossing te bedenken voor het rotatie probleem. Hierbij wordt een transformatiematrix gebruikt die vermenigvuldigd wordt met het verschil van D en C:

$$\begin{pmatrix}cos\theta & -sin\theta\\\ sin\theta & cos\theta\end{pmatrix}$$

Dit geeft ons:

\begin{align}
E_x & = cos\theta(D_x-C_x) - sin\theta(D_y - C_y) + C_x \newline
E_y & = sin\theta(D_x-C_x) + cos\theta(D_y - C_y) + C_y
\end{align}

In Java kan je `Math.cos(rad)` gebruiken om bijvoorbeeld de cosinus te berekenen. Vergeet niet graden om te vormen naar radialen met behulp van `Math.toRadians()`.

## <a name="oef"></a>Labo oefeningen

* Vervolledig de lege test implementaties. Controleer of je testen groen zijn door ze te laten uitvoeren door je IDE. 
* Vervolledig de `eet()` implementatie van de Giraf: de vaststelling dat eucalyptus planten dodelijk zijn is nog niet geïmplementeerd. Gebruik om twee strings met elkaar te vergelijken `stringVariabele.equals("string 2")`.
* Maak de `VectorTest` klasse aan en kopiëer de test cases. Vervolledig nu de `rotateAround()` methode met behulp van bovenstaande formule. (Afronden van `double` naar `int` is toegestaan)

## Denkvragen

* Kan je de volgende woorden verklaren:
    - instantie
    - variabele
    - klasse
* Wat is het verschil tussen een klasse definitie en een klasse instantie?
* Wat is het verschil tussen een instantie en lokale variabele?

[^1]: Dit klopt natuurlijk niet, we vereenvoudigen hier. 
