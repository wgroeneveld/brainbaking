---
title: Building an Athlon Windows 98 Retro PC
subtitle: "Gaming from Quake to Quake III: Arena!"
date: 2020-10-17
---

After the previous month's [reviving of a 80486 PC](/post/2020/09/reviving-a-80486/), including [upgrade 1](/post/2020/09/486-upgrade-sd-hdd/) and [upgrade 2](/post/2020/09/486-upgrade-sound-blaster/), it is time to revisit the last decent DOS-based Windows operating system: Windows 98 Second Edition. Earlier, I admitted the `66MHz` DX2 processor just wasn't good enough for Duke3D and Quake. I do have a Windows XP box (meat for another blog post), so I wanted to build something in-between. And yes, I will happily ignore the existence of Windows Me(h).

The 486 PC is able to run games from the early eighties to 1995. My Windows XP machine is a late WinXP era PC that is able to play games up to 2011. I needed something that sits comfortably in between these two timelines. The original Pentium CPU wasn't on my mind since a fast 486 (DX4) is able to beat it. As a kid, in the year 2000 I was a proud owner of a newly released AMD Athlon Thunderbird `1GHz`, upgrading from a Pentium II. It was the year of the Gigahertz barrier breach:

![](../ClockSpeed.png "Stock CPU clock speed history. Source: maximumpc.com")

