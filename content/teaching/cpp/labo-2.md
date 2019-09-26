---
title: 'Labo 2: Pointers in C en C++'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

In onderstaande schematische voorbeelden zijn de volgende concepten expliciet te onderscheiden:

1. Een **naam** van een variabele
2. Een **waarde** van een variabele

En de volgende impliciet:

1. Het **type** van een variabele
2. Het **adres** van een variabele

Het **type** van een variabele bepaalt de hoeveelheid geheugen die vrijgemaakt wordt om de waarde te kunnen bewaren. De waarde is ofwel een actuele waarde ofwel een adres dat refereert naar een andere waarde. Elke variabele heeft een uniek adres. Variabelen kunnen dus naar elkaar verwijzen.

{{<mermaid>}}
graph TD;
    A[variabelenaam<br/>waarde]
    B{variabelenaam<br/>adres}
{{< /mermaid >}}

Dit voorbeeld visualiseert `int a = 5`:

{{<mermaid>}}
graph TD;
    A[a<br/>5]
{{< /mermaid >}}

Waarbij het type, `int`, afhankelijk van het platform een aantal bytes reserveert (`sizeof(int)`) op een bepaald adres. Het adres kunnen we zelfs manipuleren in C/C++ en is essentiëel voor het gebruik van onder andere arrays.

## "Compound" types

C/C++ gebruikt een _pass-by-value_ systeem om variabelen door te geven aan functies. Dit wil zeggen dat de waarde gekopiëerd wordt, en die functie geen wijzigingen kan aanbrengen aan de originele waarde. Dat is iets positief: **separation of concerns**.

Als we denken aan ons persoon voorbeeld van [labo 1](/teaching/cpp/labo-1), wordt die struct dus telkens overgekopiëerd. Dat kan zeer inefficiënt zijn, naargelang de grootte van de data! Om dit te vermijden, gebruiken we een "pointer": een referentie naar de actuele data. Objecten worden in Java standaard _pass-by-reference_ meegegeven - in C moeten we hier nog iets extra voor doen dus.

In plaats van `is_oud(struct Persoon persoon)` wordt de signatuur `is_oud(struct Persoon* persoon)`. Om hier een waarde uit te lezen hebben we twee mogelijkheden:

1. De pointer _"dereferencen"_: de eigenlijke waarde opvragen, achter de referentie.
2. Via de pointer de members van de struct opvragen met "`.`".

Omdat in C de `.` operator voorrang heeft op `*`, moeten we haakjes gebruiken voor optie twee: `(*persoon).leeftijd`. Dat is vervelend om constant te gebruiken, daarom is er een alternatieve syntax met de arrow `->` operator: `persoon->leeftijd`.

In Java spreek je members natuurlijk altijd aan met `.`.

### Reference types

**Opgelet** - reference types zijn C++ specifiek. Dit is echter een integraal onderdeel van je kennis van compound types en wordt dus hier al uitgelegd. Als je onderstaande voorbeelden wenst te testen, gebruik dan `g++` in plaats van `gcc`!

Een referentie variabele is niet meer dan een alternatieve naam voor dezelfde variabele. Ze zijn herkenbaar door `&` na variabele type. Referenties moeten "gebind" worden bij declaratie:

```C
int geslacht = 10;
int &mannelijkheid = geslacht;
int &vrouwelijkheid;    // compiler error
```

{{<mermaid>}}
graph LR;
    A{&mannelijkheid} -->|ref| B[geslacht<br/>10]
{{< /mermaid >}}

Referenties kan je zien als "constante pointers" die automatisch de `->` toepassen. Het adres van het doel wordt bewaard, niet de eigenlijke waarde. Referenties zijn geen objecten en hebben geen volwaardig adres op de stack.

Je kan nog steeds de waarde van het object wijzigen via de referentie: `mannelijkheid = 20;` zal de variabele geslacht ook wijzigen - die zijn immers hetzelfde. Als je dat wil vermijden heb je `const` nodig (p60).

