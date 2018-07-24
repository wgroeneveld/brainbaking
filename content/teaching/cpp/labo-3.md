---
title: 'Labo 3: Introductie in GBA Programming'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

Je hebt nu een crashcrusus C achter de kiezen met een grondige focus op pointers. Hoog tijd om die kennis om te zetten in iets concreet én plezant. We gaan een héél simpel Gameboy Advance (GBA) spel ontwikkelen.

De GBA is een goede keuze om de kracht (en zwakheden) van C te demonstreren. Er is immers géén besturingsyssteem aanwezig. Er zijn géén libraries aanwezig voor memory management, IO, files, error handling, ... Het is een embedded hardware systeem dat een _cross-compiler_ vereist: een compiler op onze PC's dat compileert voor een ander platform en CPU, namelijk een 32-bit [ARM](https://en.wikipedia.org/wiki/ARM_architecture) op 16.78 Mhz. 

<center>
    <img src="/img/teaching/gba.jpg" class="bordered" /><br/>
    Het resultaat van veel hard werk in C (en Assemly)...
</center>

## GBA Programming: een introductie

Om eender wat gedaan te krijgen op een GBA zullen we alles met [memory-mapped IO](https://en.wikipedia.org/wiki/Memory-mapped_I/O) moeten doen, door rechtstreeks bits weg te schrijven in geheugenadressen die zaken als het scherm, knoppen en het geluid voorstellen. Er is niet eens een `printf()` functie! In de plaats daarvan moeten we "hello world" tekenen op het scherm, wat véél meer werk vereist. 

Programmeren op een extern systeem brengt véél hardwarematige complexiteit met zich mee. We gaan hier niet alles behandelen. De geïnteresseerden kunnen hier terecht voor meer diepgaande tutorials:

* [http://www.loirak.com/gameboy/gbatutor.php](http://www.loirak.com/gameboy/gbatutor.php)
* [https://www.coranac.com/tonc/text/first.htm](https://www.coranac.com/tonc/text/first.htm)

Laten we het eenvoudigste eerst proberen: de achtergrond te kleuren. 

### Het geheugen layout van de GBA

Een duidelijk zicht op I/O adressen en hun functie zijn belangrijk. Adressen vallen in een range, afhankelijk van de grootte van het geheugen van elk systeem. Hieronder een kort overzicht ([bron](https://www.reinterpretcast.com/writing-a-game-boy-advance-game)):

1. `0x00000000 - 0x00003FFF` - 16 KB System ROM (executable, but not readable)
2. `0x02000000 - 0x02030000` - 256 KB EWRAM (general purpose RAM external to the CPU)
3. `0x03000000 - 0x03007FFF` - 32 KB IWRAM (general purpose RAM internal to the CPU)
4. `0x04000000 - 0x040003FF` - I/O Registers
5. `0x05000000 - 0x050003FF` - 1 KB Colour Palette RAM
6. `0x06000000 - 0x06017FFF` - 96 KB VRAM (Video RAM)
7. `0x07000000 - 0x070003FF` - 1 KB OAM RAM (Object Attribute Memory — discussed later)
8. `0x08000000 - 0x????????` - Game Pak ROM (0 to 32 MB)
9. `0x0E000000 - 0x????????` - Game Pak RAM

### Display setup

Er zijn 6 verschillende "Video Modes" beschikbaar die je moet aan- of uitzetten voordat je iets kan tekenen op het scherm. De GBA ondersteunt tilesets om sprites efficiënter te tekenen (de 3 laatste modes), maar wij hebben voorlopig genoeg aan pixel per pixel de kleur te zetten (de 3 eerste modes). De eenvoudigste mode zonder buffering is **video mode 3**. Dit heeft een resolutie van 240x160. Elke pixel RGB waardes om aan te spreken. 

Naast mode 3 moeten we ook een "Background mode" kiezen. Er zijn 4 achtergrond lagen beschikbaar die het mogelijk maken om een 3D illusie te creëren door laag per laag te tekenen. BG mode 2 volstaat voorlopig.

De video parameters worden weggeschreven in controleregister `0x4000000`. De combinatie van BG2 en Mode3 kunnen we met een bitwise operator `|` samen plakken, maar je kan evengoed de bits apart manipuleren. Om de cryptische registers wat te verduidelijken gebruiken we preprocessor defines.

```C
#define MODE3 0x0003
#define BG2 0x0400

volatile unsigned int *display_control = (volatile unsigned int*) 0x4000000;

int main() {
    *display_control = MODE3 | BG2;
}
```

Zie [Hardware Specifications](https://www.cs.rit.edu/~tjh8300/CowBite/CowBiteSpec.htm) documentatie.

Wat doet die `volatile` daar? Dit zijn low-level registeradressen die op eender welk moment door de hardware zelf veranderd kunnen worden. Het volatile keyword zegt tegen de compiler dat dit stukje code niet geoptimaliseerd mag worden. De compiler kan anders nog beslissen om instructies van volgorde te wisselen met vreemde werking tot gevolg. 

### Simpele display manipulatie

De vereiste display setup is gebeurd, laten we wat pixels wegschrijven in het scherm register op `0x6000000`:

```C
#define WIDTH 240
#define HEIGHT 160
volatile unsigned short *vram = (volatile unsigned short*) 0x6000000;

vram[80*WIDTH + 115] = 0x001F; // 000000000011111 = R
vram[80*WIDTH + 120] = 0x03E0; // 000001111100000 = G
vram[80*WIDTH + 125] = 0x7C00; // 111110000000000 = B

while(1);
```

Prachtig, een rode, groene en blauwe pixel opgelicht! 

VRAM is een (short, 16-bit) pointer naar een adres, om de X en Y coördinaten te bepalen gebruiken we een formule `vram[X*WIDTH +Y]`. De oneindige lus zorgt er voor dat het spel niet plots "stopt" - vergeet niet dat er geen OS is, dus zo'n gevaarlijke code moet zelfs op de GBA. 

Kleueren zijn binaire nummers. De hoeveelheid aan bits geeft ons een idee hoeveel unieke kleuren we hebben. De originele Gameboy had 2 bits: zwart, wit, en twee schakeringen van grijs tussenin. De GBA heeft er 15 (1 bit ongebruikt), met 5 bits per interval:

{{<mermaid>}}
graph LR;
    A[--] --- B[B]
    B --- C[B]
    C --- D[B]
    D --- E[B]
    E --- F[B]
    F --- G[G]
    G --- H[G]
    H --- I[G]
    I --- J[G]
    J --- K[G]
    K --- L[R]
    L --- M[R]
    M --- N[R]
    N --- O[R]
    O --- P[R]
    style B stroke:blue
    style C stroke:blue
    style D stroke:blue
    style E stroke:blue
    style F stroke:blue
    style G stroke:green
    style H stroke:green
    style I stroke:green
    style J stroke:green
    style K stroke:green
    style L stroke:red
    style M stroke:red
    style N stroke:red
    style O stroke:red
    style P stroke:red
{{< /mermaid >}}

Hexadecimale kleuren tekenen is onbegonnen werk natuurlijk, laten we een functie maken die de juiste bits shift afhankelijk van een R,G,B waarde van 0 tot 31 (`unsigned int`):

```C
unsigned short color(unsigned int r, unsigned int g, unsigned int b) {
    unsigned short c = (b & 0x1f) << 10;
    c |= (g & 0x1f) << 5;
    c |= (r & 0x1f);
    return c;
}
```

`Ox1f` verzekert 5-bits (`11111` binair), met eerst blauw, dan groen en dan rood op de juiste plaats geshift. 240x160 = 38.400 kleuren x 16-bit = 614.400 bits / 8 = 76.800 bytes. Adres `0x6000000` gaat dus tot `0x6012c00`.

Om niet altijd het adres rechtstreeks aan te spreken met de breedte berekening, wrappen we dat ook nog in een functie:

```C
void set_pixel(int x, int y, unsigned short color) {
    vram[x*WIDTH + y] = color;
}
```

Een loop over X en Y waardes van het scherm zorgt voor een vrolijke kleur op je Gameboy scherm. [Download het labo-3-gbabg.c hier](/teaching/cpp/labo-3-gbabg.c). Merk op dat dit pushen van pixel per pixel natuurlijk erg inefficiënt is: daarvoor zijn de tile video modes 0, 1 en 2.

Dit is wat je te zien krijgt:

<center>
    <img src="/img/teaching/mgba_output.png" class="bordered" />
</center>

## Keypad input

Oké, we hebben en "spel" geschreven met een blauwe achtergrond. Hoe passen we dit aan afhankelijk van een bepaalde toetsencombinatie? Volgens de GBA Keypad input [specificaties](http://www.akkit.org/info/gbatek.htm#gbakeypadinput) moeten we hiervoor IO register `0x04000130` uitlezen. 

Bit 6 staat bijvoorbeeld voor "up". [Geconverteerd van binary naar hex](https://www.binaryhexconverter.com/binary-to-hex-converter) levert `1000000` (6de bit op 1, beginnend vanaf 0) ons `40` op. We kunnen key up dus definiëren als `#define KEY_UP 0x0040`. Je kan ook dynamisch 6 bits shiften: `#define KEY_UP (1 << 6)`. Een derde mogelijkheid is in machten van 2 te werken (bits): `#define KEY_UP 64`.

Het is een goed idee om maar 1x tijdens de game loop alle key states uit te lezen. Een mask die alle input bits checkt is daarvoor nodig:

```C
#define KEY_ANY  0x03FF

int main() {
    unsigned int keys;
    while(1) {
        keys = ~*key_input & KEY_ANY;
        // do stuff
        if(keys & KEY_UP) {
            // do more stuff
        }
    }
}
```

Merk de `~` op: het register bewaart de state omgekeerd. 

## Compileren voor de GBA

De gcc compiler kan je C programma ook compileren - het is tenslotte in de C taal geschreven. De register adressen verwijzen echter niet naar het juiste als je die binary op je PC wil uitvoeren, wat resulteert in "Segmentation Fault" waarschuwingen. 

### De cross-compiler

De "DevkitPro" toolchain installeren levert je een aantal cross-compilers en linkers op die een C source file omzetten ine en GBA binary. Zie [installatie instructies](https://devkitpro.org/wiki/Getting_Started) per OS. Via de meegeleverde package manager `pacman` kan je op OSX de package `gba-dev` installeren. Voor Windows is er een installer voorzien. 

Je hebt 2 dingen nodig:

1. `arm-none-eabi-gcc`, de cross-compiler
2. `arm-none-eabi-objcopy`, de linker

[Download een Makefile voor gba dev hier](/teaching/cpp/labo-3-gba.Makefile). Pas je emulator pad en source bestandsnaam aan. 

### Je GBA file emuleren op PC

Compileren met een cross-compiler gaat, maar de binaries kan je nooit op een ander systeem draaien dan waarvoor het gecompileerd is - tenzij je dit emuleert. Een `.gba` binary kan je emuleren op de PC met [mGBA](https://mgba.io). 

### Je GBA file spelen op een echte Gameboy

De aanschaf van een [EZ-FLASH Omega](http://www.ezflash.cn/product/omega/) bord maakt het mogelijk om met microSD kaarten `.gba` roms in te laden op je Gameboy Advance. Zo'n cartridges bestaan al jaren: vroeger was EZ-Flash IV en Supercard populair. Tegenwoordig kan je met een SD adapter files drag- en droppen. 

<center>
    <img src="/img/teaching/gba_ezflash.png" class="bordered" />
</center>

Het plastieken omhulsel open gevezen geeft zicht op het bord:

<center>
    <img src="/img/teaching/ezflash.jpg" class="bordered" />
</center>

Dit is een deel van [labo 4](/teaching/cpp/labo-4) op de eigenlijke hardware:

<center>
    <img src="/img/teaching/gba_labo3.gif" style="width: 75%" class="bordered" />
</center>

Een EZ-FLASH Omega kaart kost ongeveer €30 op Ebay. Dit is uiteraard volledig vrijblijvend: een minimum vereiste is de werking van je creatie op een emulator. Een rom uitvoeren op de eigenlijke hardware kàn verrassend zijn; sommige emulatoren zijn flexibeler in werking. 

## Bits en bytes beter begrijpen in C

Om hexadecimale geheugenadressen en bit flags beter te begrijpen op de GBA moeten we ontdekken hoe bitwise operatoren, `sizeof()` en shifts werken in C. De implementatie van byte groottes wijzigt per computer maar is (bijna) altijd 8 bits: `00000000`. De GBA vereist vaak - zoals het definiëren van kleuren - 16 bits: 8x2. Die kracht van 2 is geen toeval in de binaire wereld. We gebruiken 3 types in zo'n embedded systeem: 

1. 8 bits: `typedef unsigned char uint8`
2. 16 bits: `typedef unsigned short uint16`
3. 32 bits: `typedef unsigned int uint32`

Elke individuele bit op `1` of op `0` zetten kan je doen met hulp van binaire of bitshift operatoren. Een 16-bit variabele kan in feite 16 individuele eigenschappen opslaan (die actief of inactief staan). In een moderne taal als Java, op een moderner besturingssysteem, speelt geheugengebruik op zo'n niveau geen rol meer. Daar definiëren we voor praktische redenen gewoon 16 aparte `boolean` variabelen. 

Op de GBA speelt geheugengebruik een zeer belangrijke rol en kunnen we met "bit masks" alle eigenschappen samen proppen in 2 bytes. Vergeet niet dat er bijvoorbeeld maar 96KB aan 16-bit VRAM beschikbaar is. De [technische GBA Memory Map](https://problemkaputt.de/gbatek.htm#gbamemorymap) pagina geeft weer hoeveel geheugen er bij welk IO adres beschikbaar is. 

[Download het voorbeeldprogramma hier](/teaching/cpp/labo-3-bits.c) om wat te experimenteren met deze gegevens. [Hex naar Binary](https://www.binaryhexconverter.com/hex-to-binary-converter) converters en [Wikipedia](https://en.wikipedia.org/wiki/Bitwise_operations_in_C) kunnen helpen. 

```
hoeveel bits zit er in ene byte hier? 8
sizeof BYTES unsigned short 2 - unsigned int BYTES: 4
sizeof BITS unsigned short 16 - unsigned int BITS: 32
sizeof arr8 uint32: 32

key right (1 << 4):             0000 0000 0001 0000
key right na nog 1 bitshift:    0000 0000 0010 0000
opgeteld met bitwise OR |:      0000 0000 0011 0000
inverse met bitwise ~:          1111 1111 1100 1111

x mask:                         0000 0001 1111 1111
y mask:                         0000 0000 1111 1111
```

## Labo oefeningen
<a name="oef"></a>

1. Vorm het voorbeeld in de tekst om naar een "hi!" hello world applicatie. Teken de symbolen per pixel. [Download het labo-3-gbabg.c hier](/teaching/cpp/labo-3-gbabg.c). [Download een Makefile voor gba dev hier](/teaching/cpp/labo-3-gba.Makefile). Probeer eerst het bestaande te compileren met `make`.
2. Laten we het iets dynamischer maken. Lees het key input register in en maak gebruik van de pijltjes om je "hi!" tekst te verschuiven. Wat een spannend spel is dit aan het worden! Definiëer het input register op exact dezelfde manier als `vram` in de tekst. 

## Denkvragen

1. Waarom denk je dat Video mode 3 inefficiënt is? Kan je een alternatief verzinnen en dit vergelijken met mode 3 in termen van werking? 
2. Nu je gezien hebt hoe we iets compileren voor een andere architectuur (`ARM` en niet `x86`), kan je ook een definitie geven van een _embedded system_? Hoe past een cross-compiler in dat plaatje? 
3. Wat gebeurt er met de output van het x en y mask als je in het bits voorbeeldprogramma in main `uint16 nr;` herdefiniëert als een `uint8`? Kunnen we dit om geheugen te besparen overal toepassen?