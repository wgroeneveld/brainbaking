---
title: Table of Contents sample
date: 2020-07-01
---

Aanduidingen:
"-" = Gewone opsomming
"V" = Na schrijven hoofdstuk herbekijken en afvinken
"X" = Na schrijven hoofdstuk herbekijken en expres weglaten

## Bemerkingen

- Deel II/III opdeling 2D/3D niet geweldig; wat doen met bvb Advance Wars waarbij pathfinding in geen van beiden past? => wel logische hoofdstuk-opvolgingen maken, eerst basic 2D, dan basic 3D, dan more advanced 
- Telkens beginnen met **onderzoeksvraag**?? bvb 'how to render minimal 3D-like game' of 'how to have bigger maps than 64x64' of 'how to draw a line'
- Teklens eindigen met **game loop** elementen toegevoegd; na Part II (2D ding) volledige loop functies/dingen laten zien
- Part III dingen tussen de Part II games door steken als 'intermezzo'?

Dingen die me nog het meeste storen:

- "algoritmes" -> niet altijd; ook techniek, waarom dat dan (alleen) in titel?
- gokken indien geen gamedev vast te krijgen (e.g. golden sun: FSM)
- mooie afbakening spel vs uitleggen concept; afbakening hoofdstuk = ? flou!
- 2D physics: er is ook 3D; dat ook al uitleggen? te vergaand... grenzen? flou!

Hoofdstukken based on Game Programming Algorithms and Techniques:

[ ] Overivew (game loop buffering ed) => eerste iets van part II
[ ] 2D Graphics => games (part II)
    [ ] Sprites
    [ ] Scrolling
    [ ] Tile Maps
[ ] Linear Algebra for Games (vectors/matriches) => integreren in 3d stuk/weg
[ ] 3D Graphics => games (part II)
    [ ] Lightning/shading
    [ ] Visibility/coords/...
    [ ] Transformations (texture mapping?)
[ ] Input => WEGlaten; hoort bij hardware
[ ] Sound => ??? !!! 
    [ ] Basic Sound (GB coproc. waveforms?) - gba mixing = CPU-intensitive, there was no 'sound chip'!  https://www.neogaf.com/threads/game-boy-advance-sound-hardware-what-the-hell-nintendo.759027/page-2
    [ ] 3D Sound
[ ] Physics
    [ ] Planes, rays, line segments
    [ ] Collision geometry/detection
    [ ] Physics-based movement
[ ] Cameras => integreren in 3d stuk
[ ] AI
    [ ] "Real" VS Game AI
    [ ] Pathfinding
    [ ] State-based behaviors
    [ ] Strategy and Planning
[ ] Menu interfaces => weg
[ ] Scripting => weg 
[ ] Networked Games => ??? !!!


## Table of Contents

### Versimpeld; games

[ ] Een of ander te moeilijk spel met Action Replay en Game Genie? - "interrupting the game loop": cheat systems; game genie ea die registers veranderen --> HOE? https://www.youtube.com/watch?v=C86OsYRACTM

[ ] network: 4 player adapter ding?

https://www.youtube.com/watch?v=NJZ3keMXKH4 12:47 adres. Code: XX YY ZZZZ (origineel nummer, aangepast nummer, adres ZZZZ $C108 -> leuk om in address space te refereren zoals CH1). Apart hoofdstuk aan wijden of niet?. Sommigen hebben blijkbaar ook flash rom. hi-res picture. sommigen inline memory dump games ram! (Xterminator, action replay 4 "MAX")
Is idd mogelijk om de boel te doen glitchen, 37:40 TNMT3; 7 levens terwijl er maar 5 mogelijk zijn in de bar = window kapot. Zelfs "save states", 8 K rom

[ ] Sprites
    [ ] Sprites intro (Wario 1-4)
    [ ] Sprites advanced (Castlevania DoS)
    [ ] BG/Tile-based gameplay (Mr. Driller 2) (Tetris zelf sprite->bg)
    [ ] Sprites compression (DKC3 GBA)
    [ ] Sprites Mode 7 (F-Zero)
[ ] 2D Physics
    [ ] Gravity/Buoyancy (??) https://gafferongames.com/post/integration_basics/ http://lolengine.net/blog/2011/12/14/understanding-motion-in-games Archimedes' zeker niet
    [ ] Collision detection (??)
[ ] Bitmap-based (+overgang? DKC CGI, scaling/mode7/+1BG illusions)
    [ ] 3D engines wireframes (X GB)
    [ ] 3D engine raycasting (Wolf3D GBA)
    [ ] 3D engine texturing, BSP (Duke Nukem GBA)
    [ ] 3D engine modern software renderer (Nightfire)
