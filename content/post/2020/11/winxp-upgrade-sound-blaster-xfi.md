---
title: "WinXP Upgrade: Sound Blaster X-Fi"
date: '2020-11-08'
subtitle: "From Embedded Realtek To EAX 5 Blasting Sound"
tags:
  - soundblaster
  - winxp
  - retro
categories:
  - hardware
bigimg: xfi.jpg
---

Ever since the "_Sound Blaster_" brand became iconic in those [486 PCs](/post/2020/09/486-upgrade-sound-blaster/), I became a big fan of most products Creative brought to the market. Their iconic big boxes that accompanied new sound cards were always a joy to open up, and the last PCI card in their Sound Blaster range from 2005, the X-Fi, is no different. 

I've been doing some research on the Sound Blaster family, and Wikipedia [summarizes the cards](https://en.wikipedia.org/wiki/Sound_Blaster) quite nicely. In short, there are 5 generations of older cards I'm interested in:

1. 8-BIT ISA cards, the original _Sound Blaster 1.0/2.0_ (1989);
2. 16-BIT ISA cards, the _SB Pro 1.0/2.0_ (1991);
3. The _Sound Blaster 16_, which I [wrote about](/post/2020/09/486-upgrade-sound-blaster/) earlier, and _Vibra 16_ (1992);
4. The _AWE32_ (1994) and _AWE64_ (1996) digital sample-based synthesis cards;
5. The PCI cards; roughly divided in _PCI128_/_AudioPCI_ and _Live!_ (1998), the _Audigy_ (2001), and the _X-Fi_ (2005).

