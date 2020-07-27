---
title: trying to understand gba bios compression
date: 2020-07-03
from: Nagy Tibor
---
I followed the GBATEK docs when I implemented that library. The way it
describes the compressed data formats could be a bit hard to decipher
but everything is there.

https://problemkaputt.de/gbatek.htm#biosdecompressionfunctions

To use Huffman in your game first you need to embed Huffman-encoded
data in your ROM. For images, I see you are using grit. You can tell
grit to emit Huffman-compressed palettes, graphics and tilemaps with
-pzh, -gzh and -mzh respectively. Then on the GBA instead of copying
your graphics data straight to VRAM use the HuffUnComp() function to
decompress it there. It's a thin wrapper around the BIOS syscall with
the same name.

https://github.com/wgroeneveld/gba-sprite-engine/blob/941aea12411b4aeeac58546edb3bd060349f0697/engine/include/libgba-sprite-engine/gba/tonc_bios.h#L302

For other binary data, I'm sure you could find some tool on gbadev
sites to Huffman compress your data before embedding it into your ROM.
Wish I could say use my library to do it, but Huffman compression is
the only function I was too lazy to implement.

The Wario Land 4 stuff: The compression format was already known from
other games (Metroid Fusion). I just reimplemented it in Rust to be
able to use it for romhacking. However there's a tilemap compression
algorithm I reverse engineered myself, used for the in-game cinematics
of the game. I used the disassembler of no$gba to find out how it
works, but now I recommend using Ghidra for these kind of stuff.

https://github.com/xTibor/steaks/blob/c8537dc63e1a9119f72ad42f8f7aa28f45b8dc3e/tools/intro_gfx_viewer/src/main.rs#L134-L153
