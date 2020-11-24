---
title: "Win98 Upgrade: Sound Blaster Audigy"
date: '2020-11-24'
subtitle: "From a Cheap PCI128 To EAX Advanced HD"
tags:
  - soundblaster
  - win98
  - retro
categories:
  - hardware
bigimg: audigy.jpg
---

My initial [Windows 98SE retro PC build](/post/2020/10/building-an-athlon-win98-retro-pc) came with a free [Ensoniq AudioPCI](https://en.wikipedia.org/wiki/Sound_Blaster#Ensoniq_AudioPCI-based_cards) based card, a cheap 1998 OEM alternative to the _AWE64_ or the _Sound Blaster Live!__ line. The Sound Blaster PCI128 or _Vibra128_ is basically the same card, as it contains a Creative AudioPCI chip. The card is good enough if you're not picky, but it comes with a few major downsides:

1. No external header pins for those cool looking `5.2"` audio drive bays;
2. No EAX support for games;
3. Horrible, _horrible_ Sound Blaster 16 (SB16) DOS emulation (see below);
4. No digital audio out;
5. Analog audio out is not that great.

And since I bought a [Creative X-Fi](/post/2020/11/winxp-upgrade-sound-blaster-xfi) for my WinXP machine, I was in the mood for another Sound Blaster upgrade. The X-Fi is the last entry in the fifth generation of Creative SB PCI cards, of which the Audigy, PCI 512, Sound Blaster Live! and PCI 128 are also a part. In 1998, I actually used to own a variant of a SB Live! card, but the analog audio output port is of questionable quality (although I never noticed that as a kid). The main problem with going for subjective history-accuracy here is the sheer variability of quality on Live! cards, so hunting down the right `CT4830` or whatever version is challenging. 

![](../audigy-vibra128.jpg "The Audigy next to its predecessor, the Sound Blaster Vibra128.")

The eBay price range also dictated my decision to simply buy an Audigy (first edition) `SB0090` card instead - these cards are from 2001, which is still not too recent. At [VOGONS](https://vogons.org), the consensus for a Windows 98 build is an Audigy 2 ZS, which has updated DAC and op-amps to produce more than `108` dB and support surround 7.1. The ZS is not made to work with Win9x and I didn't want to overdo it, so I settled with a `SB0090` instead, costing a whopping `10 EUR`...

So, what does Wikipedia have to say about this card? 

> It has an `EMU10K2` chip, an updated version of the Live! `EMU10K1`, that supports EAX 3.0 Advanced HD and up to 5.1 channel output.

The hardware can handle the mixing of 64 DirectSound3D channels, compared to only half (32) on the Live! cards. But I want to compare it to the Audio PCI or PCI128 card I threw out - well it's better than that successor. We're not going to learn much by looking at the numbers. Let's do some test recordings instead and let the results speak for themselves. 

![](../audigy.jpg "The Sound Blaster Audigy SB0090 card with shiny IO ports.")

### The EAX experience in games

Installing the card was painless, except for removing the old Sound Blaster drivers, as the uninstaller crashed. Windows 98 is _very_ picky when it comes to swapping in and out pieces of hardware, so I was a bit worried there, and tried to manually cleanup the mess, with varying degrees of success. The Audigy installation CD ISO is available at [vogonsdrivers.com](http://vogonsdrivers.com), and after installing the DOSDRV and 1.12 patch, rebooting a few times because of the obligatory blue screen, I moved on to testing games.

First up: _Dungeon Siege_. It has excellent EAX support that enhances the feeling of actually being in the Kingdom of Ehb - or at least in its many dungeons and caves filled with stuff to whack at. Listen to a short clip with EAX enabled on the new card:

{{< video "/vid/ds-eax.mp4" >}}

Now listen to the very same scene recorded with the Vibra128 card, which cannot do EAX:

{{< audio "/audio/ds1_noeax_pcm128.mp3" >}}

What should be immediately noticeable is the reflective, muffled sound coming from the EAX-enabled card because the party enters a cave. The bouncy sound of the squeaks of the valve , followed by the goblin fight that sound very, _very_ flat on the PCI128 card. Admittedly, Dungeon Siege likes to overdo this effect and it does get old every time you enter a huge cave (which is about half the game). It is clear that the difference is very audible and does affect my mood when playing a game: "immersiveness" of course is relevant.

The Audigy install CD-ROM comes with a nice "mine demo" that showcases all different EAX effects (sound reflection etc). Phils Computer Lab has [more audio samples](https://www.youtube.com/watch?v=C4SWsC86jZw) available at YouTube.

Now, If you'd ask me what the difference is between playing Dungeon Siege with a Sound Blaster Audigy on Windows 98 or with an X-Fi on Windows XP, the answer I would give is _I don't know_. To be honest, that difference would be marginal - at least to my ears. 

### SB16 and MPU-401 DOS emulation

I'll be brief and resort to my _Rise of the Triad_ comparison again:

#### Sound Blaster 16

**The Reference**; an authentic SB16 on my [486 PC](/post/2020/09/486-upgrade-sound-blaster):

{{< audio "/audio/ROTT_sb16.mp3" >}}

**The PCI128 card**;

{{< audio "/audio/ROTT_sb16_pcm128.mp3" >}}

**The Audigy card**;

{{< audio "/audio/ROTT_sb16_audigy.mp3" >}}

What on earth is that PCI128 card doing? I have never heard anything that bad in a long time... So yeah, if being able to play older DOS games is of any importance to you, then I implore you to upgrade. SB16 emulation is clearly not one of its strong points. Just to be sure, let's listen to the classic _grabbag_ Duke Nukem 3D tune with the music configured to Sound Blaster:

{{< audio "/audio/dn3d_sb16_pcm128.mp3" >}}

That's just _sad_. Fortunately, the Audigy clearly knows how to handle the emulation, although it does not sound as clear as it should compared to the reference audio. The tones sound a bit harsh on the edges, but it's as good as it's going to get for OPL3 emulation. Unless one uses a ISA motherboard and slots in a proper Sound Blaster AWE64... 

The Audigy to the rescue:

{{< audio "/audio/dn3d_sb16_audigy.mp3" >}}

#### MPU-401

In the end, the _proper_ way to play Duke Nukem 3D is with General MIDI support (recorded with Audigy):

{{< audio "/audio/dn3d_mpu_audigy.mp3" >}}

![](../dn3d.jpg "Let's Rock!")

A monumental difference compared to both SB16 variants! Now, let's compare the same _Rise of the Triad_ level 1 music again, this time by configuring `SNDSETUP.EXE` with "Wave Blaster" or "General MIDI" options (both are the same on emulated hardware).

**The Reference**; an authentic SB16 on my [486 PC](/post/2020/09/486-upgrade-sound-blaster) with S2 Wavetable daughter board:

{{< audio "/audio/ROTT_waveblaster.mp3" >}}

**The PCI128 card**;

{{< audio "/audio/ROTT_mpu_pcm128.mp3" >}}

**The Audigy card**;

{{< audio "/audio/ROTT_mpu_audigy.mp3" >}}

Both cards are clearly different than the S2, but the S2 isn't exactly a genuine piece of general MIDI hardware, and I sadly do not own proper Roland audio hardware. However, when comparing PCI128 with Audigy, differences are suddenly much more subtle. To be honest, I can't really make out any when I listen on my laptop speakers. The difference is present when using high quality headphones, but either version is more than good enough for me. 

### More toys to play with

The Audigy supports proper Sound Font switching, you can mess around with the EAX effects on the desktop using a very annoying TaskBar, and there are a bunch of other goodies present - provided you wish to install those. A audio CD daemon, the PlayCenter, the AudioHQ configuration center, MIDI finetuning properties, Wave Studio to record stuff, and so forth. Software support of the Vibra128 card pales compared to this. 

![](../audigytools.jpg "Look at all these 'creative' Creative tools, especially the taskbar!")

Of course, in the end, it's the audio playback that matters, not the software tools that I barely touch anyway, although it is nice to be able to have the power to configure it all. In any case, I can conclude that this hardware upgrade again was worth the effort and I enjoyed a day of fiddling with it. Just be sure to never play SB16-enabled games on your PCI128!

