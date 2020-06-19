---
title: "ITiCSE 2020: A Report"
date: '2020-06-22'
subtitle: "Findings from the first Virtual SIGCSE Conference"
tags:
  - conference
categories:
  - education
---

I was supposed to fly out to Norway - and then COVID came along and said "nope". Too bad, as the appealing photographs of Trondheim certainly made the [ITiCSE](http://iticse.acm.org) (_Innovation and Technology in Computer Science Education_) conference even more attracting this year. Instead, it took place on-line, using Zoom and Moodle as the tools of choice. I'd like to briefly summarize things that caught my attention. I haven't been able to watch all sessions and recorded presentations, but it's an interesting exercise to dump my own thoughts here. 

### A selection of papers

#### [Creative Choice in Fifth Grade Computing Curriculum](https://dl.acm.org/doi/pdf/10.1145/3341525.3387405)

_How do you engage younger students?_ The answer seems to be through _creativity_ - interesting, as we found similar things when [letting students program on the GBA](/sigcse). Naturally, as soon as the C-word is dropped, my interest is peaked. The authors talk about P-Creativity (Personal, the focus point) and H-Creativity (novel to humanity, impacting a much broader audience). 

> Do creative assignments effect student performance? No statistic relevance was found. 

Even without the statistic significance, and even with the focus on younger students, paper references could be interesting to check out for undergraduates ("_effective means of engaging various students_", "_champions of change_", and others)

#### [Examining student coding behavior](https://dl.acm.org/doi/pdf/10.1145/3341525.3387408)

This study was conducted in context of a creative computing course, in which expression is the main goal, not efficient coding or syntax knowledge. Lots of work like Abstract Syntax Trees and Vocabulary Analysis has been done in this one, and it got me wondering - we could do something similar (albeit much simpler) using Github commit logs as a base. I do have a few years of commit logs lying around from the GBA C++ course, maybe I already have interesting data. 

The question is then, what would I be looking for? This research tried to examine how students' work evolved over time. Maybe it would give us insight on the creative process of creating a game? Given the fact that not all students commit everything in a single hefty push with commit comment "_Work done! We rule!_"... 

#### [Top-down Design of a Curriculum for a Computer Games BA](https://dl.acm.org/doi/pdf/10.1145/3341525.3387378)

The paper contains an interesting discussion on the vote for C# instead of C++, as of course Unity always wins in educational contexts over the Unreal engine. However, what I found the most interesting, combined with words in the closing keynote, was perhaps the fact that there are so many distinct Computer Science-related degrees out there. 

A Computer Game BA is multi-disciplinary in nature: arts, design, programming, ... Our faculty of Engineering Technology delivers engineers who can specialize in Electronics/ICT. Then there's a more theoretical Computer Science degree, but in Leuven, you can also go for a Software Engineering approach without resorting to a bachelor of applied informatics. That begs the question:

> In any CS degree, is there enough space to learn something well? 

If you get to see a bit of game programming, a bit of AI, and a bit of design, are you a jack of all trades, or a jack of no trades at all? The same could be said for our own students, since the first year is shared across all engineering students, and packed with general courses (almost) devoid of computing...  

The more specialized - and complex - the Computing world gets (according to Matti Tedre, every decade), the more difficult it will be to deliver students capable of doing exactly whatever the industry requires. Instead, I think we should focus on abstract thinking skills, and use Capita Selecta to let them have a taste of the possiblities. In the closing keynote, Matti anecdotally brings up old ACM SIGCSE Bulletins, concluding that the discussions we're having today in CSEd are still the same discussions almost 40 years ago:

- What should we teach students?
- Which programming language is better to learn than others?

That keynote was awesome, not only because of the contents, but also because of the 'augmented reality'-enabled joke:

![](../augmented.jpg "Matti's Augmented Reality slides")

At least we got the feeling of looking at it from an audience. 

#### [A feedback-oriented platform for programming practice](https://dl.acm.org/doi/pdf/10.1145/3341525.3393996)

An interesting tool developed at Los Andes in Colombia to cope with submissions of 900+ students and deliver a deliberate practice platform that can scale up when needed. I'm drawn to this because of the use of Docker and the philosophy of automation. However, I can't help but wonder:

> Why does everybody have to keep on reinventing the wheel?

There are so many tools out there, including this one, that has not been tailored for usage outside of the context. It's a "_scratch your own itch_" project, which is great, but when a paper like this gets accepted, it suddenly stands in the spotlight, potentially becoming of use for other universities. And that ultimately rarely happens. There are exceptions, where it's well-marketed and matured, like BlueJ for instance.

I've come across papers before that employed a home-brewed piece of technology for their method that I wanted to use too, but was out of luck because I could not find a download link or more info. Simply making these things a bit more visible on the Internet would do wonders. I wonder why more people in the industry are automatically - and intentionally - giving back to the community, compared to people in academia. That might be a bold (and possibly wrong) statement; it's a gut feeling. 

Same feeling with the [Postponing the Concept of Class When Introducing OOP](https://dl.acm.org/doi/pdf/10.1145/3341525.3387369) paper: why invent a prototype-based language (Wolluk) instead of reusing Javascript? That almost seems ridiculous considering graduates will have to learn JS anyway!

#### [Twenty-Four Years of ITiCSE Authors](https://dl.acm.org/doi/pdf/10.1145/3341525.3387387)

A _bibliometric_ paper - another new term I've learned - concerned the last 24 years of published papers at ITiCSE by Simon. Why is this interesting? Because it's a big **wake-up call for Belgium**! ITiCSE is the highest-rated European conference on Computing Education, and we're one of the worst scoring countries:

![Number of papers, including fractional contributions, from each country](../countries-iticse.jpg)

That means Belgium submitted **two papers** in the last twenty-four years to a highly rated computing education conference. Two. 2. Can you believe that? Looking at our neighbors: Netherlands 21, Germany 55, France 16. _Whoops_. I could go ahead and look up the data for the SIGCSE Technical Symposium, but I'm pretty sure things are even worse there as it's generally regarded as a USA-heavy conference (and they are planning to do something about that).

At least the year `2020` proved to be an exception: my supervisor Joost and I both published a paper, cranking up the number to a whopping four, thereby leaving Cyrpus and Romania behind - given they did not publish anything this year.

It's very sad to see that Computing Education has not been recognized as a true discipline in Belgium. At my university, we have a small research group dedicated to that (OVI), but compared to [other KU Leuven CS research groups](https://wms.cs.kuleuven.be/cs/onderzoek), it could almost be called redundant. That said, if it were not for CSEd, other CS disciplines would not be academic disciplines right now... It's about time somebody rings the bell! 

To again quote Matti Tedre's amazing closing keynote:

> When it comes to pioneers in computing... most of them are also educators. 

### The transition from face-to-face to virtual

I'll sum it up with a screenshot:

![zoom](../zoom.jpg)

Yeah. Zoom connection issues, especially when presenters switched. It wasn't bad but I did experience this multiple times. Having to navigate in-between sessions was especially confusing, hopping back and forth between Moodle and Zoom. There was no central hub available (besides the somewhat clumsy Moodle), meaning these things were not possible:

- Chatting with a specific person without contacting them via Moodle
- Having persistent chat and Q&A text. 
- Looking around and seeing who's attending in Zoom Webinars. What's up with that? I had the feeling like I was watching alone... 
- When a session ended, 'returning somewhere' for a chat.

It was okay for a first attempt, but to be honest, using a more community-based hub such as Slack or Discord instead of having to go to Moodle would certainly make it easier to get the 'conference-vibe'. Remember mIRC back in the day? If you joined a channel, you could see stuff happening. Now, I couldn't. 

The organization did their best, I think partly participants (like myself) are to blame: 300+ registered, barely anything moving on the forums. How is that possible? A lot of open sessions and poster sessions were empty: authors waiting for questions that never came. Of course in a digital world it's easier to get distracted or to quietly slip off to do something else.

### Closing thoughts

Do not mention "computational thinking" in ACM conferences. I seemed to unleash quite a chain of reactions in the open discussion talks doing that - it should be called "_algorithmic thinking_" now? I don't get why that would make things clear. It's as vague as the first term, you just sidestepped the 30 or so definitions already present in literature, congrats. 

Another just as vague concept: using [notational machines](https://www.felienne.com/archives/6375) in teaching. I'm still trying to wrap my mind on the concept - the paper that tried to clear things up was not particularly helpful... To be honest, I think a bit of industry-experience I carry around, also called _pragmatism_, would do wonders here. Insert random [Too Far Gif](https://tenor.com/view/the-office-steve-carell-michael-scott-too-far-road-trip-problems-gif-4412706) here:

![took it too far](../toofar.gif)

Another interesting discussion on why we should stop teaching low level concepts (programming) compared to other fields took place in the closing keynote. According to Matti:

> Programming is a really clumsy way to interact with a computer.

It's apparently something from the eighties. We need that less and less. It's needed more rarely for making the computer do the kinds of jobs you want the computer to do. He doesn't see why we should stick to that clumsy way when we already have different means of controlling it.  In the end, "_we want to teach kids how to control the machines_". 

As complexity slowly but steadily grows, it will be really interesting to see what the computer science (education) field will look like in a few decades... 

Things I still need to plow through:

- [Emergence of computing education as a research discipline](https://aaltodoc.aalto.fi/handle/123456789/18195) - Simon's PhD thesis
- [What is computing education research?](https://gist.github.com/amyjko/689837b8eefccb3a8a28ff0aa5300615) Amy J. Ko's notes
- [The Computer Boys Take Over](https://www.goodreads.com/book/show/9247209-the-computer-boys-take-over) - a book about the computer revolution of the mid-twentieth century
