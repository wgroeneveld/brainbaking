---
title: "3D Software Rendering on the GBA"
date: '2020-07-21'
subtitle: "Game Boy Advance Fixed-point math, here we come..."
tags:
  - gba
categories:
  - programming
---

When I started programming the [gba-sprite-engine](https://github.com/wgroeneveld/gba-sprite-engine/) two years ago, I knew I would be getting myself into trouble. The Game Boy Advance only has 16Mhz and it's whole software library is written in low-level C using DMA (Direct Memory Access) and memory-mapped IO. Translation: pointers! `**` - Yay!

In the end, switching to `C++11` while trying to unit test and stub out BIOS code as much as possible did help soften the pain. I'm glad I got my hands dirty again, and it writing "closer to the metal" was a welcome change from the usual high-level stuff I produce. 

But GBA MODE 0-1-2 is not the only possibility to write a GBA game. There's also _bitmap mode_, 3-4-5, that lets you write pixel colors (or palette indices) yourself. This opens up possibilities of software rendering things yourself. 90% of the GBA library did **not** do that. But a few games did:

- Doom, Doom II, Duke Nukem Advance (Ray casting engines and/or ports)
- 007 Nightfire (A more modern 3D engine)
- Asterix & Obelix XXL
- A few terrible race games

How do you render things in 3D without hardware acceleration, and without an FPU on the circuit board that handles `float` digits, taken into account the (mostly) 16-BIT bus rate and 16Mhz CPU? Well... It does not exactly produce 30+ FPS:

![](https://github.com/wgroeneveld/gba-bitmap-engine/raw/master/img/monkey.gif?raw=true "Wireframing 507 vertices and 968 faces")

![octahedron](https://github.com/wgroeneveld/gba-bitmap-engine/raw/master/img/raster.gif?raw=true "Trying to rasterize the same thing")

Drawing a lot of lines is not exactly something the GBA loves to do. And I did use [tonclib's optimized routines](https://www.coranac.com/tonc/text/toc.htm) after a failed attempt to implement Bresenham myself. MODE4 has weird byte-write requirements and you can optimize DMA writing of horizontal lines. 

But the worst part was fixed-point math, sine lookup tables, and calling the BIOS just to get a square root of something. `Math.sin()` takes input in radians, in any common programming language. The above imported [Babylon JS](https://sandbox.babylonjs.com) mesh expects the same, but my sine table is filled in `[1-512]` slices and expects it's input 16-BIT. More needless bit-shifting. 

I intended to design the engine again as high-level as possible taking advantage of C++'s objects and operator overloading. How about `worldMatrix * viewMatrix;`? Everything is unit-tested (thank god for that, it took out a lot of bugs). But passing objects around in limited RAM sounds ridiculous - and it probably is, even if it's a `const MatrixFx&` reference or a `std::shared_ptr<Mesh>`. 

Reverting to a simple box sped up the FPS:

![](https://github.com/wgroeneveld/gba-bitmap-engine/raw/master/img/wired2.gif?raw=true "A BabylonJS-exported Box. (including a bug)")

![](https://github.com/wgroeneveld/gba-bitmap-engine/raw/master/img/octa.gif?raw=true "A rasterized octahedron, with back-face culling.")

Even calculating the frames per second is a pain. What's a "second"? Okay, so we need a hardware timer interrupt. When does this thing overflow? How many cycles does the CPU take before that happens? Are you seriously using the divide operator instead of `fxdiv()`?

Also, I could not remember most of the math needed to project 3D vertices into a 2D view, so I let myself be guided by David's excellent [3D soft engine tutorial](https://www.davrous.com/2013/06/13/tutorial-series-learning-how-to-write-a-3d-soft-engine-from-scratch-in-c-typescript-or-javascript/) in JavaScript. Of course I had to port in all Matrix/Vector operations myself.

Future work: texturizing - I'm curious to see at what rate we could get a simple box textured with a mario "?" block. I won't even try to attempt portal rendering like the 007 Nightfire devs. 

Check out the source code here: https://github.com/wgroeneveld/gba-bitmap-engine/

### Unit testing GBA BIOS functions

Tonc's library functions, which sometimes act as BIOS wrappers, are forward-declared in header files. A square root function, `u32 Sqrt(u32 num16fx)`, for instance, does not calculate anything: rather, it executes a BIOS interrupt call. 

Since GTest cannot cross-compile, let alone execute BIOS interrupts, I needed a way around this. Simply using my own implementation by defining `Sqrt` suffices thanks to the linker:

```c
namespace externMath {

#include <math.h>

    float root(float num) {
        return sqrt(num);
    }

}

u32 Sqrt(u32 num16fx) {
    float numfloat = num16fx / ( (float)( 1<<16 ));
    return float2fx(externMath::root(numfloat));
}
```

Instead of a BIOS call, I leave it up to the `math.h` default sqrt implementation.

Sometimes, that does not suffice. In `tonc_math.h`, some forward-declared functions are also defined, in which case GTest will panick. For that, I resorted to `#ifndef` statements. The result is a bit of a mess, but it works:

```c
#include <libgba-bitmap-engine/gba/tonc_types.h>
#ifdef CODE_COMPILED_AS_PART_OF_TEST
    #include <libgba-bitmap-engine/gba/tonc_math_stub.h>
#else
    #include <libgba-bitmap-engine/gba/tonc_math.h>
#endif
```

Since I did not want to change the tonc files itself, constructs like the above sometimes appear in the engine header files when referencing tonc files. Interested readers can always plow through the C++ files in the Github repository. 

