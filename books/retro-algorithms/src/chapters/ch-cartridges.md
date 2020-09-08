
## Game Cartridges

What is a game console without its games? A cafe without beer, according to Belgians. Carefully preserved game cartridges are the bread and butter of any retro game collection. As for the Game Boy family, there are four official different types of cartridges to collect: original gray Game Boy carts, black Game Boy carts that increased the color palette on the Game Boy Color, translucent Game Boy Color exclusive carts, and the smaller Game Boy Advance ones. 

Inserting Game Boy Color games into an older Game Boy system is not impossible, but the notch on the top right of the cartridge prevents the power switch from sliding all the way to the left. Due to changes in aesthetics, owners of the Pocket could boot up these games, only to be greeted with a screen that states your Game Boy is incompatible with the games. 

Provided the game did boot in the first place. Remember air-blowing into the cartridge to clear out any dust, because the boot-up sequence somehow got stuck at a badly scrambled Nintendo logo? These cartridge slots were not spring-loaded: there was no _Zero Insertion Force_ (ZIF) connection smoothly accepting the cartridge that should avoid angry gamers from jamming the game in the handheld and potentially damaging things. Eventually, Nintendo did migrate towards a ZIF slot with the later Nintendo DS and Switch consoles.

Blowing the cartridge might never have fixed anything. Instead, simply removing the cartridge and reinserting it would have been enough for the connectors to correctly touch each other. In fact, according to Nintendo's NES Game Pak Troubleshooting webpage, overenthusiastic blowers might even damage the cart[^nesfaq]:

[^nesfaq]: [https://www.nintendo.com/consumer/systems/nes/trouble_game.jsp](https://www.nintendo.com/consumer/systems/nes/trouble_game.jsp). 

> 4. Do not blow into your Game Paks or systems. The moisture in your breath can corrode and contaminate the pin connectors.

The lesson here is to not spit on sensitive electronic contacts. Still, _Blow The Cartridge_ became a popular meme, and even a retro video game comic. With the release of the Switch, Nintendo engineers came up with a clever solution to make sure game carts never came in contact with our mouth:

> To avoid the possibility of accidental ingestion, keep the game card away from young children. A bittering agent (Denatonium Benzoate) has also been applied to the game card. This bittering agent is non-toxic.

Of course, the very first thing game reporters did was licking Switch cartridges to "verify these claims". Yuck. 

\begin{figure}[h!]
    \centering
    \includegraphics[width=0.56\columnwidth]{ch-cartridges/gbcartridgesizes.png}
    \caption{A comparison of various Nintendo Game Paks (actual size): GB(C) (Gray), GBA (Purple), (3)DS (Yellow), Switch (Red). Dimensions in millimeter. Excluding notches on GBA and 3DS paks. Each generation seemed to cut the cart size nearly in half.}
\end{figure}

As the fifth generation consoles advanced its technologies, with Sony's PlayStation on the front line, the rise of cheap mass-producible optical discs superseded the more expensive circuit boards with custom chips. Except that Nintendo's N64 reluctantly clung onto the cartridge system. CDs indeed increased storage capacity, making way for bigger texture maps and more intricate level design, but we tend to forget the biggest downside: loading times.

When comparing the Nintendo DS to the Sony PSP, this disadvantage is especially painful. A Gamespot article, bluntly subtitled "_Let's face it. The PSP suffers from horrendous load times. But just how bad are they?_", concludes that "_PSP games take a long time to load. Hardly any PSP games took less than a minute to load and quite a few took two or more._"[^gspsp] The solution? Jailbraking your PSP and ripping games onto a Memory Stick, a horrendous proprietary flash memory card system. I'm sure it must have been a source of great jokes at Nintendo staff parties. 

[^gspsp]: Source: [https://www.gamespot.com/articles/under-the-hood-psp-load-times/1100-6159832/](https://www.gamespot.com/articles/under-the-hood-psp-load-times/1100-6159832/).

\begin{figure*}[h!]
    \centering
    \includegraphics[width=\textwidth]{example-image-a}
\end{figure*}

Memory-mapped IO is responsible for the near-instant load times, allowing developers to treat cartridge ROM and RAM as if they were soldered on the PCB of the device itself. Other advantages of cartridges include the freedom to install any sensor you could think of and less system RAM usage that is typically required to read CD-ROMs. While "blowing the cart" might fix a N64 cart, a damaged PS1 CD-ROM can only be tossed in the bin. Popular early home computers such as the Atari 400 and the Commodore 64 also made use of cartridges, next to magnetic media.


### Cartridge design

While it is the iconicexterior plastic case that most people will fondly remember, it is the interior circuitry design of Game Boy games that is very compelling. Precisely because Game Boys only expect to load off something with 32 pins, there's a lot of creative margin for game developers to go wild. 

\begin{figure}
    \centering
    \includegraphics{ch-cartridges/cartridgedesign.png}
    \caption{Examples of cartridge PCB designs: \emph{The Legend of Zelda: Oracle
    of Seasons} (left) and \emph{Darkwing Duck} (right). The Zelda PCB contains the 16 megabit game ROM (right), a battery for the 64K-SRAM (left) to save data, a MBC-5 controller chip above the RAM and a RAM protector on the top left. The noticeably simpler Darkwing
    Duck PCB only comes with a MBC-1 chip, without any way to save the game.}
\end{figure}

As explained in chapter \ref{mbc}, games bigger than 32 KB required a Memory Bank Controller to swap chunks of 16 KB on-the-fly. These mapper chips also evolved as the Game Boy technology was revised. MBC1 could work with a 2 MB ROM and 32 KB of RAM at most, while the MBC5 can map up to 8 MB and is compatible with the GBC's double clock speed mode. 

Early games were frustrating not only because of their difficulty but also because of the lack of a save feature. Some developers intentionally left out the feature to artificially prolong the game, while others mostly cut it due to the added cost: anything extra soldered onto the PCB increased the manufacturing price. It sometimes breaks my heart to read in retro interviews with developers that the save feature didn't make it because the publisher wanted to cut costs[^saveex]. 

[^saveex]: For example, Plok for SNES in Retro Gamer 208.

Joonas Javanainen created an online Game Boy hardware database that contains photos of all possible cartridge circuit boards, available at [https://gbhwdb.gekkio.fi](https://gbhwdb.gekkio.fi). There, you can marvel at exotic MBC models, such as the MBC7 of _Kirby Tilt 'n' Tumble_ which is capable of reading data from the 2-axis ADXL202E accelerometer that detects how you hold the GBC in order to roll Kirby to the appropriate direction. 

Since we know everything is memory-mapped, something on the cartridge should be responsible for enabling access to installed sensors: the MBC. In order to read accelerometer data, you first have to latch it by writing `AAH` to location `$A010`. Then, X and Y values are accessible by reading two bytes from `$A020` and `$A040`.

Kirby was not the only one to receive a special sensor: there are improved and more sensitive gyro sensors (_Yoshi Topsy-Turvy_ and _WarioWare: Twisted!_ for GBA), light sensors that help you kill vampires[^vamps] (_Boktai: The Sun Is in Your Hand_ for GBA), rumble packs that required an extra AA battery (_Pokémon Pinball_ for GBC), extra infrared sensors that catch TV remote signals to reveal secrets in games (_Robopon: Sun Version_ for GBC), and Real Time Clocks to catch 'em all or make sure your _Tamagotchi_ is kept well-fed. 

[^vamps]: This was an especially sneaky way for Konami to get gamers to play outside. Not only for the fresh air but mostly because the non-lit GBA screen made games hardly playable without the presence of direct sunlight. 

Certain labels on the sticker of the cartridge revealed the compatibility of special play modes:

- "_Official Game Boy Video Link Game Pak_": The game has multiplayer support via the Link Cables. Strangely enough, many later games with multiplayer support lacked this label. 
- "_Super Game Boy Game Pak_": The game has enhanced Super Game Boy support that makes playing it on SNES more compelling.

\marginfig{ch-cartridges/donkeykong.png}{Donkey Kong has special support for the Super Game Boy on SNES, according to the black label.}{.}

### Hey, there's a a cartridge in your cartridge?

The Super Game Boy (SGB) was as an inventive way to enlarge the SNES library with more than a thousand Game Boy Games. Nintendo engineers created a SNES cartridge that is able to play original Game Boy cartridges (or black GBC ones in GB mode). 

\marginfig{ch-cartridges/dkgb.png}{Donkey Kong played in the BGB emulator, in original GB mode.}{.}

\marginfig{ch-cartridges/dksgb.png}{Donkey Kong played in the BGB emulator, in SGB mode. Notice that not only the border is colorful, but also the score on top, which is part of the game itself.}{.}

\marginfig{ch-cartridges/spaceinvaderssgb.png}{Booting Space Invaders on the SGB even reveals a hidden game mode!}{.}

Super Nintendo PCBs used the same mechanics as Game Boy PCBs: anything goes, as long as the pinout signal is what the machine expects it to be. Opening up a Super Game Boy reveals a Sharp `SGB-CPU` and two RAM chips, suspiciously familiar to those who inspected the Game Boy PCB at page \pageref{gbp}. The Super Game Boy is essentially a Game Boy itself! However, a lack of a separate crystal means the clock frequency of the SNES is followed, which divides by five, giving 4.295 MHz instead of 4.194 MHz, resulting in a slightly too fast running game. This can be rectified by buying the Super Game Boy 2, only released in Japan, or by soldering on the correct crystal oscillator yourself. 

Games that did not label "Super Game Boy Game Pak" could still be played on the SGB. A simple interface allowed players to change four colors of the GB palette and pick one of the few pre-defined borders that are present to adjust the TV to the GB aspect ratio. The presence of the label indicated a few mostly unimpressive extras (more colors or fancy border images to choose from). 

Some games did proudly wear the SGB label, managing to pull off very impressive tricks: from dramatically improved music (_Animaniacs_) and sound (Princess Peach actually yells "Help Me!" in _Donkey Kong_), and multiplayer support through up to four SNES controllers (the _Bomberman GB_ and _Wario Blast_ games), to even implementing an almost complete new 16-bit game (_Space Invaders_). 

The question is: how did developers cram in all that extra information on a tiny ROM chip on a Game Boy cartridge? The answer lies in taking control of the SNES CPU by hacking the P14 and P14 output lines of the Joypad register at `$FF00`. A crude packet transfer system can be set up to transfer streams of 128 bits of data from the GB to the SNES CPU. Large 4KB data blocks can be transferred by temporarily dumping data into VRAM. There are commands to manipulate palette data, to transfer WRAM, and even to change SNES VRAM OBJ data[^sgbcommands]. The latter allows developers to replace 8-bit GB sprites with 16-bit SNES ones. 

The SGB BIOS contains pre-defined sound effects (explosions, projectile hits, jumps, gate squeaks, ...) that can be played with the `SOUND` command. This saves developers some much-needed ROM space, although it is also possible to send data directly to the SNES APU via VRAM transfer.

[^sgbcommands]: A complete overview of commands can be found in the GB Pan Docs at [https://gbdev.io/pandocs/#sgb-functions](https://gbdev.io/pandocs/#sgb-functions).

\begin{figure}
    \centering
    \includegraphics{ch-cartridges/sgb.jpg}
    \caption{TODO The Super Game Boy PCB, containing two times 64K SRAM (top), the SGB BIOS ROM (right) and the GB CPU (left).}
\end{figure}


Sadly, GBC-exclusive games were not supported on the SGB. The 2003 GameCube accessory, confusingly called "_Game Boy Player_", is able to play all cartridges of the entire Game Boy family, including GBA games. The peripheral is installed via the high-speed port on the bottom of the GameCube. It bears more resemblance to the Sega CD extension than to the cartridge-in-cartridge SGB design. While the Game Boy Player enables another thousand games to be played on a bigger screen, the SGB-specific features of original GB games were lost. The good news is that the synchronization issue is fixed and some games (_Drill Dozer_, _Mario & Luigi: Superstar Saga_, etc) supported the rumble feature from the GameCube controllers.

### Memory-mapped cheating

As a kid, I never made it to the final boss of _Teenage Mutant Ninja Turtles II: Back from the Sewers_. No save slot and too much flying bullets to avoid in later areas eventually made me give up, until my dad bought me a _Game Genie_. It is another cartridge-in-cartridge device that fools the Game Boy into thinking it is running Turtles II, while in fact it is the Game Genie ROM that feeds it a modified version of the game. 

\marginfig{ch-cartridges/gamegenie.png}{The Game Genie with a GB cartridge loaded reversed.}{.}

The back of the bulky peripheral holds a tiny code book in which you can find cheats such as unlimited energy (`001-B6B-3BE`) or codes that start the game directly on act 5 (`043-8BE-E66`). Enabling one or more codes caused the Game Genie to hijack certain read requests from the CPU, and return other data instead of what the game ROM was supposed to do. This simple system was again made possible due to memory-mapped IO. 

A Game Genie code encodes a memory address to look out for, a value to return instead, and an optional conditional operand. Since many games were memory banked, memory addresses locations could point to different portions of the ROM depending on the piece of memory currently being banked by the MBC. A comparison value (the last three hexadecimal values of the code) should in theory mitigate this, although it does not completely solve the issue. This means using Game Genie cheats could result in weird things happening.

The Turtle II invincibility Code `001-B6B-3BE`, or in binary `0000. 0000 0001-1011 0110 1011-0011 1011 1110`, can be decoded as `0100 0001 1011 0110-0011 0101-0000 0000` by moving and inverting bits by a predetermined formula. The first four groups of bits represent the address: `$41B6`. the last two groups of two bits represent the condition and value: `35` and `00`. Some bits serve as a simple integrity check, but other than that it is possible to mess with any ROM value as new codes can be made up. 



Action Replay

mega memory card

### The sad tale of counterfeit cartridges

hier zetten in plaats van tussen hoofdstuk?

Foto GBA castlevania inside; tips; foto super GB 88

Met DS systeem veel moeilijker?