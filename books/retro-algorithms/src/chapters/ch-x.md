
# Bitmaps

## X

\cover{x}{Argonaut Games}{1992 (JPN)}{Space combat simulator}

The early nineties was a golden age for gaming, not only on handhelds. Lucky gamers with access to more powerful hardware could mess around in 3D environments, something that was deemed impossible on the Game Boy. That is, until Jez San and Dylan Cuthbert of Argonaut Games decided it would be cool to program a 3D space simulator for the GB. The result is _X_, a stellar achievement released in 1992 running on one of the weakest pieces of hardware imaginable at that time.

To be fair, that's not the whole story. Argonaut Games was already well-known for their 3D space combat simulators _Starglider_ and it's successor _Starglider 2_, published in 1986 and 1988. Starglider 2 was released on Amiga, Atari ST, MS-DOS, Macintosh, and the ZX Spectrum. The latter platform is highly interesting to us, because the Spectrum is based on a Zilog Z80 CPU running at 3.5 MHz - it has close similarities with the Game Boy's hardware, and thus, it's limitations. 

Dylan kindly agreed to chat a bit about his experience creating X, and he indeed confirms that 8-bit assembly programming on UK's beloved _Speccy_ was something he could do with his eyes closed. 

"Of course the Game Boy not a Z80 and a hybrid cut down thing but the Z80 is the closest thing to it and I’d had years of programming that on the ZX Spectrum" he recalls. 

But these Spectrum games were simple platformers. In a 2018 interview with USG[^usgint], Dylan admittedly reported it even caused his first job application at Argonaut to be rejected - they had already moved on to 3D games. Like all eighteen year old coders, bursting with energy and refusing to be turned down, he traded the ZX Spectrum for the more powerful Amiga to figure out 3D graphics. A second attempt at Argonaut hit bullseye thanks to a 3D demo which did not fail to impress company founder Jez San.

[^usgint]: https://www.usgamer.net/articles/dylan-cuthbert-star-fox-game-boy-hacking-feature-interview

After deciding to make something on the most popular handheld of the nineties, the first hurdle to take was to figure out how the Game Boy actually functions. Nintendo was very stingy at handing out official development kits, especially outside of Japan. The guys at Argonaut thought the quickest way to do it was to "simply" reverse-engineer it, explains Dylan in the USG interview:

> "We hacked together a Game Boy development kit with a camera pointed at the Game Boy. We took a cartridge — I think a Tetris cartridge — and unscrewed it all. We connected up wires to chips and connected them to this circuit board one of the guys had at Argonaut made. They'd gotten into circuit printing and were printing the circuit boards in this bath full of acid."


