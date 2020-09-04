---
title: "Reviving an old 80486 PC"
date: '2020-09-03'
subtitle: "24 years later, does it still work?"
tags:
  - retro
  - hardware
categories:
  - braindump
---

What better birthday present to wish for as rapidly too old growing nostalgic computer nerd than a too old PC? "_Here, take this. At least now we don't have to haul it to the container park!_" And what exactly is _this_?

- [M602](https://www.elhvb.com/webhq/models/486vlb3/m601.html) motherboard with 3 32-bit VLB buses, and 7 ISA slots, supporting CPUs up to 66 MHz. `256 k` cache installed. 
- [AMD 80486DX](https://en.wikipedia.org/wiki/Intel_80486) CPU chip, `40 MHz`.
- Cirrus Logic (837) [CL-542X-VLB-U](http://www.vgamuseum.info/index.php/component/k2/item/135-cirrus-logic-cl-gd5426) `1 MB` VLB VGA card (expandable up to 2 MB)
- `8 MB` FPM DRAM fitted in eight SIMM slots
- [Conner CFS210A](https://www.computerhope.com/hdd/hdd0018.htm) `213 MB` HDD and a 1.4 MB floppy reader

When I turned it on, I was greeted with the blue Award BIOS 4.5 screen, and it started calculating the RAM width. Wow, it does still work! **CMOS FAILURE. DEFAULT SETTINGS USED.** Whoops. Luckily, the HDD auto-detect BIOS feature still worked, and Windows 3.1 still booted. The HDD did not lose data, and most floppy's that came with the PC still contain their original data. 

Then I started wondering, what if I tried to upgrade the PC, just for the fun of it? DOOM could technically run, the VLB bus is very fast and 8 MB would be more than enough. A piece of junk for one person, a toy to fiddle with and learn from for another. 

### Challenge 1: The CMOS Battery

![](../batt.jpg "The corroded battery replaced with a new one.")

The old `3.6 V` battery corroded parts of the motherboard and had to be desoldered. Following a guide form [pc-restorer.com](http://pc-restorer.com/replacing-cmos-batteries-in-old-pcs/) was easy enough; creating a replacement was a bit more challenging. I did not want to solder on another one that might leak again after a few years. Instead, I used the 4 external jumper pins, labeled `EXT-BAT` in the above photo, to connect an external battery. 

A lazy do-it-yourself way to solder on plus and minus at pin one and four, respectively. After cleaning the muck, problem one was fixed.

### Challenge 2: Noise

![](../power.jpg "The opened up 200 W power supply.")

These tower PCs from yesteryear seemed to produce an awful lot of sound, compared to my passive MacBook Air from 2012. I still had a "silent" Nexus `12 V` fan lying around, so I simply decided to open up the power supply and switch fans. The result is astonishing: the Nexus is almost inaudible! 

Alas, the major source of noise seems to not come from the voltage supplier, but the hard disk itself: not only the bleeps and bloops from a 24 year old disc, but mostly the spinning headers itself. I might try to look around for a silent model, or even investigate how to [use flash cards](https://dfarq.homeip.net/sd-to-ide-performance/) with the 40-pin legacy IDE interface.

### Challenge 3: The DX2 Upgrade

![](../cpu.jpg "Out with the DX, in with the successor!")

I found an AMD 80486DX2 CPU on eBay for `10 EUR` - exciting! A `40%` faster chip, running at `66 MHz`, the maximum the motherboard can handle. I'd love to get the one hundred one, but have no intentions of switching the motherboard itself. It has to keep its retro vibe somehow... 

Four days later, it arrived in a bad condition: to my frustration, it had lots of bent pins. Great. Carefully bending them requires patience and a few particular pins in one corner did not want to comply. I engaged an expert at all things gold-related: my wife. 

![](../cputryout.jpg "The expert at work.")

After running back and forth, fetching a few small tweezers from her jewelry atelier, the problem was solved and the CPU snuggled up into the prehistoric socket. Somehow, I missed the grand moment. Oh well. 

After one more hour of fiddling and cursing with too many jumper wires in order to get everything back into its case, it was time to test things out and power it back on. No luck. Again. Nope. It turned out that the power cord suddenly stopped working. 

After connecting another one, I failed to notice "**80 MHz**" at the BIOS checkup screen. Unaware of the problem at hand, I happily fiddled with the date settings in the BIOS, chuckling that at least the battery worked. It froze a few seconds later. Uh oh. The CPU felt way too hot... Fortunately, that also caused me to figure out the root cause: I was somehow overclocking the chip without a heatsink and without compatibility of the motherboard!

Ten minutes of fiddling with jumpers, and possibly more cursing - the online M601 jumper manual did not completely match my M602 motherboard layout - this is the result:

![](../done.jpg "DX2 Installed, 66 MHz. 10 EUR well spent!")

We're in business! VGA output on the 20" widescreen also works. The faster response time puts less strain on my eyes than the 12" Compal CRT next to it, although in all fairness you do lose the retro vibe a bit. 

### Challenge 4: Sound

As for future work, the PC seems to lack any sound card. The PC speaker bleeps grow old very quickly, and I'd love to get to play Bobby Prince's Duke Nukum II soundtrack. I want to get my hands on a Creative Sound Blaster Pro 2 (not the budget 16-bit things), but that will possibly involve more eBay scouring. These cards are still ridiculously expensive: the Cirrus Logic VGA card currently installed costs on average 70 EUR!

Peeking at other retro enthusiast blogs, it seems like [USB Floppy emulators](https://dfarq.homeip.net/gotek-floppy-emulator-for-retro-pcs/) exist, HDDs are being replaced with SD/CompactFlash cards, [ISA RJ-45 network cards](https://dfarq.homeip.net/using-an-ne2000-network-card-in-dos/) are begin screwed in, [more L2 cache is being installed](https://www.youtube.com/watch?v=e4rw3d7mu28), and so forth. So many more fun things to do!

To be continued... 
