---
title: 'Programming: a Creative Cognitive Process'
date: '2019-10-08'
bigimg: /img/glasses.jpg
subtitle: Mapping creativity models to software development
tags:
  - creativity
  - phd
published: true
---

My [previous](https://people.cs.kuleuven.be/~wouter.groeneveld/slr/) [studies](https://people.cs.kuleuven.be/~wouter.groeneveld/delphi/) investigated which non-technical skills are currently being taught in software engineering education, and which are perceived as needed to excel in the industry. We found creativity to be one of the key skills that still seemed to be mostly ignored in higher education (at least in Computing). The term 'creativity' is highly subjective, contextual, and vaguely defined (or not at all), so connecting the dots proves to be quite a challenge. 

Software development _is_ creating a software product, line by line. Therefore, software development is seen as one of the most creative endeavors people can embark in. There are no restrictions on physical laws, only the boundaries of your own imagination. And of course processing speed, Amazon Cloud costs, the willingness of others to collaborate, and so forth. But the given flexibility of software engineering is unique compared to other engineering disciplines. In civil engineering, you do not refactor a bridge in a few days, or adjust the angle of suspension hooks in mere seconds after a failing test. Of course, the heavy emphasis on theory and prototyping should help in avoiding these kinds of mistakes, but the point is: we software developers love making them. 

In fact, I think we are in love with failure. 

If you cannot fail, you cannot learn. And since failure is so easy (and hopefully fixing mistakes is also easy!), developers should love learning. The fact that the software world is ever-evolving does not make things easier. Since we are ever-creating, even in operation modus, the question is: how does creating, or rather _creativity_, work - applied to the field of software engineering? There is a lot of research on creativity in the field of (cognitive) psychology, resulting in a plethora of theoretical models, of which a few are easily transferable across domains. 

One of those models is Amabile's Componential Model of Creativity[^ama] ([img src](https://www.slideshare.net/medikawy_2005/how-to-kill-creativity-in-your-organization/14-knowledgeexibility_imaginationintrinsic_extrinsicThe_threecomponentsof_Creativityexpertisemotivationcreativethinkingskillswhere)):

<center>
    ![creativit model](/img/creativitymodel.jpg)
</center>

As deceptively simple as this looks, let us zoom in on each component and try to map these to the field of software development.

### The Three Components of Creativity

#### a. Expertise Component

An 'expert' knows things a junior does not. By knowing, we are talking about several major parts:

1. **Technical knowledge**, (`33%`) such as:
  - Programming Languages
  - (Enterprise) Patterns
  - Principles such as Unit Testing
  - Tooling, IDEs, shortcuts, ... 
2. **Domain knowledge**, such as:
  - Product-specific functional information
  - Diverse experience (combined with tech. knowledge, `18%`)
3. **Brilliance**: general intelligence (`13%`)
4. **Naivety**: 'fresh'/new to the problem at hand (`13%`)

Knowing what an Observer pattern is also implies you have the capability to apply it to a given problem. These expertise parts reside in the yellow image, typically not overlapping other components. To be able to speak the language, one has first to learn the language. To learn anything, a certain degree of intelligence is required. 

#### b. Motivational Component

A lack of motivation can be devastating to your mood and your willingness to solve things in the first place. The motivational component contains several layers of philosophical and psychological roots, not limited to simply intrinsic VS extrinsic motivation. This component is not specific too software development and very hard to foster within others (typically it is not sufficient to waive with green paper containing dollar sings...). `40%` is related to self-motivation.

Motivation (and to a certain extend, the other components as well) is also influenced by an invisible component, namely **environment**. This could be the company culture you're working in, the mood of your colleagues, or family and friends. `30%` is related to the qualities of the group you are in, while `17%` is related to social skills. 

#### c. Creative Thinking Skills Component

This is the most interesting component in my opinion, and also the most severely lacking for a lot of developers. Even if your expertise component is full of technical information, it is not worth anything if you do not know how to combine these using techniques called '_creative thinking skills_'. These skills allow you to successfully combine your expertise to hopefully create something new and novel (the classic definition of creativity). 

Typical creative skills are idea generation techniques such as _brainstorming_. However, according to Amabile[^ama], this component contains `41%` personality (persistence, curiosity, energy), and `38%` special cognitive abilities (described as 'special talents in problem solving'). Changing your personality is more challenging than learning 'special talents'. A. Miller identified cognitive processes associated with creativity, of which these six are the most interesting to look at from our perspective [^mill]:

> ##### 1. _Perspective Taking_: Looking at a problem from different angles

A classic theoretical example is applying the first step in the computational thinking process by reducing concrete problems (e.g. four colors) into it's abstract counterpart (bintrees, graphs). 

A more concrete example could be the following. You are responsible for implementing the generation of certain documents, which employees need to sign (interact with). Since you are used to think in terms of employers, you create a 'generate' button for employers to click on, which will then send the documents to the employee. However, halfway through a colleague stops you and says 'wait, let us _look at the bigger picture_ here. Is this the right location for the button? Why not let employees pull the documents instead of pushing? We already have such a system, let us find out.' You both get up and walk to the domain model poster to re-evaluate what should be done.

> ##### 2. _Imagery_: Imagining potential solutions to explore the potential

For example, you are creating an API that will be used by other pieces of software within the company. You imagine it could be a simple HTTP POST. But as soon as you do that, you remember that hosting it will prove to be a challenge, and blocking unwanted calls or an overload of them will also cause problems. Then you imagine a service bus could work. Other endpoints could also hook into that. It would be easier to maintain. 

> ##### 3. _Idea generation_: Generate multiple solutions for a given problem

This one is quite straightforward. 'Okay, we need to query the customer DB for unknown addresses, but the table is huge. What options do we have?' Take out a pencil and write down everything you can come up with. Cache the results after a first run? Create an index? Or cache customer related info at bootstrap? Create a cleanup script to run nightly? ... Of course you are drawing on your expertise component here!

The '_five why's_' could also fall within this category, generating different ideas and drilling down until you find the 'root cause' of the problem. It could also be part of no. 4.

> ##### 4. _Metaphorical/Analogical Thinking_ 

**Connecting the current problem with related ones**:

'So we need to create yet another GET service that queries our DB. Wait, _haven't we done this before?_' Taking a look at previous problems and trying to relate it to your current one can yield interesting results, such as reworking the previous one to better fit your current one, or simply using methods/services/... from another problem that you could not come up with on your own.

Over-familiarization is a well-known trap here. The adept you are at something, the less likely you will look at it differently and the more you will connect your problem with previously solved ones. In the end, everything will be done the same way, without experimenting with different approaches.

**Use previously used solutions in a new way**: 

Suppose you're really good at Java and you take on a new job as a C# developer. Congrats. Let's create an `enum`:

```C#
enum EmployeeDocumentState {
    GENERATING,
    GENERATED,
    UPLOADED,
    SIGNED,
    REJECTED
}
```

Now let us write some domain-driven code. We need a `CanEmployeeInteractWith()` method that, depending on certain states, decides if an employee can do things with the document. Whoops. No can do: an `enum` in C# is essentially an `int`, inherited from C. In Java, you can write methods on them. Static extensions to the rescue:

```C#
static class EmployeeDocumentStateExtensions {
    public static bool CanEmployeeInteractWith(this EmployeeDocumentState state) {
        // ...
    }
}

var state = EmployeeDocumentState.SIGNED;
if(state.CanEmployeeInteractWith()) {   // yes!
    button.enable();
}
```

In essence, you are drawing on your Java knowledge to enhance your C# code. You could also enhance C `struct`s with function pointers to emulate objects. 

**Combining dissimilar concepts into a new idea**: 

Drawing from information from outside your own domain could also be useful and generate inventive solutions. In fact that is how Velcro got invented: by studying the abilities of insects to climb walls and 'stick' to material. 

In Linguistic Creativity, creative patterns are hypothesized to be part of two categories: pattern-forming (following the rules of the language, creating interactions/repetitions) and pattern-reforming (breaking the rules and reshaping it into something new). 

<center>
  ![Creative Patterns](/img/creativepatterns.jpg)
  Creative Patterns?
</center>

> ##### 5. _Incubation_ (letting 'the idea ripen' for a while)

Cognitive processes could be grouped into **intuitive** and **deliberate** processes. Intuitive processes will be very familiar with you. Taking a break from deciphering the problem, for instance, and going for a walk, or implicitly holding off on evaluating your own ideas. Good ideas are like good wine: the longer they ripe, the better they become. 

But in the end, your boss expects you to implement that piece of functionality, not to wait for ages until it 'gets better'... 

> ##### 6. _Flow_ (automatic, effortless, state-of-mind)

During interviews conducted by A. Miller, people frequently mentioned that they 'get ideas when relaxed'. What they are referring to is the state of _flow_ in which everything seemingly is done without any effort. A lot of psychological research has been dedicated to this topic, and it is a bit less interesting compared to other cognitive processes because it is very hard to pinpoint. 

### But what about Creative Problem Solving? 

There is some confusion in literature regarding terms such as creative thinking, creative problem solving, and creative coding. To be honest, none of these fit well within the 'creative thinking skills' component, at least in my mind. 

**_Creative Coding_** is an unfortunate term that has nothing to do with problem solving. What? Indeed. Creative coding is a recent phenomenon in which the emphasis is on _artful_ creating, where expression is more relevant than solving things. You use code to express yourself, generating digital graphical 'art', using programming languages and tools such as [ProcessingJS](https://processing.org).  Students following a creative coding course are encouraged to talk to people outside of their faculty and to experiment with different digital 'materials' (code, languages, visualizations). Creativity is also not assessed as such. It's what would happen if Van Gogh would have access to the V8 engine. \\
It has yet to be investigated whether the teaching of artful creative coding will actually enhance practical creative skills. 

**_Creative Computing_** (or _Computational Creativity_) aims to simulate creativity using Artificial Intelligence, rather than stimulating it within the humans that are doing all the programming work. It could require creativity to write algorithms that show 'creative' skills, but the emphasis is on the mechanical part of creativity. AI that creates music or art falls within this category. 

**_Creative Problem Solving_** on the other hand does put emphasis on problem solving, but in an inventive way. That is, it uses a model to help you overcome a problem or invent a new product. It's steps are Clarify (1), Ideate (2), Develop (3), and Implement (4). During each of these steps you will be needing different components of Amabile's model. **CDIO** (Conceive, Develop, Implement, Operate) has the same approach. CDIO was invented at MIT to make engineering students more like real-life engineers.

**_Theory of Inventive Problem Solving_** (TRIZ) is a Russian problem-solving, analysis and forecasting framework derived from studying inventions. In my opinion, it has little to do with creativity, as you are instructed to follow a complex matrix based on previous inventions and patents, and it is very much geared towards physical engineering. 


### To Conclude...

People are not born creative. It takes a lot of hard work, on both the knowledge (expertise in area/domain, creativity skills) and personal skills (self-motivation, brilliance, personality) sides. Our intention is to enhance higher education with the teaching of concrete creativity skills while using programming to tackle a problem. For that the identification of these cognitive processes need to be fleshed out. It also begs the question: how can we evaluate these? I'll have to let this idea mature for a while...  

[^ama]: Amabile, Teresa M. "Componential theory of creativity." Harvard Business School 12.96 (2012): 1-10.

[^mill]: Miller, Angie L. "A self-report measure of cognitive processes associated with creativity." Creativity Research Journal 26.2 (2014): 203-218.