![Starglider 2 on the ZX Spectrum. Source: https://spectrumcomputing.co.uk/](ch-x/starglider2.png)

\marginfig[-3.85cm]{ch-x/starglider2_amiga.png}{Actually, Starglider 2 should look like this, showcasing flat shaded colored polygons.}{Starglider 2 on Amiga}

Argonaut's Starglider combined with Dylan's knowledge of ZX assembly programming and 3D graphics thus somehow successfully morphed into a Game Boy game. but how is that technically possible? Compared to relatively powerful machines such as the Amiga and the Atari ST, Nintendo's original handheld machine was meager and low on memory. Exactly like Sinclair's microcomputers, performance was sacrificed for affordability. 

Screenshots showcasing different versions of Starglider 2 should clarify what "_meager_" hardware means.

Reduce the palette of 15 shades to only four shades of gray and you've got something quite similar to X, including the stuttering frame rate. In order to get a playable frame rate, a lot of optimization cuts had to be made: no textures let alone filled polygons, only a few objects rendered at once, and a limited amount of rotation. 

\marginfig{ch-x/x.png}{X on the Game Boy.}{A screenshot of X}

I ask Dylan if any 2.5D rendering techniques such as raycasting were involved.

"Nope, there were no hacks, it’s full 3D! The data is all 3D and I used a number of techniques to get the speed up. " So X was actually modeled like more modern 3D games. Color (ha!) me impressed. 

Before we can take a look at Dylan's tweaks to get it running on a Game Boy, we first have to figure out how 3D graphics rendering actually works. "Zero matrices are involved of course!" enthuses Dylan. But what does that entail exactly?

### The very basics of 3D graphics

Graphical processing involves a lot of simple and more intricate mathematics. In case you're starting to panic: I leave the details to Eric Lengyel who's better suited to explain advanced concepts in his book _Mathematics for 3D game programming and computer graphics_ [@lengyel2012mathematics]. Instead, I'd like to give an overview of the steps needed to transform a simple shape from a 3D world into a 2D world, and thus onto the Game Boy screen. 

Ranging from simple to multi-layered and quite complex, contemporary 3D game engines usually involve the following steps:

1. Build the 3D scene in memory using "models" (the objects represented in the game world) and process them. This can be very primitive (wireframes like in _X_) or more advanced (textures and light mapping like in _Quake_). I don't need to tell you that texturing is out of the question on any 8-bit system. 
2. Convert the 3D world space into 2D screen space (_projection_ and _rasterization_).
3. Post-process the converted pixels[^pxsh]. Forget about this on any Game Boy machine... 

[^pxsh]: This is called _pixel_ or fragment shading, while the first processing step is called _vertex_ shading.

X does not go further than wireframe rendering. Starglider 2 on Amiga showcases flat shaded colored polygons. Modern graphics APIs like Microsoft's Direct3D provide a processing pipeline [@msd3d] that involves far too many intricate steps for any Game Boy to handle. We'll cover rudimentary shading and texturing in later chapters. For now, let's focus on the essentials: screen space projection. 

Suppose we want to render a simple _cube_. A cube is a simple _polyhedron_, or a three-dimensional shape with six flat _polygonal_[^poly] faces: each face is simply a square (left, right, up, down, front, back). To draw a square you'd need four $(x,y)$ coordinates and draw lines between them. However, to draw a cube, you don't need six times that amount - instead, we're interested in the _vertices_: the points where two lines meet to form an angle. 

[^poly]: A polygon is simply a two-dimensional figure containing a finite amount of straight line segments (e.g. a square). A polyhedron therefore is a three-dimensional shape containing a finite amount of polygons as sides or "faces" (e.g. a cube).

Our cube contains eight very simple vertices: `(-1, 1, 1)`, `(1, 1, 1)`, `(-1, -1, 1)`, `(-1, -1, -1)`, `(-1, 1, -1)`, `(1, 1, -1)`,`(1, -1, 1)`, `(1, -1, -1)`. These numbers may be confusing because when we draw a cube on a piece of paper, we unconsciously project the object onto a 2D space and flatten the model. In front view, you will probably draw a big square partially obfuscated by a smaller square inside.

\marginfig[-2.2cm]{ch-x/babylon-screen-box.png}{A cube displayed in model space.}{A rendered cube in model space.}

\marginfig[-0.2cm]{ch-x/babylon-world-boxes.png}{Multiple projected cubes in world space.}{Multiple projected cubes in world space.}

The above 3D vertex coordinates are raw _object coordinates_ in model space, with their initial position and orientation before any transformation is applied. In order to calculate the window or _screen coordinates_, a number of operations are performed.

First (1), all cube models have to be put in the same space, the _world space_. To convert from model space to world space, vertices are translated by multiplying them with the ModelWorld matrix. Since every model has it's own position and orientation in the world, they all have different ModelWorld matrices. A box in model space is just a single box - where do you want to place it in the game world? To the left of that tree? Or a little further away, slightly rotated? That's the world space. Designing single models in 3D computer graphics software toolsets such as Blender stay within the confinements of model space. Once a level designer places it into the game world, probably using a game editor, it's in world space.

\marginnote[-1.1cm]{
    \begin{tikzpicture}[node distance=1.5cm]
        \node (vertex) [startstop] {Vertex data};
        \node (mvm) [box, below of=vertex] {World matrix};
        \node (pm) [box, below of=mvm] {View matrix};
        \node (w) [box, below of=pm] {Projection matrix};
        \node (vp) [box, below of=w] {Viewport transform};
        \node (src) [startstop, below of=vp] {Screen data};

        \draw [arrow] (vertex) -- node[anchor=east] {Object coords} (mvm);
        \draw [arrow] (mvm) -- node[anchor=east] {World coords (1)} (pm);
        \draw [arrow] (pm) -- node[anchor=east] {View coords (2)} (w);
        \draw [arrow] (w) -- node[anchor=east] {Device coords (3)} (vp);
        \draw [arrow] (vp) -- node[anchor=east] {screen coords (4)} (src);
    \end{tikzpicture}
}

Next (2), we need to find an efficient way to project the world onto the screen. As a gamer, you cannot see the entire game world: your view is limited to where the camera points at. That camera can be arbitrarily oriented in space to catch only a glimpse of the enticing game world. To keep the math (and matrices) in check, it is a lot simpler if the camera is centered in the origin and looks down one of the three axes. This intermediate _view space_ step does exactly that: repositioning everything using a view matrix to make things simpler. In practice, step one and two are executed with one single transformation matrix called the ModelView matrix.  

Then (3), since now our camera is correctly positioned, all that is left is projecting what the camera 'catches' of the game world onto the screen. But before we can do that, we first have to project from view space to _projection space_ using yet another transformation matrix. This space allows us to quickly discard polygons that fall outside the camera view area, a process called _clipping_. The projection matrix defines the viewing volume. There are two common ways to project from view space into projection space: orthographic projection and perspective projection. orthographic projection is used in 2D gaming with 3D engines where there's no dynamic depth. In perspective projection, clipped coordinates have to be divided by a depth factor $w$, hence it's name _perspective division_. 

\marginfig{ch-x/babylon-projection.png}{Projecting using perspective division. The further back, the smaller on the target screen.}{Projecting using perspective division.}

The best way to visualize the difference between these two projections is to think about parallel lines. Go outside and take a look at the left and right side of the road. At the horizon, these lines seem to intersect. In Cartesian space, that usually does a good job at describing 2D and 3D objects, this is very difficult to express. The Cartesian space is a coordinate system you are probably very familiar with in 2D: two axes that form perpendicularly oriented lines. It was named after the brilliant French philosopher and mathematician René Descartes.

However great Descartes was, Cartesian coordinates help little when trying to project two parallel lines merging at the horizon. How about the rather unusable $(\infty, \infty$)? The solution is to introduce $w$ so that $(x, y)$ becomes $(x, y, w)$. These are called Homogeneous coordinates, something invented by August Ferdinand Möbius to help calculating graphics in projective space. Möbius introduced one more dimension to N-dimensional coordinates, allowing us to express the concept of infinity as $(x, y, 0)$.

However, we still need Cartesian coordinates to project everything to a 2D screen raster, so these are converted back by dividing[^div]: $(x/w, y/w)$. After perspective division, coordinates are also called _device_ coordinates. Device coordinates almost resemble screen coordinates, but are not yet translated and scaled to screen pixels.

[^div]: As a retro game programmer, any kind of division should raise a red flag, as these are very expensive instructions eating up precious CPU cycles!

Lastly (4), window or _screen coordinates_ are calculated to flatten the image from the camera by applying a viewport transformation. After this step, vertex shading becomes pixel shading in the API pipeline. The screen dimensions are used here. This last stage of 3D is also called _rasterization_ since polygons are translated into colored pixels in a 2D raster. 

To summarize - inside the game loop, the following happens:

```
render 3D coordinates = 
    for each model:
        for each vertex in the model:
            transform coords using ModelToWorld 
                                 x WorldToView 
                                 x ViewToProject matrices
            discard vertices outside of camera view
            flatten to 2D screen coordinates
```

\marginfig{ch-x/cube-points.png}{Rendered screen coordinates of cube vertices in front view. Can you spot the cube? How about with your eyes squinted?}{Rendered screen coordinates of a cube.}

I have implemented a simple version of this concept on the Game Boy Advance. The GBA allows me to program in C++ instead of assembly, making the code easier to read and understand. The rendered figures in the margin are screenshots taken from that demo. You can take a look at the matrix transformations in `gba_engine.cpp` at [https://github.com/wgroeneveld/gba-bitmap-engine/](https://github.com/wgroeneveld/gba-bitmap-engine/).

### Drawing lines

Stopping after projecting coordinates onto the screen won't get us very far: without any lines drawn between them, all you can see is mere dots representing an object. While trying to imagine what the object looks like is fun, it's not as much fun as seeing and interacting with the real thing. Thus, the rendered screen coordinates should be connected with lines: rasterization. 

\marginfig{ch-x/cube-vertex-lines.png}{Simply connecting the projected coordinates does not suffice.}{A partially wireframe-rendered cube.}

However, simply connecting the dots will not suffice. Remember that in order to minimize the amount of vertices for a model, we only defined eight coordinates for our cube? Connecting eight points on a piece of paper does not produce a nice-looking cube. Wireframe rendering means rendering a model by drawing the outlines of multiple smaller shapes using the simplest possible 2D geometric shape: a _triangle_. 

\marginfig{ch-x/cube-orig.png}{The same wireframe-rendered cube in front view using triangular faces. A lot less strain for our imagination. Notice that the 'X' in the front is a result of the back-faces also being drawn, while in reality they are mostly invisible.}{A wireframe-rendered cube using triangular faces.}

3D modeling tools can automatically break down an object into triangular faces. A face is internally represented an index pointing to three vertices of a model. A square can be divided into two triangles by drawing a single diagonal line, forming two faces. Since we have six squares to cover in a cube, we've got 12 faces in total to define. 

But how do you draw a straight line between two points in a 2D space? "Well, take a ruler, place your pencil at one point, and follow the ruler until you reach the other point!" And how do we do that in pixel space? 

- If $y_0$ and $y_1$ are equal, start at the lowest $x_0$ value, add 1 until you reach $x_1$. Do the same vertically if $x_0$ and $x_1$ are equal.
- If the line is diagonal, the solution is also trivial. For instance, going down to the bottom right[^botr], add 1 to both $x_0$ and $y_0$.
- But what about a line at 30 degrees? Or 110?

The trick is coming up with a generic solution that is capable of handling lines at any angle. Luckily, Jack Elton Bresenham already solved this problem for us in 1962 when he was working for IBM. By now, it has been iterated and improved upon countless of times [@jia2008modified]. There are other line drawing algorithms, but Bresenham's is one of the oldest and fastest because it uses cheap integer operations - exactly what a Game Boy programmer needs. 

In the following figure, a downward sloping line has been drawn on top of a 2D raster to illustrate which pixels to color on screen. Bresenham came up with an effective way to test whether or not the $y$ coordinate should be increased (thus further lowering the line): by checking the midpoint of the pixel. In this example, the $x$ coordinate always increases by one. This case should be modified for each octant, so you'll first need to figure out in which direction the line will be going. 

If the midpoint of the traversing pixel lies above the line, such as the colored pixels in the figure, it is time to increase $y$. As long as the midpoint stays below the line, we're safe to continue horizontally. 

[^botr]: In screen space, the top left corner is $(0, 0)$.

![Midpoints of each pixel are marked with a red circle. All individual colored pixels end up producing the desired line.](ch-x/bresenham.png)

Bresenham's algorithm is indeed an effective way to draw arbitrary lines, although it tends to produce "jagged" edges. Anti-aliasing, the technique to smooth out a line by rendering multiple pixels per pixel of the final image, is a video memory-intensive process so we're out of luck here. With the low resolution of the Game Boy, it would have resulted in very blurry frames, making the ghosting issue of the original Game Boy seem even more troublesome. Furthermore, as mentioned before, post-processing pixels is out of the question simply because of hardware limitations. 

\marginfig[-2.5cm]{ch-x/x-face-alias1.png}{A blown-up screenshot of the commander in X emphasizes the lack of anti-aliasing: look at all those jaggies!}{The X commander without anti-aliasing.}

Inside the game loop, the downward sloping line, of which the starting and ending coordinates have been projected into 2D screen space, can be drawn like this:

```
draw downward sloping line = 
    for each horizontal pixel:
        increase x by 1
        if the midpoint is above the line:
            increase y by 1
```

### The visibility problem

Merely converting vertex data to screen data and drawing triangles would end up in a big mess of intersecting lines if a lot of models are visible on screen. After all, polygons that end up at the back of other polygons, and therefore are hidden to the player, should not be drawn. This is called the _visibility problem_ in 3D computer graphics.

\marginfig{ch-x/x-visibility.png}{Polygons are simply overdrawn in X.}{Polygons are simply overdrawn in X.}

The simplest solution to the problem is to be inspired by one of the most likable media personalities of the eighties and nineties: the painter Bob Ross. His joyful and soothing instructions guide you towards your first success in oil painting. Attentive viewers of his _The Joy of Painting_ TV show will notice that he always starts with the mountains, gradually working his way towards the foreground. The end result is always a stunning canvas consisting of a few overlapping layers of oil, painted in less than thirty minutes.

"There!" he proclaimed, putting down his brushes. The _painter's algorithm_ Bob employed can also be translated to computer graphics: draw everything back to front. Things that should not be visible will simply be overdrawn. 

As you might have guessed, redrawing pixels is a waste of precious CPU cycles, and is to be avoided at all costs, especially when filling polygons. Therefore, detecting and removing hidden surfaces[^detec] before they are sent to the rendering pipeline will result in a significant performance gain. Clipping polygons outside of camera view in projection space is one of the techniques to do that. However, we can do better, for instance by calculating if a model's face is facing away from the camera - and thus on the back of the model - in order to skip drawing them. Partial visibility checks are made possible by splitting polygons into smaller pieces.

[^detec]: Early rejection of models is also called _culling_. Multiple techniques are described in the CryEngine docs at [https://docs.cryengine.com/display/SDKDOC4/Culling+Explained](https://docs.cryengine.com/display/SDKDOC4/Culling+Explained).

X does not attempt to handle the visibility problem and simply depicts everything, presumably because the game is not worth the candle. Wireframe renderers enable the player to see through objects anyway. Later chapters describe how bitmap-based GBA games handle this. 

### How to get it running on the Game Boy

Now that we're experts at projecting 3D models onto a 2D canvas on screen and drawing lines between points to produce something meaningful, the question is: how to cram all this logic into an 8-bit handheld? The answer is rigorously reducing functionality, according to Dylan Cuthbert. 

"I mapped the screen to be a screen buffer - can’t remember the dimensions of it, but not huge." he explains when I ask him how he even managed to manipulate individual pixels. Remember that the GB does not have a bitmap mode - it's designed to work with sprites only!

"Then, I transferred that into the character map every frame. I transferred it byte by byte by polling the H-blank flag and only transferring it during that time." This sounds surprisingly similar to the HDMA method encountered in chapter-x.

"I used a number of techniques to get the speed up, mostly table lookups. Especially for the perspective division and rotation, so sine tables. I didn’t even really use fixed point math as far as I can recall" continues Dylan. "I think the units were just kept small so `1` was quite small. It was just integer math with everything below the fixed point being discarded after multiplies."

Transformation matrices involve $cos(x)$[^cos] and $sin(x)$ calculations, exactly like GBA's affine sprite transformations, except that this time transformations are sadly not hardware-accelerated. Trigonometry _LUTs_ (lookup tables) are well-known techniques to retro coders. Instead of going through type conversions and floating-point functions, you can conserve CPU cycles by spending memory to build a LUT which stores pre-calculated sine values. The occupied RAM space on an already limited system is a conscious trade-off to make.

[^cos]: Smart sine tables also house cosine values. Instead of using 360 units for a circle, use a power of two, such as 512. Then, a cosine value is just a shifted sine, and wrapping can be achieved with a few bitmasks. The _Tonc_ documentation provides further implementation details of LUTs. 

Also, note that Dylan avoids dividing by $w$ inside the game loop by creating another LUT especially for this purpose. 

"And most of the 3D is single axis rotation with some special cases for two axis - flying things primarily so they can bank and dive." This greatly simplifies the matrix multiplication steps, further unburdening the CPU.

The easiest way to increase the performance of any bitmap-rendered game is to reduce the resolution. X contains a fairly large HUD, where you can keep an eye on your fuel level. It's also a neat trick to reduce the CPU load since that part is tile-based and fairly static. Even the arrows explaining the concepts of the game during the tutorial are sprites. 

\begin{figure*}[h]
  \includegraphics[width=\linewidth]{ch-x/x-tutorial-tiles.png}
\end{figure*}

\begin{figure}[h!]
    \centering
    \includegraphics{ch-x/x-tutorial.png}
    \caption{The X tutorial scene (left) and the active tileset (above). Note the repeating pattern in the 5 parts
    of the dotted line leading up to the arrow, pointing at your current speed (HIGH). \newline The gray spots in between the Japanese symbols in the tileset constantly change as new bytes from the buffer are copied over.}
\end{figure}

As expected, everything that makes up the HUD is present in the tileset, from altitude measures to numbers and text. 

The more Dylan explained and the more I poked around in mGBA inspecting the game's internals, the more I sympathized with this man. My own feeble attempts at programming in 3D were done in C++ on the GBA, which already left me sweaty - I couldn't bear to think about having to do all that in assembly! When inquired how Dylan coped with structuring code such as matrices and vertices, his response was quite pragmatic.

"It’s all machine code so data driven - although I had some simple data structures for convenience that could equate to C style structures but the Z80 isn’t good for accessing that kind of organization of data so yeah..." What are you going to do?

\marginfig{ch-x/x-tunnel.png}{The impressive tunnel sequences come with an equally impressive soundtrack by Japanese composer Kazumi Totaka - his first game in a slew of many great Nintendo titles to come, including Animal Crossing and Luigi's Mansion.}{The impressive tunnel sequence in X.}

"I did use one trick in the tunnels to clip the tunnel segments to the next segment  and make them look solid" recounts Dylan. The claustrophobic vibe, a pleasantly upbeat soundtrack and a fixed but fast speed that requires concentration all make up for one of the most exciting parts of the game. 

Sadly, X was never released outside of Japan. Although the game was fully localized and ready to be shipped under the name _Lunar Chase_, it apparently never did[^floating]. Presumably, American retailers preferred simple 2D-like games that were selling like hot cakes instead of a nerdy 3D game that looked to intricate for kids to handle. The huge popularity of the Game Boy meant it was not the ideal platform for experimentation. Of course, in Japan, anything stamped with a Nintendo logo sells like hot cakes. 

[^floating]: An English tech demo of X is still floating around the internet. 

### The legacy of X

Perhaps the most impressive feat of X is it's 3D rendering without any dedicated hardware to support it. Early fully 3D polygon-based simulation games such as Hard Drivin' on Arcade boasted some serious muscle under the hood. Atari's Hard Drivin' ran on an early version of the first dedicated polygonal 3D graphics board destined for Namco's racing game Winning Run, called System 21 or better yet, the "Polygonizer". The three stacked PCBs accommodated six different processors, of which several dedicated to handle rendering, geometry and physics[^retro205].

[^retro205]: Source: Retro Gamer 205. Namco and Atari were sister companies at that time, so the system was co-developed.

Nintendo's involvement and interest in the X project ultimately paved the way for Star Fox (or Starwing in Europe), another Argonaut masterpiece that came with filled polygons more akin to Starglider 2 on the Amiga. That would not have been possible without the onboard "Super FX"[^sfx] RISC co-processor that also was conceived by the guys at Argonaut. Nintendo's then new _Super_ NES was still quite weak compared to home computers of the early nineties. 

[^sfx]: During development, it was codenamed "_MARIO_" (Mathematical, Argonaut, Rotation, & Input/Output).

\marginfig{ch-x/starfox.jpg}{Peppy's iconic "Do a barrel roll!" exclamation from Star Fox even caused a giggle with Google engineers. Try typing it in Google Search.}{Star Fox on SNES.}

In 1990, Argonaut Games demoed a version of a Starglider NES port to Nintendo. Impressed with the work, and in need of help for their launch title Pilotwings, Nintendo asked polygon experts Argonaut how to correctly rotate planes in their game. Because of severe hardware limitations, they ran out of memory before a frame could be drawn. Jez San proposed to solder a 3D chip directly onto the cartridge PCB that could do the necessary math. 

Since the aging NES console was on the verge of being replaced by the SNES, Nintendo briefly considered to package the Super FX with their new machine. Alas, time constraints prevented that from happening. Imagine what the 16-bit war would have been like if the SNES motherboard came with a Super FX chip preinstalled! Instead of SEGA's popular TV commercial _Genesis Does What Nintendon't_, it could have been _Nintendoes what Genesis doesn't_... 

![The PCB of a PAL version of Yoshi's Island, with the GSU-2 in the middle, flanked by the 2 MB ROM on the left and the 256 KB frame buffer and save game SRAM on the upper right.](ch-x/pcb-yoshi.jpg)

Since the SNES itself still only supports sprite modes, the Super FX chip draws polygons to a frame buffer in the extra RAM that also sits on the PCB of the cartridge. Similarly to Dylan's frame buffer copy technique in X, DMA is used to transfer the contents to the video memory of the SNES itself. 

Instead of designing hardware first and writing software for it, Starfox and the Super FX chip were developed the other way around. This enabled the developers to optimize the chip to their needs to really take advantage of it's capabilities. A second version of the chip, labeled GSU (Graphics Support Unit) 2, running at twice the clock speed of it's predecessor (21.4 MHz), eventually made it possible to port DOOM to the SNES - after still making heavy compromises[^doomsnes]. It was also used to help with the calculation of 2D sprite transformations in Yoshi's Island, six years before the GBA was conceived. 

[^doomsnes]: Read more about the birth of DOOM on the SNES in Fabien Sanglard's excellent _Game Engine Black Book: DOOM_. 

Randal Linden, the developer of DOOM FX on SNES, released it's source code in 2020 on Github at [https://github.com/RandalLinden/DOOM-FX](https://github.com/RandalLinden/DOOM-FX). If you're feeling particularly adventurous on an early Sunday morning, you can try to wade through the assembly lines to discover how the Super FX chip was programmed. 

Ultimately, little games made use of either GSU chip since it greatly increased manufacturing costs and even MSRP. Only 5 games would use the first iteration: Dirt Racer, Dirt Trax FX, Star Fox, Stunt Race FX and Vortex. Even less games would use the GSU-2 chip: DOOM, Yoshi's Island and Winter Gold. 

X on the Game Boy is a landmark in gaming. No single Game Boy (Color) game would come near matching it's polygon processing power. Without X, there would be no Star Fox franchise, no DOOM on an early Nintendo console, and a pretty crappy version of Yoshi's Island. 

\newpage

### What's outside the game loop?

* A few prepared lookup tables that hold pre-calculated data such as sine, cosine and perspective division values.
* Vertex data of each object in the game world, for each level. 
* A screen buffer where the graphics are drawn to. 

### What's inside the game loop?

* A software pipeline rendering mechanism that is able to transform 3D object coordinates into 2D screen data, updating the screen buffer between frames.
* Rasterization of simple triangles by efficiently drawing lines between two arbitrary points, based on the midpoint of each pixel. 
* Several optimization tricks that help reduce the CPU load, such as looking up values in LUTs, hidden surface removal, clipping, reducing the resolution, restricting rotations and keeping the math as simple as possible (e.g. no floating points). 
* A fast way to copy over the screen buffer at the right moment, avoiding flickering effects. 
