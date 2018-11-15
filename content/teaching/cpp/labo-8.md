---
title: 'Labo 8: GBA Programming in C++: een abstractielaag'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

Het zal je ondertussen wel al duidelijk zijn dat technische details zoals IO pointers en OAM vanuit [labo 4](/teaching/cpp/labo-4) de code er niet bepaald duidelijker op maken. Jammer genoeg voorziet de GBA geen andere mogelijkheden. Een oplossing zal van de ontwikkelaar zelf moeten komen, in de vorm van de principes uit [labo 7](/teaching/cpp/labo-7).

## Abstracties creëren

Als ontwikkelaar wil ik niet altijd bezig zijn met de juiste hexadecimale waarde voor IO pointer aan te spreken om een sprite te renderen. Dit zou éénmalig voorzien moeten worden, en dan **herbruikbaar** moeten zijn. Herbruikbaarheid betekent:

1. In C: gebruik maken van `function`, `struct`
2. In C++: gebruik maken van `class` bovenop bovenstaande.

[De oplossing van labo 4](/teaching/cpp/labo-4-gba-2.c) voorziet methodes als `create_sprite` die zowel voor de bal, de paddle als de blokken aangeroepen kunnen worden. Omdat de OAM structuur té low-level is, voorzien we een abstractielaag: de functie geeft een `sprite*` struct terug die we zelf ontworpen hebben:

```C
typedef struct sprite {
    int x;  // position
    int y;
    int dx; // velocity
    int dy;
    uint8 w;  // dimensions (bvb simple hitbox detection)
    uint8 h;
    volatile oam_object *obj;
} sprite;
```

De sprite struct heeft een reference naar `oam_object*` vast. Dit noemt men "**wrapping**": de code kan niet rechstreeks aan het object maar moet met de sprite werken. In C zijn er geen mogelijkheden om dit te encapsuleren met een access modifier zoals C++' `private`.

Vergeet niet dat deze eigenschappen redundant zijn en geheugen innemen voor niets... In de OAM struct zitten eigenlijk in bepaalde bits diezelfde eigenschappen (x, y, w, h). De afweging tussen gebruiksgemak en geheugengebruik is in dit geval echter eenvoudig gemaakt. `sprite.x` is een pak eenvoudiger in gebruik dan `sprite.obj->attr1 | OAM_X_MASK`!

{{<mermaid>}}
graph TD;
  A[highlevel Sprite struct]
  B[lowlevel OAM struct]
  A --> |obj*|B
{{< /mermaid >}}

De waardes in de sprite manipuleren levert echter een synchronisatie probleem op: de GBA reageert enkel op het OAM geheugen dus we moeten beide waardes _in sync_ houden:

```C
void position(sprite *s) {
    volatile object *obj = s->obj;
    int x = s->x;
    int y = s->y;
    obj->attr0 = (obj->attr0 &  ~OAM_Y_MASK) | (y & OAM_Y_MASK);
    obj->attr1 = (obj->attr1 & ~OAM_X_MASK) | (x & OAM_X_MASK);
}
```

## De Gameboy Advance en C++

De devKit toolchain voorziet ook een C++ cross-compiler: `arm-none-eabi-gcc` wordt simpelweg `arm-none-eabi-g++`. _That's it!_ Je kan C++11 gebruiken en naar hartelust STL bibliotheken in de code verwerken in plaats van met `char*` "collecties" te moeten werken.

Echter... Er is geen enkel productiespel ooit uitgebracht op een cartridge dat in C++ geschreven is. Dit om de eenvoudige reden dat C++ een hoop overhead met zich meebrengt:

* De _footprint_ van een `.gba` ROM is véél groter in C++ door extra libraries
* De memory _footprint_ van een `class` t.o.v. een `struct` zou +/- 4 bytes extra zijn

Gezien de erg beperkte hardwaremogelijkheden van de GBA is het voor veel grote spellen praktisch gezien niet haalbaar om alles in C++ te schrijven. Trouwens ook niet in C: veel kritieke instructies in engines zijn nog in Assembly geschreven.

`ls -la` output:

<pre>
-rwxr-xr-x   1 jefklak  staff    8320 Jul 25 13:54 main_c.gba
-rwxr-xr-x   1 jefklak  staff   23328 Jul 22 20:36 main_cpp.gba
-rwxr-xr-x   1 jefklak  staff   24032 Jul 25 13:55 main_cpp_stl.gba
</pre>

De C++ ROM is 280% groter dan de C ROM, als je `<vector>` e.d. mee include zelfs 288% - van 8K naar 23K!