As clearly visible in [the graph](https://web.archive.org/web/20150418074002/http://www.maximumpc.com:80/article/home/history_dream_how_ultimate_pc_has_evolved_15_years), 2000 was a big turning point for CPU speed. The Thunderbird was one of the first, that was also easily overclockable. AMD's K7 Athlon XP breached `2GHz` only two years later. So, the quest became clear and my mind was set: chasing nostalgic values again. I even managed to find my original [AOpen HQ45 mid tower](https://www.cnet.com/products/aopen-hq45-mid-tower-atx-series/) again!

### So... Which specs?

I had no intentions to build a ridiculously overpowered "_ultimate win98 gaming PC_", as many other bloggers [like](https://www.tomvanbrienen.nl/building-a-new-ultimate-windows-98-retro-pc-in-2020/) [to](https://retrorevive.enochdew.com/uwin98/) [call](https://www.overclockers.co.uk/forums/threads/building-the-ultimate-windows-98-gaming-pc.18845723/) it, I wanted something with subjective nostalgic value that is able to run any game from 1996 till 2003. More than `500MHz` certainly is overkill if you only want Win98 to run smoothly. At work, I managed to salvage an `1.4GHz` Thunderbird that might still work. Alas, it turned out to be dead[^dead] - but at least the motherboard was okay. 

[^dead]: We might have blown up that one. The old thermal paste and layers of dust on one of the motherboards started to smoke... 

![](../mobos.jpg "Which motherboard to pick, which slots to prefer?")

Another old and very much yellowed PC tucked away in a storage area brought salvation: it held an Athlon XP 2200+. That was not really what I was looking for, but the socket matched, and in the end I simply underclocked the newer CPU to `1.35GHz` by setting the FSB speed to 100 and switching out motherboards. It came with an AGPx8 board with DDR memory, and I was looking for a more authentic SD-based one. 

It is important to take a moment to look at various motherboard features, such as the interfacing support. I found another old board with one ISA-slot, but it only supports socket-A CPUs up to `1.0GHz`. Do I really need an ISA-based Sound Blaster in this PC? The 486 will more than suffice for OPL3/WaveTable music. In the end, I chose a board that supports both DDR and SD (but not both), and went with the latter. This is what I managed to scrape together:

- AMD [Athlon XP Thoroughbred](https://nl.wikipedia.org/wiki/Athlon_XP) 2200+ underclocked at `1.35GHz`
- Gigabyte K7 motherboard (2xUSB1.1, whoop-whoop!)
- 2x`256MB` PC133 Geil SD-RAM
- Seagate Barracuda 7200rpm `80GB` IDE
- [nVidia Riva TNT2 M64](https://www.techpowerup.com/gpu-specs/riva-tnt2-m64.c1304) OEM AGP graphics card
- Creative [Sound Blaster PCI Vibra 128](https://en.wikipedia.org/wiki/Sound_Blaster#Fifth_generation_Sound_Blasters,_PCI_cards,_multi-channel_and_F/X) (fifth gen.) - included with case
- A generic Realtek Ethernet RJ-45/Coax jack PIC network card
- [AOpen HQ45 ATX mid tower](https://www.cnet.com/products/aopen-hq45-mid-tower-atx-series/) with a newer `240W` PSU - `€50`

Although some of the cards aren't exactly something to write home about (A GeForce 3 Ti200 I once owned would also be authentic), they will do just fine until I come across something better. Ebay is sometimes too depressing: instant gratification at the cost of steep shipping prices. 

This is what the assembled motherboard looks like:

![](../win98cards.jpg "Inside the belly of the Win98 PC - plenty of space left!")

One of the things I did order as soon as I powered on the machine was a silent cooler. The stock Thermaltake socket A cooler pictured above sounds like a jet taking off! I might also drill some holes and install another Nexus 120mm system fan running at `7V` to get rid of the heat. The AOpen case isn't the best regarding air flow. Also, if anyone has suggestions on which cool/fun PCI/AMR cards to install, feel free leave a comment below.

### The (un)stableness of Windows 98 S.E.

After [downloading Windows 98](https://winworldpc.com/product/windows-98/98-second-edition) and burning the ISO (Burning a CD! The last time I did this was about 15 years ago. _Exciting!_), I was ready to FAT32-format the HDD with plenty of space for bigger games. The installation process blazed through in about 15 minutes (the specs are a bit high for a Win9x OS), but after the third reboot, blue screens started to appear. Here we go again... 

Fortunately, a second clean reinstall fixed that. I must have missed something. Next up were the nVidia drivers, but how to transfer data from other PCs onto this one? Removable USB media was not recognized - neither was the first Ethernet card I installed. Internet Explorer 5 managed to open [vogonsdrivers.com](http://vogonsdrivers.com) after swapping cards, allowing me to browse to proper Win9x USB drivers. A reboot or 20 later, my USB stick was finally working in Windows Explorer. 

I decided to also install the [Unofficial Win98SE Service Pack](http://htasoft.com/u98sesp/) 3.64, maintained by the community - that's why the screenshot below shows 'Windows ME' in the System Settings. It contains a lot of upgraded system files from later operating systems. It's also possible to install a modern fork of Mozilla using something called 'KernelEx', a layer of Win2000/XP drivers that make it possible to run more Win programs on DOS-based Win systems. Ultimately, I decided against using that, as I have another WinXP machine and Opera 10 works with (some) HTTPS websites.

![](../win98screen1.jpg "Win98 SE with an active Plus! theme. Wizardry 8 rearing to go!")

The Pinnacle PCTV Rave PCI tuner card I once had installed in a case such as this one refused to work on Win98, while it works flawlessly on the WinXP machine. I do have to admit that back in the day I quickly switched from Win98/Me to NT4/2000 after being fed up with the frequent crashes, odd error messages on bootup/shutdown and general unstableness of the operating system. Even simply uninstalling stuff like the Pinnacle software and drivers caused problems after rebooting. The hardware specs certainly can handle Win2000/XP but solely for nostalgic reasons, I wanted one PC with Win9x. 

The [MS Plus!](https://en.wikipedia.org/wiki/Microsoft_Plus!) themes still make me smile. Who doesn't like wiggling his mouse pointer all day if it's an animated bee, or hearing the startup/shutdown jungle noise? The first thing I did after the video/audio drivers was of course installing [Wizardry 8](https://jefklakscodex.com/tags/wizardry8/), my all-time favorite PC RPG, released in 2001.  Now, on to GOG.com/my gaming rack to fetch Unreal Tournament/Diablo II/GTA2/Baldur's Gate/Might and Magic VIII and others!
