
# Hardware

## The Game Boy Family

\cover{gbconsole.png}{Nintendo}{1989}{Handheld game console}

The original Game Boy (GB), codenamed Dot Matrix Game (DMG) or more lovingly called the _Gray Brick_, was not Nintendo's first electronic gaming handheld if you take the Game & Watch series into account. Still, it was the first breed of a new generation of handheld gaming _consoles_: a piece of machinery that enabled swapping game cartridges on the go. And those four AA batteries made sure you could stay on the go for as long as 15 hours - I hope you brought your spare set. 

It was released in April 1989 in Japan and after hitting the U.S. shelves two months later, the system sold a million units within a few weeks. Early adopters in Europe were better off importing as it took more than one year to arrive there! Nintendo quickly realised that the Game Boy was going to be a huge hit, and there was (almost) nobody there to stop them. 

Colored Game Boy casings were only offered six years after the original release, under the "_Play It Loud!_" campaign. It was purely a cosmetic change that would carry over to later revisions in the Game Boy family. According to Ars Technica, there are six major reasons why it performed so well over the course of its lifespan[^ars]:

[^ars]: Source: [https://arstechnica.com/gaming/2019/04/game-boy-20th-anniversary/](https://arstechnica.com/gaming/2019/04/game-boy-20th-anniversary/).

1. _Tetris_. Who would not recognize the iconic music and blocks at the hands of Alexey Pajitnov? The bundled game was a perfect match for a limited 8-bit system, best to be played in short bursts. Otherwise you run the risk of still hearing Music Type A in your dreams... 
2. Battery Life. Compared to the Sega Game Gear and Atari Lynx, both technically superior devices, the Game Boy simply allowed you to keep on playing. Battery technology was still in its infancy, and more CPU power or a backlit colored screen required too much juice. The Game Gear for instance required six AA batteries and lasted four hours - dying `73%` faster than the Game Boy!
3. Price. At launch, the Game boy was priced at `$89.99` and the Game Gear at `$149.99`[^gbpr] - that's `40%` more expensive. 
4. The Nintendo Brand. When conceiving the Game Boy, Nintendo was already dominating the home console market with the Nintendo Entertainment System (NES). Who could say no to a portable version of _Super Mario Bros._, called _Super Mario Land_, a launch title nonetheless?
5. The _Pokémon_ craze. Gotta catch 'em all!
6. Flexibility. Nintendo kept up with the technology race by regularly releasing new hardware revisions, updating the screens and power supply. You could even play Game Boy games on your SNES and GameCube.

[^gbpr]: In 2020, the GB would cost `$177.50` and the Game Gear `$295.85`.

The seventh reason might be overlooked by Ars Technica: _Robustness_. U.S. Police officer Stephan Scoggins of course bagged his Game Boy when he was deployed to support Operation Desert Storm as a medic. The barracks he slept in got bombed, completely destroying most possessions in it - except for his Game Boy. The handheld looked toast, so Stephan sent it to Nintendo for repair. Technicians only had to replace the destroyed battery pack before hearing the iconic _Pling!_. Military grade test passed. Stephan was sent a replacement unit and the scorched machine, dubbed the _Gulf War Game Boy_, was set on display at the Nintendo NY Center. 

\marginfig[-2cm]{ch-handheld-gb/gulfwar.png}{The Gulf War Game Boy still plays Tetris!}{The Gulf War Game Boy.}

I can't recall the number of times I dropped my (or one of my sisters) Game Boy: down the stairs at home "by accident" or on the concrete at school in a blind rage because of that annoying water level. Back then, instead of scraping together shattered glass and calling a cellphone repair shop, I simply had to dust off the front and maybe look around for the cartridge. 

To prove just how successful the Game Boy family would become, let us take a look at a console sales chart. What immediately becomes apparent is that the PlayStation 2 sits on the throne, very closely followed by the Nintendo DS family. The Game Boy family "only" comes in third, selling close to 119 million units in total since 1989 (including the Pocket and Color revisions). 

Before the rise of the PS2, the Game Boy would be the best selling gaming device ever, comfortably beating even home consoles. The Game Boy Advance did not perform too shabby either with its 81.5 million units. And even though the PlayStation Portable failed to challenge the DS, it did sell rather well. Early hacks and the easy installation of homebrew software is one of the major reasons why. I doubt Sony would call that a success. The excruciatingly slow loading speed of the UMD disks was universally hated. Sony's second shot at the handheld market with the Vita performed quite poor compared to the 3DS. 

\label{sales}
\begin{figure*}[ht!]
    \centering
    \includegraphics{ch-handheld-gb/sales.png}
    \caption{Total console units in millions sold, based on historical data from Nintendo, Gamespot and Wikipedia. Handhelds in dark green, TV consoles in light green.}
\end{figure*}

The main competitors of the Game Boy dangle at the bottom of the chart. The Atari Lynx barely sold one million units and the Game Gear managed to grab about `8%` of the handheld market share. 

In 2003, Nokia thought it was a good idea to compete with the Game Boy Advance. Why carry both a cellphone and a gaming device when one can be both, right? The result was a phone/game device that did neither well. The project was quickly abandoned two years later. Who would have thought that gamers dislike having to pry out the battery each time they want to swap game cartridges. 

Technically, the Game Boy was a bit less exciting:

| _Specification_ | _Value_                                      |
|-----------------|----------------------------------------------|
| CPU             | 8-bit Sharp LR35902 at 4.19 MHz (Z80-based)  |
| Memory          | 8 KB work WRAM, 8 KB video VRAM, 256 bytes ROM |
| Cartridges      | 32 KB to 8 MB                                |
| Screen          | 160 width x 144 height (10:9 aspect ratio)   |
| Colors          | 2-bit (4 shades of "olive green")            |
| Audio           | Two pulse wave generators, one 4-bit wave sample channel, 1 noise generator |
| Audio output    | handheld: mono. headphones: stereo.          |

By the year 1989, most home computers were powered by the 32-bit Intel 80386 processor running at 16 MHz, usually supported by a few megabytes of memory. Comparing a small (and cheap) handheld device with a PC is of course rather unfair. 

The specifications are more akin to Nintendo's 1985 NES. The console came equipped with two 8-bit Ricoh microprocessors: the CPU, running at 1.79 MHz in NTSC areas and at 1.66 MHz for the PAL version, and the PPU (Picture Processing Unit) running at 5.37 MHz and 5.32 MHz. It only contained 2 KB onboard RAM but supported expansions through the cartridges, up to 48 KB. One could look at the numbers and conclude that the GB was more powerful than the NES, but it's a bit more complicated than simply comparing hertz or byte values. 

The Game Boy was as one of the last 8-bit gaming device undoubtedly the weakest performing hardware devices of it's generation. This was far from a design flaw. The decision to use cheap and well-established technology in new ways fitted right in Nintendo's design philosophy. Gunpei Yokoi, the creator of the Game & Watch devices, the Game Boy, the D-pad, and the Metroid series, called it "_Lateral Thinking with Withered Technology_"[^thinkdiff]. Fun and gameplay before cutting edge technology, something that still stands when looking at Nintendo's later consoles such as the Wii and the Switch. Using withered technology also increased the battery life and reduced production costs. 

[^thinkdiff]: "_Think Different_" sounds suspiciously familiar. Other hardware companies such as Apple also tend to use established technology in new ways. The difference is that Nintendo is not a hardware company: it's a toy company that happens to utilize hardware.

The as advertised[^adv] more powerful Sega Game Gear was just was weak in reality, but it wasn't a case of lateral thinking: Sega's rushed effort to quickly counterattack the GB led to the recycling of older Master System hardware[^msh]. As a result, the Game Gear, released one year after the GB, also housed a variant of the Zilog Z80 8-bit CPU clocked at 3.5 MHz. Strangely enough, it also has 8 KB work RAM, and even the screen has the same resolution as the GB... 

[^adv]: Sega's Aggressive TV commercials called the Game Boy colors "_Creamed Spinach Color_" and showcased a kid hitting himself on the head with a squirrel before playing a Game Boy in order to see "colors". 

[^msh]: It was even possible to play Master System games with a converter cartridge. 

### The Game Boy Pocket

In 1996, Nintendo released the Game Boy Pocket to bridge the gap between a future colorized version of the Game Boy, not to be released until two years later, and the original version. One year later, in 1997, Nintendo's main handheld competitor Sega would throw in the towel by discontinuing the Game Gear. 

Contrary to the bulky original model from '89, the Pocket only required two AAA batteries - that's a lot less weight to be carried around as a kid. The cost was `33%` less playtime, clocking in about 10 hours on average. 

The best part of the Pocket was not the weight, but the screen: `48.5 mm` width and `43.5 mm` height (`65 mm` diagonal) meant it was larger than both the original and the superseding Game Boy Color! Even if you still could not play in darker environments, the screen quality noticeably improved by reducing pixel-response time. It was far from perfect, but the "true" black-and-white screen did get rid of the four shades of green. To put a Pocket under the Christmas tree, your parents had to dish out only `$69`[^gbpprice].

[^gbpprice]: About `$113.37` in 2020. 

Under the hood, besides the screen and power supply, the technical capabilities remained unchanged. 

\newpage

\begin{figure}[h!]
    \centering
    \includegraphics{ch-handheld-gb/hw-gbpocket.jpg}
    \caption[The Game Boy Pocket.]{The Game Boy Pocket. Early versions came without the "power" indicating LED, that was reintroduced later due to public demand. As usual, limited editions with special colors were also issued. The depicted European model is from 1997. \newline A slightly modified version called the \emph{Game Boy Light} sadly only really saw 'the light' in Japan, in April 1998, only five months before the arrival of the Game Boy Color. I am sure the system would have sold overseas just as crazy as the other machines, since it was the first Nintendo handheld to feature an electroluminescent backlit screen. European gamers like myself had to wait until 2006 to get their hands on the GBA SP AGS-101, the second backlit Game Boy model ever created. \newline The GB Light's power source were two AA batteries instead of the AAA of the pocket, good for the same twelve hours of gameplay with the backlight turned on. Visually, the BG Light and the GB Pocket look the same, except that the back of the GB Light is slightly thicker to accommodate the bigger batteries. The printed circuit board (PCB) layout is identical to the Pocket.}
\end{figure}

\newpage

\begin{figure}[h!]
    \centering
    \includegraphics{ch-handheld-gb/pcb-gbpocket.jpg}
    \caption{The main board viewed from the back of the Game Boy Pocket. An aluminum piece that is part of the plastic housing, not depicted here, shields the CPU chip (CPU-MGB) from signals coming from the cartridge when inserted into the black slot. \newline The clock speed is regulated by the crystal on the left of the CPU that reads 4.1943 (MHz). The smaller chip on the upper left is the LCD regulator (DMG-REG), while the one on the lower right is the amplifier (AMP-MGB). \newline Compared to the PCB of the original Game Boy, there's only one visible SHARP 8 KB (64K) SRAM chip. Another 8 KB video RAM was embedded in the CPU casing. \newline Two potentiometers regulate the volume (gray wheel) and screen contrast (black wheel). \newline The mono sound output generated by the speaker on the bottom left could be overcome by a headphone jack that does output in stereo. }
\end{figure}

### The Game Boy Color

\marginfig{ch-handheld-gb/mario2-gb.png}{Super Mario Land 2 on the original Game Boy: four shades of ugly looking green.}{Super Mario Land 2 on the original Game Boy.}

\marginfig{ch-handheld-gb/mario2-gbp.png}{Super Mario Land 2 on the Game Boy Pocket: A lot more clear with four shades of grey.}{Super Mario Land 2 on the Game Boy Pocket.}

\marginfig{ch-handheld-gb/mario2-gbc.png}{Super Mario Land 2 on the Game Boy Color: the four accents have been replaced by colors, and sprites (Mario, the Goomba, the coin) even received extra tints!}{Super Mario Land 2 on the Game Boy Color.}

Why did it take almost nine years for Nintendo to develop a colored version of their Game Boy when the technology was already there? Sega's Game Gear could output colors in 1990. The answer is, again, battery life and price. Nintendo always made sure that gamers (and their parents) could afford their handhelds. Having to buy a lot of batteries also comes at a price, and rechargeable batteries were not yet mainstream.

The biggest difference between the Color and the original is... well... the colored screen! Although still not backlit, the GBC was universally praised by reviewers and loved by consumers. The smart decision to keep the technology mostly unchanged enabled gamers to play old GB games on the GBC. What's more, playing older games on you Color somehow transformed your monochrome dull-looking "spinach drab" into an aesthetically pleasing experience! The scanline-enabled screenshots of Super Mario Land 2 in the margin showcase the difference between each Game Boy revision. 

Besides the nostalgic value, the Gray Brick was quickly ditched in favor for the definitive way to play the games: on the Game Boy Color. The GBC is capable of automatically adding up to 16 colors to certain original games (gray cartridges). 45 unique palette configurations are stored in a hash table inside the GBC BIOS. Games that match the hash are assigned a certain configuration. For example, in table `0x05`, hash `0xC9` corresponds to the hash found in _Super Mario Land 2_ cartridges, thus selecting the following colors:

\definecolor{ml2bg0}{HTML}{FEFCCE}
\definecolor{ml2bg1}{HTML}{71EFEF}
\definecolor{ml2bg2}{HTML}{9C8431}
\definecolor{ml2bg3}{HTML}{595959}

\definecolor{ml2obj00}{HTML}{FFFFFF}
\definecolor{ml2obj01}{HTML}{ED7033}
\definecolor{ml2obj02}{HTML}{94431C}
\definecolor{ml2obj03}{HTML}{000000}

\definecolor{ml2obj10}{HTML}{FFFFFF}
\definecolor{ml2obj11}{HTML}{63A4FC}
\definecolor{ml2obj12}{HTML}{244AFB}
\definecolor{ml2obj13}{HTML}{000000}

- Background: \hspace{1mm} \colorbox{ml2bg0}{\texttt{0xFFFFCE}}, \colorbox{ml2bg1}{\texttt{0x63EFEF}}, \colorbox{ml2bg2}{\textcolor{white}{\texttt{0x9C8431}}}, \colorbox{ml2bg3}{\textcolor{white}{\texttt{0x5A5A5A}}}
- Object layer 0: \colorbox{ml2obj00}{\texttt{0xFFFFFF}}, \colorbox{ml2obj01}{\texttt{0xFF7300}}, \colorbox{ml2obj02}{\textcolor{white}{\texttt{0x944200}}}, \colorbox{ml2obj03}{\textcolor{white}{\texttt{0x000000}}}
- Object layer 1: \colorbox{ml2obj10}{\texttt{0xFFFFFF}}, \colorbox{ml2obj11}{\texttt{0x63A5FF}}, \colorbox{ml2obj12}{\textcolor{white}{\texttt{0x0000FF}}}, \colorbox{ml2obj13}{\textcolor{white}{\texttt{0x000000}}}

If the BIOS did not recognize a game cartridge, a default palette configuration was used instead. However, players could also influence the configuration by pressing a combination of certain buttons while the Game Boy was booting and the Nintendo logo was being displayed. Twelve palette configurations are stored next to the hash table for the player to manually select, of which six were unique to the manual selection. Try it yourself by pressing \rightarrow, \circled{B} + \uparrow, \circled{\small A} + \uparrow, \leftarrow, or \circled{B} + \downarrow . You should immediately see its effect on the logo screen since the background colors change. Even the word "_COLOR_" in the logo advertised the capabilities as each letter represents one of the five color flavors in which the GBC was sold: Berry (C), Grape (O), Kiwi (L), Dandelion (O), Teal (R). Strangely enough, the translucent purple one does not fit in that row. Limited edition colors would also follow soon. 

\marginfig{ch-handheld-gb/gbcolorlogo.png}{The Game Boy Color Logo.}{The Game Boy Color Logo.}

\begin{figure}[t!]
    \centering
    \includegraphics{ch-handheld-gb/color-ml2.jpg}
    \caption{Super Mario Land 2 cover art in original colors.}
\end{figure}

\marginfig[-14.2cm]{ch-handheld-gb/color-ml2-4.jpg}{Super Mario Land 2 cover art in 4-color grayscale (simulated GB) mode.}{Super Mario Land 2 cover art in GB mode.}

\begin{figure}[t!]
    \centering  
    \includegraphics{ch-handheld-gb/color-ml2-56.jpg}
    \caption{Super Mario Land 2 cover art in 56-color (simulated GBC) mode. Note the lack of subtle shades in Mario's face and the bottom of his shoe.}
\end{figure}

The Game Boy Color uses a 15-bit RGB color palette, where five bits are used to represent red, green, and blue values, yielding `32.768` unique colors in total ($(2^5)^3$). 15-bit RGB palettes were quite popular: the SNES, Nintendo DS (for 2D output), Sega 32X, GBA, PS1 (for 3D textures) all had a color depth of 15-bit. In practice, most devices restrict the amount of colors to be used at the same time due to memory limitations. For the SNES, most games use 256-color mode[^snescolor]. For the GBC, only 56 distinct colors could be employed for transparent GBC-only cartridges. As we will discover later, there is a way around this limitation.  

[^snescolor]: Sega's MegaDrive/Genesis a used 9-bit palette with usually only up to 61 colors visible at once without special effects. The Game Gear employed a 12-bit palette with 32 different colors on-screen. The Game Boy Color almost doubled that amount, although admittedly Sega did beat Nintendo to the colored market by eight years! 

In addition to the joy of fiddling with Nintendo's proprietary Link Cables to play Tetris against each other, you could now use the new infrared port to exchange and unlock special items. Sadly, only a few (17) games ended up supporting the functionality, and it was later dropped with the Game Boy Advance. Pokémon players rejoiced while others shrugged: merely exchanging high scores isn't all that exciting. Wireless communication technology wasn't yet cheaply available and gamers had to wait until the Nintendo DS to comfortably compete without an excess of too short cables attached. 

Technically, the Game Boy Color looked remarkably similar to its predecessor:

| _Specification_ | _Value_                                           |
|-----------------|---------------------------------------------------|
| CPU             | 8-bit Sharp LR35902 at 4.19/8.39 MHz              |
| Memory          | 32 KB work WRAM, 16 KB video VRAM                 |
| Cartridges      | 32 KB to 8 MB                                     |
| Screen          | 160 width x 144 height (10:9 aspect ratio)        |
| Colors          | 15-bit                                            |
| Audio           | Two pulse wave generators, one 4-bit wave sample channel, 1 noise generator |
| Audio output    | handheld: mono. headphones: stereo.               |

Recycling the PCB of the Pocket and the CPU of the original GB again significantly reduced manufacturing costs. The CPU itself could run at twice the speed of the original (for GBC-only games) but only the oscillating crystal itself was changed, "overlocking" the older configuration. The memory size was quadrupled for the work RAM and doubled for the VRAM since storing 15-bit palette data required much more space. Game developers could choose not to take advantage of the increased clock speed and memory size by releasing black cartridges that could also run on the original GB.

### The Game Boy CPU Architecture

\begin{figure}[h!]
    \centering
    \includegraphics{ch-handheld-gb/gbarchitecture.png}
    \caption{A simplified schematic of the Game Boy hardware architecture. The Audio Processing Unit (APU), Central Processing Unit (CPU), and Picture Processing Unit (PPU) are embedded in the DMG-CPU casing. Not all cartridges contain batteries that power SRAM. }
\end{figure}

While the CPU is indeed the "central" processing unit, it delegates audio and picture processing to the corresponding subsystems, also embedded within the DMG-CPU casing. Graphics calculations are done in the CPU, but the PPU is responsible for converting the stored graphics from the VRAM to pixels on the screen itself. The inner workings of the PPU is explained in chapter TODO-ref.

The same applies for the audio: the CPU reads data from the ROM and can apply transformations to it before sending it off to the APU. Its job is to mix different channels and convert them from digital to analog. Then, after the amplifier adjusts the volume depending on the value of the potentiometer (the volume wheel), the audio signal is played by either the mono speaker or the stereo headset. How audio works is explained in chapter TODO-ref.

At any given time, these subsystems[^subs] can cause the CPU to _interrupt_ its current work and execute a special subroutine. Interrupts allow developers to program special effects by hooking into the hardware internals. For example, when a frame is rendered, the PPU emits a "_v-blank_" (vertical blank) event, signaling that it is done rendering. This can be listened to in order to quickly write to VRAM after the PPU is done. Modifying VRAM in-between rendering can cause flickering on screen. Other uses of interrupts include synchronization of linked Game Boys, timers that can be programmed, and listening for button presses. 

[^subs]: Subsystems not depicted in the schematic are the timer, the memory bank controller (MBC), the serial port, and the direct memory access (DMA) mechanic. These will be discussed later. 

In essence, the Game Boy uses a simple hardware architecture. The CPU has access to pretty much all subsystems through a concept called _memory-mapped IO_: reading certain parts of the memory results in reading certain states of subsystems. There are no device drivers and there is no operating system managing resources for multiple programs. In fact, the only program running at a given time will be the game you booted up - after the BIOS handed over the controls, that is. 

Since the Sharp CPU is an 8-bit processor, it can only access and process 8 bits of data at one time. However, in order to directly access any subsystem through the memory-mapped system, it uses a 16-bit address bus. That means `65.536` positions of memory can be directly accessed: from `$0000` to `$FFFF`\sidenote[9][-1.6cm]{Instead of
  working with long binary numbers, most Game Boy programming happened
  using hexadecimal values, preprended by \texttt{\$} or \texttt{0x}.
  \texttt{\$FFFF} equals \texttt{1111111111111111}, sixteen enabled bits
  or \texttt{65535} in decimal.}. The full address space looks like this:

\begin{figure*}[h!]
    \centering
    \includegraphics{ch-handheld-gb/gbmemmap.png}
    \caption{A visual representation of the 16-bit address space.}
\end{figure*}