[ ] AI 
    [ ] Pathfinding (Advance Wars) GUESS
    [ ] State-based: FSM (Golden Sun) GUESS
    [ ] Steering behaviour (Grand Theft Auto Advance) GUESS
[ ] Homebrew? wanneer eerste compilers? state? JVijn?

?? network?
?? sound?

### Part I: The Game Boy (Advance)

#### 1. Preface

- Personal relation with GBA
- Relate to own research?
- active community! (e.g. chiptunes)
- Digital Foundry opschepperij van Eurogamer: poly's, tera's, BSP's, maar wat betekent het allemaal? doen helemaal geen goede job in dingen uitleggen!
- WHY would you want to know/learn? why learning retro? -> goed om nog alles vanaf 0 te kunnen uitleggen VS advanced usage enkel 'leren werken met' Unity - sort() gebruiken VS kennen. is nu niet meer mogelijk om in uw eentje echt alles te kennen/kunnen

#### 2. The Handheld

V what's '8-bit CPU'? 16-bit? -> 16-bit address space: 64KB. registers ook iets van zeggen? te diep? https://www.youtube.com/watch?v=RZUDEaLa5Nw 3:39. instructions: total control over system. also, gigantic pain to do simple things. no names, ...
V GB -> GBC: 10yrs. 16kb ram, maar 2x8 VRAM BANK
V Mhz, cycles, ARM, ... 
V Memory mapped IO = things appear to the CPU as if they were memory. just read from 16-bit address space
V No OS. Assmebly, C, C++, layers ...
V BIOS https://gossipfunda.com/gba-bios/ https://mgba.io/2017/06/30/cracking-gba-bios/ checksum, nintendo logo = first anti-piracy tool - twee dingen: nintendo logo check (GBC checks less) + header checksum https://gbdev.io/pandocs/#the-cartridge-header en https://www.youtube.com/watch?v=HyzD8pNlpwI 19:53 nintendo could control which games were released. copymark en trademark voilation indien meegenomen. checksum header: don't blow into the pins?. nintendo logo on the screen - NO cleanup: do something with it (some games)
V historiek/vgl met bestaande HW/andere consoles, porting
V similarities (S)NES, ed
V on-system IRAM/WRAM/VRAM next to catrdige ROM/RAM http://problemkaputt.de/gbatek.htm#gbamemorymap
V modding: backlit, battery pack, ... 
V launch titles! Circle of the Moon; launch title: shows GBA capabilities. exceeds any 16-bit cv; and you can hold it in your hands? gba launch titles VS gb launch titles = huge "jump" - since dreamcast/ps2; ook niet-first parties
V GBA: kwaliteit kleurenscherm beter dan GBC; minimizes motion blur ed maar nog steeds geen backlit. grootste nadeel; zie castlevania. (afterburner). => daardoor veel te hoge contrast-game dingen zoals Harmony of Dissonance. Foto nemen met GBA zonder mod die bepaalde castlevania (donkere) area toont?

Eerder in Game-specifieke stukken zoals Wario: 

