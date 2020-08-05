
# Bitmaps

## X

\cover{x}{Argonaut Games}{1992 (JPN)}{Space combat simulator}

The early nineties was a golden age for gaming, not only on handhelds. Lucky gamers with access to more powerful hardware could mess around in 3D environments, something that was deemed impossible on the Game Boy. That is, until Jez San and Dylan Cuthbert of Argonaut Games decided it would be cool to program a 3D space simulator for the GB. The result is _X_, a stellar achievement released in 1992 running on one of the weakest pieces of hardware imaginable at that time.

To be fair, that's not the whole story. Argonaut Games was already well-known for their 3D space combat simulators _Starglider_ and it's successor _Starglider 2_, published in 1986 and 1988. Starglider 2 was released on Amiga, Atari ST, MS-DOS, Macintosh, and the ZX Spectrum. The latter platform is highly interesting to us, because the Spectrum is based on a Zilog Z80 CPU running at 3.5 MHz - it has close similarities with the Game Boy's hardware, and thus, it's limitations. 

Dylan and I chat a bit about his experience creating X, and he indeed confirms that 8-bit Assembly programming on UK's beloved _Speccy_ was something he could do with his eyes closed. 

"Of course the Game Boy not a Z80 and a hybrid cut down thing but the Z80 is the closest thing to it and I’d had years of programming that on the ZX Spectrum" he recalls. 

Starglider's wireframe graphics somehow made it to the Game Boy - but how? Compared to relatively powerful machines such as the Amiga and the Atari ST, Nintendo's original handheld machine was meager and low on memory. Exactly like Sinclair's microcomputers, performance was sacrificed for affordability. 

Screenshots of different versions of Starglider 2 clarify what '_meager_' hardware means:

\marginfig[5.6cm]{starglider2_amiga.png}{Actually, Starglider 2 should look like this, showcasing flat shaded colored polygons.}{Starglider 2 on Amiga}

