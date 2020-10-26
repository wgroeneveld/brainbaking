---
title: Building a Core2Duo Windows XP Retro PC
subtitle: "Gaming from UT2004 to (almost) The Witcher 2!"
tags:
  - winxp
  - retro
categories:
  - hardware
date: 2020-10-25
---

Earlier in October, I blogged about [building an athlon win98 PC](/post/2020/10/building-an-athlon-win98-retro-pc/) which allowed me to replay Quake 1, 2, and 3 on original hardware. It is time to move on from Windows 98 and take the leap of faith, from DOS-based Windows operating systems, to one of the most popular Windows flavours of olde: Windows XP, released in 2001. XP was indeed a bit special becuase it was supposed to replace both Windows Me for "home users" and Windows 2000 for "profs" (although out of frustration, I ended up working with NT-based systems more often than DOS-based). WinXP's legacy only increased due to the unstable mess of its successor, Windows Vista. 

The classic OS has had an extremely long lifespan, being discontinued in 2008, and having had the luxury of three officially released service packs. Generally speaking, there are also three "WinXP era" PC builds to be put together:

1. Early WinXP (2001): `512 MB` SD RAM, Pentium III/IV `2 GHz`, GeForce 3/4 AGP
2. Mid WinXP (2003): `1 GB` DDR RAM, Pentium IV `3 GHz` GeForce FX AGP
3. Late WinXP (2006): `2 GB` DDR2 RAM, Core2Duo `2 GHz`, GeForce 8800 GTS PCI-E

