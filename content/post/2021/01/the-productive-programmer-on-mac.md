---
title: "The Productive Programmer on Mac"
subtitle: "A tribute to the ideas of Neal Ford"
date: 2021-01-13
tags:
  - productivity
categories:
  - programming
---

In 2010, I attended a [Devoxx Conference](https://devoxx.be/) talk by Neal Ford called _"Productive Programming"_. Of course, I also bought the [accompanying book](https://www.goodreads.com/book/show/3411606-the-productive-programmer?from_search=true&from_srp=true&qid=JyUZOnUvOl&rank=1), published in 2008. Eleven years ago, I also gained interest in [self-improvement](/tags/self-improvement/). Therefore, any sort of productivity tip was welcomed with open arms. I think/hope Neal converted many non-believers that day. It even gave me ideas to do a talk myself - which I did in the following year. It is a lot of fun to rummage through old notebooks as [I'm digitizing these](/post/2021/01/digitizing-journals-using-devonthink/), to see which ideas from others got my own ideas flowing. Here is the proof:

![](../devoxx-note.jpg "Page 19 of my first 'real' journal ever.")

Back to _The Productive Programmer_. Neal Ford's premise was simple: you're a programmer, so use your PC as productive as you can. You're stuck behind the desk for eight hours a day anyway! While that idea wasn't exactly mind-blowing, the fact that so many people - colleagues - I knew still could not touch type, let alone consistently use shortkeys to refactor pieces of code, was baffling to me. So I decided to go all in and hopefully impress a few others on the way. Not to boast my ego, but to inspire others. 

A Productive Programmer knows the _mechanics_ of productivity, and he has gained enough experience through _practice_ to seize opportunities to further improve things. In the light of my [new M1 MacBook Air](/post/2020/12/developing-on-apple-m1-silicon/), let us take a look at what that entails for a Mac user. The book might propose many tools that aren't relevant anymore, but the underlying concepts remain significant. I hope this will inspire students and smart people that recently joined the Mac club to pay attention to what they're doing. Always ask yourself: am I doing this a lot? Can this be done quicker?

## A. Mechanics

A quote from the book that resonated with me:

> Spend a little time each day to make every day more productive. <span>Neal Ford</span>

### 1. Acceleration

![](../icon-iterm.png#right)

_Don't type the same commands again and again_. Find something to do the work for you. Neal suggests to use things that _remember history_: clipboard extenders, history keepers that can be automatically recalled, command prompt plug-ins, and so forth. These things seem so mundane and obvious nowadays. Yet, who knows every [obscure feature](https://iterm2.com/features.html) of their [Zsh](https://www.zsh.org/)-powered [iTerm2](https://iterm2.com/)? A few I just learned yesterday:

- `⌘+;` to auto-complete anything from history. I usually resort to Zsh's smart history.
- `⌥+SPACE` is my iTerm hotkey, an overlay window that appears out of nowhere. Always access to the command line!
- In combination with Alfred: `⌘+SPACE`, `>` to quickly output anything to cmd.

Things like a built-in password manager, badges, image integration and clipboard managing are less useful for me, since I use other tools that work outside of a shell. I'm still discovering new features and it's impossible to list them all here. 

![](../icon-alfred.png#right)

Another saying: _search trumps navigation_. Don't use Finder to click through all directories if you know what you're looking for: let the tools do the work for you. Remember Google's clean and simple search UI? There's one single input box: type and thou shall find. I cannot recount the number of times I've pressed `CTRL+SHIFT+T` in Eclipse in my life, or `⌘+O` in IntelliJ. Why limiting yourself to only use these search tools inside a specific code editor, when you can have it across your Mac?

That's right, I'm not talking about Spotlight but about [Alfred](https://www.alfredapp.com/) that hijacked Spotlight's `⌘+SPACE` shortcut on my laptop. I've never given it much thought until yesterday, but that small application might just as well be the best productivity boosting tool I've used in years. The possibilities with Alfred are endless. Things I use:

- The clipboard history. Bye bye, Clipy - we've had a good run!
- Custom web searches: `gr` for a quick Goodreads lookup, `sc` for Google Scholar, `yt` for YouTube, ... Remember the coolness of these quick searches in your shiny Google Chrome browser back in 2013? Well... 
- Snippets. Typing `bbblog` (Brain Baking Blog) _anywhere_ pastes a Markdown snippet to start writing a new blog article, including my pre-set front matter and filled in date. 
- Workflows. Oh boy, where to begin?
    + `tr` to quickly translate from Dutch to English when I'm writing a paper ([alfred-google-translate](https://github.com/xfslove/alfred-google-translate)).
    + `pows` to quickly find a synonym using the Power Thesaurus when I'm writing a paper ([alfred-powerthesaurus](https://github.com/clarencecastillo/alfred-powerthesaurus)).
    + `mdn` or `vue` to quickly find developer documentation of a JavaScript method in MDN or the VueJS docs. There are countless workflows like these!
    + `dnt` to quickly look up something in DEVONthink.

You might have noticed the increased usage of the word _quickly_. I have the feeling that I only barely scratched the surface of Alfred. Oh, and it's _faster_ than Spotlight, even for bootstrapping basic applications.

![](../alfred-demo.gif "Accelerate your Workflow. From the alfred-powerthesaurus repo.")

### 2. Focus

> The higher level of concentration, the denser the ideas. <span>Neal Ford</span>

This section of the book is a toned-down version of Cal Newport's [Deep Work](https://www.goodreads.com/book/show/25744928-deep-work?from_search=true&from_srp=true&qid=sGwpE3mzlh&rank=1). He shows that tools like TeakUI for Windows XP (Hah! Remember that?) can de-clutter your Windows setup, creating more room in your head for actual ideas. Use virtual desktops, use _Distraction Free Modes_, such as Sublime Text's `⇧+⌘+⌥+F`.

An ex-colleague of mine used the Pomodoro technique and installed a small application that reminds him when to take a break and when to push on. Of course, you could track all these things and have it draw fancy graphs for you to marvel at (how bad you did that day). There is a plethora of apps for this at your disposal, but I personally never used any. 

### 3. Automation

> Don't Repeat Yourself (DRY)!<span>Neal Ford</span>

_"Can I script that?"_ should be the first thing that springs into your mind when you're doing something for the second time. Use [IFTTT](https://ifttt.com/), automate RSS filtering (or let Feedly do this for you). However, don't make the mistake of reinventing the wheel!

Another thing Neal was advocating for: use a _real_ programming language when scripting. You never know when that _jig_ will turn out to be a permanent part of your development cycle. If that is the case, it will get expanded. If that is the case, it better damn well be easily unit-testable!

![](../icon-firefox.png#right)

In 2010, Selenium and WebDriver was thé tool to automate your browser, and to write acceptance tests with. Nowadays, we have [Cypress](https://www.cypress.io/) and others that are gaining popularity. One thing that struck me in that Devoxx presentation was, why limit the usage of these tools to your workday? They can also be useful to automate mundane things such as form completions - outside of the enterprise application you're working on. [Tampermonkey](https://www.tampermonkey.net/scripts.php) and [MonkeyScripts](https://monkeyscripts.org/) also fall into this category. Think about it - how many hours a day do you spend on a computer? I bet 80% of that time, you have at least one tab open in a browser, looking for something (shady?). Do not overlook your browser habits when thinking about automation. 

### 4. Canonicality

Don't throw away binaries: (automatically) archive artifacts instead. Leverage continuous integration and deployment techniques, and device principles when thinking about your own workflow. Use virtualization, also back up your _configuration_: config is code! 

To me, not only configuration, but also _documentation_ is code:

> Out-of-date documentation is worse than none because it is actively misleading.<span>Neal Ford</span>

This is the single best reason to completely ditch (manually adding) Javadoc. Use tools like [Swagger](https://swagger.io/) to create and automatically maintain your API documentation. Am I boring you by repeating words like _auto_? 

## B. Practice: your Editor

_Learn to get to know your tools._ Do not just "use" them - understand them, click through all menus, write down the shortcuts, and try to learn one (of an action you of course actually use) very day. This isn't limited to just your (code) editor! 

![](../icon-sublime.png#right)

Talking about editors: pick one and dive deep - it's as simple as that. Editors come and go, but Vi and Emacs will probably stay forever, so both are a solid choice - if you can muster chewing through thick guides and a _very_ steep learning curve. In 2012, I gave up on Vi (sorry, I'm a softie) and bought Sublime Text together with my first MacBook - probably the best decisions I've made that year. Funnily enough, eight years later, I'm still learning new Sublime tricks. Admittedly, it takes a lot of effort to deliberately learn new things when actually you want to concentrate at the task at hand. A few recent things I've learned:

- `⌘+B` to build a Markdown file using Pandoc and a custom Makefile. 
- `^+⌘+T` as a custom shortcut that opens a new tab in the current path using the Terminus plugin. Thanks, [OdatNurd](https://www.youtube.com/watch?v=mV0ghkMwTQc)!
- `⌘+R` (Go To Resource) also works with [MarkdownEditing](https://github.com/SublimeText-Markdown/MarkdownEditing) and allows you to quickly jump to certain sections in your paper text.
- `⌥+⌘+V` in MarkdownEditing auto-creates a `[](link-from-clipboard)` nippet.
- There are also snippets in here, although I use Alfred for that. 

And of course, the well-known  `⇧+⌘+P` Command Palette that seems to be commonplace now - great! I also try to remap keys in other tools to resemble the ones I know by heart. This means less confusing and learning, and more time to focus on content.

Although I really, really, should take more time to thoroughly learn Sublime! 

