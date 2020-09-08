
# Hardware

## The Game Boy Family

\cover{gbconsole.png}{Nintendo}{1989}{Handheld game console}

The original Game Boy (GB), codenamed Dot Matrix Game (`DMG`) or more lovingly called the _Gray Brick_, was not Nintendo's first electronic gaming handheld if you take the Game & Watch series into account. Still, it was the first breed of a new generation of handheld gaming _consoles_: a piece of machinery that enabled swapping game cartridges on the go. And those four AA batteries made sure you could stay on the go for as long as 15 hours - I hope you brought your spare set. 

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

In 2003, Nokia thought it was a good idea to compete with the Game Boy Advance. Why carry both a cellphone and a gaming device when one can be both, right? The result was the N-Gage, a phone/game device that did neither well. The project was quickly abandoned two years later. Who would have thought that gamers dislike having to pry out the battery each time they want to swap game cartridges. 

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
    \label{gbp}
\end{figure}

\newpage

\begin{figure}[h!]
    \centering
    \includegraphics{ch-handheld-gb/pcb-gbpocket.jpg}
    \caption{The main board viewed from the back of the Game Boy Pocket. An aluminum piece that is part of the plastic housing, not depicted here, shields the CPU chip (CPU-MGB) from signals coming from the cartridge when inserted into the black slot. \newline The clock speed is regulated by the crystal on the left of the CPU that reads 4.1943 (MHz). The smaller chip on the upper left is the LCD regulator (DMG-REG), while the one on the lower right is the amplifier (AMP-MGB). \newline Compared to the PCB of the original Game Boy, there's only one visible SHARP 8 KB (64K) SRAM chip. Another 8 KB video RAM was embedded in the CPU casing. \newline Two potentiometers regulate the volume (gray wheel) and screen contrast (black wheel). \newline The mono sound output generated by the speaker on the bottom left could be enhanced by a headphone jack that outputs sound in stereo. }
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
    \caption{A simplified schematic of the Game Boy hardware architecture. The Audio Processing Unit (APU), Central Processing Unit (CPU), and Picture Processing Unit (PPU) are embedded in the DMG-CPU casing. Optional components on the cartridge, such as the battery that powers SRAM and the Memory Bank Controller (MBC), are marked orange. Based on Rodrigo Copetti's Game Boy Diagram.}
    \label{gbarchitecture}
\end{figure}

While the CPU is indeed the "central" processing unit, it delegates audio and picture processing to the corresponding subsystems, also embedded within the DMG-CPU casing. Graphics calculations are done in the CPU, but the PPU is responsible for converting the stored graphics from the VRAM to pixels on the screen itself. The inner workings of the PPU is explained in chapter TODO-ref.

The same applies for the audio: the CPU reads data from the ROM and can apply transformations to it before sending it off to the APU. Its job is to mix different channels and convert them from digital to analog. Then, after the amplifier adjusts the volume depending on the value of the potentiometer (the volume wheel), the audio signal is played by either the mono speaker or the stereo headset. How audio works is explained in chapter TODO-ref.

At any given time, these subsystems[^subs] can cause the CPU to _interrupt_ its current work and execute a special subroutine. Interrupts allow developers to program special effects by hooking into the hardware internals. For example, when a frame is rendered, the PPU emits a "_v-blank_" (vertical blank) event, signaling that it is done rendering. This can be listened to in order to quickly write to VRAM after the PPU is done. Modifying VRAM in-between rendering can cause flickering on screen. Other uses of interrupts include synchronization of linked Game Boys, timers that can be programmed, and listening for button presses. 

[^subs]: Subsystems not depicted in the schematic are the timer, the serial port, and the direct memory access (DMA) mechanic. These will be discussed later. 

In essence, the Game Boy uses a simple hardware architecture. The CPU has access to pretty much all subsystems through a concept called _memory-mapped IO_: reading certain parts of the memory results in reading certain states of subsystems. There are no device drivers and there is no operating system managing resources for multiple programs. In fact, the only program running at a given time will be the game you booted up - after the BIOS handed over the controls, that is. 

Since the Sharp CPU is an 8-bit processor, it can only access and process 8 bits of data at one time. However, in order to directly access any subsystem through the memory-mapped system, it uses a 16-bit address bus. That means `65.536` positions of memory can be directly accessed: from `$0000` to `$FFFF`\sidenote[9][-1.6cm]{Instead of
  working with long binary numbers, most Game Boy programming happened
  using hexadecimal values, preprended by \texttt{\$} or \texttt{0x}.
  \texttt{\$FFFF} equals \texttt{1111111111111111}, sixteen enabled bits
  or \texttt{65535} in decimal.}. The full address space looks like this:

\begin{figure*}[h!]
    \centering
    \includegraphics{ch-handheld-gb/gbmemmap.png}
    \caption{A visual representation of the 16-bit address space. Based on DuoDreamer's DreamScape Game Boy Memory Map.}
\end{figure*}

\definecolor{memmap0}{HTML}{CE48AF}
\definecolor{memmap1}{HTML}{7436A5}
\definecolor{memmap2}{HTML}{BF58FE}
\definecolor{memmap3}{HTML}{EE7D33}
\definecolor{memmap4}{HTML}{F5B233}
\definecolor{memmap5}{HTML}{FDE033}
\definecolor{memmap6}{HTML}{FDF47C}

- \colorbox{memmap0}{\textcolor{white}{\texttt{\$0000-\$00FF}}}: _Interrupt tables_. The first 255 bytes in the address space are reserved for managing interrupts. For example, if you write a certain address to `$0040`, which is the v-blank interrupt, the CPU will jump to that location and execute a piece of code after the PPU declares it is done writing all pixels to the screen for a single frame.
- \colorbox{memmap1}{\textcolor{white}{\texttt{\$0100-\$014F}}}: _Cartridge header area_. These addresses allow the developer to access the cartridge and retrieve metadata: game name, cartridge type, ROM/RAM size, color mode, ... \newline Address `$0104` should point to the Nintendo logo present on the cartridge[^revcopy]. It was Nintendo's attempt to prevent unauthorized publishers from releasing games on the Game Boy, as the logo is a registered trademark. Upon booting the GB, the BIOS will check if the logo is present. If it is not, it will simply hang after displaying the logo on screen and the game will not start. 
- \colorbox{memmap2}{\textcolor{white}{\texttt{\$0150-\$7FFF}}}: _Cartridge ROM_. When the BIOS is done checking the integrity of the inserted game, it hands over control by starting execution at `$0100`, which usually contains a jump to `$0150`: the first line of code of the game itself. 
- \colorbox{memmap3}{\texttt{\$8000-\$9FFF}}: _VRAM_. Tiles and background data used by the PPU to draw the screen is accessible via these addresses. 
- \colorbox{memmap4}{\texttt{\$A000-\$BFFF}}: _Cartridge RAM_. This RAM is external and optional. If a GB game allows you to save and load your progress, these addresses are used to to it. 
- \colorbox{memmap5}{\texttt{\$C000-\$FDFF}}: _WRAM_. Address space used to store temporary variables. Your score, amount of lives, current level number, ... 
- \colorbox{memmap6}{\texttt{\$FE00-\$FFFF}}: _Various_, including sprite RAM and hardware IO registers. Instead of waiting for certain interrupts to occur, you can also poll IO ports directly. This is a very dense area: almost every bit has a special meaning. 

[^revcopy]: These simple checks did not prevent hackers from reverse-engineering software in order to copy the logo data. In the early nineties, multiple lawsuits concerning similar copyright infringements were filed: Accolade copied the trademark security system of the Sega Genesis/MegaDrive and Atari copied the NES "checking integrated circuit" (CIC) chip. These cases proved to be influential in how reverse engineering with unlicensed products is perceived in issues involving copyright. 

\marginfig{ch-handheld-gb/x-nintendo-logo.png}{Fun fact: the PPU did not clear VRAM after displaying the Nintendo logo. Many games played with it, adding various effects, such as this fading one as seen in in \emph{X} (see chapter \ref{ch-x}). }{.}

This memory map method allows developers to easily load any kind of data using the correct address within the 16-bit range. Want to check if the player pressed \circled{\small A}? Read the first bit at `$FF00`. Want to read graphics data from the cartridge and write it to VRAM in order to display it? Read from `$2FF0` and write to `$9000`. Every single action involves an address. 

You might be wondering how the ROM space can fit inside the rather small 32 KB space at `$0150-$7FFF`, or how the 32 KB WRAM of the GBC can fit inside the tiny space at `$C000-$FDFF`. The answer is it does not fit. Instead, the Game Boy uses _banking switching_: a technique to dynamically reconfigure certain address space blocks to map other portions of memory. 

\label{mbc}

The cartridge ROM blocks are split in two: the first 16 KB (called bank $0$) is fixed, while the second part (bank $n$) is dynamic. Some games like Tetris do not need bank switching as their ROM footprint is small enough to fit inside the address space. Most games are bigger than 32 KB and can grow up to 8 MB. The part responsible for switching out banks in the second part is called the _Memory Bank Controller_ (MBC), a chip on the cartridge and not the Game Boy PCB itself. Different versions of these chips exist as we will see in chapter TODO-ref.  

Ordering the MBC to switch to a certain bank is a matter of writing to... read-only memory? For example, to read the next 16 KB positioned at bank 5, we load the value `5` into destination `$2000` (that lies within cartridge ROM address space). The MBC intercepts this useless attempt to write to read-only memory and switches banks instead.

For the Game boy Color, the whole VRAM address space is also banked. There are two 8 KB VRAM banks available since the Color contains twice the amount of video memory. The second half (4 KB) of the WRAM address space is also banked where you can choose to map one of the seven banks of 4 KB each, covering 32 KB in total.

\begin{figure*}[h!]
    \centering
    \includegraphics{ch-handheld-gb/gbmemmapbank.png}
    \caption{Memory banking on the 16-bit address space. Light green memory portions (VRAM, WRAM) are only available for the Game Boy Color.}
\end{figure*}

\newpage

### Processing Instructions

As soon as you power on your Game Boy until the batteries are run out or you're tired of playing, the CPU executes a sequence of 8-bit instructions. When looking at the address space, we know instructions start at `$0000` and continue into the BIOS area to display the logo, eventually ending up in the cartridge ROM. But what exactly is an instruction and how does the CPU process it?

Imagine you are configuring the GPS of your car. Usually, it is a simple matter of entering the destination address, maybe followed by the option to take the most economical route. "Go to Brussels" is a very high-level instruction that the GPS breaks down into low-level instructions: "Drive straight ahead here", "Turn left there".  

\marginfig{ch-handheld-gb/2goombas.png}{}{Two Goombas from Super Mario Land 2.}

Sadly, instructing the Game Boy to "draw two Goombas", a high-level instruction, simply does not work: it is not familiar with drawing, nor with a Goomba. Instead, game programmers tell the CPU what to do using special machine codes. These low-level instructions can manipulate _registers_ in order to do something. Drawing a Goomba requires a staggering amount of instructions: copy a value from cartridge ROM into a register, increase the value of the address pointer to copy the next value, copy all these Goomba parts into VRAM using the same sluggish procedure, and so on. 

\label{ldgb}

An example of a Game Boy instruction is `01111000` (`$78`). It tells the CPU to copy the value of register B into register A. Fortunately, programmers do not need to memorize each bit: instead, they write what is called _assembly_ code `LD A,B`[^ld] instead. Coding in assembly is the most basic (and perhaps also the most exhausting) way to write programs. More modern machines, including the Game Boy Advance, allow game developers to write code in higher level programming languages that is compiled into low level machine code[^gbacode]. Instead of having to yell "Turn left! Go Right!", which might "drive" a competent driver mad, you could say "follow this national road until we reach the next village". That way, less instructions are needed to arrive at Brussels.

[^ld]: Read as "load in A the value of register B". The destination register is always mentioned first. 

[^gbacode]: This is not entirely correct: you can write GB games in C instead of assembly thanks to SDCC (Small Device C Compiler), an ANSI C compiler that can target the Game Boy platform. These tools are usually made by fans who reverse-engineer the hardware. 

Every CPU comes with its own instruction set that programmers need to master. The Game Boy CPU instruction set[^cmds] is a mix between the Zilog Z80 and the Intel 8080. Instructions cover loading values into registers (e.g. hard-coded numbers, from addresses, or from other registers), arithmetics, jumping to certain addresses, and so forth. 

[^cmds]: Eight bits give us $2^8$ (256 or `$FF`) possible instructions or "opcodes" - without counting the special `CB` codes.

In order to calculate something, the CPU needs a place to quickly and temporary store stuff, separate from RAM. These 16-bit places are called registers. The memory chip acts like a cupboard. In order to have dinner, you take out the plates and put them on the table. Only then the cutlery and plates become something to interact with for your guests. The CPU can only perform arithmetics on values stored in register `A`. 

\marginfig{ch-handheld-gb/gbregisters.png}{Available registers in the Game Boy CPU. The \texttt{SP} (Stack Pointer) and \texttt{PC} (Program Counter) registers cannot be split up. The \texttt{HL} register is used to point at an address in the memory map.}{Registers of the Game Boy.}

Some registers can be split in two separate 8-bit registers when more space is needed. Others need to keep their 16-bit length in order to point to certain addresses in memory space. Otherwise, we would not be able to reach the second half of the memory space. 

But how exactly are instructions processed and where do they come from? Any CPU follows a simple "machine cycle" of actions in order to process instructions: _fetch_ the instruction, _decode_ the instruction, and _execute_ the instruction. 

\label{fetch-decode-execute}

1. _Fetch_ the next available instruction where the special Program Counter (`PC`) register is currently pointing at. The `PC` could contain `$3000`, an address that lies within bank `0` of the cartridge ROM. Any fetch instruction looks at the `PC` value and simply fetches eight bits at that location. 
2. _Decode_. Great, we've got `01111000`, now what? The CPU needs to figure out (decode) what each unique combination of bits should do. Some operations take arguments, in which case we also need the fetch the next 8 bits. After we know what to do, we can safely increase the `PC` value for the next fetch.
3. _Execute._ So, `01111000` was fetched and deciphered. Now we need to actually do something: load the value of register B into A. Depending on the instruction, the execution time varies. 

### A "bit" about the speed of the CPU

In theory, the Game Boy runs at a speed of 4.19 MHz. However, since we know that instructions take a while to go through the fetch/decode/execute machine cycle, the actual execution time of an instruction becomes slower. On the Game Boy, any instruction takes at least four clock cycles to execute, bringing the effective CPU speed closer to 1 MHz. 

What is a megahertz anyway? Hertz is a unit of _frequency_, defined as one cycle per second. One MHz equals $10^6$ Hz. Sine waves, light flashes, musical tones, and clock speeds of oscillating crystals on PCB boards: they all have their own rhythm or frequency. The refresh rate of your TV, for instance 60 Hz, means it will display an image 60 times per second. 

The crystal on the circuit board dictates how "frequent" the CPU can process instructions. The instruction processing speed is also expressed in _clock cycles_. An instruction that takes four cycles means that the frequency wave of the crystal has gone up and down four times before the instruction was successfully processed. 

\begin{figure*}[h!]
    \centering
    \includegraphics{ch-handheld-gb/gbclockcycle.png}
    \caption{The square wave signal of the Game Boy clock. The amplitude alternates between a fixed minimum and maximum because of electronic switching behavior.}
\end{figure*}

The clock goes at a rate of 4.19 MHz, or 4190000 Hz, or 0.000000239 seconds, or 239 nanoseconds. It takes at least four clock cycles for the fetch/decode/execute machine cycle to complete, depending on the instruction: about one microsecond. 

The fewer available resources such as a low clock rate, the more important it becomes for programmers to be well-aware of the instruction processing time. There is little room for errors. In the end, gamers want a snappy experience, not a sluggish Mario that who responds late to button presses. 

### Game Boy Accessories

Secretly playing in bed at night was out of the question with the Game Boy. Without a proper light source, it was nearly impossible to distinguish friend from foe in-game. Companies like Hori and Joyplus quickly responded by flooding the market with an abundance of accessories, of which some required even more batteries.  

One particular accessory stands out as the all-in-one solution. Perhaps the ultimate way to play the Game Boy is the _Handy Boy_. An advertisement claims that you should not settle for less[^handyboy]:

[^handyboy]: Image courtesy of [Retromags.com](https://retromags.com) curator Phillyman.

> _Fully loaded_. It's the stereo-amplifying, screen magnifying, night lighting, fire button enlarging, thumb stick controlling, compacting easy carrying accessory for your Game Boy - whew! Try saying that three times fast - it's a mouthful! But that's what you get when you have it all. Other Game Boy accessories leave you with nothin' to say. Hey, there's only one worth talkin' about. _Handy Boy - don't settle for less._

Besides that mouthful, there's a rechargeable battery pack, a solar charger, more screen-related attachments like the Nuby Boy, the Light Boy, and the Light Magic, ways to cheat using Action Replay or Game Genie adapters (see chapter TODO-ref), Link Cables and 4-player adapters (see chapter TODO-ref), more external sound amplifiers, a camera, a printer, an FM radio receiver,  the Work Boy for those spreadsheet fans, the Barcode Boy to scan random articles in the hope of playing certain mini-games, a sonar to detect fish underwater, and even Singer's Game Boy Sewing Machine[^agvnacc]!

[^agvnacc]: I highly recommend you to watch the Angry Video Game Nerd inspect these gadgets, at [https://www.youtube.com/watch?v=EEzJH90h3aA](https://www.youtube.com/watch?v=EEzJH90h3aA). The result is, as expected, hilarious. 

The portability of the handheld was also questioned as dragging accessories, cartridges and batteries around proved to be quite a challenge. The solution to this problem is of course more accessories: waist bags and shoulder bags for the quick field trip and bigger plastic Game Boy travel cases that can harbor lots of goodies for the sleepover. 

At least GB "LAN" parties did not involve hauling twenty kilogram CRT screens from point A to point B. You did bring your Link Cable, right? 

\backgroundsetup{
  scale=1.0,
  angle=0,
  opacity=1,
  contents={\includegraphics[width=\paperwidth,height=\paperheight]{ch-handheld-gb/acc.jpg}}
}

\newpage

\BgThispage
\mbox{}

\newpage

