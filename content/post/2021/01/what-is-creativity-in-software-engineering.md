---
title: "What is Creativity in Software Engineering?"
subtitle: "A Focus Group of Creative Programmers"
date: 2021-01-20
tags: [creativity, phd]
categories:
  - programming
---

Last month, our paper entitled _"Exploring the Role of Creativity in Software Engineering"_ got accepted for publication in the proceedings of the 43nd International Conference on Software Engineering: [Software Engineering in Society](https://conf.researchr.org/track/icse-2021/icse-2021-Software-Engineering-in-Society) (ICSE-SEIS). Read the [pre-print paper here](https://arxiv.org/abs/2101.00837). In this article, I'd like to summarize and rephrase our findings, since academic prose can be a bit... well... you know. 

## Why the sudden interest in creativity? 

Good question. In my PhD work, I try to identify - and later on, hopefully amplify - so-called _non-technical_ skills that are needed to succeed as a software engineer. First of all, software engineering is my field of expertise: read the [about me](/about) page if you didn't know that yet. Secondly, I wondered what else besides the technical mumbo-jumbo one really has to master in order to be a _proper_ developer. This goes beyond programming languages, frameworks, typing and productivity knowledge. 

In the previous years, I've worked on:

1. Trying to come up with a list of skills that are important, according to experts in the field;
2. Trying to come up with a list of skills currently taught in higher education;
3. Trying to match these and narrow down the results to reveal the biggest skill gap.

Guess what. Creativity was in the top 3. But the more papers I read about the topic (of which surprisingly little specifically for software development!), and the more people I talked to, the less easily "creativity" could be defined. Hence the effort to facilitate a focus group, where 33 experts in 4 groups talked about their personal experience on the subject at hand. 

I wrote about programming as a [creative cognitive process](/post/2019/10/creative-cognitive-processes/) before, and tried to link the different existing frameworks out there. Most were too theoretical or contained too little context to be able to relate to practical software development. This time, we wanted to validate our thoughts by involving others.

## Dimensions of Creative Problem Solving

After plowing through `399` lovely minutes of discussion, applying the needed qualitative tactics and methods, we came up with 7 main themes that, according to our interviewees, define creativity in the world of (agile/enterprise) software development. The paper contains much more details surrounding these, I merely try to summarize in this blog post. 

![](../creativity-mindmap.jpg "A mind map of the 7 identified themes of creativity in software engineering.")

We did our best to be as specific as possible, using the wording of the participants as much as possible, but generalizations of course are bound to be made at some point in time. Also, instead of going for a vague term like "creativity", we always talked **in context of a programming problem**. That is why the center states "creative problem solving" rather than "creativity". Someone said:

> Creativity simply arises when you are solving a problem. 

Existing literature has proven before that creativity is context-dependent. Whether or not it's also domain-dependent is still an on-going debate. 

### 1. Creative Techniques

Let's start with obvious ones: when talking about creativity, someone is bound to mention "brainstorming" or "combining ideas". Yet, if you don't know about these (practical) techniques, you'll have a harder time solving the problem at hand. For instance, until recently, I never heard about non-linear note-taking, [until now](https://zettelkasten.de/introduction/). It has completely changed the way I work!

The most interesting remark came from someone who said:

> Creativity is the brew of different inputs. 

Because of this, he actively sought out new information - anything that could help him in making the connection with the current problem. Thus, the more you know (and can remember!), the more you can link. And the more you can link, the more you can _cook up_ a solution! That is why this term is colored both blue and purple.

More interesting common practices that were mentioned:

- _Peeling the onion_ by keeping on asking _"why?"_;
- _Rubber ducking_;
- Switching gears: zooming out or zooming in;
- Seeking out edge cases (hopefully in combination with unit tests);
- ... 

Things like _shower thoughts_ reminded me and participants of Andy Hunt's [Pragmatic Thinking & Learning](https://www.goodreads.com/book/show/3063393), one of the best books any developer can read. 

### 2. Technical Knowledge

If creativity is the brew of different inputs, then you better be inputting a lot! Without any base knowledge of the problem at hand (syntax, alternative previous solutions, ...), your creative mind will probably never even bootstrap. The obvious link to another popular non-technical skill, _continuous learning_ (or _lifelong learning_) can be made here. 

### 3. Communication

Many people falsely assume that creativity is a very personal matter: the lone genius creating away of having awesome thought after thought. Yet it is usual within [the Camerata](https://jessitron.com/2020/12/26/purple-developer/) where the magic happens: the group of like-minded people that share ideas, in a liquid network, as in Steven Johnson's [Where Good Ideas Come From](https://www.goodreads.com/book/show/8034188). 

Rubber ducking is all good, but it's better to do it with a colleague: the sensible or insensible response might trigger a thought in your brain and end up helping your creative process. Rubber ducks don't talk back, as far as I know. 

Communicating might also help with motivation - which in turn helps you being more creative (extrinsic motivation only goes that far). One participant said:

> Doing something without feedback is just too non-committal.  

### 4. Constraints

Besides of the exchange of ideas in the communication dimension, working with a fast feedback loop and doing stuff client-oriented introduces **constraints**. Constraints are the things of the Devil - the things we as developers usually curse at: time too short, nagging client, stupid bug report, and so forth. Yet, in reality, the _sweet spot of creativity_ is having enough constraints to keep it challenging. Biskjaer talks about [How task constraints affect inspiration search strategies](https://link.springer.com/article/10.1007/s10798-019-09496-7) - and that is exactly what happens with creative software developers. 

Next time your team members complain about yet another constraint, tell them they're being more creative that way.

### 5. Critical Thinking

Criticizing others' ideas (_"That ain't gonna work!"_) is easy. Coming up with good alternatives yourself is not. Separating the wheat from the chaff, in terms of conceptual ideas you and your team has on this one programming problem, is very important. My ex-colleagues neatly summarized this as: _"don't ASS-ume, you make an ass out of u and me"_. This was said quite often, for example when we assumed the `NullPointerException` was because of `x`, without digging deeper first. 

Of course, the cause turned out to be a combination of `y` and `z`.

### 6. Curiosity

Closely related to **motivation**. One participant said he had a lot of respect for creative solutions, also beyond the context of software engineering. Admiring something creative because of the creative aspects drives your own curiosity, pushing you to look for alternatives and niche paths you might never have looked at before. In short: get out of your comfort zone! Work cross-team, pick up that other programming language, read others' blogs (thanks!) - even if it makes you feel uncomfortable. That feeling is the feeling that you're _learning_.

Does this mean we always have to be curious? Unlikely. Use your critical thinking skills to decide! Participants emphasize the right combination between creativity and critical thinking, taking into account the context and constraints of the problem:

> Creativity is the means, not the goal.

### 7. Creative State of Mind

Before being creative, you first have to be _allowed_ to be creative: companies should also and actively support this! Setting the right scene to allow the flow of thought is a requirement of good creative problem solving. This means your environment should allow for freedom and flexibility. 

#### This is where "the magic" happens

Funnily enough, creative thinking does not seem to happen exclusively on the workplace, behind your desk. Someone said ideas come to mind when standing in front of a traffic light, while others jot stuff down after a shower. I loved this statement:

> When I'm at work, all I have to do is type out the solution in my head.

Of course, `80%` of the work has been done _before_ getting to work (or on the previous days/weeks at work). 
I remember our boss being very angry because we were letting off steam by playing cards at 14h30 - just finishing up a game we had to interrupt. What he didn't see was our invisible collectible creative problem solving effort (and probably also sweat) we put in earlier. Like the guy who said I just type out stuff when I'm at work. Managers like busy-work, but most if it is distinctively _not_ creative: that part has already been done!

## Future Work

There are many more variables involving creativity and sparking that creative _flow_ (how to assess it, what are some limitations, what are motivations to be creative, ...). We're planning on using the above dimensions to create a small survey in order to test how creatively students approach a programming project. I think we can safely assume that there is still a lot of unexplored ground to cover, and I love that - it means we can contribute something useful! 