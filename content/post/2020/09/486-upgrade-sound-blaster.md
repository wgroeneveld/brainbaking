---
title: "486 Upgrade 1: Sound Blaster 16"
date: '2020-09-18'
subtitle: "A Classic ISA sound card, including MIDI daughter board!"
tags:
  - soundblaster  
  - 486
  - retro
categories:
  - hardware
bigimg: sndblaster.jpg
---

The first in hopefully many to come [retro 486 PC](/post/2020/09/reviving-a-80486/) update posts! As mentioned then, the PC I received did not come with a sound card. For retro gaming, unless you want to be stuck replaying the same levels of Duke Nukum I again and again, a good Creative _Sound Blaster_ card is the best fit - especially since I fondly remember those DOS-era tunes.

So, the hunt for a Sound Blaster ISA card began. A blog post at [Nerdly Pleasures](https://nerdlypleasures.blogspot.com/2012/07/sound-blaster-16-trials-and-tribulations.html) made me reconsider my first thought and not buy an AWE32/64 card or a Pro 2.0, but go for a classic 16 variant instead. It seems that one has to pay special attention to the PCB "CT" version. Most later OEM cards (and the "Vibra" ones) come with less hardware components equipped (no wave table header, no CD-ROM interface, no PC Speaker JP support, ...), or worse: don't have a genuine Yamaha OPL3 sound chip. 

It might indeed be quite a _nerdy_ pleasure, but the difference is profound. Listen to a [Wikipedia SB16 Synthesis](https://en.wikipedia.org/wiki/Sound_Blaster_16#OPL-3_FM_and_CQM_Synthesis_options) sound sample that compares the Yamaha OPL-3 FM chip with Creative's own CQM version. The card I ended up buying, a **CT2290**, has the Creative CT1747 chip labeled "OPL", which integrated the YMF262 OPL-3 FM synthesizer (located on the middle in the photo below). 

![](../sndblaster.jpg "The Sound Blaster 16 with S2 Wave Blaster daughterboard attached.")

`€53` excluding shipping and a few days later, it arrived from a German eBay seller cleverly named "Electronics Recycling". I wish there were more actual stores like that. Installing the DOS drivers is quite easy; `SBBASIC.EXE` from [Phil's Computer Lab](philscomputerlab.com/creative-labs-drivers.html) takes care of everything, including modifying `AUTOEXEC.BAT`. The jumpers were configured to address `240`, IRQ `5`, DMA `1` and HDMA `5`. I left them there. 

---

**Edit** 2020-09-29: After having trouble with [sound FX in Mystic Towers](https://www.vogons.org/viewtopic.php?f=7&p=897873), I closed JP12 and JP13 on the card to change the address to `220` - the most universally accepted `BLASTER` address. Apparently, parts of the Mystic Towers code hard coded the address. Halloween Harry also refused to work on another address. After the change, Adlib-compatible games stopped playing sound until IRQ was set to `7` using `DIAGNOSE.EXE`.

---

Perhaps the most compelling part of the above photograph is the strange petite daughter board on the top right that is attached to the Sound Blaster. It uses the wave table MIDI header port. Since actual retro Creative Wave Blaster boards are very scarce (+€300 on eBay), the internet handed me a Belgian alternative: the **Dream Blaster S2** from [Serdaco BVBA](https://www.serdashop.com). New hardware for old hardware because - why not? The S2 is the cheapest option available (`€34`). Since I never used external synthesis before and Philq's review on YouTube was laudatory, I got ahead and clicked buy. Belgian money well-spent. 

Of course, not every game supports wave tables or even has MIDI music. As a test, I recorded and edited a few samples from Rise of the Triad. Each video contains three parts:

1. A part with the "PC Speaker" option configured in `SNDSETUP.EXE`;
2. A part with the "Sound Blaster" option;
3. A part with the "Wave Table" option.

The result: (_dial up your volume! I recorded with my smartphone on purpose, I don't have an external VGA capture device and I want you to hear everything, including keystrokes_)

#### The Apogee Intro

{{< video "/vid/rottsnd-apogee.mp4" >}}

The difference is huge, and I couldn't wipe that grin off my face - even with just the Sound Blaster, I just _love_ that intro. This brings back so many fond memories. Notice the subtle differences in the background with the S2! And yes, my VGA card and CPU can barely handle the game. An issue for a future blog post[^perf]. 

Let's continue to the ROTT main menu and loading screen:

#### Main Menu

{{< video "/vid/rottsnd-menu.mp4" >}}

The first 30 seconds sure are a bit dull. Who plays ROTT with PC Speakers anyway? The SB's main menu music is not that profound, but the Wave Blaster indeed "blasts" it out of the park. And as soon as that loading screen music starts, oh my. Trembling knees! There is that grin again!

The music continues on to the gameplay:

#### Gameplay

{{< video "/vid/rottsnd-gameplay.mp4" >}}

You can see that the PC clearly is not up to the task and even shows several dips in music and sound FX playback while firing missiles. I did temporarily resocket the motherboard with the DX40 CPU. All options are set to maximum, I do not care for graphics performance just yet[^perf]. 

I isolated the Rise of the Triad gameplay music tracks by recording using my [X-Fi WinXP card](/post/2020/11/winxp-upgrade-sound-blaster-xfi). With SB16 Sound Blaster music option (daughterboard disabled):

{{< audio "/audio/ROTT_sb16.mp3" >}}

With WaveBlaster music option (daughterboard enabled):

{{< audio "/audio/ROTT_waveblaster.mp3" >}}

_Oh my_ indeed!

Of course, this is just a sample of a single game. Other DOS MIDI masterpieces include:

- The Monkey Island games;
- Lode Runner: The Legend Returns on Win 3.1
- ...

This Sound Blaster 16 has made me childishly happy.  Now where are all those floppy's?

Right, here:

![](../dosgames.jpg "A photograph of my 2006 desk with retro DOS manuals")

---

In case anyone wants to jumper the PC Speaker pins on their Sound Blaster, configure them as follows: ([src](https://www.vogons.org/viewtopic.php?f=9&t=18283&p=131727&hilit=sound%20blaster%20speaker#p131727)):

Sound Blaster:
```
Pin 1 = +5V
Pin 2 = Speaker
```
IBM PC:
```
Pin 1 = Speaker
Pin 2 = None/Key
Pin 3 = Ground (No need to connect)
Pin 4 = +5V
```

See [all CT2290 jumper configurations](https://stason.org/TULARC/pc/sound-cards-multimedia/CREATIVE-LABS-INC-Sound-card-SOUNDBLASTER-16-PRO-C.html).

Note that some static noise will inevitably make it to your boxes if you do decide to connect the motherboard pins to the Sound Blaster. That's part of the charm!

**Addendum**, 6th of November 2020: The VOGONS [Grand OPL3 Comparison](https://sites.google.com/site/soundcardcomparison/) website ([original forum post](https://www.vogons.org/viewtopic.php?f=62&t=32933)) has this to say about the SB16 CT2290: 

> It has one of the best FM sound i have heard so far. Very clean output, wide and clear spectrum range. The FM out of this card will please your ears. 

You can download the [sample pack](https://dl.dropbox.com/u/43851675/CT2290/CT2290.zip) and compare it with other CT SB cards on the site. 

[^perf]: It turns out that I forgot that the _TURBO_ pins were jumpered on themotherboard, but the button was not pressed. Without _TURBO_, the performance is comparable to a 386. Ouch, what a stupid mistake to make! Thanks [VOGONS community](https://www.vogons.org/viewtopic.php?f=46&t=76632) for the hints. 
