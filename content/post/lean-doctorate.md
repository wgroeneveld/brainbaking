---
title: The Lean Doctorate
date: '2018-10-19'
subtitle: Using agile practices to tacle a long-term research project
tags:
  - phd
  - tools
  - agile
published: true
---

At the start of my doctoral study, things are a bit _woozy_. The use of that word "bit" may be the inverse of exaggeration: shaping an abstract idea into a malleable and well-defined project is a process that can easily take up months. After that you still have to "start" actually doing stuff in context of your invented project! Most doctorates are classical examples of a **waterfall** process: come up with an abstract, do your (and a lot of) literature study, reach certain milestones. It's clearly visible in the [Arenberg Doctoral School Roadmap](https://set.kuleuven.be/phd/roadmap.htm).

As an _agile_ software engineer, that uncertainty leaves me with an unpleasant feeling as I struggle to define clear goals on a weekly basis. Sprints of 2 or 3 weeks are out of the question... Are they? Why should they be? A quick "_agile doctorate_" lookup in Google Scholar nets me academic papers like [An Agile Approach to the Doctoral Dissertation Process](http://csis.pace.edu/~ctappert/srd2015/2015PDF/d4.pdf) and [The Conclusion](http://csis.pace.edu/~ctappert/srd2016/2016PDF/a3.pdf). The only problem with these papers is that they propose to change the formula all together in an experimental context. There is - surprisingly - next to nothing academically published about someone's PhD process in an iterative or _agile_ way! 

### How to be an Agile Academic

Maybe we should ask [Jeff Sutherland](https://www.scrumalliance.org/community/profile/jsutherland) on how to achieve this, but I doubt the SCRUM Alliance principles were in his head when he did his dictorate. Katy Peplin wrote a nice article about [being an agile academic](https://www.katypeplin.com/blog/2017/10/25/be-an-agile-academic) that advocates for principles like getting feedback, fast(er) and using Test Driven Design. As some wise men once said,

> Fail fast, fail often. 

#### Early feedback

To fail means to get feedback. To get feedback means to **publish**. That's right, publish as early and as often as possible! But how can you publish papers when you haven't even started researching, let alone writing something useful yet? I'm not only talking about [lean publishing of academic papers](https://speakerdeck.com/jakevdp/in-defense-of-extreme-openness) (as Jake VanderPlas said _in defense of extreme openness_), but also about concepts. Anything you put on (virtual) paper can be used to get feedback. 

For example, Katy identified daily stand ups used in agile teams as a useful way to identify what was blocking her progress by doing a stand-up with... yourself! That way she got feedback from herself. A PhD can be a lonely process indeed, but it doesn't have to be that way. You can change that yourself by explicitly asking feedback to your peers, colleagues and friends. 

My way to get feedback is to follow in Jake's footsteps and to simply [publish **everything** on Github](wgroeneveld.github.io/phd). Add a big "feedback" button that redirects to the Github Issues page to invite people who come across your work to leave valuable insights. Why only publishing a paper, if you can publish everything related to your work, including papers? It contains reports of meetings, brainstorms, concept items I'm working on, definitions, bibliography, ... Literally everything. **Document everything** - a useful tip!

Another way to get feedback if you're developing is using your trusty Unit Tests and Continuous Integration system. As I'm not coding for my PhD, this might not apply, you might think. But actually, I can still take those concepts and try to apply them to my writing:

* Create separate pages for separate ideas/subjects. (Test Classes)
* First write down _what_ you're trying to write down. ("X in here", "WHEN I'm finished with this, X and Y SHOULD be defined here"). (Given, When, Then Test Cases)
* Then write, and rewrite, and rewrite. The expected outcome of that page might also change. 

Publishing these pages as a website using `Hugo` makes it very easy to share a link and ask someone for feedback. Of course, before simply pushing everything into the open, your supervisor (and possibly your Faculty) should agree with this. But after showing the advantages of being open, I'm sure that won't be a big problem. 

#### Planning

Another useful tip you hear often might be to "try to work on a weekly basis". They are talking about _planning_ your week. If planning a whole doctorate is too difficult (it is, and it's scope will change often) - simply plan each week. I use [Trello](https://trello.com/b/xbb3Wh56/phd-wouter) for that and you guessed it - it's open to the public. It's a bit more intricate than your average "todo - doing - done" list, but not by much:

1. Todo - backlog: anything in here. Things I will need to do in the next months - years. Very vague items. Might and probably will be split in multiple items. 
2. Todo - Week X [Deadline Y]: Something to work towards, for example a seminar you're attending or holding next month, or a brainstorm week you're holding with a research group where you can get feedback from your supervisor (or others).
3. Todo - Week X: the current week. What will you be doing this week? Try to be as descriptive and concrete as possible. 
4. Doing
5. Done: timestamped.

Apart from that, I'm relying on the following labels:

* Red: BLOCKED (no separate column, preserves the overview). You want as little as possible of those. Check on those daily!
* Green: WRITING
* Blue: LITERATURE STUDY (research from others to go through)
* Orange: FEEDBACK
* Yellow: DOCTORAL STUDY (classes to attend)
* Purple: ADMINISTRATION

### The _lean_ Tools used to battle with

Writing requires a... typewriter? Text editor? Sublime Text. Pushing to a github repository means we'll be using `git` and the command line (`iTerm`) a lot. I'm a big fan of Markdown thanks to small but great generators like `Hugo` used on this site. Instead of redirecting everyone to the Github repository homepage, I converted my PhD repository to a Hugo website and published it as a Github Page. That means written Markdown files are instantly and easily readable by a bigger audience and sharing the work through a website is a bit easier. 

Sublime works well in combination with Git and Markdown; especially with plugins like WordCount, MarkdownEditing, GitGutter, BracketHighlighter and Compare Side-By-Side. My choice for using Markdown instead of LaTeX might sound strange for academics, but Hugo's publishing skills are simply unmatched if you want feedback, fast. Things like Pandoc and AcademicMarkdown can be used to convert `.md` files to academic `.pdf` papers, like [Eric J. Ma](http://www.ericmjl.com/blog/2016/6/22/tooling-up-for-plain-text-academic-writing-in-markdown/) did. More on that later when I'm on the verge of actually publishing something in an academic journal. 

### Anything else? 

I'm sure my methods of bootstrapping my research can be further enhanced by people who've been through the whole process and are also agile advocates. If you think my work might benefit from some other tool or practice not mentioned here, please let me know by [adding an issue in the Github repo](https://github.com/wgroeneveld/phd/issues) as feedback. Every remark is greatly appreciated!  

In the meantime, take a second to skim through [my work so far](https://wgroeneveld.github.io/phd/). Thank you!