### Pointer types

Een pointer is een "veranderbare" referentie naar een variabele. Pointers hebben hun eigen geheugenadres op de stack en kunnen op eender welk moment naar iets anders verwijzen: ze zijn niet constant. Ze zijn herkenbaar door `*` na variabele type.

```C
int jong = 10;
int oud = 80;
int *leeftijd = &jong;
leeftijd = &oud;
```


{{<mermaid>}}
graph LR;
    A{*leeftijd} -->|na regel 3| B[jong<br/>10]
    A --> |na regel 4| C[oud<br/>80]
{{< /mermaid >}}

Merk op dat we hier toch nog `&` gebruiken! Dit is geen referentie type maar de _address-of_ operator om het adres van de variabele jong vast te krijgen. Een pointer verwijst naar een adres, niet naar een waarde.

Wat is de output van `printf("%d", leeftijd);`? 1389434244! Huh? We drukken het **adres** van de pointer af, niet waar de pointer naar verwijst. Om dat te doen heb je weer de `*` operator nodig: `printf("%d", *leetijd);`. Dit noemen we _dereferencen_.

De compiler geeft dit ook aan als warning:

> warning: format specifies type 'int' but the argument has type 'int *' [-Wformat]

Pointers kunnen ook verwijzen naar... pointers naar... pointers naar ... Genoeg keer `*` toevoegen.

```C
int jong = 10;
int *ptr = &jong;
int **ptr_to_ptr = ptr; // compiler error
int **ptr_to_ptr = &ptr;
```

{{<mermaid>}}
graph LR;
    A{"**ptr_to_ptr"} -->|ref| B{"*ptr"}
    B --> |ref| C[jong<br/>10]
{{< /mermaid >}}

Waar wijst een nieuwe pointer naar die nog niet geïnstantieerd is?:

```C
int *ptr;
printf("%d", *ptr); // print -122O4735835
```

Whoeps. Merk op dat, afhankelijk van de compiler C implementatie (VC++, clang, GNU C, ...), een ongeïnitialiseerde pointer naar `0` _kan_ evalueren. Ga daar in geen geval van uit, en ken altijd de waarde `NULL` toe: `int *ptr = NULL;`.

`NULL` is een platform-afhankelijke macro die in C verwijst naar 0, meestal in de vorm van een void pointer. Een `void*` pointer kan naar eender welk type verwijzen en wordt meestal gebruikt om low-level memory aan te spreken, zoals we zullen zien bij de GBA.

De definitie van een pointer schrijft niet voor waar de `*` precies moet staan: `int* leeftijd` is hetzelfde als `int *leeftijd`. Pas om met dingen als `int* leeftijd, ouderdom`! De laatste veriabele is hier een gewone int, en géén pointer!

Referenties en pointers kan je mixen: `int *&ref_to_ptr = ptr`. Lees de tekenreeks van rechts naar links: "referentie van", "pointer".

#### Functie pointers

Een pointer kan ook verwijzen naar een functie (p247), daarvoor heb je dezelfde signatuur definitie nodig:

```C
#include <stdio.h>

int verhoog(int getal) {
    return getal + 1;
}

int verdubbel(int getal) {
    return getal * 2;
}

int main() {
    int (*op)(int) = &verhoog;

    printf("verhoog 5: %d\n", op(5));
    op = &verdubbel;
    printf("verdubbel 5: %d\n", op(5));
    return 0;
}
```

De definitie van de op pointer ziet er wat vreemd uit, maar de signatuur voorspelt dat we een `int` retourneren (meest links), en dat er één parameter nodig is, ook in de vorm van een `int` (tussen haakjes).

Functie pointers kan je ook als parameter meegeven, bijvoorbeeld met `void exec(int (*op)(int)) {`. Een functie kan een functie (pointer) teruggeven, bijvoorbeeld met `int (*kies_op(int mod))(int) {`. De functie "kies_op" verwacht 1 int parameter en geeft een functie pointer terug die verwijst naar een functie met 1 int parameter en returnvalue int. Om dat warboeltje te vereenvoudigen wordt meestal `typedef` gebruikt:

```C
#include <stdio.h>

typedef int(*func_type)(int);

int verhoog(int getal) {
    return getal + 1;
}

int verdubbel(int getal) {
    return getal * 2;
}

func_type kies_op(int mod) {
    return mod == 0 ? &verhoog : &verdubbel;
}

void exec(int (*op)(int)) {
    printf("exec: %d\n", op(5));
}

int main() {
    exec(kies_op(0));       // print 6
    exec(kies_op(1));       // print 10
    return 0;
}
```

Laten we de Persoon `struct` van [labo 1](/teaching/cpp/labo-1) eens herbekijken in het licht van pointers (en typedefs):

```C
#include <stdio.h>
#include <stdlib.h>

struct Persoon {
    int leeftijd;
    int (*is_oud)();
};

typedef struct Persoon Persoon;

int is_oud(Persoon* this) {
    printf("checking leeftijd van persoon: %d\n", this->leeftijd);
    return this->leeftijd > 60;
}

Persoon* create_persoon(int leeftijd) {
    Persoon* persoon = malloc(sizeof(Persoon));
    persoon->leeftijd = leeftijd;
    persoon->is_oud = &is_oud;

    return persoon;
}

int main() {
    Persoon* jaak = create_persoon(40);

    printf("is jaak oud? %d\n", jaak->is_oud(jaak));
    free(jaak); // niet echt nodig, programma stopt hier toch.
    return 0;
}
```

Vergeet niet dat we nog steeds in C aan het programmeren zijn.

Wat is er veranderd?

1. `Persoon` is een typedef geworden.
2. Pointers zijn gebruikt om struts door te geven. `malloc()` komt kijken om geheugen te reserveren voor een nieuwe persoon. Vergeet niet dat we dit zelf moeten terug vrijgeven met `free()`!
3. Het belangrijkste: een **factory method** `create_persoon` is nodig om een nieuwe persoon te assembleren en de is_oud methode aan de struct te plakken.

Dat ziet er al iets gestroomlijnder uit maar vereist nog steeds te veel boilerplating. Zo'n constructies ga je zelden tegen komen in de praktijk. Ontwikkelaars die graag objecten maken zullen C links laten liggen.

### Praktisch gebruik van pointers

Omdat in C alles _by-value_ doorgegeven wordt, kunnen we met pointers de waarden van variabelen in een functie manipuleren die erbuiten gedeclareerd werd. In Java kan je de waarde van member variabelen in objecten ook wijzigen, maar niet **primitives**! Hoe wissel je twee getallen zonder iets terug te geven?

```C
void swap(int *px, int *py) {
    int temp;
    temp = *px;
    *px = *py;
    *py = temp;
}
int x = 10, y = 20;
swap(&x, &y);
printf("(%d, %d)\n", x, y); // print (20, 10)
```

Zoiets is ondenkbaar in Java - daar hebben we truckjes voor nodig als een `int[]` dat toch een object is. Natuurlijk is deze implementatie ook **nadelig**: is het wel duidelijk voor de caller dat variabelen gewijzigd worden?
Performante algoritme implementaties profiteren van deze mogelijkheden. Duidelijke domain-driven applicaties niet: daar dient een hogere taal voor.

Pointers en arrays gaan hand-in-hand in C. Op pointers kan je ook operaties als `++` en `--` uitvoeren die de pointer in het geheugen één plaatsje naar links of rechts opschuiven. Met `char *tekst = "sup"` verwijst de pointer naar het eerste karakter:

{{<mermaid>}}
graph TD
    A{*tekst}
    A-->|begin van array|C['s']
    A-.->D['u']
    A-.->E['p']
    A-.->F['\0']
{{< /mermaid >}}

Een eigen `printf("%s", tekst)` zou het overlopen van de pointer kunnen zijn, tot er niets meer is, en karakter per karakter afdrukken:

```C
void print_tekst(char *tekst) {
    while(*tekst != '\0') {
        printf("%c", *tekst);
        tekst++;
    }
}
```

In C is `a[i]` exact hetzelfde als `*(a + i)`!

## Herhaling: let op met syntax!

Zie pagina 53 - symbolen zoals `*` en `&` in C en C++ hebben verschillende betekenissen.  

- `int &r = i;` - & na een type: dit is een reference type
- `int *p;` - * na een type: dit is een pointer type
- `p = &i` - & gebruikt in een experessie als _address-of_ operatie
- `*p = i` - * gebruikt in een expressie als _dereference_ operatie

Vergeet niet dat de eerste regel enkel geldig is in C++.

## <a name="oef"></a>Labo oefeningen

1. Implementeer `int strcmp_own(char *s, char *t)` van `<string.h>` zelf. Geef het getal 0 terug indien strings gelijk zijn, een getal kleiner dan 0 (bvb. -1) indien s < t en een getal groter dan 0 (bvb. 1) indien s > t. Gebruik je pointer kennis om snel het geheugen te scannen.
2. Jij bent een brave bibliothecaris. En als brave bibliothecaris is het je taak om boeken alfabetisch te sorteren op achternaam. Laat de gebruiker een aantal achternamen ingeven, gescheiden door spatie (tip: [strtok](http://www.cplusplus.com/reference/cstring/strtok/), en druk dan gesorteerd de inventaris af. Uiteraard gebruik je pointers.
  - input: `lenaerts zwanskop aerts groeneveld`
  - output: `aerts groeneveld lenaerts zwanskop`
3. Ohnee, je broer de stoute bibliothecaris is gearriveerd! Hij maakt een zootje van de bibliotheek en sorteert graag omgekeerd van Z naar A, de smeerlap. Voorzie naast `void brave_bibliothecaris(char **auteurs, int aantal)` ook een `void stoute_bibliothecaris(char **auteurs, int aantal)` methode. Vraag de gebruiker eerst of hij stout of braaf geweest is. Gebruik functie pointers om te wisselen van bibliothecaris!
  - input: `stout` (enter) `lenaerts zwanskop aerts groeneveld`
  - output: `zwanskop lenaerts groeneveld aerts`

Tips:

- [Voorbeeld gebruik](https://www.tutorialspoint.com/c_standard_library/c_function_strcmp.htm) van de standaard `strcmp` functie.
- Opnieuw: denk aan de [GNU Coding Standards](https://www.gnu.org/prep/standards/html_node/Writing-C.html)!
- Een "array van strings" is in C een pointer naar pointers van characters (`char**`).
- Je mag een arbitraire hoeveelheid spaties aannemen.
- [Insertion Sort](https://en.wikipedia.org/wiki/Insertion_sort) is goed genoeg, pseudocode staat daar. Gebruik je eigen strcmp!
- De stoute bibliothecaris mag de brave zijn werk gebruiken en _reversen_!
- Pas op met `fgets` na `scanf` - deze laat `\n` nog in de stream achter die de eerste onterecht verwerkt. Gebruik `getchar()` om dat karakter te negeren.

## Denkvragen

1. Wat is het verschil tussen `char msg[] = "heykes"` en `char *msg = "heykes"`? Verduidelijk je antwoord met een schema.
2. Wat is het verschil tussen `int a[10][20]` en `int *b[10]`? Kan je ook iets zeggen over het geheugengebruik?
3. Hoe zouden we de bibliothecaris kunnen veralgemenen naar een sorteerder van eender welk datatype in plaats van enkel char? Denk aan Java's generics.
4. In welk geval zou jij zeker pointers gebruiken in C, en in welk geval niet? Beargumenteer je keuze.
5. Als ik mijn eigen gelinkte lijst wens te implementeren, hoe ziet mijn data structuur er dan uit? Teken ook een schema van zo'n lijst als voorbeeld.