![Starglider 2 on the ZX Spectrum. Source: https://spectrumcomputing.co.uk/](starglider2.png)

Reduce the palette of 15 shades to only four shades of gray and you've got something quite similar to X, including the stuttering frame rate. In order to get a playable frame rate, a lot of optimization cuts had to be made: no textures let alone filled polygons, only a few objects rendered at once, and a limited amount of rotation. 

\marginfig{x.png}{X on the Game Boy.}{A screenshot of X}

I ask Dylan if any 2.5D rendering techniques such as raycasting were involved.

"Nope, there were no hacks, it’s full 3D! The data is all 3D and I used a number of techniques to get the speed up. " So X was actually modeled like more modern 3D games. Color (ha!) me impressed. 

Before we can take a look at Dylan's tweaks to get it running on a Game Boy, we first have to figure out how 3D graphics rendering actually works. "Zero matrices are involved of course!" enthuses Dylan. But what does that entail exactly?

### The very basics of 3D graphics

Graphical processing involves a lot of simple and more intricate mathematics. In case you're starting to panic: I leave the details to Eric Lengyel who's better suited to explain advanced concepts in his book _Mathematics for 3D game programming and computer graphics_ [@lengyel2012mathematics]. Instead, I'd like to give an overview of the steps needed to transform a simple shape from a 3D world into a 2D world, and thus onto the Game Boy screen. 

Ranging from simple to multi-layered and quite complex, 3D game engines usually involve the following steps:

1. Build the 3D scene in memory using models and process them. This can be very primitive (wireframes: _X_) or more advanced (textures, light mapping: _Quake_). I don't need to tell you that texturing is out of the question on any 8-bit system. 
2. Convert the 3D world space into 2D screen space (_projection_ and _rasterization_)
3. Post-process the converted pixels[^pxsh]. Forget about this on any Game Boy machine... 

[^pxsh]: This is called _pixel_ or fragment shading, while the first processing step is called _vertex_ shading.

X does not go further than wireframe rendering. Starglider 2 on Amiga showcases flat shaded colored polygons. Modern graphics APIs like Microsoft's Direct3D provide a processing pipeline [@msd3d] that involves far too many intricate steps for any Game Boy to handle. We'll cover rudimentary shading and texturing in later chapters. For now, let's focus on the essentials: screen space projection. 

Suppose we want to render a simple _cube_, one of the many appearing shapes in X, especially in the tunnel scenes. A cube is a simple _polyhedron_, or a three-dimensional shape with six flat _polygonal_[^poly] faces: each face is simply a square (left, right, up, down, front, back). To draw a square you'd need four $(x,y)$ coordinates and draw lines between them. However, to draw a cube, you don't need six times that amount - instead, we're interested in the _vertices_: the points where two lines meet to form an angle. 

[^poly]: A polygon is simply a two-dimensional figure containing a finite amount of straight line segments (e.g. a square). A polyhedron therefore is a three-dimensional shape containing a finite amount of polygons as sides or 'faces' (e.g. a cube).

Our cube contains eight very simple vertices: `(-1, 1, 1)`, `(1, 1, 1)`, `(-1, -1, 1)`, `(-1, -1, -1)`, `(-1, 1, -1)`, `(1, 1, -1)`,`(1, -1, 1)`, `(1, -1, -1)`. These numbers may be confusing because when we draw a cube on a piece of paper, we unconsciously project the object onto a 2D space and flatten the model. In front view, you will probably draw a big square partially obfuscated by a smaller square inside.

\marginnote[-1cm]{
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

\marginfig{babylon-screen-box.png}{A cube displayed in model space.}{A rendered cube in model space.}

\marginfig{babylon-world-boxes.png}{Multiple projected cubes in world space.}{Multiple projected cubes in world space.}

The above vertex coordinates are raw _object coordinates_ in model space, with their initial position and orientation before any transformation is applied. In order to calculate the window or _screen coordinates_, a number of operations are performed[^op]. 

[^op]: The above schematic summarizes these operations.

First (1), all cube models have to be put in the same space, the _world space_. To convert from model space to world space, vertices are translated by multiplying them with the ModelWorld matrix. Since every model has it's own position and orientation in the world, they all have different ModelWorld matrices. A box in model space is just a single box - where do you want to place it in the game world? To the left of that tree? Or a little further away, slightly rotated? That's the world space. Designing single models in 3D computer graphics software toolsets such as Blender stay within the confinements of model space. Once a level designer places it into the game world, it's in world space.

Next (2), we need to find an efficient way to project the world onto the screen. As a gamer, you cannot see the entire game world: your view is limited to where the camera points at. That camera can be arbitrarily oriented in space to catch a glimpse of the game world. To keep the math (and matrices) in check, it is a lot simpler if the camera is centered in the origin and looks down one of the three axes. This intermediate _view space_ step does exactly that: repositioning everything using a view matrix to make things simpler. In practice, step one and two are executed with one single transformation matrix called the ModelView matrix.  

Then (3), since now our camera is correctly positioned, all that is left is projecting what the camera 'catches' of the game world onto the screen. But before we can do that, we first have to project from view space to _projection space_ using yet another transformation matrix. This space allows us to quickly discard polygons that fall outside the camera view area, a process called _clipping_. The projection matrix defines the viewing volume. There are two common ways to project from view space into projection space: orthographic projection and perspective projection. orthographic projection is used in 2D gaming with 3D engines where there's no dynamic depth. In perspective projection, clipped coordinates have to be divided by a depth factor $w$, hence it's name _perspective division_. 

\marginfig{babylon-projection.png}{Projecting using perspective division. The further back, the smaller on the target screen.}{Projecting using perspective division.}

The best way to visualize the difference between these two projections is to think about parallel lines. Go outside and take a look at the left and right side of the road. At the horizon, these lines seem to intersect. In Cartesian space[^cart], that usually does a good job at describing 2D and 3D objects, this is very difficult to express. The solution is to introduce $w$ so that $(x, y)$ becomes $(x, y, w)$[^homo]. However, we still need Cartesian coordinates to project everything to the screen, so these are converted back by dividing: $(x/w, y/w)$. After perspective division, coordinates are also called _device_ coordinates. Device coordinates almost resemble screen coordinates, but are not yet translated and scaled to screen pixels.

[^cart]: The Cartesian space is a coordinate system you are probably very familiar with in 2D: two axes that form perpendicularly oriented lines. It was named after the brilliant French philosopher and mathematician René Descartes.

[^homo]: These are called Homogeneous coordinates, something invented by August Ferdinand Möbius to help calculating graphics in projective space. Möbius introduced one more dimension to N-dimensional coordinates. Using Homogeneous coordinates, the concept of infinity (where two parallel points would merge at the horizon) can be expressed as $(x, y, 0)$, while using Cartesian coordinates, you would end up with the rather unusable $(\infty
, \infty$). If only I had paid more attention in mathematics courses, this stuff is fascinating! 

Lastly (4), window or _screen coordinates_ are calculated to flatten the image from the camera by applying a viewport transformation. After this step, vertex shading becomes pixel shading in the API pipeline. The screen dimensions are used here. This last stage of 3D is also called _rasterization_ since polygons are translated into colored pixels in a 2D raster. 

To summarize - inside the game loop, the following happens:

```
for each model:
    for each vertex in the model:
        transform coords using ModelToWorld 
                             x WorldToView 
                             x ViewToProject matrices
        discard vertices outside of camera view
        flatten to 2D screen coordinates
```

\marginfig{cube-points.png}{Rendered screen coordinates of cube vertices in front view. Can you spot the cube? How about with your eyes squinted?}{Rendered screen coordinates of a cube.}

I have implemented a simple version of this concept on the Game Boy Advance. The GBA allows me to program in C++ instead of Assembly, making the code easier to read and understand. The rendered figures in the margin are screenshots taken from that demo. You can take a look at the matrix transformations in `gba_engine.cpp` at [https://github.com/wgroeneveld/gba-bitmap-engine/](https://github.com/wgroeneveld/gba-bitmap-engine/).

### Drawing lines

Stopping after projecting coordinates onto the screen won't get us very far: without any lines drawn between them, all you can see is mere dots representing an object. While trying to imagine what the object looks like is fun, it's not as much fun as seeing and interacting with the real thing. Thus, the rendered screen coordinates should be connected with lines.

\marginfig{cube-vertex-lines.png}{Simply connecting the projected coordinates does not suffice.}{A partially wireframe-rendered cube.}

However, simply connecting the dots will not suffice. Remember that in order to minimize the amount of vertices for a model, we only defined eight coordinates for our cube? Connecting eight points on a piece of paper does not produce a nice-looking cube. Wireframe rendering means rendering a model by drawing the outlines of multiple smaller shapes using the simplest possible 2D geometric shape: a _triangle_. 

\marginfig{cube-orig.png}{The same wireframe-rendered cube in front view using triangular faces. A lot less strain for our imagination. Notice that the 'X' in the front is a result of the back-faces also being drawn, while in reality they are mostly invisible.}{A wireframe-rendered cube using triangular faces.}

3D modeling tools can automatically break down an object into triangular 'faces'. A face is simply an index pointing to three vertices of a model. A square can be divided into two triangles by drawing a single diagonal line, forming two faces. Since we have six squares to cover in a cube, we've got 12 faces in total to define. 

But how do you draw a straight line between two points in a 2D space? "Well, take a ruler, place your pencil at one point, and follow the ruler until you reach the other point!" And how do we do that in pixel space? 

- If $y_0$ and $y_1$ are equal, start at the lowest $x_0$ value, add 1 until you reach $x_1$. Do the same vertically if $x_0$ and $x_1$ are equal.
- If the line is diagonal, the solution is also trivial. For instance, going down to the bottom right[^botr], add 1 to both $x_0$ and $y_0$.

The trick is coming up with a generic solution for any arbitrary angle. Luckily, Jack Elton Bresenham already solved this problem for us in 1962 when he was working for IBM. By now, it has been iterated and improved upon countless of times [@jia2008modified]. There are other line drawing algorithms, but Bresenham's is one of the oldest and fastest because it uses cheap operations - exactly what a Game Boy programmer needs. 

[^botr]: In screen space, the top left corner is $(0, 0)$.

### How to get it running on the Game Boy

tricks mentioned by Dylan