My [WinXP retro machine](/post/2020/10/building-a-core2duo-winxp-retro-pc/) never housed a soundcard: instead, it was the first PC I built that relied on embedded, onboard audio, coming from the motherboard. The [MSI MS-7357](https://www.manualslib.com/manual/709493/Msi-Ms-7357-V1-X.html?page=75#manual) mobo has a Realtek `ALC888` audio chip soldered on that is capable enough in its own right. However, it pales in comparison with the Sound Blaster X-Fi or _eXtreme Fidelity_.

![](../xfi.jpg "The Sound Blaster X-Fi PCI Xtreme Music Edition.")

Multiple versions of the card exist, but luckily, in comparison to the confusing _Live!_ or _SB16_ revisions (of which there are good and less than stellar cards to pick from), the differences are negligible. Well, that's not entirely true, as there exist different [chip versions](https://en.wikipedia.org/wiki/E-mu_20K) of the `EMU20K1` audio chips with a bit of increased RAM. I went ahead and ordered the cheapest I could find for `18EUR`, apparently the _Extreme Music_ variant. It sadly came without awesome looking drive bay as the _Fatal1ty_ pro ones, but the `AD_EXT` pins are all there, so that's for on the wish list. 

Now, what does this card do, compared to its elder brother the Audigy, or even the well-loved Audigy 2 ZS, the "best" Win9x card? According to Wikipedia, it was:

> The most powerful, offering an extremely robust sample rate conversion engine in addition to enhanced internal sound channel routing options and greater 3D audio enhancement capabilities.

What does that mean? Well, the 51 million transistors operating at `400 MHz` compute about **24 times** faster than the Audigy processor. Okay, so it's _very_ speedy. What else? Well, it has EAX 5.0 support, a 24-bit crystallizer that can emphasize low or high pitched portions of sound, a completely overhauled sampling engine and better mixing support, ... The list goes on. 

I love the neat placement of the micro resistors and the overall look and feel of this black card:

![](../xfi-zoom.jpg "Don't you just love the intricate details (and powerful opamps) on here?")

### In-Game Performance

We're off to a good start here. After slotting it in and installing the drivers and tools, it's time for some games (and for more fiddling with settings). I disabled the Realtek chip in the BIOS to avoid conflicts or loading of unused drivers. 

Most games sound just a little bit more clear, but I am no audiophile. Admittedly, the initial excitement wore off pretty quickly. The main problem is that it is very hard to directly compare onboard audio with something like this without changing the default audio settings in the Creative tools and the games themselves. Furthermore, recording samples for this article sound like crap on my MacBook Air because of the _Intel HD Audio_ system. It seems that writing about subtle audio differences is much easier than adding an audio excerpt: it will depend on the audio hardware you have installed yourself when listening to it!

For example, this is a short Unreal Tournament 2004 clip, where audio hardware acceleration and EAX is turned on and off, _before_ fiddling with the Creative Console to increase the bass:

{{< video "/vid/ut2004_withoutbass.mp4" >}}

However feeble my attempt to capture the deltas, nobody will deny the superiority of EAX-enhanced sound. Next, I switched on _Bass Boost_ and the X-Fi _Crystallizer_. Notice the bassy "thuds" when clicking on the buttons in the upper menu. It sounds very hollow on my MacBook, but the difference is there:

{{< video "/vid/ut2004_withbass.mp4" >}}

When actually playing, the game sounds absolutely _fantastic_! The difference is even more pronounced when plugging in high quality headphones, thanks to the CMSS-3D feature of the sound card: the X-Fi 3D virtualization does a great job in giving the illusion of being fully immersed in the sound and music. Admittedly, the difference between the Realtek and the X-Fi, without relying on the added features, is far from mind-blowing. As [Tom's Hardware](https://www.tomshardware.com/reviews/high-end-pc-audio,3733-19.html) already pointed out (in 2014), _anything above $2 buys more features, not better quality_. CMSS 3D and EAX do add to the total quality, though. 

#### FPS Performance

According to hardware reviews such as [Guru 3D](https://www.guru3d.com/articles-pages/sound-blaster-x-fi-titanium-hd-review,1.html), the fast `EMU20K1` chip should even give a graphics performance boost: less work for your CPU to be done. However, I measured FPS on multiple games, and I could not see a substantial fluctuation between normal (embedded) audio or hardware-enabled (X-Fi) audio. That might be because my system is already quite powerful for a 2005 computer, or because the Realtek chip does the job good enough, or because the games are programmed the way they are.

<script type='text/javascript' src='/js/amcharts4core.js'></script>
<script type='text/javascript' src='/js/amcharts4charts.js'></script>
<script type='text/javascript' src='/js/amcharts4animated.js'></script>

To be fair, there was a _slight_ performance gain:

<div id="aoediv" style="width: 100%; height: 500px"></div>

The real gain is proper EAX support, superior IN/OUT ports, bass boost, virtual 3D audio stuff, etc ... The card software even lets you choose something called "_Sound Banks_" for MIDI synthesizing if that's your thing or if you plan to emulate an ISA Sound Blaster card in Win9x compatibility mode:

![](../xfitools.jpg "A bunch of Creative Tools to fiddle with various settings.")

Listen to a [DOOM general MIDI sample](https://forums.overclockers.com.au/threads/my-386-time-machine-project-so-far.902342/page-16#post-12708395) recorded by Phils Computer Lab to convince yourself that the X-Fi is very capable of pulling off DOS music tricks. I myself will resort to my other retro Win98/486 PCs for that. 

I can happily conclude that the PCI slot will remain to be occupied by the X-Fi card, and the embedded audio will remain to be disabled. If it was all worth it for casual games such as playing _Plants VS Zombies_ without headphones, I don't know... But for a few (European) bucks, why wouldn't you? Grab them now before they become as scarce as the upper tier Sound Blaster 16 cards!

More information:

- LGR [X-Fi Platinum XP Upgrade](https://www.youtube.com/watch?v=-TpGtrhpDuI&t=326s)
- Phils Computer Lab [Sound Blaster X-Fi MB3](https://www.youtube.com/watch?v=gSBMrHfsXjE) review
- `AD_EXT` [pinout scheme](https://pinouts.ru/Audio-Video-Hardware/sb_audigy2_ad_ext_pinout.shtml). It is possible to tap into SPDIF, MIDI, and GP signals separately. Note that your front panel headphone jack will likely pick up static noise except if it's wired directly onto the Sound Blaster using these pins. Another reason to buy the drive bay!

<script>
am4core.ready(function() {

am4core.useTheme(am4themes_animated);

function createChart(divid, data) {
    var chart = am4core.create(divid, am4charts.XYChart);
    chart.data = data;

    chart.padding(40, 40, 40, 40);

    var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
    categoryAxis.renderer.grid.template.location = 0;
    categoryAxis.dataFields.category = "config";
    categoryAxis.renderer.inversed = true;
    categoryAxis.renderer.grid.template.disabled = true;
    //categoryAxis.renderer.minGridDistance = 100;
    categoryAxis.renderer.minWidth = 120;

    var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
    valueAxis.min = 0;

    var series = chart.series.push(new am4charts.ColumnSeries());
    series.dataFields.categoryY = "config";
    series.dataFields.valueX = "val";
    series.tooltipText = "{valueX.value}"
    series.columns.template.strokeOpacity = 0;
    series.columns.template.column.cornerRadiusBottomRight = 5;
    series.columns.template.column.cornerRadiusTopRight = 5;

    var labelBullet = series.bullets.push(new am4charts.LabelBullet())
    labelBullet.label.horizontalCenter = "left";
    labelBullet.fontSize = 20;
    labelBullet.label.dx = 5;
    labelBullet.label.fill = am4core.color("white");
    labelBullet.label.text = "{values.valueX.workingValue}";
    labelBullet.locationX = 1;

    categoryAxis.sortBySeries = series;

    var columnTemplate = series.columns.template;
    columnTemplate.adapter.add("fill", function(fill, target) {
      return am4core.color("#018660")
    })
}

createChart("aoediv", [{
      "config": "Age of Empires III, Realtek",
      "val": 62
    }, {
      "config": "Age of Empires III, Creative X-Fi",
      "val": 66
    }, {
      "config": "UT2004, Realtek",
      "val": 163
    }, {
      "config": "UT2004, Creative X-Fi",
      "val": 165
    }]
    );

}); // end am4core.ready()
</script>