Voor Software ontwerp in C/C++ ligt de focus op **software ontwerp**, niet op performante algoritmes of hardware. Wij gaan dit "probleem" dus straal negeren en vanaf nu alles in C++ schrijven. Emulators hebben hier geen probleem mee, evenals de EZ-FLASH Omega ROM die ik gebruik om op echte hardware te draaien.

### Een minimale 2D sprite engine

Welke concepten hebben we nodig om een minimaal spel te ontwerpen dat met 2D sprites werkt (`MODE1`)? Neem de Arkanoid clone opnieuw als voorbeeld. Ook technische vereisten zoals deze kunnen in een analyse gegoten worden om de ontwerpfase van het ontwikkelen te vergemakkelijken:

<pre>
GBA001. Een minimale 2D sprite engine

Beschrijving:
Als programmeur wil ik niet bezig zijn met technische details van de GBA interface bij het ontwikkelen van een spel.
Ik wil eenvoudig sprites op het beeld kunnen toveren en deze kunnen manipuleren.

Context: Het moet mogelijk zijn om het gebruik van OAM en VRAM te vergemakkelijken.

Acceptatiecriteria:
- Ik wil als ontwikkelaar bij het boostrappen van het spel "sprite mode" kunnen kiezen.
- Ik wil makkelijk sprites kunnen toevoegen aan de hand van een externe image in jpg/png formaat zonder iets van het palet af te weten.
- Ik wil sprites kunnen verplaatsen op het scherm
- Ik wil eenvoudig kunnen zien of sprite 1 "botst" met sprite 2.
</pre>

Dit vraagt niet om een volledige herwerking van de opgave uit labo 4, maar om een abstractielaag in de vorm van klassen. Welke concepten kunnen we afleiden uit de analyse, of welke ontbreken er nog?

{{<mermaid>}}
graph TD;
  Z{GBA}
  A{SpriteManager}
  B{Sprite}
  C[OAM]
  D[Palet]
  E[ImageData]
  Z --> |setRenderer|A
  A --> |add<br/>1 op veel|B
  B --> |"collidesWith(other)"|B
  B --> |"move(x,y)"|B
  B -.-> C
  B -.-> D
  B -.-> E
{{< /mermaid >}}

Bovenstaand model kan afwijken van wat jij in gedachten had: hier is geen enkelvoudig antwoord op te geven, de enige vereiste is een laag tussen het gebruik van OAM, VRAM en de programmeur die als designer optreedt.

Denk bij het ontwerpen van een klasse na over eventuele logische operatoren die van pas kunnen komen. Het is niet de bedoeling om een hoop overrides te implementeren om te laten zien hoe goed je daar in bent: code wordt "_just-in-time_" geschreven: [YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it). Templates en abstracte klassen zijn ook niet altijd nodig.

Ga uit van het eenvoudigst mogelijke. Welke minimale elementen heb je absoluut nodig om de vereiste analyse tot een goed einde te brengen? Laat alle toeters en bellen achterwege en concentreer je op herbruikbaarheid en Clean Code.

## Image data importeren

Het OAM is gekoppeld aan een referentie naar het palet samen met een referentie naar het VRAM waar je je image data in de vorm van een "tileset" hebt opgeslagen. Voor de paddle voorzagen wij met een simpele for lus onze eigen tile data:

```C
    for(int i = 0; i < 4 * sizeof(tile_4bpp) / 2; i++) {
        paddle_tile[i] = 0x2222;
    }
```

In de praktijk wordt art aangeleverd door 2D artiesten die gespecialiseerd zijn in pixel art. Deze files moeten we vertalen naar hexadecimale waarden gegroepeerd in tileset en palet data.

Gegeven de volgende "pixel art":

<img src="/img/teaching/labo-8-kul.png" />

Herinner je dat OAM data vaste groottes hebben: we kiezen hier voor 64x32. Hoe verwerken we deze png in de ROM? Emulator screenshot:

<img src="/img/teaching/labo-8-kul-0.png" />

