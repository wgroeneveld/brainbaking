---
title: "Win98 Upgrade: GeForce 3 Ti200 vs Riva TNT2"
date: '2021-01-28'
subtitle: "Get more out of that AGPx4 slot!"
tags:
  - geforce
  - win98
  - retro
categories:
  - hardware
bigimg: geforce3.jpg
---

After building a [Windows 98SE retro PC](/post/2020/10/building-an-athlon-win98-retro-pc) in October 2020, I've upgraded the sound card to a proper [SoundBlaster](/tags/soundblaster). Yet, little games made use of that capability because my graphics card lagged behind. The PC slotted a OEM version of a Riva TNT2 M64 card with `32MB` SD RAM. The chip has a sticker called _"Sparkle"_ on it, but it sure wasn't sparkling that much as soon as I booted Unreal Tournament. So, the only logical conclusion to make was to do another upgrade.

What are the options? During the end of the nineties and the beginning of the 2000s, the video card market exploded. From dual-linked Voodoo cards on PCI ports to competitive ATI Radeon ones that also were quite new at that time. I had two options: either I stay true to the historical correctness of the retro computer, or I go all out and get the best my motherboard could possibly handle. I of course chose option number 3: something in-between.  

## The GeForce 3 Ti 200 

![](../geforce3.jpg "The MSI/Medion GeForce 3 Ti200 card.")

The third generation of Nvidia's GeForce graphics processing units, the GeForce 3, was released in the beginning of 2001. I'm pretty sure most people by then had moved on from Windows 98 to (hopefully) Windows 2000 - thereby safely sidestepping the disaster that Windows Me (or Millennium) was. Compared to the Riva TNT2, a chip also by Nvidia from early 1999, the GeForce 3 cards were beasts - yet only two years passed since the TNT2 release!

