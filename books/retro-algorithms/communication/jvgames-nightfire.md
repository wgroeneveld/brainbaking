---
from: Vince, Jag
date: 2020-07-04
title: "RE: 007 Nightfire GBA 3D engine"
---

Doom, Wolf 3d, Duke Nukem used the raycasting method, which you know uses 2D height mapped blocks or line segments like in the image below.  Really fast for rendering but its big limit, because the map was 2D you could not have a player above and below a bridge. So no ledges or bridges or inside and outside of homes etc..

![](../wolf3d.png)

We used standard 3D rendering techniques like modern games are using.  Our engine would be very similar to the Quake engine as a software based 3D rendering engine.  Compared to Quake our limitations were we used “Vertex” shadow mapping instead of “texture” shadow mapping like quake did.  And because divisions were so expensive on a GBA (I think 30 clocks) to keep the speed up we did not want to divide our texture coordinates by Z often.  So keeping the floors and walls horizontally and vertically aligned we could get away with a single division per vertical sliver of wall and horizontal sliver of ground. 
 
Dividing by Z per pixel creates perspective correct textures and lighting etc.  Quake used a divide by Z every 16 pixels for perspective corrected textures.  If you don’t perspective correct at all the effect was swimming textures on the wall as you move.  Games on the PlayStation 1 exhibit this effect.  We avoided all that as long as the Z distance is the same across all pixels you are going to linear interpolate from, you can get away with one divide.
 
Another difference is that we needed to keep the polygon count down per frame, so while quake used BSP (Binary Spaced Partitions ) to draw the scene, we used cubed portals on ours.  We rendered the “Cube” that was X,Y and Z aligned. First draw the cube we are in.  Then, if there was any holes in the adjoined cube portal we would draw that next, until the scene was completely filled.  Unreal was the first major game to use portal rendering.  But theirs was arbitrary at any angle, location or direction.  These techniques allowed large worlds to be created and those polygons that are known not to be visible to the camera does not even attempt to draw, saving lots of processor power.
 
Vince

---

Hi Wouter,
Thanks for reaching out to us, it’s always wonderful to hear from fans.
Nightfire for the GBA was very challenging.  We utilized our Entity Engine that was originally developed on for Towers ][ on the Atari Jaguar.
Back then, because of Doom, the rule of thumb was raycasting but we wanted to separate ourselves a little.  The problem with Raycasting is that you couldn’t have any bridges or be able to go under architecture.
It was something we wanted, so our engine was actually polygon based.  A huge feat for such limited hardware. To keep the speed up on the GBA we did limit up and down rotation to mimic raycasting like Duke Nukem so we would only need one divide per horizontal or vertical line.
Vince was the architect of the Entity Engine.
 
We would be more than happy to give insight on whatever it is your looking for.
Good luck on the book
 
Jag
JV Games Inc.


