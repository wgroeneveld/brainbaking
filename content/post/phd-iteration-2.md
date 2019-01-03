---
title: "A Ph.D. Thesis: Iteration 2"
date: '2019-01-03'
subtitle: On Mastering Lean Skills in Software Engineering Education
tags:
  - phd
published: true
---

A huge amount of ideas and a quite a few months later, my original [proposal](/post/phd-proposal/), called _"The disparity between industrial requirements and classic education of modern software engineering."_, changed for the better. The approved abstract is called _"Improving software engineering education by closing the gap with modern non-technical industrial requirements"_. After struggling to find any focus (and reference material to work with), I now settle with:

> Mastering Lean Skills in Software Engineering Education

### Defining what a skill is

These "lean skills" refer to the required skillset of modern software engineering practitioners. The skills themselves are not quite modern or new, but the ever evolving software development industry increasinly demands good noncognitive abilities next to conventional cognitive thinking - something that is on the rise for the last 10 years. Identifying non-technical requirements has been done plenty of times before and took on the form of the [SWEBOK](https://www.computer.org/web/swebok) model and the like. 

The problem with educational software engineering research in this area, is that either the papers are extremely vague, or they are too broad. Radermacher [^1] and Sedelmaier [^2] for instance identified missing soft skills in engineering education, but those skills do not speak for themselves: "project management", "personal skills", "ethics", "oral communication". I tried to create an overview of these papers as an introduction for myself into the topics and research world but ended up frustrated and confused. It also of course consumed some valuable months of my time...

Simply trying to pin down these terms by defining them seems to be a daunting task that will likely never receive a consensus[^3]. For example, I tried to [define](https://wgroeneveld.github.io/phd/src/definities/) the differences between "skill", "ability", "knowledge" and "competence". It took me more than a week and I gave up: every author gives his or hers own interpretation to these terms. 

Since my background is with Computer Science and I've been a software engineer for 11 years, I'd like to incorporate this experience into my future work by concretizing these vague "skills" into something that people from the engineering industry understand and can work with. In the end, I'll have to define my own interpretation of the words "lean skills". 

### Knowing what to work with

To be able to uniquely contribute to software engineering education research, I want to combine insights from multiple disciplines. I'm an avid philosophy and psychology reader and recognize the need for integration of certain key principles from these worlds into a more technical, engineering world. 

Let's try to create an overview of important work in each area that would translate well into engineering education:

#### Philosophy

1. _Self-cultivation_ (Bildung), Humboldt
2. _Virtues_ and _eudaimonia_, Aristotle
3. _Self-control_, Seneca and Aurelius
4. _How to live_, Montaigne (and others)

Avoid emphasis on Metaphysics and (pure) Ethics.

#### Psychology

1. _Grit_, Duckworth
2. _Flow_, Csikszentmihalyi
3. _Mindset_, Dweck
4. _Thinking, fast & Flow_, Kahneman

#### Software Engineering

1. _Software craftsmanship_, McBreen
2. _Lean software development_, Toyota Manufacturing
3. _Extreme Programming_, Beck
4. _PeopleWare_, DeMarco
5. _Pragmatic Thinking & Learning_, Hunt

Almost all works suffer from a number of problems:

* Too theoretical (e.g. Metaphysics, theoretical Computer Science)
* Too superficial (e.g. "The passionate programmer")
* Too vague (e.g. 95% of all academic papers?)
* Too much usage of buzz-words (e.g. "Management 3.0")
* Too little research-based (e.g. "Drive")
* ... 

It will be about finding the greatest common divisor and getting out of the way of vague or popular terms ("business"!). As you might have guessed, there are overlappings - the obvious one being _PeopleWare_ as part of engineering and social psychology. Of course, grit and flow are natural evolutions of philosophical insights. There is plenty of techincal work released in the software engineering world based on these insights, although that is not immediately clear. 

### A Practical Philosphy for Engineering Education

To be able to effectively master these "lean skills", principles from all worlds could be extracted and reformulated into a practical philosophy (course), geared towards (software) engineering students. 

This can be as technical as we want it to be. For example, take the excellent idea of studying [7 programmings languages in 7 weeks](https://pragprog.com/book/btlang/seven-languages-in-seven-weeks). To facilitate rapid learning that is required in a modern ever-changing software engineering world, requiring students to adapt to a new language every week would serve the purpose of building resilience to constant change. This exercise will be theoretically substantiated by drawing from philosophical and psychological research. Without this step, students would not have a firm understanding of [why this resilience is needed](post/teaching-philosophy-first/), and they will not be able to translate what they have learned into the real world after graduating. 

{{<mermaid>}}
graph LR;
    A(Philosophy)
    B(Psychology)
    C(Software Engineering)
    A --> C
    A -.-> B
    B --> C
{{< /mermaid >}}

I have yet to come across a good body of work emerged from within the Software Engineering world that successfully combines these ideas. Engineering research is typically very technical, and engineering education research as stated before either too vague or too pedagogical. Philosophy isn't exactly popular, especially among pragmatic engineers. University faculties do not usually work outside their own safe boundaries. 

That said, I'm actually still struggling how to integrate what I want to do with what I have to do. Scientific (educational) research needs to contain well-defined questions, substantiated by references to more existing research. It's very easy to fall into the "vagueness" trap, especially if your thesis subject is too broad. 

[^1]: Radermacher, Alex, and Gursimran Walia. "Gaps between industry expectations and the abilities of graduates." Proceeding of the 44th ACM technical symposium on Computer science education. ACM, 2013.
[^2]: Sedelmaier, Yvonne, and Dieter Landes. "Software engineering body of skills (SWEBOS)." Global Engineering Education Conference (EDUCON), 2014 IEEE. IEEE, 2014.
[^3]: Duckworth, Angela L., and David Scott Yeager. "Measurement matters: Assessing personal qualities other than cognitive ability for educational purposes." Educational Researcher 44.4 (2015): 237-251.