Technology evolved rapidly (as usual) during these times: from SD to DDR, from single to dual core, and from AGP interfaces to [PCI Express](https://nl.wikipedia.org/wiki/PCI_Express) in 2004. Since I have a fairly powerful Win98SE build with `512MB` SD RAM, I am more interested in era two and three. Back in 2007, I completely redid my gaming rig, focused on **noise reduction**. I slowly but surely hated the noisy stock Athlon fans and had discovered [silentpcreview.com](https://silentpcreview.com) and their excellent community forums. Based on silence before power, I put together a lovely horizontal desktop PC with a sleek looking Antec case. 

### So... Which specs? 

In 2007, I had just begun to work, so I was still on a budget. The Core2Duo CPUs were becoming mainstream and pushed out single cores for good, while the GeForce 8800 GTS was the top of the line if you wanted to push those frames per second to the limit - including the excess noise and heat generation. Since I wanted silence, I got a fanless passive 8600GT - a mistake, since in my microATX case I couldn't get rid of the heat. The GPU easily peaked towards `80°C`, not something I was comfortable with. I ended up adding another fan between the graphics card and my TV card, losing two more slots. 

![](../winxp-geforce.jpg "GeForce 8600GT (left) and Radeon HD5570 (right).")

When I rescued the PC from a dusty closet earlier this month, I went over the options again. I had spare parts lying around from a more recent 2012 Core i5 build, and ultimately decided to swap graphics cards. The AMD Radeon HD5570, as you can see from the photo above, is a lot less beefy:

- It has a HDMI output port (Not very WinXP-ish but hey, it's there);
- It's a single-slot card and my case is small;
- It's _much_ more powerful (`1 GB` DDR3 VRAM??), and _much_ more energy-friendly. 
- It's free... 

The biggest disadvantage is the whiny tiny fan that loves to make a LOT of noise - not exactly what I was aiming for. A `5V` molex mod luckily shut it up. Also, buying a 8800GTS would force me to upgrade my `350W` PSU. The full build looks like this:

- Intel [Core2Duo](https://nl.wikipedia.org/wiki/Intel_Core_2) E6550@`2.3 GHz`
- [MSI G33M MS-7357](https://www.cpu-upgrade.com/mb-MSI/G33M_(MS-7357).html) DDR2 micro-motherboard, PCI-E 1.0
- 2x`1 GB` Geil Dual Channel DDR2-RAM
- Seagate [Barracuda 7200.10 RPM](https://nl.hddzone.com/seagate-st3320620as-harde-schijf-pcb/) `320 GB` HDD
- AMD Radeon HD5570
- Integrated audio and network ports (I might change that someday)
- [Antec NSK2400 HTPC Case](https://techgage.com/article/antec_nsk2400_htpc_case/) Silent
- Coupled with the awesome [Dell UltraSharp 2007WFP](https://www.cnet.com/products/dell-ultrasharp-2007wfp-series/specs/) 20" wide-screen IPS monitor.

I'm not too worried about the retro-correctness "level" of things inside the case, but the HD5570 is an `$80` entry-level card from 2012, so it's not too unbalanced. A few days ago, I bought a Core2Duo E7400@`2.8 GHz` for only `5 EUR` but sadly my motherboard refused to accept it as I cannot seem to get past POST with it installed in the socket 775 holder. Oh well, the difference won't be groundbreaking. 

![](../winxp-cores.jpg "Installing the core and mounting the cooling block.")

Every single fan inside the case has been modded: `7V` for the `350W` PSU and both Nexus Silent 120mm orange fans, and `5V` for the tiny AMD thing. The CPU cooler was mounted with a silent 80mm Bapst fan. The result? The GPU fan is **still** the noisiest! Nevertheless, Heat dissipation is good enough. The Nexus fans can't reach the back of the PCI-E cards so the passive 8600GT was never a good idea. The Radeon peaks to `60°C` with a small `5V` fan, still way below dangerous levels. 

### Performance

Simply put: it's great. Until your heart desires playing The Witcher 2 on a decent resolution with medium settings: the game runs relatively smooth but doesn't go beyond 18FPS. Still, for such a system, it's good enough for me. Looking at the [minimum specifications](https://www.systemrequirementslab.com/cyri/requirements/the-witcher-2-assassins-of-kings/11073) of the game, it seems that CPU/RAM is the bottleneck here. Whatever - most games I will be playing will be either early to mid winxp-era games anyway. Unreal Tournament 2004? +100FPS. Rainbow Six 3: Raven Shield? Capped at a comfortable 60FPS. Age of Empires III - a game I somehow never managed to run? +60FPS. Neverwinter Nights 2 struggles running smoothly, but that's due to the sluggish engine implementation. 

![](../winxp3-aoe3.jpg "Age of Empires III, everything maxed, on 1680x1050: above 60FPS.")

Even DScaler 4.x coupled with my trusty Pinnacle PCTV Rave PCI TV-Card works like a charm, connecting the Composite output of my GameCube to the system. That's how I played console games in 2003... Fortunately, nowadays we can safely replace a blurry mess with razor-sharp pixels outputted by FPGA-powered projects like Carby or the [EON GCHD Mk-II](https://www.eongaming.tech/product-page/gchd-mk-ii-hdmindigo) adapter. That means I moved my trusty silver GameCube to a newer HDMI-enabled screen. I might try HDMI PCI-E capture cards next in this build, but the motherboard is only capable of PCI-E 1.0 speeds (`250 MB`/s per pin instead of PCI-E 2.0's `500 MB`). 

After installing some games and tweaking Windows a bit:

![](../winxp1.jpg "The WinXP Service Pack 3 System Properties with a cold GPU.")

So that's it, now I own a 486 DX2-66 [DOS 6.22/Windows 3.11](/post/2020/09/reviving-a-80486) PC, an [Athlon Windows 98SE](/post/2020/10/building-an-athlon-win98-retro-pc/) PC, and a "newer" late era Windows XP machine! I had to completely reorganize my office space to accommodate all three computers including a newer screen and space for my work MacBook - but it was all worth it! Maybe one day I will be brave enough to take photos of the space and upload it to [Reddit's Retro Battle Stations](https://www.reddit.com/r/retrobattlestations/). 

Oh, and never install Windows XP on a hard disk that already contains a Linux distribution. Microsoft installers love to overwrite the Master Boot Record without asking... 
