---
title: 'Sparking Creativity with the Game Boy Advance'
subtitle: 'Presented at SIGCSE 2020, Portland, OR, USA'
accent: "#008eb3"
disableComments: true
disableList: true
---

<img src="https://sigcse2020.sigcse.org/images/logo/sigcse2020-bridge.png" />

### Poster Abstract

Numerous studies have shown that Game-Based Learning positively impacts educational effectiveness and student motivation. However, according to Amabile's Componential Model of Creativity, _motivation_ is only one aspect of creativity, next to _expertise_ and _creative skills_. Therefore, we looked beyond motivational aspects in order to amplify all dimensions of creativity. In a 'Software Design in C++' course at our local faculty of Engineering Technology, students learn to apply high-level object-oriented software development techniques on low-level embedded hardware. By introducing the Game Boy Advance (GBA), a 32-bit handheld released by Nintendo in 2001, students not only need the domain-specific technical _expertise_ and _motivation_ to succeed, but also the right _creative skills_ to cope with the limitations of this embedded system that has only 96kb of VRAM. We focused the labs on stimulating these creative problem-solving techniques. Results are promising: students were highly motivated and creative output was distinctly increased; but technical expertise was still lacking during examination. Further work involves investigating the impact of peer-assessment on all aspects of creativity.

_Groeneveld, W., Aerts, K. (2020). Sparking Creativity with the Game Boy Advance. In: Proceeding of the 51th ACM technical symposium on computer science education. Presented at the SIGCSE '20, Portland, OR, USA, 11 Mar 2020-14 Mar 2020._

- [Download the Poster Paper](https://lirias.kuleuven.be/retrieve/552354).
- [Download the Poster itself](/files/sigcse2020-poster.pdf).

![](/files/sigcse2020-poster-preview.png "Poster preview, click to enlarge")

### Project results 2018 - 2019

{{< vimeo 314203871 >}}
<br/>

Utilizing the custom-built [gba-sprite-engine](https://github.com/wgroeneveld/gba-sprite-engine/) library residing at <i class='fa fa-github'></i>  Github. See the README there for more information. The engine itself uses the [Tonc](https://www.coranac.com/tonc/text/toc.htm) C calls behind the scenes. 

#### Survey results

24 recorded participants. 

> [1] Have you ever played a Game Boy (Advance) game before?

Blue: yes, red: no.

<center>
    <img src="/img/teaching/cpp/gbasurvey_1.png""/>
</center>

> [2] How motivated were you during project work?

Five-point Likert scale. 1: not at all. 5: extremely. 

<center>
    <img src="/img/teaching/cpp/gbasurvey_2.png""/>
</center>

> [3] Did the fact that you are developing on the GBA influence your motivation?

Blue: yes, positive; more motivated than classical assignment. Orange: it did not matter for me. Red: negative; less motivated than classical assignment. 

<center>
    <img src="/img/teaching/cpp/gbasurvey_3.png""/>
</center>

### Project results 2019 - 2020

{{< vimeo 392922578 >}}

## '_Software Design in C++_' Course Details

The following lecture slides and lab notes were used throughout the semester to get students acquainted with the C++ programming language, high-level object-oriented design, and the Game Boy Advance hardware. Students had no knowledge of C or C++ before. They had some knowledge of programming in Java before. 

This is the English index page, roughly based on the [Dutch index](/teaching/cpp/), where students can find more information regarding the course itself. All links below contain content in Dutch. 

### Lectures

1. [Introduction in C/C++: context, ecosystem](/teaching/cpp/slides-1/)
2. [Pointers in C, dynamic memory in C++](/teaching/cpp/slides-2/)
3. [Introduction in Object-Oriented thinking in C++](/teaching/cpp/slides-3/)
4. [Templates, operators, STL, summary, exam info](/teaching/cpp/slides-4)

### Lab notes

1. [Introduction in C](/teaching/cpp/labo-1)
2. [Pointers in C and C++](/teaching/cpp/labo-2)
3. [GBA Programming in C: an introduction](/teaching/cpp/labo-3)
4. [GBA Programming in C: tile-sets, a simple game](/teaching/cpp/labo-4)
5. [Introduction in C++](/teaching/cpp/labo-5)
6. [C++ Class Inheritance, operators and templates](/teaching/cpp/labo-6)
7. [Software design: thinking and testing before coding](/teaching/cpp/labo-7)
8. [GBA Programming in C++: an abstraction layer](/teaching/cpp/labo-8)
9. [GBA Programming in C++: scrolling backgrounds](/teaching/cpp/labo-9)
10. [GUI design with C++ in Qt: an introduction](/teaching/cpp/labo-10)
11. [GUI design with C++ in Qt: porting a GBA game to Qt](/teaching/cpp/labo-11)