Daar hebben we [png2gba](https://github.com/IanFinlayson/png2gba) voor nodig, die de image omzet naar hexadecimale data. De [broncode van bovenstaande screenshot](/teaching/cpp/labo-8-kulsprite.c) verduidelijkt dit. Op de github pagina staan instructies om het tooltje te compileren.

1. Exporteer een header file: `png2gba -p -t img.png`
2. `#include <kul.h>`
3. Kopiëer data rechtstreeks naar VRAM met `memcpy`
4. Map palet en VRAM index op een OAM object zoals gezien in labo 4

```C
void copy_image_data() {
    memcpy(pal_fg_mem, kul_palette, sizeof(kul_palette));
    memcpy(&tile_mem[0][0], kul_data, sizeof(kul_data));
}
```

OAM attributes maken het eenvoudig om de image horizontaal of verticaal te _flippen_, bijvoorbeeld bij sprite animaties die naar links of naar rechts lopen. Transformatiematriches zijn nodig om te roteren.

Export tool [grit](https://github.com/eigerva/grit) geeft meer mogelijkheden, om bijvoorbeeld stukken van een palet te exporteren met `./grit piskel.png -p -gt -gB4 -ftc -pe 16` - zie [handleiding](http://www.coranac.com/man/grit/html/grit.htm). Maak op [piskelapp.com](www.piskelapp.com) je eigen pixel art.

### Een kijkje achter de schermen

Emulators zoals mGBA zijn krachtige tools voor de beginnende GBA ontwikkelaar om te graven in hun favoriete ROM. Ze bieden de mogelijkheid om tiles, palettes, sprites, geheugenwaardes, ... allemaal in te kijken. Een van mijn favoriete games is Castlevania: Aria of Sorrow. Ik kan met mGBA zien hoe de sprites zijn opgedeeld in het scherm.

Probeer aan de hand van deze animatie maar eens te bepalen welke sprites gebrukt worden, en welke achtergronden:

<img src="/img/teaching/aria-of-sorrow.gif" style="width: 100%" class="bordered" />

Herinner je uit labo 4 dat er 4 VRAM pointers naar achtergrond geheugen is: 4 char blocks. Bovenstaand spel creëert zo de illusie van diepte: verschillende achtergronden schuiven over elkaar met verschillende snelheden (kijk goed naar de maan).

<div class="row">
  <div class="col-md-6">
      <img src="/img/teaching/aria-of-sorrow-0.png" /><br/>
      Alles aan
  </div>
  <div class="col-md-6">
    <img src="/img/teaching/aria-of-sorrow-1.png" /><br/>
    Sprites (OAM) uit
  </div>
</div>


<div class="row">
  <div class="col-md-6">
    <img src="/img/teaching/aria-of-sorrow-2.png" /><br/>
    bg3 uit
  </div>
  <div class="col-md-6">
    <img src="/img/teaching/aria-of-sorrow-3.png" /><br/>
    bg2 uit
  </div>
</div>

Uiteindelijk stelt zo'n 2D platformspel niet zo veel voor op gebied van sprite engine. Er kunnen immers maar maximum 128 objecten tegelijkertijd in het geheugen opgeslagen worden. In Aria of Sorrow wordt dat opgelost met "tussenschermen": van area 1 naar 2 moet je door een soort van sluis. In de achtergrond wordt een hoop nieuwe data in alle IO adressen gepompt.

Het meeste werk ligt bij de artist. De screenshot linksboven toont de aanwezigheid van 2 personage sprites (Alucard en Soma) en 3 nummer sprites (Healthbar: 3, 2, 0). Toch klopt dit niet helemaal als je graaft in de mGBA sprite explorer:

<img src="/img/teaching/aria-of-sorrow-sprites.png" />

Soma bestaat uit 2x 64x32 OAM objecten! <br/>
Er zal dus ook een soort van OAM manager nodig zijn die beide sprites aan elkaar rijgt, zodat in de code en in het spel dit één sprite lijkt te zijn. Dit zijn nog [artefacten van de originele Gameboy](http://gbdev.gg8.se/wiki/articles/GBDK_Sprite_Tutorial).

## <a name="oef"></a>Labo oefeningen

1. Implementeer bovenstaande technische analyse in C++. Verterk vanuit een [modeloplossing](/teaching/cpp/labo-4-gba-2.c) van labo 4. Bedenk welke verplichte parameters nodig zijn om een sprite "in te laden". Test om te beginnen de C implementatie met de `gcc` compiler met behulp van de Makefile uit [labo 3](/teaching/cpp/labo-3-gba.Makefile).
2. Voorzie ook een `KeyManager` die inlezen van toetsen abstraheert. Werken met functie pointers als callback methodes is niet nodig.

## Denkvragen

1. Welke functies uit de opgave zou je _niet_ abstraheren in klassen maar voldoen aan een duidelijke naamgeving? Waarom zouden dezen wel in de global namespace mogen leven?
2. Wat als ik een sprite nodig heb die groter is dan 64x64? Wat zou de `SpriteManager` klasse moeten teruggeven bij het aanmaken van een "sprite" (niet een GBA sprite, maar de term die wij handhaven)?
