---
title: 'Teaching by philosophy'
date: '2018-05-31'
subtitle: On explaining the why before the how
tags:
- teaching
- philosophy
published: true
aliases: ["/post/teaching-by-philosophy"]
---

Also worth reading: [reverse engineering a curriculum](/post/reverse-engineering-a-curriculum/).

**Awareness**, that's the keyword I'm looking for here. 

Students are required to slog through a lot of classes during their university years. You pick a major, computer science, and you start learning things like algorithms, data structures, compilers, operating systems, and more abstract (maybe even worse) things like mathematics, geometry and logic. You of course accept those separate subjects as a part of the computer science major - there's little other choice. Professors do their best at throwing random theories at you while you do your best at catching them - and possibly letting them go after passing the exam. 

### The problem

But nobody ever tells you why you need to learn mathematics, geometry and logic. You implicitly know algorithms, data structures and compilers are part of "computer science" and there are overlapping pieces of knowledge to be learned. For instance, the first year you'd need to learn a _syntax_ to express those algorithms in. Probably Java. But why would you need to learn the same amount of proofs that mathematics majors need to learn? All subjects are intertwined but you don't know how. And nobody seems to care. 

A more concrete example. I teach "software design in Java", an introductory course in **software design** using **Java** as a syntax. We need something to express yourselves in and that's not going to be Dutch or English. But since for most students it's also their first time with Java, the "design" part rapidly succumbs to heavyweight syntax lifting in Java: brackets here, generics there, libraries and imports everywhere. Students simply call this course "Java". Uh, wait...

The "software design in" part seems to have been be completely dropped. Whoops! Did you as a teacher maybe intend to learn them something else except

```java
List<string> stuff = new ArrayList<>(); // don't forget ;
```

? Didn't think so. 

### The solution

#### 1. The graduate school solution: drop concepts

A short sighted solution would be to rename the course.

> Software design in Java -> **Java**

Skip the design, that's something students will pick up during classwork, their thesis or after school. It'll even depend on the firm they will land in so why bother. Just fit them with enough syntax knowledge that is not translatable to another language (because we dropped the concept!). That would require the language to be stable and growing. 

And that would require the school to be ever vigilant of "hot new fuzz" from the IT world so the course "Java" could be redone in "TypeScript" or even "Solidity". 

#### 2. The university school solution: drop implementation

A short sighted solution would be to rename the course.

> Software design in Java > **Software design**

Skip (emphasis on) the syntax, that's something students will pick up during classwork, their thesis or after school. It'll even depend on the firm they will land in so why bother. Just fit them with enough conceptual knowledge that is applicable in any language (but you'd have to get your hands dirty first!). 

Did you see what I did there? 

#### 3. My solution: **use philosophy**!

Instead of immediately focusing on how to write example x or y in Java, instead focus on **why** you're teaching this course. Focus on why "software design" is prepended in the course title, but still followed by "in Java". I had no clue that by learning (let's call it following a course instead) mathematics, I was actually learning how to use lemma's (something you know works) to deduct another truth (something you're trying to aim at). If the professor explained why math is important to computer science students (pick a concept and apply it somewhere else) and how it fits into my education, I would no doubt have paid more attention.

Therefore, every single practical lab should:

1. [Start with why](https://startwithwhy.com/)
2. Followed with practical examples using syntax as a means to an end

Simply translating "MVC" into "Model-View-Controller" would not suffice. Why would you want to separate these concepts? What is each concept? **Show them**. And then, show them the syntax. But since students sleep during the theory (the explaining part) and struggle during the labs (the practical part), you have to be very, very consistent with this message. Repeat it every single time a lesson starts. 

Otherwise "Software design in Java" will inevitably degrade into "Java". 

That is why [thinking in terms of objects using natural language](/post/thinking-in-terms-of-objects/) is so important to me. The most important exercise in the design course contains almost zero syntax difficulty, but since later exercises require more Java knowledge like threading and JavaFX, they seem to be of higher importance. 

One could say: "I don't really know what threads are doing in such a course!" and I would heartily agree with you. But unfortunately, sometimes at schools subject matter is jammed together within one course because of .... (fill in: time constraints, political issues, lack of consultation with professors)
