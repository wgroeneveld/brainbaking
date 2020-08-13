---
title: te bekijken/zelf proberen
date: 2020-07-07
---

## Brain Baking

[ ] Landingspagina, donate, algemeen download, buy, ...
[ ] per hoofdstuk:
    [ ] links naar supplimentary reading materiaal (wat hier verzameld is) of wat referenties zijn die in elk hoofdstuk verschuild zitten?
    [ ] code examples links Github?
[ ] conversie C/C++ GBA programming pagina's, naar blog posts of iets wat hier permanent staat? Wat is het verschil... (Aantrekkingskracht site/blog dingen ook te lezen + doneren, https://fabiensanglard.net/gebbdoom/)

## Engels

[X] it's - its

## LaTeX conversie

[X] eerste 3 woorden na \chapter{} en \section{} auto-converten naar \newthought{}
[X] Markdown makkelijker maken om images op verschillende plekken toe te voegen zonder syntax van TeX te moeten gebruiken?
[X] footnote automatisch converteren naar sidenote

## Layout

[ ] Chapter nummers genoeg van de kant af https://tex.stackexchange.com/questions/96090/formatting-subsections-and-chapters-in-tufte-book
[ ] 'Part x' pagina's: over hele breedte een mooie image?
[ ] sidenotes raggedouter werkt niet goed precies
[ ] 'chapter-x' refs maken
[ ] elke game name ref in _italics_ - overal hetzelfde?

## Images

[ ] script/automate convert img/x.png -filter box -resize 1000 imgprod/x.png

## Inhoud

- appendix maken van terminology (polygon, vertex, pixel, rasterization, aliasing, moiré, camera, frostrum, ... ) bvb vertex shader = routines done to move and color triangles) zie techspot artikel
- games mentioned index
- "with contributions of ... " = héél belangrijk, ook naar commerce. 
- Further reading indien meer interesse: in tech. detail (1) en voor andere retro consoles (2). plus voornamelijk website (zie hieronder) linken!

## Supplementary material 

- Website brainbaking.com met per hoofdstuk:
    + extra screenshots/gifs parallax tonen ed
    + extra voorbeelden in code (zie hieronder) met links ed
    + extra referenties externe tutorials voor further reading (zie onder)

## Hardware 

- sdks? https://www.retroreversing.com/official-gameboy-software-dev-kit/ en hardware kits? https://www.retroreversing.com/game-boy-advance-development-kit/

Analogue pocket 2021 ook vermelden!

## Hoofdstukken/ideeën nog uit te werken

- sound/music? beeps van GB vs GBA, sound channel, hoe werkt dat?
    + http://www.herbertweixelbaum.com/comparison.htm waveforms difference, introduceren? - zie discography, 8-bit operators zit er ook in; lijkt me zeker een hoofdstuk waard indien iemand kunnen interviewen en uitleggen hoe dit technisch werkt?
    + nanoloop tegoei leren kennen. => Analogue Pocket tussenkabels??
- network play? infrared port, link cable, ... ?



## 2D sprite engine samples

- Alpha blending: ventje in water laten vallen als tech. demo zie https://www.coranac.com/tonc/text/gfx.htm en Wario Land 4 water
- simpel voorbeeld GB game met assembly/C 
- Retro Game Mechanics Explained

## 3D bitmap engine samples

- raycast engine schrijven op gba (is dat wel raycasting? mode4?)

## 3D/texture rendering tutorials

- https://www.learnopengles.com/android-lesson-six-an-introduction-to-texture-filtering/ en https://www.learnopengles.com/android-lesson-four-introducing-basic-texturing/
- zeer goed artikel: https://www.techspot.com/article/1916-how-to-3d-rendering-texturing/ (hele serie) - te wazig: https://en.wikipedia.org/wiki/Texture_filtering
- https://www.davrous.com/2013/06/13/tutorial-series-learning-how-to-write-a-3d-soft-engine-from-scratch-in-c-typescript-or-javascript/ volgen (in GBA?)
- texture filtering & MIP mapping: https://daviddegeyter.wordpress.com/2015/11/06/example-02-02-texture-filtering-mip-mapping/ (MIP Latijn!)
- doom engine code review https://fabiensanglard.net/doomIphone/doomClassicRenderer.php
X eens RenderDoc https://github.com/baldurk/renderdoc gebruiken in Win om een spel zoals Raven Shield te bekijken? zie https://www.adriancourreges.com/blog/2016/09/09/doom-2016-graphics-study/ => NEE

=> GPU FPU unit count '3500' vs 2 bij 8 cores, ook al minder GHz?

### Portal rendering

- Video tutorial: https://www.youtube.com/watch?v=HQYsFshbkYw (heeft ook nog veel andere gerelateerde zaken)
- Build engine internals https://fabiensanglard.net/duke3d/build_engine_internals.php - mooi verschil tussen Portal rendering en BSP rendering uitgelegd

## Andere boeken te bekijken?

- https://www.chriskohler.biz/power-up-chris-kohler-2016/
- https://www.amazon.com/Untold-History-Japanese-Game-Developers-ebook/dp/B00Q93N29I
- http://iwataasks.nintendo.com
- https://www.goodreads.com/book/show/34376766-blood-sweat-and-pixels?ac=1&from_search=true&qid=zVIQDAnAQy&rank=1
- https://www.resetera.com/threads/artbooks-gaming-books-ot-a-new-era-a-new-shelf.1086/page-90#post-41465034
- https://readonlymemory.vg/shop/book/britsoft-an-oral-history/
- https://readonlymemory.vg/shop/book/japansoft-an-oral-history/