---
title: 'Computer Science education modules'
date: '2018-06-29'
subtitle: Categorizing the essential Computer Science knowledge
tags:
- teaching
- phd
published: true
---

Also worth reading: [Reverse engineering a curriculum](/post/reverse-engineering-a-curriculum/).

I happened to come across a very interesting study path for "game programmers" published at [https://github.com/miloyip/game-programmer](https://github.com/miloyip/game-programmer). It's a nice visual representation of books that help you become a better (game) programmer, starting from zero (game programming for kids) and ending at advanced game physics and Artificial Intelligence. I am not keen on becoming a game programmer but the reason this is interesting is that the author has done a great job trying to categorize the different requirements - what it takes to be a programmer in general. Let's take a closer look at that. 

<center>
    <img src="/img/miloyip.png" class="bordered"/><br/>
    <span>A cut-out part of the study path, copyright Milo Yip</span>
</center>

## Study paths for any programmer

Starting at **Computer Science (CS)**, many of my favorite books on the subject are prominently displayed: **Structure and Interpretation of Computer Programs** (SICP) and **Introduction to Algorithms**. Milo also identifies 3 categories within CS: CS Foundation (SICP), Algorithms, and Mathematics for CS. 

After the required[^1] CS path, we move on to **Programming Languages**. For the game industry, C(++) and C# are important. Sadly, C++ is a horrible mess and requires different levels of specialized books to completely grasp. I was actually researching C++ books as I'm preparing a "Software design in C/C++ with Qt" course for the coming academic year. 

Okay, what's next after a basic CS layer with some intermediate language knowledge? **Software development**, being the practice (TDD, refactoring, clean code, legacy code) and the design (patterns). I'm ignoring his UML reference here. Why would you separate programming languages from software development? You need basic understanding of a language to speak. Grammar (syntax) and speaking (development) are useless separately but a lot of books focus too much on only one of these. 

After that path, the in-depth game development parts begin. Let's look at it this way: the bachelor years are over, time to specialize in the master years.

## Study paths for an academic Master

As a little experiment, I decided to map out my own master education in order to compare the above to some academic reference material. You will see that the abstract "study paths" are very much alike.

### The Bachelor years

These are the courses I followed in 2003 to reach the grade of Academic Bachelor in Informatics (Computer Science), at [UHasselt](https://www.uhasselt.be/). 

#### **First year:**

- Introduction to CS and imperative programming 1
- Introduction to CS and imperative programming 2
- CS Tools (no idea anymore)
- Math for CS 1
- Math for CS 2
- Logic and modeling
- Computer-systems
- Computer arithmetic and decision science
- Human aspects of CS
- Introduction to research and seminars

Extremely heavy on the mathematics and logic, more than 50% of the students stop at this point and because of that. Almost everything is theoretically interesting but practically unprocessed.  

#### **Second year:**

- Algorithms and data-structures
- OO programming
- Advanced algorithms and OO programming
- Probability statistics
- Operating systems
- Logic and Functional programming
- Introduction to databases
- Theoretical informatics

Slowly building upon the first year, introducing algorithms, extending on logic, moving from imperative to object-oriented programming. 

#### **Third year:**

- Telecommunication and telematics
- Software engineering
- Computer networks
- Compilers
- Technology of multimedia systems and software
- Technology of tools of User Interfaces
- Data mining
- Distributed systems
- Bio-informatics
- AI techniques

Finally a lot of freedom for the student as I remember 40% of those courses were optional as I picked data mining and bio-informatics to fill up on points.

### The Master year(s)

These are the courses I followed in 2007 to reach the grade of Master in Informatics (Computer Science), specialization human-computer interaction, at [UHasselt](https://www.uhasselt.be/). 

- 3D interaction and virtual environments
- Advanced software engineering
- Evaluation of User Interfaces
- User-centric system development
- Actual trends in human-computer interaction
- Legal aspects of computer science

I ignored the obvious thesis and internship. The master year included a lot (+60%) of optional courses but I can't remember exactly which one is and which one isn't. The master year has [changed a lot since 2007](https://www.uhasselt.be/masteropleiding-in-de-informatica): it's now 2 years and the specializations have expanded: I could choose from 3 (databases, the theoretical oriented one, multimedia, the graphical oriented one, and human-computer interaction, the engineering oriented one). Now there are six at that university!

There has been a lot of shoving-around (from bachelor to master and the other way around) since I graduated. Things like compilers for instance, and legal aspects seems to be an obligatory course now. But looking at [the list](https://www.uhasselt.be/Studiegids?n=3&txtitemid=66&i=135#66) from a distance, we can clearly distinguish the following trends (only looking at the Master years now!):

1. (Big) "Data" became more apparent.
2. Entrepreneurship is encouraged with some new courses dedicated to that and project management. (both required, rejoice!)
3. Networking (security, IoT) became more apparent.
4. AI and machine learning became more apparent. I was interested in this but in 2006 you could only follow a Master after Master in AI in another university. 
5. "Agile" is a thing and part of policy informatics. (Huh?)

## Essential Computer Science

It seems to me that most courses map quite well with Milo's requirements on game programming. Would that also be the case with other source material?

Yes. 

Look at this well-documented [Google Coding Interview University](https://github.com/jwasham/coding-interview-university#the-daily-plan). I'll let the author speak for it's contents:

> I originally created this as a short to-do list of study topics for becoming a software engineer, but it grew to the large list you see today. After going through this study plan, I got hired as a Software Development Engineer at Amazon. <br/>
> This is my multi-month study plan for going from web developer (self-taught, no CS degree) to software engineer for a large company.

This clearly suggests a (big?) difference between a developer and an _engineer_.[^2] The latter sounds a cooler for sure. But what exactly would be required to make the jump from one title to the other, according to jwasham? The list is too long so let's make some abstractions:

- Algorithms (including NP-completeness) and their complexity
- Data structures (including dynamic programming)
- Object-Oriented Programming
- Design patterns
- Threading, processes and scheduling
- Networking
- System design, scalability and data handling

<center>
    <img src="/img/csbooks.jpg" class="bordered"/><br/>
    <span>Which of these is the most important one?<br/>SICP of course!</span>
</center>

It's an unordered list but you can easily map those subjects onto the previous bachelor years. It's a bit more practically oriented though: a lot more in-depth algorithms and less logic, probability and mathematics. Prerequisites are knowing C so imperative programming got you covered. You can read more about his personal story [on Medium](https://medium.freecodecamp.org/why-i-studied-full-time-for-8-months-for-a-google-interview-cc662ce9bb13).

A more hands-on approach is to be preferred to keep students engaged. [Google's Tech Dev Guide](https://techdevguide.withgoogle.com/) or classic pair programming brain teasers on [Code Wars](https://www.codewars.com/) suggest the same but a close inspection reveals a rather theoretical approach! 

### In Applied informatics
 
So what about the professional Bachelor in Applied Informatics? Is this the road to become a developer but not an engineer, as explained by jwasham? Take a look at the programme from a nearby graduate school, [PXL](https://www.pxl.be/Assets/website/student/werving/infobrochures/documenten/basisopleidingen/TIN_programma.pdf):

#### **First year:**

- Application development (Java/.NET/Web Essentials, Web Scripting)
- OS Essentials
- Security essentials
- IT & Data Essentials ("problem solving")
- Business communication skills

#### **Second year:**

- Java/.NET/Web Advanced
- Server OS Essentials
- Software Analysis
- Security & Data Advanced
- Business communication skills 2

The third year is a specialization year with three choices: application development (mobile development, programming "expert", software engineering), software management (modeling, management) and networking (cloud & automation, OS expert). I can only guess at the contents of the very vague course descriptions but almost anything from the computer science path seems to be completely vanished. 

That leaves me to conclude that the _"2. Programming Languages"_ study path with a bit of _"3. software development"_ apply for a professional bachelor[^3]. Advanced principles might as well be learned on-the-job if you're hired (_"6. Game development"_) but it's sad to see that not even a little bit of the essentials are integrated into the plan. I know this to be true because I was a guest lecturer for courses like the essential and advanced application development parts. 

Of course as a Master and a PhD student I'm highly biased towards academia but I worked for 11 years in the software development industry where practicality is more important and most colleagues came from the applied trajectory.
<br/>This will prove to be insightful when thinking about a global software engineering philosophy!  

[^1]: According to the github link, and according to all academic educations. Applied informatics seems to completely (or partially) skip this step, see later on.
[^2]: To quote the source: "Large software companies like Google, Amazon, Facebook and Microsoft view software engineering as different from software/web development, and they require computer science knowledge."
[^3]: Remember, other graduate schools offer other trajectories. 