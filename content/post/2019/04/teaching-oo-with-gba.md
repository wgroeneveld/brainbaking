---
title: Teaching Object-Oriented design using the GBA
date: '2019-04-15'
bigimg: /img/gbacarts.jpg
aliases:
    - /post/teaching-oo-with-gba/
subtitle: C++ and a GBA engine. Let's learn to create a game!
tags:
  - teaching
  - gba
  - C++
published: true
---

Electrical Engineering students have to work through a programming course in their third year at KU Leuven, a course called '[Software Design in C/C++](/teaching/cpp/)'. This course is one of the things I inherited from my retired colleague when I started working for the University. As is the case with most programming courses, it's contents was _boring as hell_. 

So, instead of simply making minor adjustments to the syllabus and calling it a day, in the summer of 2018 I decided to throw everything in the begin and start over - hooray, a _greenfield_ project! This was one of the rare opportunities for me to do so as most other courses are taught together with others. This one wasn't, I also had to lecture theory and administer exams. coincidentally, also in that very same summer, I re-found my love for the retro Game Boy, and started wondering how to program games for it. My knowledge of C and C++ was limited to a few years of practical use in the industry, working on administrative Windows MFC applications.

I got to work, by scanning documentation, cursing and swearing _a lot_, and ultimately learning how to create games for the Game Boy Advance. Most if not all GBA games are written in `C`. As much as I like simple elegance, I did opt for `C++` instead, because I wanted to bring in object-orientation and unit testing the way I was used to these, like in `C#` and Java. That also means getting used to the ugliness of C++. Oh well. 

At the end of February 2019, all (but one) students finished their project, creating a game (concept) on the GBA, all working on the actual hardware, tested with a EZ-DRIVE cartridge. The result is compiled in the following 6-minute video:

{{< vimeo 314203871 >}}

<br/>
I'm actually really proud of what they achieved. Developing something for the GB(A) is notoriously hard if you are not familiar with the architecture. Some examples of 'challenges' (sources of swearing):

- There is no OS. Nothing is managed. Do it yourself.
- Hardware interaction is done through address memory mapping. That means reading and writing byte streams to hard-wired pointers.
- Forget debugging. 
- Graphics is another tough nut to crack, using optimized sprites, a shared palette, and other techniques needed because of the limited (hardware) space.

All those things are extras, the main point of the course is to learn object-oriented development, close to the hardware. Most students had difficulties enough with the `C++` syntax. They did complete another programming course, software design in Java, but that seemed to be long lost and forgotten, as is usually the case with hard working students. 

To ease their pain, I created a concept framework in `C++`, called '[<i class='fa fa-github'></i>&nbsp;gba-sprite-engine](https://github.com/wgroeneveld/gba-sprite-engine/)' (available on GitHub through that link), which students had to fork, compile, and use for their projects. It comes equipped with a few demo projects, and throughout the different labs, we worked our way through the GBA's conceptual hardware model, using the following outlines as a guideline:

1. [Introduction in C](/teaching/cpp/labo-1)
2. [Pointers in C and C++](/teaching/cpp/labo-2)
3. [GBA Programming in C: an introduction](/teaching/cpp/labo-3)
4. [GBA Programming in C: tilesets, a simple game](/teaching/cpp/labo-4)
5. [Introduction in C++](/teaching/cpp/labo-5)
6. [C++ Class Inheritance, operators and templates](/teaching/cpp/labo-6)
7. [Software design: thinking and testing before coding](/teaching/cpp/labo-7)
8. [GBA Programming in C++: an abstraction layer](/teaching/cpp/labo-8)
9. [GBA Programming in C++: scrolling backgrounds](/teaching/cpp/labo-9)

The syllabus is accessible through the links, although in Dutch. 

Especially the live Castlevania demo's were quite appealing to students, showcasing sprite design, different backgrounds, and the palette:

![Aria of Sorrow](../aria-of-sorrow.gif)

God I love that game. I'll gladly take every opportunity I have to look and/or play it. 

The sprite engine does the heavy lifting in terms of image memory allocation and storage, and provides some abstract concepts for sprites/backgrounds/music/scenes. But not before we've seen these in the labs ourselves (lab 1-4). Take a look at the [<i class='fa fa-github'></i>&nbsp;GitHub documentation of the engine](https://github.com/wgroeneveld/gba-sprite-engine/) to get a better picture on the included features. (For the most part) Unit tested and all. It is cross-platform compatible, as the GBA is actually an ARM machine, you'll be needing a cross-compiler from the [DevKitPro toolchain](https://devkitpro.org/wiki/Getting_Started). 

The emphasis lies on the _object-oriented_ part of the course title, that is why the design of the game, and game engine, was very important to me. If you are creating a platformer like Mario, and you can jump, grab coins, and squash enemies, then I want to see that reflected in your design. Where is the statement `mario.jump()`, where are the `class Coin` and `class Goomba : public Enemy` definitions? You can extend from the following engine parts:

![gba-sprite-engine design](https://github.com/wgroeneveld/gba-sprite-engine/raw/master/img/design.png?raw=true)

After the oral defense of their game, students completed a short survey that helped me assess what to do with the course during the next academic year. Most students were very enthusiastic regarding the inclusion of the GBA, compared to another dull set of assignments. They also responded positively to the question whether the Game Boy could be used in other courses as well, such as hardware architecture design, or (advanced) chip design (using an FPGA). 

I'm happy they liked it, and although the theoretical exam results were not that promising, the practical projects were. We will be using more or less the same course contents next year. After academic year 2019 - 2020, the course will sadly disappear into two other courses: the C hardware-related part will merge into a more OS-oriented course, and the C++ object-oriented design part will merge into a software engineering-oriented course. Both new courses still need to be planned and implemented. 

That means there's still a chance for me to sneak in Castlevania, right?
