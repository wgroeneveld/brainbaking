---
title: 'Software ontwerp in C/C++: Project opdracht'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

## Project opdracht

Om jullie recent bijgeslepen object-geörienteerde technieken te laten zien gaan jullie een **GBA spel** ontwerpen en ontwikkelen in C++11. De focus van de opdracht ligt niet op correcte low-level IO mapping maar op kritisch denken en testen zoals gezien in [labo 7](/teaching/cpp/labo-7). Uiteraard komen zowel pointers en GBA programming technieken van de vroegere labo's, als C++ class inheritance en abstractie lagen uit de latere labo's aan bod. 

Vertrek vanuit de [gba-sprite-engine](https://github.com/wgroeneveld/gba-sprite-engine/) library die ik gebouwd heb op <i class='fa fa-github'></i> Github door een <i class='fa fa-code-fork'></i> Fork te nemen met de knop rechtsboven. Op die manier bespaar je veel werk met een nieuw GBA project op te zetten en alle IO adressen opnieuw te mappen. Er is een README voorzien voor meer info. De engine gebruikt [Tonc](https://www.coranac.com/tonc/text/toc.htm) achterliggend. 

Wat voor soort spel het moet zijn laat ik volledig aan jullie over. Het spreekt voor zich dat complexiteit (en originaliteit!) mee in rekening gebracht wordt: zie evaluatiecriteria. Inspiratie nodig? 

* [Top 10 Gameboy Advance games in 10 minutes](https://www.youtube.com/watch?v=2-R-F-A48FI)
* [25 Best Gameboy Advance games Ever](http://www.denofgeek.com/us/games/game-boy-advance/256070/25-best-game-boy-advance-games-ever)

Werk in **groepen van 2** of indien oneven 3. 

## Minimumvereisten

Lees dit goed na: projecten die niet voldoen aan de volgende vereisten zullen niet geëvalueerd worden. 

1. De code leeft in een repository op Github onder jullie username met de [MIT](https://help.github.com/articles/licensing-a-repository/#disclaimer) license. 
2. Je vertrekt vanuit `gba-sprite-engine` - zie hierboven. Daarbij blijf je binnen GBA `MODE0` en werk je met sprites. C++11 is hiermee ook een vereiste.
3. Indien je je baseert op andere bestaande code doe je aan **bronvermelding**! Plagiaat wordt zeer ernstig bestraft. 
4. Je voorziet minstens één extra **unit test** klasse waar je je logica in test zoals zwaartekracht en botsingen.
5. Je project moet uiteraard minstens compileren.
6. Je repository `README.md` bevat een kleine functionele beschrijving van jullie spel, gecombineerd met een schets van het **domein model**. 

Het is **niet** de bedoeling om je te baseren op één van de engine demo's en die simpelweg verder uit te werken. Dat biedt onvoldoende uitdaging en originaliteit. 

Omdat als vereiste elk project op Github leeft kunnen jullie elkaar's repository ook raadplegen. Of jullie daar gebruik van willen maken laat ik aan jullie over: onthoud _sharing is caring_ en vergeet de bronvermelding niet. Het is geen race voor het beste waarbij je je code zorgvuldig moet afschermen: iedereen vertrekt vanuit dezelfde basis en iedereen kiest een ander soort spel.

## Evaluatiecriteria

Punten worden op twee keer op `/20` gegeven. Eenmalig een globaal cijfer, eenmalig een genormaliseerd cijfer, rekening houdend met de volgende subcriteria en gewichten:

1. `O.5` Abstracties
2. `O.5` Clean Code
3. `0.3` Complexiteit
4. `0.3` Originaliteit
5. `0.2` Unit testing
6. `O.2` Domein model

Waarbij beide cijfers herleid worden tot één. <br/>
Criteria en gewichten onderhevig aan verandering tot 5 weken voor het laatste labo.

## Inleverformaat

Datum te bepalen, evenals verdedigingsdata.

* Je mailt je github repository URL door, samen met een gecompileerde `.gba` ROM die je zelf getest hebt. 
* De gecompileerde ROM upload je ook naar Toledo.
* Er hangt ook een kleine verdediging aan vast zodat ik kan valideren of je voldoende kennis hebt over de code van je eigen spel. We spelen samen het spel en overlopen de code, waarbij er geantwoord wordt op enkele vragen die invloed uitoefenen op het globaal cijfer. 

## Praktische tips

* Begin bij het begin: werk een concept uit **op papier** en teken dan een ruw model uit. Dit model is onderhevig aan verandering naargelang de ontwikkeling. Vergeet het finale model niet toe te voegen aan de README.
* **Hou het simpel** en werk gradueel iets complexer uit. Wees niet te overmoedig: een zeer goede implementatie scoort hoger dan een slappe complexe.
* Denk voor stukjes met logica eerst aan unit testen. Een test die slaagt helpt je al een heel eind verder. 
* Test je spel tijdig op de mGBA emulator, of in de GBA zelf met een flashcard. 
* Gebruik het voordeel van git: check in op regelmatige tijdstippen, zelfs meerdere keren per dag, wanneer iets werkt. Op die manier bespaar je jezelf een hoop werk als er iets teruggedraaid moet worden. 
