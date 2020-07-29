---
from: Dylan Cuthbert (FB)
date: 2020-07-25
see_also:
    - https://arstechnica.com/gaming/2017/10/exclusive-legendary-star-fox-coder-on-series-history-surprise-sequel-launch/
    - https://web.archive.org/web/20190210151024/https://www.usgamer.net/articles/dylan-cuthbert-star-fox-game-boy-hacking-feature-interview
    - "sinclair ZX Spectrum UK-populair, limited & meager https://www.youtube.com/watch?v=1NiK-eghxi8 3:25"
---

Hi Dylan,
I'm a CS academic teaching students at my university in Belgium programming using the GBA. I'm writing a book about retro game boy algorithms and would like to include X for explaining the basics of 3D rendering. I already have guys from Wolf3D/DoomII/Nightfire collaborating to explain things like texturing/raycasting/etc. I know it's been long but: could we chat about that? Thanks a lot! Kind regards

Hi there, sure I can answer as much as I can
It’s been a long time though!

Great, thanks! I've been toying with it in an emulator and know that only the GBA has a bitmap mode. Only the arrows in the tutorial part seem to be sprites. I presume everything else is rendered with h-blank interrupts that quickly changes the palette?  8kb ram seems too little to hold any kind of screenbuffer. I also doubt that with 4Mhz vertices are being translated from 3D to 2D 🙂 can you maybe give an overview of how you built the engine, what you remember and what you want to tell?

I mapped the screen to be a screen buffer - can’t remember the dimensions of it but not huge 
Then I transferred that into the character map every frame
I transferred it byte by byte by polling h-blank flag and only transferring it during that time
The data is all 3D and I used a number of techniques to get the speed up, mostly table lookups ! Especially for the perspective division and rotation (sine tables)
Zero matrices are involved of course
And most of the 3D is single axis rotation with some special cases for two axis (flying things primarily so they can bank and dive)

Very impressive. I fiddled with a 3D renderer on the GBA - https://github.com/wgroeneveld/gba-bitmap-engine/ - and also used sine lookup tables but even on the GBA the result wasn't great. I'm not used to writing low-level fixed-point math code.
did the data structure in assembly pose any problems? In C++ you simply create a class to hold whatever matrix/vector/... you want. I can imagine that being hard with a limited amount of registers

I didn’t even really use fixed point math as far as I can recall 🙂 I think the units were just kept small so ‘1’ was quite small
So it was just integer math with everything below the fixed point being discarded after multiplies  etc

but there were no 2.5D techniques such as raycasting involved - it was actually modelled like modern 3D games?

It’s all machine code so data driven - although I had some simple data structures for convenience that could equate to c style structure but the z80 isn’t good for accessing that kind of organization of data
Yes there were no hacks, it’s full 3D - I used one trick in the tunnels to ‘clip’ the tunnel segments to the next segment  and make them look solid
Of course it’s not a z80 and a hybrid cut down thing but the z80 is the closest thing to it and I’d had years of programming that on the Zx spectrum

Did you program any 3d-based game on the spectrum before that, where the ideas emerged?

Not really, but on the Amiga yes I did some 3D demos and I helped on Starglider 2 for the pc

Starglider was awesome and also ahead of it's time! I presume that Starfox took the idea further, or did you start from scratch? Since the (S)NES HW shares some techniques with the GB(A)

The key is the table for the perspective divide - it takes up a bit of space but it makes things pretty quick 
And of course the log table for the multiplies
