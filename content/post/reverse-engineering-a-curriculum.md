---
title: 'Reverse engineering a curriculum'
date: '2018-06-15'
subtitle: Imagining the end before starting with the beginning
tags:
- teaching
- phd
published: true
---

Also worth reading: [Teaching by philosophy](/post/teaching-by-philosophy/).

What if, instead of starting with the beginning, you'd start with imagining where you'd land if you'd successfully finish a big project? Thinking like this would temporarily eliminate the _how_ question and focus on the _what_ or _why_ question on a higher level. It's a good exercise that might net me new ideas or forge novel connections between two slumbering thoughts. Let's try to imagine what a __curriculum for computer science__ should look like ideally without holding back on the actual practical possibilities - based on rough ideas noted in my [proposal](/proposal). 

## 1. Defining the core Principles

Let's take a look at concepts that deserve more attention in a curriculum - any curriculum really, not simply limited to engineering. My focus is on computer science within the engineering faculty but didactic terms can be easily generalized.

#### Collaboration: The Camerata

I was amazed by Jessica Kerr's article [on the Origins of Opera and the Future of Programming](https://the-composition.com/the-origins-of-opera-and-the-future-of-programming-bcdaf8fbe960) today. She found out that _extreme inventive bursts_ happen in special groups, or **Camerata's** - in music (The Camerata), art (the Salon in Paris) and even in science. The jump from science to practical software engineering is marginal and easily taken. 

> the Camerata resembles the kind of “invisible college” which is the key to creativity in science.
This “invisible college” is an association of people who share ideas. Who build a new reality together, then spread it to advance the wider culture.

The most important phenomenon to observe is this: **Great teams make great people**, not the other way around. "You don’t hire star developers, put them together, and poof get a great team. It’s the other way around. When developers form a great team, the team makes us into great developers.". 

If great teams create great people, do great educational institutions create great graduates? Can we apply industrial mentor models like eXtreme Programming to tighten the Camerata feeling in a practicum? That invisible college is very visible: it's **the** college! Sharing ideas is mostly a one-way transaction (teacher -> student) but graded projects encourage (some) two-way collaboration (student <-> student).

#### Learning: Symmathesy

To continue with Jessica's article, she touches upon another very important principle in software engineering: learning. Not just learning, but within a system that grows and changes, and affects your whole self. Nora Bateson calls it a [symmathesy](https://norabateson.wordpress.com/2015/11/03/symmathesy-a-word-in-progress/). Focusing on _life long learning_ is a start, but symmathesy goes much broader than that: it's the context where the learning happens that is paramount to me. Learning within a living system, learning alone as [self improvement](/tags/self-improvement/) or together, part productivity part generality. Both models get little to no attention in traditional education.  

