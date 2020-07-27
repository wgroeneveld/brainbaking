---
title: Doom II GBA
date: 2020-07-13
---

Hi Wouter,

I'd be happy to chat. A couple of years ago a modder from Russia got in contact with me about the Southpaw Engine that we used for Duke Nukem Advance, Doom II GBA and Ice Nine. I gave him a "memory dump" of what I could remember in an email and he posted it on a forum here: https://www.doomworld.com/forum/topic/98744-gba-doom-2-map-converter/?page=2&tab=comments#comment-1882553


If you've got anything else you'd like to ask me I'd be happy to answer.

Cheers,
Chris

---

Ok, guys, I have some interesting news!

 

Long time ago I've sent messages to every developer who worked with GBA Doom 2 in hope to get some information about Southpaw Engine. And today Chris Hayton (the Southpaw Engine programmer) answered me!

 

Here goes the text (without my question, I just simply asked to help understand how it's works):

---

Thank you for your correspondence (below) and apologies for taking so long to reply to you (I hardly ever check Facebook). I'm very interested to hear about your retro game modding and I'll do my best to help you.

 

Unfortunately I haven't worked for Torus Games since 2006, so I don't have access to any of the source code for the Southpaw Engine, which was retired years ago in any case. So, I will have to go on memory. Let me first tell you a bit about the development process. Duke Nukem GBA used bitmap mode 4 for the in-game rendering, and a char-based modes for the cutscenes and menu screens. Torus Games already had a char-based engine that they used for some of their 2D GBA titles and some tools that they used to convert the assets produced by the artists into the palettized GBA char-based formats. They also had a sound engine that was brought across from their 2D games as well. So the Southpaw engine was the only new tech that was unique to DNA.

 

I was the programmer responsible for the rendering engine, and wrote a conversion tool (called convwad.exe) that converted Doom WAD files to our format. We didn't use WAD files "as is" because of space considerations, we wanted to pack as much onto the cartridge as possible. There is a simple 1:1 correspondence between structures like linedefs and so on from the WAD format and ours. I think the format started off with a count of all the different structure types (linedefs, sidedefs etc) and then the data was just written out. So, it should be possible for you to extract the levels from the ROM, reverse the process and end up with WAD files of all the Duke Nukem Advance Levels. If you look for repeating patterns in the data you should be able to see how large the data structures are and how many of them there are. Once you have reverse engineered the format you can make your own levels and put them in the game.

 

We stored the wall textures in a compressed format that is different to Doom's. The texture is broken up into vertical 1-pixel wide strips and any duplicates are removed (lots of the textures contain repeating patters so there is a lot of this). A 1D array is stored with the index of the appropriate vertical strip for each horizontal position in the texture. Identical strips will reference the same index. Because the rendering engine draws the walls in vertical strips, the indexing can be calculated at the start of the run rather than per-pixel. Floor textures are all 32x32 pixels (IIRC, might be 64x64) and are not compressed in this fashion because they can be rendered at any angle. All textures are stored with multiple mip-map levels (this improved image quality, but also speed up the rendering, because we could assume that the texture co-ordinate would increase by either 0 or 1 for each screen pixel, which enabled a bunch of optimizations)

 

Transparent textures are compressed by only storing the pixels between the first and last non-transparent texel of each vertical strip along with the number of transparent texels that have been chopped off at the top so that the rendering code can compensate for this. When there is run of transparent pixels in the middle of the strip there there is a special color index at the start of the run that encodes how many transparent pixels the renderer needs to jump over. This means that it doesn't waste time sitting in a loop iterating over texels that will not be rendered.

 

Animated and destructible wall textures were implemented using special naming schemes for the textures e.g. wall_0, wall_1, wall_2 would animate in a loop etc

 

For scripting, we used a combination of the Doom linedef behaviours for opening/closing doors and so on, along with simple text file that contained dialogue text to be displayed and various actions (e.g. show security camera views etc). We changed the meaning of some of the linedef types to look up a string from the text file indexed by the linedef (or sidedef perhaps) and display it instead of producing the Doom behaviour. Various escape characters in the string produced scripting behaviours. It should be straightforward to find this stuff in the ROM by searching for dialogue text. This had the side-effect that it was possible for scripting sequences to work in one language and not another, if someone accidentally removed the scripting commands from the translated text!

 

Of course in Torus's port of DOOM II to the GBA the default behaviours are used. Duke Nukem was actually produced first, so it was very handy for us that we had used Doom WADs "under the hood" for DNA when it came to doing the Doom II port.

 

I hope this is all of some help to you, feel free to come back to me with more questions.

 

Best regards,

Chris Hayton

Palmerston North,

New Zealand

---

Sure, I'd be happy to proofread. To answer your questions: 1) yes, there was a set of lookup-tables for the different lighting levels, I can't remember how many exactly, maybe 32 or 64. There was a single 256-colour palette that had to be shared by all textures and software-rendered sprites (the HUD overlay had its own palette by virtue of using the GBA's hardware sprites). Rendering a texture was a two-step process: look up the byte value of the texel, and then use it as an index into the appropriate 256-byte lighting table to read out the remapped (lit) pixel value. We had a special case for the default (unlit) lighting level where the texels could be written as-is because the lighting table mapped the values to themselves. The unlit lighting level was somewhere in the middle of the lighting range, so the remapping tables could either lighten or darken the pixel. IIRC we also had lighting tables for special effects e.g. coloured lighting that was used on some levels for red lights etc. In the case of software sprites and transparent wall textures the transparency check was done on the unlit texel value. Unlike PC Doom we didn't apply any depth-based lighting effects. 2) Yes we used BSP trees, however we didn't generate them ourselves, we just used third-party tools for working with the Doom WAD format before running the BSP through our conversion tool. The development timelines for GBA games were quite tight (usually 4-6 months) so we had to get things up and running as quickly as possible, especially if we wanted to have time to work on tuning the gameplay. In the case of Duke Nukem Advance the development time was unusually long because the scheduled release date was delayed due to the September 11 attacks - a lot of game publishers didn't think the timing was right to release a game in the immediate aftermath. 3D Realms also had an "it's done when it's done" attitude to project schedules, which was unusual and afforded us a lot of time to polish the game. The original version of DNA didn't have floor or ceiling textures, that was something we managed to squeeze in with the extra time.

Cheers,
Chris
