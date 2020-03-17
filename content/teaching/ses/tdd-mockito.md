---
title: 'TDD In de praktijk: Mockito'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>

Mockito is verreweg het meest populaire Unit Test Framework dat bovenop JUnit wordt gebruikt om heel snel Test Doubles en integratietesten op te bouwen. 

<center>
    ![Mockito logo](/img/teaching/ses/mockito.png)
</center>

Lees op [https://site.mockito.org](https://site.mockito.org) **hoe** je het framework moet gebruiken. (Klik op de knoppen **WHY** en **HOW** bovenaan! Volledige [javadoc](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)) Denk aan de volgende zaken:

- Hoe include ik Mockito als een dependency in mijn project?
- Hoe gebruik ik de API om een Test Double/mock aan te maken?
- Hoe valideer ik verwachtingen die ik heb van deze Test Double?

### Een interface 'mocken': the hard way

Zoals aangehaald in de [TDD noties](/teaching/ses/tdd) kan een eigen implementatie van een interface worden gemaakt die als Test Double werkt (denk aan Arnie's stuntman). Het vervelende is dat deze klasse enkel maar wordt gebruikt in test code, dus niet in productie code. Mockito maakt dit dynamisch aan, zonder dat er ooit het keyword `class` bij aan de pas komt. 

<center>
    <img src="https://wgroeneveld.github.io/tdd-course/img/testdouble.jpg" style="width: 75%; border: 1px solid black;" /><br/>
    <em>I'll Be Back.</em>
</center>

Stel, Arnold gaat acteren voor de nieuwe film **Die Hard: In A Deepen Beek** (uit in 2025 - Bruce had geen zin meer). Hij moet daarvoor een aantal fantastische stunts uithalen, die hij niet graag zelf zou doen. De volgende interface definieert een 'Arnold', waarbij `doBackFlip()` de gevaarlijke stunt is (resultaat is `true` indien geslaagd):

```java
public interface IllBeBack {
    boolean doBackFlip();
}
```

De casting crew en de director verwachten dat tijdens een opname 3x een backflip succesvol wordt uitgevoerd. Indien deze niet lukt, wordt de take opnieuw genomen. Dit manifesteert zich in code in de vorm van een `RuntimeException`. De One And Only Arnold had op dat moment een crisisvergadering in Californië en kon niet aanwezig zijn op de set. Gelukkig zijn er lookalikes en stuntmannen genoeg:

```java
public class ArnieLookalike implements IllBeBack {
    @Override
    public boolean doBackFlip() {
        return false;
    }
}

public class StuntmanArnie implements IllBeBack {
    @Override
    public boolean doBackFlip() {
        return true;
    }
}
```

Enkel `StuntmanArnie` is fysiek krachtig genoeg om consistent de backflip uit te voeren. De lookalike ziet er uit zoals Arnold, maar bakt jammer genoeg van de scene niet zo veel. Hieronder een blueprint van de opname code:

```java
public class DieHardInADeepenBeek {
    private IllBeBack arnoldActor;

    public void setArnoldActor(IllBeBack actor) {
        this.arnoldActor = actor;
    }

    public void recordActOne() {
        boolean succeeded = true;
        for(int i = 1; i <= 3; i++) {
            succeeded &= arnoldActor.doBackFlip();
        }

        if(!succeeded) {
            throw new RuntimeException("do that again, please...");
        }
    }
}
```

De hamvraag is nu: hoe testen we de **logica in `recordActOne`**? Daarvoor zal de backflip soms moeten lukken, en soms ook niet. We hebben dus zowel een `ArnieLookalike` als `StuntmanArnie` implementatie nodig:

```java
public class DieHardInADeepenBeekTests {
    @Test(ExpectedException = RuntimeException.class)
    public void recordActOne_backflipFails_haveToRedoTheWholeThing() {
        // 1. Arrange
        var movie = new DieHardInADeepenBeek();
        var actor = new ArnieLookalike();
        movie.setArnoldActor(actor);

        // 2. act
        movie.recordActOne();
        // 3. assert (in annotation)
    }

    @Test
    public void recordActOne_backflipSucceeds_ok() {
        // 1. Arrange
        var movie = new DieHardInADeepenBeek();
        var actor = new StuntmanArnie();
        movie.setArnoldActor(actor);

        // 2. act
        movie.recordActOne();
        // 3. assert
        assertTrue(true);
    }
}
```

### Een interface 'mocken': the easy way

In plaats van de `ArnieLookalike` en `StuntmanArnie` klasses zelf te maken, kunnen we hier Mockito het zware werk laten doen door gebruik te maken van de `mock()` methode. De testen worden dan lichtjes anders, omdat we daarin het gedrag van de mock eerst moeten bepalen voordat we naar de act en assert stappen kunnen gaan:

```java
public class DieHardInADeepenBeekTests {
    @Test(ExpectedException = RuntimeException.class)
    public void recordActOne_backflipFails_haveToRedoTheWholeThing() {
        // 1. Arrange
        var movie = new DieHardInADeepenBeek();
        var actor = mock(IllBeBack.class);
        when(actor.doBackFlip()).thenReturn(false);
        movie.setArnoldActor(actor);

        // 2. act
        movie.recordActOne();
        // 3. assert (in annotation)
    }

    @Test
    public void recordActOne_backflipSucceeds_ok() {
        // 1. Arrange
        var movie = new DieHardInADeepenBeek();
        var actor = mock(IllBeBack.class);
        when(actor.doBackFlip()).thenReturn(true);
        movie.setArnoldActor(actor);

        // 2. act
        movie.recordActOne();
        // 3. assert
        assertTrue(true);
    }
}
```

Het geheim zit hem in de `mock()` en `when()` methodes, waarmee we het gedrag van de mock implementatie kunnen aansturen. Dit werd vroeger manueel geïmplementeerd, maar die klasses zijn nu niet meer nodig. 

Lees op [https://site.mockito.org](https://site.mockito.org) **hoe** je het framework moet gebruiken. (Klik op de knoppen **WHY** en **HOW** bovenaan! Volledige [javadoc](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)) 

### TDD in een groter project

De [SESsy library](/teaching/ses/sessy) webapplicatie bevat ook unit-, integratie- en endtoend-testen die een meer 'real-life' omgeving simuleren met een grotere codebase. Zij die zoeken naar een beter begrip van het concept TDD en de implementatie ervan in de dagelijkse wereld, kunnen daar hun oren en ogen de kost geven. We moedigen tevens het wijzigen van testen aan om te kijken wat er gebeurt!