The TNT2 was never intended to be a big performer: the 1998 3Dfx Voodoo 2 and Voodoo 3 outperformed it in certain games. That is because the graphics APIs were not yet fully matured: you had your **Glide** drivers, that worked well with 3Dfx cards, your **OpenGL** ones, and Microsoft **Direct3D**. Some games could be patched to work better with a particular API, but most were pretty hard-wired. As a gamer with a Voodoo card, you'd be forced to also periodically upgrade your AGP slot if you wanted access to all games. The Voodoo cards slotted in PCI ports, meaning you could mix and match, or even run them in SLI, a popular configuration in the Retro PC scene at [VOGONS](https://vogons.org). That is, if you're prepared to drop more than `€140` a piece - [even nowadays](https://www.benl.ebay.be/sch/i.html?_from=R40&_trksid=m570.l1313&_nkw=voodoo+2&_sacat=0). 

I have fond memories of the floating 3Dfx logo. I remember my dad flashing our Voodoo card in order to overclock it, an attempt that ended with smoke coming out of a capacitor. We brought it back to the store, and when the guy behind the counter asked whether or not we flashed the thing, my dad said "of course not!". We promptly got a new one. However, until I can get hold of a Voodoo card at a fair price, I decided to resort to Nvidia's budget version of the GeForce 3 instead, that I found for only `€30`. The Ti 200 was basically a pumped-up GeForce 2 with `64MB` and a clock rate of `200MHz`. To me, it felt a bit more historically accurate compared to a high-end Ti 500 - although you can [overclock the card](https://www.philscomputerlab.com/geforce3-ti-200.html) by adding active cooling. As a fan of _silent_ PCs, I was keen on keeping the cooling as passive as possible. The result is a massive (well, for that time) black block on top of the GPU:

![](../geforcevsriva.jpg "The GeForce 3 (left) compared to the TNT2 (right).")

Note that the GeForce3 has multiple video-out ports: a VGA one and an S-Video one - of course both still analog. Fitting the card inside your case can be a bit challenging if you didn't do proper cable management (whoops), as it's both longer and higher than its predecessor. My card was branded _MEDION_ (by the German supermarket _ALDI_), but it's essential an _MSI_, so I don't care. It probably came from one of those cheap (but pretty good) MEDION computer builds. I got it from a friendly German IT parts recycler at eBay. 

## Performance

Okay, let's see what happens after pulling out a screwdriver and replacing the TNT2. Windows 98SE still booted - that's a start. Of course, it does not recognize the card and reverts to 16-color mode. After digging up the right Nvidia driver set (and installing DirectX 9), rebooting a couple of times, it was time to play some games. I failed to find any "GeForce3 VS TNT2" articles on the internet that compare FPS stats, so I recorded a few of my own. 

### Dungeon Siege

[Dungeon Siege](https://jefklakscodex.com/articles/reviews/dungeon-siege/), released by Gas Powered Games in 2002, is one of the first [hack & slash](https://jefklakscodex.com/articles/features/the-best-and-worst-retro-hack-and-slash-games/) games that was rendered in full 3D. This of course put quite a strain on PCs back then. Since I was replaying old H&S games, and this one was released a year after the Ti200, it was a good candidate for a first stress test. 

![](/post/2020/11/furyseye.jpg "Dungeon Siege")

To be honest, the game was unplayable with the Riva TNT2: it barely managed to pull off rendering `7` to `8` frames each second. I had to resort to my [Windows XP build](/post/2020/10/building-a-core2duo-winxp-retro-pc/) to play it, before upgrading the graphics card, where it of course comfortably peaked at `60` FPS at a resolution of `1024x768` and every setting configured to high. The GeForce 3 fared much better than the TNT2: from `8` FPS to a whopping `23` in the midst of a heavy battle with spells flying all over the place. Remember, Generation Z kids: back then, if we got more than `15` FPS, we played it and did not complain. I wandered around in the swamps for a bit, and traveled to the Goblin-infested fortress, without major hickups, although the occasional dip in frames is still there.

### Unreal Tournament

UT1, released in November 1999, was more interesting to test, because it supports multiple graphics APIs due to its launch in the midst of the "AGP war". The Glide drivers are supposed to be good, but I cannot verify that. I can, however, try out a bunch of different options with both TNT2 and GeForce3 cards. Below is a summary of my findings (all details are set to _high_ with skin to _medium_; resolution is always `1024x768`):

**Riva TNT2 M64**:

- `16bpp` (bits per pixel); Direct3D (default): `28` FPS
- `32bpp`; Direct3D: `14` FPS
- `32bpp`; OpenGL: _crash!_ (whoops)

**GeForce 3 Ti 200**:

- `16bpp`; Direct3D: `30` FPS
- `32bpp`; Direct3D: `15` FPS
- `32bpp`; OpenGL: `74` FPS

These statistics were gathered using Fraps in the same multiplayer map, with the same weapon and the same movements/location. Strangely enough, Direct3D was no friend of the GeForce 3: the amount of FPS is virtually identical? I did install the latest UT1 patches, but it could very well be that I overlooked something. It was only after switching to OpenGL that I noticed a major performance boost. Messing with color depth is dangerous on the TNT2, it seems. 

### Wizardry 8

As I mentioned in the original [Win98SE article](/post/2020/10/building-an-athlon-win98-retro-pc): the first thing I did after the video/audio drivers was of course installing [Wizardry 8](https://jefklakscodex.com/tags/wizardry8/), my all-time favorite PC RPG, released in 2001.

![](../wiz8.jpg "Wizardry 8: stranded on a beach, dangerous crabs nearby!")

Wiz8 was never the prettiest game of them all, and its development was riddled with more than a few hickups and tumbles. Sadly, Sir-Tech Canada eventually closed doors, so an official sequel is out of the question. There aren't a lot of graphics options to play with, and after choosing the OpenGL API drivers, all I can say is that both cards pull of rendering scenes in Wizardry 8 quite well. In and around the monastery, the begin location of the party, The TNT2 pushes frames to `19` FPS, while the GeForce 3 almost quadruples this to `75` FPS. Since this is not an action-packed frenetic shooting gallery, like Quake 3 or Unreal Tournament are, having semi-low frames is something you don't even notice. It played fine on the TNT2, and it plays fine on the GeForce 3.  

## So, was it worth it?

That depends. If you're like me, and prefer RPG and turn-based games to shooters, then probably not so much. Yet, I liked being able to play Dungeon Siege on Windows 98 rather than Windows XP. It felt more authentic. The hack & slash game Sacred deserves the WinXP machine since that game is from 2004: the mid-2000s, not the early ones. 

The card is cheap, silent, the installation is painless, and I can finally attempt to reinstall my favorite Grand Theft Auto version: GTA Vice City, released in 2002. We'll see how the game fares with the card - or how the card fares with the game... 