- GB: 160x144, 4 colors (2 bits), 8x8 tilebased, 20x18 on-screen (32x32 in ram: 256 - scrolling! wraps around! draw columns faster than viewport scrolls - VSyncing; scanlines; hier of in Wario land? 
- in off-screen area of viewport scrolls https://www.youtube.com/watch?v=HyzD8pNlpwI 32:59; in 2 dimensions zoals DK land) tiles, 40 sprites (10/line), 8Kb VRAM (4k bg, 4k sprites --> overlap!! speciale flags voor; overlappende tekening in boek!), 1k bg map, 1k window map) 2 layers: bg/'window' (no translucency - overlays - for score on bottom/right of screen.). 3de laag = 'sprites'. OAM map. sprites can be 16px in height. wel translucency. flip bits. 2 palettes omdat 1 bit verknoeid is door translucency. sprite drawing priority: array in memory, earlies = draws over
- LCD: 60x/sec redraw lines - race game https://www.youtube.com/watch?v=HyzD8pNlpwI 41:11 different parts of the screen behave differently. vblank interrupts LYC, scrollen op juiste moment. 
- "Mode 7" voor GB: SCX https://www.youtube.com/watch?v=HyzD8pNlpwI 44:05
- PPU timing: 20 clocks oam search, 43 pixel transfer, 51 h-blank (144 lines) 17,556 clocks/screen, 1.048.576 clock speed: 59.7 Hz refersh rate. 1140 clocks on vblank. shadow OAM nodig en kopieren dan. Refereer naar CH1 waar memory space en CPU clock speed werd uitgelegd. 

#### 3. The Cartridges 

!! Icoontjes die ge op dozen/cartridges tegenkomt uitleggen (bvb official game boy video link game pak, super game boy, ...)

- ROM/RAM. Access times, VS CD-ROM
- 'Memory bank controllers' https://gbdev.io/pandocs/#the-cartridge-header
- Save states: https://zork.net/~st/jottings/GBA_saves.html uniek voor elke cartridge...  https://gekkio.fi/blog/2015/mooneye-gb-gameboy-cartridge-types/ memory 'banking' tekening/uitleg + reden?
- GBA Video Cartridges? https://en.wikipedia.org/wiki/Game_Boy_Advance_Video zie ook https://mgba.io/2015/10/20/dumping-the-undumped/ - is blijkbaar iets bank-achtig. Zelf ene kopen en foto nemen? 
- GB Mega Memory Card savegame backup cartridge
- Extra sensoren analogue-digital convertor? https://www.reddit.com/r/Gameboy/comments/3o10rk/full_list_of_gameboy_and_gba_games_with/
    - Boktai: The Sun Is in Your Hand; lightsensor rom hack: https://github.com/Prof9/Boktai-Solar-Sensor-Patches/blob/master/Source/b1u.asm hoe werkt die interface? hoe lees je een sensor in vanuit programma? Achtergrondinfo: https://mgba.io/2015/10/20/dumping-the-undumped/
    - Kirby Tilt 'n Rumble; gyro (Ook Wario Ware: Twisted!, Yoshi Topsy-Turvy)
    - Robopon infrared
    - Game Boy Camera (apart boek zelfs; retro HW algorithms? zoveel details; CCD cell https://gbdev.gg8.se/wiki/articles/Gameboy_Camera dingen zoals https://petapixel.com/2017/07/05/guy-photographed-moon-jupiter-game-boy-camera/ en http://ekeler.com/game-boy-camera-canon-ef-mount/)
    - Harvest Moon: RTC
    - Tamagochi https://steemkr.com/gaming/@donpepe/weird-game-boy-cartridges-part-2
    - Robopon GB https://www.youtube.com/watch?v=Uch-ZWrScuY

### Part II: The Games & Their Algorithms

#### Wario Land 1-4

> Q1. How do sprite-based games work?
> Q2. What's the difference between GB, GBC, and GBA games?

- Sprites/Tiles: platformer basics; opkappen. scrolling. what's a sprite? tilemaps?
- 3/4 colors, 1/2 palettes - zie ook black art 3d 'color register'
- Evolutie in RAM/CPU/...: GB (Wario 1) -> GB(C) (Wario 2) -> GBC (Wario 3) -> GBA (Wario 4)
- how GB games are played on the GBA: aparte CPU op PCB!
- wario land 2: reeds in map zichtbaar hoe dynamisch in geladen wordt
- Wario land 4 heeft reeds parallax scrolling
- Wario land 4 heeft véél animaties: rotation, scaling, ...
- "physics" (gravity, buoyancy);  ook uitleggen?
- "pushing the hardware to the limit" (IGN review) -> helemaal niet, is gewoon wat de GBA kan. critical thinking bij reviewing niet altijd wow...
- alpha blending: water effect, hoe werkt dat?

#### Castlevania: Aria of Sorrow

> Q1. How does level progression work?
> Q2. How do I create the illusion of variety and depth?

- Enemy design: palette swapping
- Entering other areas: clear cache; unique designs. Ander VB: Legend of Zelda. Seamless worlds zoals Dungeon Siege niet mogelijk, wel groter dan 64x64 (apart HF van maken met apart spel?)
- Background layers; illusion 3D

aria's engine re-use (klopt dit?): Shaman king master of spirits https://www.youtube.com/watch?v=cPycf-0vv90 4:32 dark filter

#### Yoshi's Island 

> Q1. How do sprite transformations work?

- Rotating/scaling? waarom dit spel en niet verder Wario4?

#### Mr. Driller 2

> Q1. How do I display more things on screen than the OAM limit?

- BG Tiles used as part of the gameplay

Waarom niet Tetris? Limieten GBA VS GB? Mr. Do?

#### Ne SCHMUP

> Q1. How does collision detection work?

- collision geometry/detection, verschillende approaches
- simpel: intersecting sprite OAM edges
- complex: indien cirkel, ook kleur-rekening? metadata?
- compromis: 'forgiving hitboxes', zie Wario4 analyse

#### Advance Wars

> Q1. How does the enemy find my location? 

(vragen meer concreet richten ipv "how does pathfinding work"? -> engagement++)

Origine: Game Boy Wars (GB, GBC, JPN-only) https://www.youtube.com/watch?v=Uch-ZWrScuY - eigenlijk Famicom Wars (turbo optie betere AI? opties verschillende CPU levels)

- Pathfinding A* (eerst Dijkstra, easy opl maar duur)
- travelling salesman problem?
- turn-based tactics games better at these things VS realtime (3D)
- terrain analysis in realtime strategy games https://users.cs.northwestern.edu/~forbus/395gai/lectures/L5_Terrain_Analysis.pdf  quote "Nothing like trying to live within a tight CPU budget to unleash creativity!" => 50+% of CPU spent on pathfinding
- 3 families spatial: tiles/waypoints/quad tres
- kan ook gebruikt worden voor 2D platformers: Metroid (Fusion?) achtervolging
- dedicated AI programmer: https://www.mobygames.com/game/gameboy-advance/advance-wars/credits geeft toch iets aan, ook al kan ik hem niet bereiken?

Mr. Do? (programmer dood) - rebranded as "Quest: Fantasy Challenge" (GBC) - AI hiervoor; simpel, volgend bg; ipv Mr. Do? Dat wegdoen? Als "eenvoudigste" AI? - liniaire afstand bepaald hoe enemy naar target beweegt rekening houdend met walls

#### Tower defense 

(of iets met meer enemies tegelijkertijd?)
(of integreren in vorige HF)

> Q1. How do enemies stay on path?

- flow field pathfinding: https://www.redblobgames.com/pathfinding/tower-defense/ - probleem many enemies - going to one place; instead of running A* for each enemy, run it once
- GTA op weg blijven rijden, auto's?

#### Golden Sun

> Q1. How does the enemy decide what to do?

- AI Scripts: https://gamefaqs.gamespot.com/gba/930369-final-fantasy-v-advance/faqs/51713 
- Finite State Machines: http://intrinsicalgorithm.com/IAonAI/2012/11/ai-architectures-a-culinary-guide-gdmag-article/

- **Iets met slimmere AI dan FFV**
    + om van FSM naar behavioral tree of utility-based AI over te schakelen?
    + Hiervoor is het _vereist_ dat we weten welke AI principes op welk spel werden toegepast... rondmailen dus, en allemaal japanners. 

(integreren of niet?)

#### X - XEKKUSU

(GB, 1992) of **Faceball 2000**

> Q1. How do bitmap-based games work?
> Q2. How do I draw lines? 

- https://www.polygon.com/features/2019/4/19/18412987/game-boy-best-games-nintendo-pokemon-tetris
- wireframe modeling
- hulppijlen bij tutorial: objects ipv drawing line
- (beter alternatief zoeken; bvb FP-RPG blobber?)

https://web.archive.org/web/20190210151024/https://www.usgamer.net/articles/dylan-cuthbert-star-fox-game-boy-hacking-feature-interview

#### Wolfenstein 3D GBA

> Q1. How do I create the illusion of depth in bitmap-based games?

- Raycasting http://www.loirak.com/gameboy/gbacaster.php
- Z-Buffering: VS 'painters algorithm' => met painters beginnen als basis uitleg; hoe zo weinig mogelijk tekenen gegeven beperkte CPU kracht? -> raycasting, z-buff. 
- Page flipping: https://www.coranac.com/tonc/text/bitmaps.htm
- texture mapping zit hier al in, maar enkel walls -> details volgend stuk

#### Doom II/Duke Nukem Advance

> Q1. How do I texture walls/ceillings/floors?
> Q2. How do I reduce the polygon count?

- BSP trees?
- multi-mapping met lightning in southpaw? iemand 
- Graphic State; nog cancelled games https://www.gamezone.com/news/gz_interview_graphic_state_brings_more_innovation_to_the_gba_with_urban_reflex/ raycast BSP; ook Cruis'n Velocity en Dark Arena zelfde engine
- Doom II: compleet andere engine; veel betere draw distance en amount enemies voordat framerate zakt - verschil? (Torus games, aussies - zelfde als Duke3D => Southpaw Engine https://dukenukem.fandom.com/wiki/Southpaw_Engine)
- Textures stored as multiple mip-maps (what's a mip-map and WHY?)

#### James Bond 007: Nightfire

> Q1. How do modern 3D software renderers work?

- Vervolg doom's tekortkomingen (bridges)
- 'one of the few FPSes that lets you run, jump, duck, freelook'
- 'Real' Software 3D rendering: portal https://en.wikipedia.org/wiki/Portal_rendering https://www.flipcode.com/archives/Building_a_3D_Portal_Engine-Issue_16_More_On_Portals.shtml
- notable others: (smashing drive) Crazy Taxi: Catch a Ride Rush engine interview: https://www.gamezone.com/news/gz_interview_catch_a_ride_in_full_3d_with_crazy_taxi_for_game_boy_advance/ - kreeg slechte reviews https://en.wikipedia.org/wiki/Crazy_Taxi%3A_Catch_a_Ride => knockoff simpsons road rage: mode 7 gebruikt en sprites in de plaats! véél vlotter en beter (aansluitend met volgend spel?)

#### F-Zero: Maximum Velocity 

> Q1. How do 2D racers create that 3D effect?

- mode 2: rotated/scaled tile layers; Mode 7, rotating backgrounds
- Zonder Mode 7: Kirby's Pinball Land Game Over/Score scherm
- Ook: Simpsons racing ding. Misschien daar devs vast te krijgen?

#### Grand Theft Auto Advance

- **Grand Theft Auto Advance** (is ook een GBC port van, sprite based?)
    + mode 1: tiles + 1 rotated/scaled layer
    + accelerating with car: zooming out; bg2 xform/offset
    + onder bruggen doorrijden: alpha blending; hoe?
    + steering behaviour cars? http://www.red3d.com/cwr/steer/gdc99/ path following

#### Donkey Kong Country 3

> Q1. How do 2D platformers create that 3D effect?

- Pre-rendered 3D "CGI" Silicon https://en.wikipedia.org/wiki/Donkey_Kong_Country_3:_Dixie_Kong%27s_Double_Trouble!#Development_and_release ; mode 0 met fast-switching OAM sprites (zelfs tekst)
- compressie! The GBA BIOS has decompression routines for bit-packing, run-length encoding, LZ77 and Huffman. https://www.coranac.com/tonc/text/bitmaps.htm
- compressie: 'words' vs bytes/... zie tonc

### Part III: The Aftermath

Eerder Als tussendoortje?

- Retro on Tap: emulation (and legal concerns)
    + https://brainbaking.com/post/2018/12/over-analoog-en-digitaal/
    + "Space Shifting" in music industsry considered legal ("Fair Use")
    + https://www.howtogeek.com/262758/is-downloading-retro-video-game-roms-ever-legal/#:~:text=Emulators%20are%20legal%20to%20download,be%20made%20for%20fair%20use.
    + https://www.nintendo.com/corp/legal.jsp

> Can I Download a Nintendo ROM from the Internet if I Already Own the Authentic Game?

There is a good deal of misinformation on the Internet regarding the backup/archival copy exception. It is not a "second copy" rule and is often mistakenly cited for the proposition that if you have one lawful copy of a copyrighted work, you are entitled to have a second copy of the copyrighted work even if that second copy is an infringing copy.

The backup/archival copy exception is a very narrow limitation relating to a copy being made by the rightful owner of an authentic game to ensure he or she has one in the event of damage or destruction of the authentic.

Therefore, whether you have an authentic game or not, or whether you have possession of a Nintendo ROM for a limited amount of time, i.e. 24 hours, it is illegal to download and play a Nintendo ROM from the Internet.

- emulation => iets voor part III, zo snel mogelijk met games beginnen
    + hardware emulation (Jo contribution?)
    + software emulation (mGBA author contribution?)
- Epilogue
    + Similarities met (S)NES? of in preface?
    + Game Design is an Art, not a science. Design > Implementation (which are algorithms). In the end, same 2D pane endresult, regardless of 3D rendering techniques used. it's the game design aspects that matter most. zie ook weer http://www-cs-students.stanford.edu/~amitp/gameprog.html

## Andere misschien interessante games

- Asterix & Obelix XXL GBA
    + full 3D platformer veel vlotter dan bovenstaande games!
    + more and more 'impressive 3d games on youtube' links? https://www.youtube.com/watch?v=KlWSsI1X-0Q => PS1 game? 
    + Héél raar: de ACHTERgrond is de VOORgrond (sprites en spritemap)!!
    + devs Fernando Velez, Guillaume Dubail, ook port van Driver 3 dat er uit ziet als GTA3 ipv de GTA port die er uit ziet als GTA1
- Hoop 3D racers