It's no secret that the software landscape is continually evolving. That means a healthy focus on **transferable concepts** is much more important than practical framework or programming language knowledge. Stack Overflow keeps track of technological popularities and it's always interesting to read what they have to say about (the brutal) [lifecycles of JS frameworks](https://stackoverflow.blog/2018/01/11/brutal-lifecycle-javascript-frameworks/). Brain Moschel's article on [longevity (or the lack thereof) in JS Frameworks](https://www.bitovi.com/blog/longevity-or-lack-thereof-in-javascript-frameworks) also provides some thoughtful insights. Don't forget the choice is influenced by company location - and according to Jessica, also by the "time (culture) they live in".<br/>To distinguish the important from the unimportant.

A third part of learning is being able to manage the heap of stuff to learn. Not only sifting through useless things to learn, but more importantly being **productive in learning anything**. The word "productive" has a individual connotation here and touches upon pragmatism and thinking & learning models. Knowing how flow works and how to divide your time in bursts of Deep Learning and Shallow Learning. 
<br/>To put it simply: knowing how learning works. Henry Stanley talks about [becoming a dramatically better programmer](https://recurse.henrystanley.com/post/better/) - interesting choice of words.

#### Context creation: Mental models

Mental models are models formed in your mind when you talk about specific parts in the software you know. When communicating to other team members, you need a model to find a common ground to talk about. The problem is that each developer's mental model is potentially incomplete and out of date. 

<center>
    <img src="/img/curriculum/model.jpg" class="bordered"/>
</center>

> We spend time reconciling our mental models enough to communicate with each other; this is a [coherence penalty](http://www.michaelnygard.com/blog/2018/01/coherence-penalty-for-humans/).

I'm convinced that this coherence penalty also applies within conversations between teachers and students. A teacher creates a virtual model in his mind of different courses that are tied together and nicely intertwined. Students also create virtual models in their minds but it's much more fragmented: courses are mostly seen as separate obstacles to overcome without any clear context. 

Before teaching the _how_ (syntax), we need to teach the _why_ ([philosophy](post/teaching-philosophy-first/)). Our mental models should find a common ground! A lecturer and the students can also be seen as part of the same **Symmathetic** team: why wouldn't systems thinking apply within educational institutions? 

#### [Creativity](/post/serendipitous-creativity/): Serendipity

Malleability of software as a material is very understated. The ever faster application of changes (agility) is well-known, but the ability to transfer learned skills from one problem (project) to another is not. Creativity touches upon and enhances previous sections on collaboration, learning and context. I see creativity as an integrated part of the above but it's worth to accentuate it separately. 

> There’s something extra special about development teams: software is the most malleable material we’ve ever used in engineering, by thousands of times. There’s nothing else like it, and this changes the meaning of “team.”

<center>
    <img src="/img/curriculum/idea.jpg" class="bordered" />
</center>

It doesn't only change the meaning of team, but also the way you should think about limitations of your own expertise: there is (almost) none - except time constraints that are not relevant here. Emphasis on the creative process with the right help of brainstorming and retrospectives, techniques that can also be rightfully applied within a classroom, guided or not. 

#### Organic (software) development: Changeability

Small pieces of easily readable code maximize maintainability. Engineering isn't a long wined singular method of combining stuff anymore: it's about incremental improvements, not unlike nature! While researching reference material for this article, Googling "growing software" nets me [confusing manifesto's](http://softwaregarden.io/manifesto/) that are partially what I'm aiming for, and even more confusing [books](http://shop.oreilly.com/product/9781593271831.do) that are about managing engineers. 

Jessica's symmathesy explains that source code, continuous integration and deployment are also **part of the team** and _living (organic) things_. If you take care of these "things", these "things" take care of you. Malleability works both ways. Clear software that grows bit by bit, as you do, is the only way to achieve a ubiquitous mental model within - and outside of - your team. That personal evolving relationship between the coder and the code is what makes the team great (and therefore, the people great).

A typical software design course doesn't place enough emphasis on the longevity of software. Projects are graded and students move on to the next very individually tailored (towards technicality, not the student) course. The team constantly changes: there's no overarching project. The opportunity is there though: a typical [Master of Science in Industrial Engineering](https://www.uhasselt.be/Masteropleiding-industriele-wetenschappen#tabs6) programme takes five years[^1], a lot longer than small to average software projects in the industry! 

## 2. Incorporating those Principles

There are many ways to change an educational (master) programme:

1. Redefine course content. (ex. remove C++, add Python)
2. Redefine the way the courses are given. (ex. flipped classrooms, activating students)
3. Redefine the entire structure. (ex. self-directed, community-driven education like [Recurse](https://www.recurse.com/))

Apart from a small portion of every possibility above, my take would be to take the existing courses and integrate the principles we've extracted in part 1. It wouldn't hurt to shake up the contents now and then (1.) or to enabling students by introducing more active ways of lecturing (2.), but let's for now focus on incorporating those principles without changing too much content. 

<center>
    <img src="/img/curriculum/teach.jpg" class="bordered" />
</center>

#### A. Create a software engineering philosophy. Teach all courses in context of this shared understanding. 

This is the single most important missing piece of the puzzle. The shared mental model of what there is to be taught and in what context (why?). That philosophy should contain the core principles: **make concepts visible** and put everything into perspective! Purposes should be clear for students. After all, we're trying to spark a curiosity, an interest in engineering. Simply grading them course by course won't help there. 

Openness in academia is an interesting topic by itself. Prof. Philip Dutré talks about [transparency in education evaluation](http://phildutre.blogspot.com/2015/04/docenten-maak-je-onderwijsevaluaties.html) in his blog (in Dutch) and is worth reading. The way you grade is very important to students: they (mostly) learn what will be graded, not necessarily what you think they might find interesting. Grading should be open for everyone and again, in context of the global engineering philosophy. 

#### B. Introduce long-term projects across courses. Let students branch and redesign continually and vigorously. 

Start in the first Bachelor year with a project that will be refactored and redesigned up to the Master years. It should be something crystal clear that can bear becoming gradually more complex. Let students fail by sudden difficulty spikes. This is the only way they'll get a taste of the malleability of bigger projects. <br/>
Later boarding students could start with reference projects on different levels. 

Cross-course material only benefits the shared philosophy: A and B go hand in hand. 

#### C. Prioritize on learning within a living system. 

I would even opt for this one to use possibility (1.) and replace something useless like "business management" with a completely new course that focuses exclusively on this. The earlier in the programme track it's given, the better. Again, this should seamlessly integrate with other courses while making context explicit. 

What the exact contents of this course would be seems like an entire new article to me. 

## What's next? 

This has proven to be a refreshing exercise. We've only talked about high-level principles without worrying about the implementation (the _how_). Also, the concrete elaboration of my personal software engineering philosophy is something that will grow incrementally over the coming years, with the needed feedback from both the industry and the education institutions. 

Taking a closer look at different universities and their take on the problem will also be worthwhile. I'm sure I'm not the only researcher with these ideas. There is some research available on how children grasp programming more quickly given a conceptual explanation first. 

[^1]: Including the bachelor prerequisite years. 
