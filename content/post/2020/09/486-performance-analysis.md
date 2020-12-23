---
title: 'An am486 Performance Analysis'
subtitle: "DX-40 VS DX2-66. What's it like, pressing that Turbo button?"
bigimg: gtacrash.jpg
date: 2020-09-26
tags:
  - 486
  - retro
categories:
  - hardware
---

After the [Sound Blaster](/post/2020/09/486-upgrade-sound-blaster) and [SD-to-IDE](/post/2020/09/486-upgrade-sd-hdd) upgrades, it was time to do a decent performance analysis on the vintage DOS computer I now proudly own. The [original 80486 blog post](/post/2020/09/reviving-a-80486) mentioned a CPU upgrade from DX40 to DX2-66 MHz, but how big is this performance gain in practice? Let's install Dosbench and find out. 

### The benchmarks

The system under test specs can be [found here](/post/2020/09/reviving-a-80486/). I included the following CPUs in each result:

1. am486 DX-40 MHz, with Turbo switch ON
2. am486 DX-40 MHz, with Turbo switch OFF
3. am486 DX2-66 MHz, with Turbo switch ON
4. [Phil's Ultimate VGA Benchmark DB](https://docs.google.com/spreadsheets/d/1lvF9nOAMKLeCpHR_SaA48M7sUXItwIi72gHRcw0wpNU/edit#gid=0) reference data: the only other 486 DX-40 I could find, from user Mau1wurf1977. He runs with a Tseng ET4000 1MB VLB video card, 4MB RAM, and the same amount of motherboard cache. 

It can indeed be problematic to compare the output of various benchmarks - these might be nothing more than meaningless metrics. However, it's still fun to see bars and numbers appearing on your VGA screen and on the internet, and to try and compare them anyway. Phil's [DOS Benchmark Pack](https://www.philscomputerlab.com/dos-benchmark-pack.html) was used to carry out most of these. 

#### 3DBench FPS

![3DBench FPS chart](../3dbench.jpg)

The first thing to note here is the power of the Turbo button! Without these wires jumpered on the motherboard (and the button enabled), the overall power of your PC drops by almost two thirds or `66%`. Also, the DX2, which has a `40%` faster CPU in terms of raw power, only speeds up about `13.5%` for this 3D test. Still, it tops the "magic" 30 FPS limit!

Back in the day, anyone who was able to run a game at 30 frames per second was a happy gamer. Most games ran at half that rate, and you wouldn't care and play it anyway. In 2020, game critics complain that Mario 64 re-released in Super Mario 3D All Stars for Nintendo Switch was not bumped to 60 FPS. Maybe those guys should also build a DOS PC - and then stop whining. Sure, standards changed, but maybe our expectations are not always realistic... In the end, who cares about FPS when it plays _well_ and you're having fun?

#### PCPBench FPS

![PCPBench FPS chart](../pcpbench.jpg)

The small performance gain trend continues. I must admit that I am a bit disappointed, although I do realise that these benchmarks are usually VGA-intensitive. Since older games are software-accelerated, I hoped simply swapping out the CPU would net a bigger speed increase. 

#### Topbench scores

![Topbench chart](../topbenchchart.jpg)

Since I'm running `EMM386.EXE` with the extended `RAM` switch, `/p` was needed to force execution of the tests. The Topbench marks are missing from Phil's sheet. I had high hopes for this test as it's a general score that totals performance (MemTest, MemEA, Opcodes, VidMem, 3DGames). Sadly, the DX2-66 only gave a boost of about `10%`. It might again prove that the old motherboard is not up to snuff. Trying to force the motherboard bus speed into a CPU`/3` rate in the BIOS settings instead of the auto-detected `/4` does not change anything in various benchmarks I re-ran. Same thing with `UNIVBE` VESA 2 drivers. The cache writeback wait state is set on `2`, and a setting of `0` refuses to boot. 

The built-in database shows similar performing PCs: 

![](../topbench.jpg "The Topbench benchmark system (src: sparcie.wordpress.com)")

The non-turbo DX40 closely matched a 386SX@33MHz, like the one in the screenshot above (score: 61, VS 64). So don't bother building a 80386, just press Turbo.

#### Games: From DOOM (1993) to Duke3D (1996)

I tried running the Duke3D shareware version but without throwing out Win3.1 drivers in `AUTOEXEC.BAT`, I couldn't even meet the minimum memory requirements of `6MB` free space. After that, `DNRATE` gave me `7` FPS on average with all settings set to high on the DX2-66. As expected, not very playable - I didn't bother with the DX40.

For the DOOM dosbemch mark, two settings exist: everything on LOW and on HIGH. On LOW, the non-turbo DX-40 struggles to get `15` FPS (with turbo: `36`), while on HIGH, it's so bad that I had to stop the test. Phil's data sheet reveals `7.5` FPS but I suspect it's run on HIGH (one has to divide `74690` by the amount of realtics). The faster DX2 CPU adds two frames to the DX-40's LOW mode, clocking in `16.3` FPS on HIGH. 

Most games did not come equiped with a built-in frame counter and the Quake timedemos refuse to start for obvious reasons. Oh well, a FPS digit is only a number taken out of its context: I'm very content with the performance of the PC in general, it runs the following later nineties DOS games flawlessly:

- _Hocus Pocus_ (1994)
- _Mystic Towers_ (1994) - although the sound drops off after a minute
- _Wacky Wheels_ (1994)
- _Raptor_ (1994)
- _Rise of the Triad_ (1994)
- _Jazz Jackrabbit_ (1994)
- _Realms of Chaos_ (1995)

Even my favorite Windows 3.1 game, _Lode Runner: The Legend Returns_, which is [freeware now](https://web.archive.org/web/20081014012253/http://www.daggert.net/Folio/Programming/Presage/LodeRunner/Loderunner1.htm), works like a charm after installing Cirrus Logic Windows drivers to up the resolution and color grid:

![](../loderunner.jpg "This game is amazing with the Wave Blaster header board!")

Any EGA-like games earlier than 1993 (_Cosmo's Comic Adventures_, _Duke 1_, _Bio Menace_, _Crystal Caves_, _Monster Bash_, ...) are of course not a problem. The following games run OK, but not great:

- _Doom_ and _Doom II_ (1993/1994)
- _Heretic_ and _Hexen: Beyond Heretic_ (1995)

Unsurprisingly, those games run on the same CPU-hungry engine. It is clear that games up to 1995 are OK but after that (Duke was released in 1996), you'd need a faster Pentium (II) and perhaps even a Voodoo card for Quake to get things running. _Grand Theft Auto_ (1997) crashes after a few crawlingly slow frames (see image on top), and _Death Rally_ (1996) is more like _Stutter Rally_. I was warned: the game advertises my PC rig as the bare minimum. 

The year **1995** is indeed a turning point for PC technology: the Intel Pentium P54C with 120 MHz was finally faster than the 80486DX4-100 and Microsoft released Windows 95. 

### So, what's next, a Pentium? 

My memory is getting foggy as I do my best to recollect what computers my father and I used to build when I was just a kid. A backup of an old self-made website gave me a hint. This is an excerpt from the news entry on that site, entitled '_Merry Christmas, 24/12/2000_': (translated from Dutch)

```
Yes yes the christmas holidays are coming so exams are finished! No big failures that's the most important... At least for me because otherwise my dad would install 'the' Athlon Thunderbird processor (1 GHz) into his own PC instead of mine, and I need it that bad :-) Really, becuase that Pentium II 233 is already getting pretty old. Whoever has money is always upgrading! 
```

A Thunderbird it is. Windows 98 Second Edition: here I come. 

![](../thunderbird.jpg "An Athlon Thunderbird I salvaged from scraps at work.")

The year **2000** also is special: it was the year where the one Gig processor speed was broken, and between 2000 and 2005, this speed was increasing at a staggering rate, until the plateau of power usage was reached. [The Free Lunch Is Over article](http://www.gotw.ca/publications/concurrency-ddj.htm) explains this in more detail. My 2003 DELL Inspiron laptop used at university came packed with a Pentium 4 with a whopping 3 GHz processor. Three whole gigantic hertz-es! The 2012 MacBook Air I'm typing this on uses a more battery-friendly Core i5 1.8 GHz.

People fond of graphs and details on the history of PC performance can eat their harts out in the excellent Maximumpc.com article called "[How the Ultimate PC Has Evolved In 15 Years](https://web.archive.org/web/20150418074002/http://www.maximumpc.com:80/article/home/history_dream_how_ultimate_pc_has_evolved_15_years)".

<script>
am4core.ready(function() {

am4core.useTheme(am4themes_animated);

function createChart(divid, data) {

    var chart = am4core.create(divid, am4charts.XYChart);
    chart.data = data;
  chart.exporting.menu = new am4core.ExportMenu();

    chart.padding(40, 40, 40, 40);

    var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
    categoryAxis.renderer.grid.template.location = 0;
    categoryAxis.dataFields.category = "cpu";
    categoryAxis.renderer.inversed = true;
    categoryAxis.renderer.grid.template.disabled = true;
    //categoryAxis.renderer.minGridDistance = 100;
    categoryAxis.renderer.minWidth = 120;

    var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
    valueAxis.min = 0;

    var series = chart.series.push(new am4charts.ColumnSeries());
    series.dataFields.categoryY = "cpu";
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

createChart("3dbenchdiv", [{
      "cpu": "am486 DX-40 Non-turbo",
      "val": 10.5
    }, {
      "cpu": "am486 DX-40 Turbo",
      "val": 27
    }, {
      "cpu": "am486 DX2-66",
      "val": 31.2
    }, {
      "cpu": "Phil's Benchmark, am486 DX-40",
      "val": 17.1
    }]
    );

createChart("pcpbenchdiv", [{
      "cpu": "am486 DX-40 Turbo",
      "val": 5.6
    }, {
      "cpu": "am486 DX2-66",
      "val": 6.2
    }, {
      "cpu": "Phil's Benchmark, am486 DX-40",
      "val": 3.8
    }]
    );

createChart("topbenchdiv", [{
      "cpu": "am486 DX-40 Non-turbo",
      "val": 64
    }, {
      "cpu": "am486 DX-40 Turbo",
      "val": 136
    }, {
      "cpu": "am486 DX2-66",
      "val": 149
    }]
    );

}); // end am4core.ready()
</script>

