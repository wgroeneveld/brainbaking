---
title: Retro Algorithms; ideas
date: 2020-06-28
---

https://shop.insidegadgets.com/product/gbxcart-rw/

DOEL: iemand met liefde voor retro games bijleren HOE dingen in elkaar steken

METHOD: storm in a teacup + CRPG Handbook (Dus: afine matriches too much?)

Elk hoofdstuk heeft een DEMO stuk op Github/pagina ergens?

# Quotes

Lateral thinking with Withered Technology (Gunpei Yokoi_ http://ignorethecode.net/blog/2013/09/05/lateral_thinking_with_withered_technology/ - een van de laatste 8-BITS to hit the market. low price, high battery life.  originele quote op https://en.wikipedia.org/wiki/Gunpei_Yokoi#Lateral_Thinking_with_Withered_Technology
Gunpei Yoko artikel @ escapist: https://v1.escapistmagazine.com/articles/view/video-games/issues/issue_87/490-Searching-for-Gunpei-Yokoi

Chabudai Gaeshi - redoing things again: http://ignorethecode.net/blog/2012/04/28/chabudai_gaeshi/

Jeremy Parish: https://www.youtube.com/watch?v=1NiK-eghxi8 2:01 

> Since most Game Boy Releases for western developers were based on kid's licences and produced on suffocating shoe-string budgets, you really don't see a lot of great releases from studios outside Japan. To be fair, Japanse publishers put out a lot of crap for Game Boy too, but there were the occasional Japan-made masterpieces that made up for it. Those exquisite creations almost never came from the US though, and rarely from the UK. 

(ook: a decade behind in nineties, akin PCs from 1981)

# Titles

1. Retro Algorithms: Game Boy (Advance) Programming Patterns
2. Retro Algorithms: Game Boy (Advance) Patterns
3. Retro Game Boy Advance Algorithms ?
4. Retro Architectures? Nog vager.
5. Retro Coding Patterns on the Game Boy (Advance)
6. Retro Algorithms and Patterns on the Game Boy (Advance)

1. How Game Boy (Advance) Games Are Made
2. How It's Made: Game Boy (Advance) Games
3. How do Game Boy (Advance) Games Work?
4. Disassembling/Deconstructing/Reverse Engineering Retro Games on the GBA
5. Retro Gaming 101: Decoding Game Boy (Advance) Games
6. Decoding(/Deconstructing/...) Game Boy (Advance) Games
7. Inside the Game Boy (Advance) Game Loop
8. Inside the Retro Game Loop: Uncovering How Game Boy (Advance) Games Work

Defining every keyword:

- **Retro**; vroeger frequent gebruikte algoritmes die nu quasi out-of-the-box of hardware-enabled zijn OK
- **Algorithms**;
- **GB(A)**; target platform, mijn liefde voor nineties handheld gaming OK
- **Programming**; "programming is a way to control a machine" (quote tedre) OK
- **Patterns**; repeatable pieces of code re-used game after game (drawing lines, sprites, ...) bundled as a 'best practice pattern'

- begs the question: 'algorithm' VS 'pattern' - woord te veel? Waarom beiden?
- Meer dan alleen algoritmes? Verkeerde woordkeuze?
- Algoritmes/tech. termen in titel weglaten; is geen prog. boek maar voor iedereen! Wie zou dat kopen in de winkel als het 'retro coding patterns' heet?

# Algemeen

- vblank uitleg https://www.patreon.com/drludos crt 50vs60hz, bug vblank flickering (niet van toepassing voor gba, handheld werkt voor iedereen hetzelfde?)
- layout? crpg book/retro gamer mag? coloured hardback? in-between pags en tekst ook veel sprites steken? copyright dinges?
- Algemeen: game engine, vsyncing, interrupting?
- iets RPG achtig voor decision trees/text of text bg?
- debugging met mGBA? gdb server exploren of debugger console of ...
- saving/loading?
- compression? That is why compression is also important. The GBA BIOS has decompression routines for bit-packing, run-length encoding, LZ77 and Huffman. http://members.iinet.net.au/~freeaxs/gbacomp/ en in mindere mate https://www.coranac.com/tonc/text/bitmaps.htm
- modding/actieve retro developments zie http://www.indieretronews.com 
- gamevaluenow.com en andere 'tools' ook ergens vermelden
- GB = een van de laatste 8-BIT processors. 16-BIT address space. 64KB address space 0000-00FF 0000-8000 ROM 32Kb (tetris) VRAM 8000-A000 ExtRAM (cartridge, opt) A000-C000 RAM C000-E000 empty, OAM RAM FE00-FEA0, IO FF00-FF80, HRAM FF80 => dus spellen kunnen maar 32Kb zijn? nee, MBC - geen limiet! -> 16Kb bank0, 16Kb bank1-n - zelfde voor extram
- GB player = GB zelf! https://www.youtube.com/watch?v=HyzD8pNlpwI
- +1 system clocks (4Mhz, maar RAM maar 1Mhz, PPU 4Mhz, VRAM 2Mhz) - most numbers can be expressed in terms of 1Mhz (base2) "machine cycle" @ 1Mhz. 

## Hardware

Groot probleem: scope, begrijpbaarheid?

- hoe werkt een gb(a)? geen OS - wel os verschil
- cycles/clockhertz/mhz
- comparison games in die tijd, vs psp, cd laden traagheid?
- tijdlijn! idee van technologie at hand, ook op pc (analogie crpg book)
- "programming is a way to control a machine" (quote tedre) assembly instructions, laag c, laag c++, ... hier stopt gb, hier gba. vb loop in C schrijven, kijken op online compiler wat assembly output is
- gbc update. gb games color codes: hash 45 palette configs in BIOS, 174 gb games -> hash matches? https://tcrf.net/Game_Boy_Color_Bootstrap_ROM
- gbc: bios pre-set palette for gb games, otherwise default, or press while booting https://en.wikipedia.org/wiki/Game_Boy_Color#cite_note-16
- gbc: Hicolour "exploit"! https://romhack.github.io/doc/gbcHiColour/ 2000+/tegelijk.  the fish files, Alone in the Dark: The New Nightmare, crystalis. Hoe? palette manipulation during hblank - every scanline can have it's own set of 8 palettes/line, 8 colors/palette, 144 scanlines = 2304 colors. cannon fodder gbc intro. uses lots of CPU cycles - best for static backgrounds. alone in the dark, intro/outros. test drive le mans, wacky races. "mode 7 prequel"
- MULTIPLAYER: link cable, syncing, hoe? zie warlocked; DOOM Co-OP GBA
- super game boy SNES: speciale games hier ook voor gemaakt (logo op cartridge) bvb donkey kong; zit dat in ROM? https://www.youtube.com/watch?v=JU5OBrDlOR8 8:37
- "interrupting the game loop": cheat systems; game genie ea die registers veranderen --> HOE? https://www.youtube.com/watch?v=C86OsYRACTM
- SNES: backgrounds https://www.youtube.com/watch?v=5SBEAZIfDAg 3:49 mode2 kan apart verticaal scrollen per column ipv "gewoon" -> HDMA op GB(A) https://www.coranac.com/tonc/text/dma.htm zie https://www.youtube.com/watch?v=zjQik7uwLIQ 0:46 - palette cycling, background scrolling, horizontal oscillation, vertical oscillation, transparency, interleaved oscillation
- GBA CPU: ARM7TDMI (Thumb instr. Debug port, fast Multiplier, enhamced Ias?) RISC. ARM pipeline ipv traditional Fetch, decode, execute? https://www.youtube.com/watch?v=mpNWEbZdXNw 2:32. 256KB WRAM. 96KB VRAM vs 16 bij GBC. bitmap modes als eerste. KLOPT DIT? X op GB?

HDMA: zelfs Link's Awakening introductie... https://kemenaran.winosx.com/posts/links-awakening-rendering-the-opening-cutscene/ regen = random geplaatste 'sprites' Prehistorik Man https://www.youtube.com/watch?v=zQE1K074v3s 10:45


### Sound design

- sound/music apart spel voor selecteren?
- GB: 4 channels with stereo sound. What's a channel?
- chiptunes, nu nog modding/community mee bezig?
- verschil met GBA? 

## Proloog: Wario Land 1 (GB)

- sprite swap (coin dinges); gamasutra artikel?
- heel limited

https://www.gamasutra.com/blogs/DoctorLudos/20171207/311143/Making_a_Game_Boy_game_in_2017_A_quotSheep_It_Upquot_PostMortem_part_12.php

Misschien interview met die kerel er gewoon in zetten? zie http://www.ludoscience.com/EN/1-Ludoscience.html

## Afterthought: SNES comparison?

na al de rest?

# Deel 1: Sprite engines

## Metal Gear Solid GBC

- 2D Visibility: anders wordt ge gedetecteerd https://www.redblobgames.com/articles/visibility/ misschien niet zo complex? Ander stealth game op GBA waar het duidelijker is? Dit is ook weer een Japanner... 
- veel gemakkelijker: gewoon lijn trekken en zien of het raakt... 

## Castlevania: Aria of Sorrow (Sprites: basic platforming)

- HW supported: flipping, ...
- heel eenvoudige physics: jumping ea
- palette swapping ea
- sprite manager, 128 OAM, ...
- scrolling backgrounds, spritemap, blabla

## Yoshi's Island 2

- egg throwing simple line, bouncing, ... ?
- how to draw a line on an angle

## Iets tetris/driller achtig (Background swaps)

- Zoals dat een vb spel van studenten?

## ?? (rotaties)

- matriches, lijn trekken, ... (ala LuWe game?) https://en.wikipedia.org/wiki/Bresenham's_line_algorithm zie vb op https://www.coranac.com/tonc/text/bitmaps.htm + clipping?
- floating point probleem? => fixed point numbers
- speedup tricks: 32bit ptrs voor iets 16bit te fillen zie https://www.coranac.com/tonc/text/bitmaps.htm

## Advance Wars (Pathfinding)

- A* (pathfinding) gecombineerd met FSM? 
- behavioral trees?
- goal oriented action plan (GOAP)? http://alumni.media.mit.edu/~jorkin/goap.html

https://gamedev.stackexchange.com/questions/13420/which-algorithm-used-in-advance-wars-type-turn-based-games

# Co-op/network gaming

Doom? Tetris? How does the link cable work?

# Deel 2: Pseudo-3D engines

Nog te bekijken welk spel NIET mode 1 gebruikt?

- tony hawk's pro skater 2? gebruikt mode2
- mario vs donkey kong?
- baseball advance?
- Super monkey ball jr? gebruikt mode4, https://www.coranac.com/tonc/text/bitmaps.htm
- SNES SuperFX chip voor Star Fox op printplaat zelf: zie https://www.patreon.com/drludos (mario kart: DSP-1) => Megadrive Virtua Racing SVP chip

## Broken Sword: Shadow of the Templars

- compression, veel gebruik van bgs
- porten naar limited platform: challenges?
- affine sprite transforms: illusion of depth. How does that work? => texture mapping in general?

## Dragons Lair GBC

- andere adventure game, how handled? zie https://www.youtube.com/watch?v=6k-7t5riimQ

## Final Fantasy Tactics Advance

- terrain? multi-level things? => mode0, volledige illusie, pixels, map0 + map1 voor 'voorgrond' (sneeuwman, boompjes, ...)
- ventjes: 4 sprites elk!

## Mario Golf Advance Tour/Donkey Kong Country 3

- pre-rendered pseudo-3D backgrounds?

## 007 (Raycasting)

- duke nukem: mode 4, HUD en geweer (8 eerste) = sprites (alles rendered in bg2)
- https://www.darkfader.net/gba/ raycast engine is ook mode4 (ook bg2)
- bovenstaande zit ook 'depth lightshading' in = ?
- z-buffering uitgelegd?
- double buffering vs page flipping gba https://www.coranac.com/tonc/text/bitmaps.htm
- texture mapping? 

## F-Zero (Mode 7)

https://en.wikipedia.org/wiki/Mode_7 background rotation
- snes?

# Deel 3: Extra hardware

- special hardware cartridges? Wario Ware: Twisted, sun meter ding, gyro
- Spel van begin tot eind zelf op cartridge maken? 


## Game AI

### Advance wars:

https://books.google.be/books?id=xagLAAAAQBAJ&pg=PA56&lpg=PA56&dq=advance+wars+pathfinding&source=bl&ots=Y8LFB_GwrL&sig=ACfU3U3G5FuO8lC6GBAnekstHpOjmRezJw&hl=en&sa=X&ved=2ahUKEwihgZDmi6DqAhUhNOwKHeMSDg0Q6AEwCnoECAkQAQ#v=onepage&q=%5BGAMEAI11%5D&f=false

### Warlocked GBC

RTS als Warcraft II: **MULTIPLAYER** link-cable components!
Hoe werkt multiplayer? **Syncen?** !! Goede vraag => zijn britten. 
