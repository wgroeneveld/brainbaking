---
title: "Five reasons why agile and academia don't go together"
date: '2020-02-25'
subtitle: "Iterative methods in the academic world? Nope."
aliases:
    - /post/agile-academia/
tags:
  - agile
  - development
categories:
  - education
published: true
---

I wish the word _"don't"_ in the title of this post could go away, but after years of trying, I have to say it cannot. There are so many aspects of the academic world that speak against agility that I had to make the conscious choice to reduce the list to five big reasons why I think both do not converge well. Remember that this is my own subjective opinion, and perhaps also meant to utter some well-meant critique, but by no means a one-sided rant: I have spent rather large parts of my career on both sides. 

The word _"agile"_ can also be understood as **fast feedback**. That is my sole indicator for success in an agile world: the _demo or die_ principle, iterative development, a possible fast changing scope, ... - these concepts all have one thing in common: the principle of fast feedback. The following reasons all lack this, each with it's own reason, therefore each contributing to why agile and academia do not work together. 

## 1. The Paper Peer Review Process

### Code Reviews should not exist

Peer reviewing is a great concept that in theory should eliminate too much bias and variance, and in practice mostly manages to do just that. The better part of software development is the code (peer) review system, where colleague developers carefully review code written by their peers. The intention is to:

1. Provide useful feedback for the developer to _learn_ from
2. Increase the (code) quality of the developed product in general
3. Provide useful feedback for the reviewer him-herself

Code reviews should happen as soon as a single piece of functionality (or even a sub-part of that) is finished, in practice when a post-it note moves on the Kanban/Scrumboard to the column 'toreview'. This happens between 1 and 5 days, depending on the depth of the functional part. 

The problem is, that is _too late_. Yes, you've read that right: code reviews mostly happen too late! Frequent code reviews with lots of changes are usually red lights, indicating a major problem in the team: too little people are up-to-date on an API, conventions, standards, and so on. Remember that x days have passed, and you should go back to square one. In reality, that never happens.

_Great_ teams tackle this issue by:

1. Pair programming.
2. Frequent (ad-hoc) 'sparring' sessions, asking feedback earlier.

If everybody is pairing, code reviews are obsolete. As soon as someone writes a line of code, it's reviewed. No more eyes are needed, since the team is usually on the same line anyway - and if that is not the case, you should switch pairs more often. Hence, **Code reviews should not exist**. 

### What about Paper Reviews?

Writing a paper takes between 8 weeks and more than a year, including gathering ideas, the collection of the data, and so forth. A paper is the result of a project, let's call it the **product** to be placed in production while we're at a software development comparison anyway. So no code reviews (well, barely, from internal colleagues) of small parts happened. 

After paper submission, you usually have to wait one to three months for the conference/journal to hear a verdict. Meanwhile, a small task-force of reviewers has been assembled to read 4 to 20 papers for a given conference, and of course to provide that valued feedback. What happens? Reviewers give feedback on all sorts of things:

- On the syntax and layout of the paper
- On the study setup and results
- On the lack of references

Most of that feedback is (1) _useless_, and (2) happens way _too late_. The last conference I reviewed for, another (anonymous, luckily) reviewer commented on a certain paper that the study is done all wrong and that he or she would have liked it seen like this or like that. Let's try to link that back to software development: that's like saying the program does not fulfill the needs of the client, the database structure is set up all wrong and a critical part of the interface is missing. 

I am not saying that reviewer acted too harsh or it was stupid to give that kind of feedback. I am saying it happened way too late: for the researchers, the research setup has been done possibly more than a year ago. Where were they then? That kind of one-time feedback at the end of the cycle is usually not taken into account at all: instead, most researchers simply submit their work somewhere else. There, done. 

In the current paper acceptance system, there is simply no room for _fast feedback_. Everybody is very busy working on their own studies, I am sure, but that does not mean in-between feedback cycles are simply impossible to do. As a concerned researcher, you can try to counter this weakness by asking feedback from your research group. Good idea, but with very little reaction: they're all 'too busy' doing what they are doing. Why is this not a problem in software development? Because the review system is **built into the very culture**. 

## 2. The PhD System

By now you might have guessed where I am going with this. A PhD usually takes four years, and of course there is plenty of room for feedback before the final PhD defense. However, in practice, these moments happen infrequent and again, still too late. 

### Demo (or do not die)

Professors, as supervisors, hopefully, arrange frequent meetings with their PhD students to track the progress and to allow for a feedback moment. However, this is still not considered a standard practice and greatly varies depending on your supervisor. I know people who see and talk to their supervisor at most four times a year. Luckily, for me, we try (and sometimes fail) to keep on a steady cadence of once-a-month meetings for both supervisors. 

The problem is, again, that this is way _too late_. In one month, in a software development world, you should have passed a whole iteration, getting daily feedback from the 'development cycle' (provided all goes according to plan). So, you could compare these gatherings with the demo's that are usually organized after each iteration. Indeed a valuable way to get some feedback.

But that feedback moment is short, and a lot of things should be done by then, sometimes putting research back to square one, while earlier feedback would have prevented that. I would love to see a solution similar to the one applied in the industry: pair PhDs, like pair programming. It would certainly also fix the loneliness problem. 

### Overburdening 

Trying to pin down monthly meetings is a pain though: supervisors are usually extremely busy. Professors are burdened with education assignments, they need to search and hopefully find enough funding for research, and in-between they also need to translate knowledge into socially relevant and digestible material. Since there is usually a (big) shortage on academic staff, student groups are too big to adequately handle, assignments take longer to grade, meetings on financial reports and other necessary evil things need to be planned in, and so forth. 

I tried at times to simply hijack my co-supervisors' time when I saw him, and that works, up to a certain extend: he is usually nowhere to be found, either teaching, or in meetings, or when focus sessions are really needed, grading/preparing at home. 

## 3. The Email World

_Well, can't you simply ask for feedback via email, in between your monthly meetings?_ you ask. Yes of course we can, but it's usefulness is very much limited due to problem number three: the Email World. 

The academic world is run by email. It eats mails for breakfast, breathes inbox all day long, and probably cooks up crumbled email for dessert. 

And it is horrible. I _hate_ every aspect of it. But there is simply no other way to reach out to someone. As a software developer, reaching out to others is as simple as moving your butt a few meters to your left or right. If you need someone from another team, fine, maybe you even need to go up or down a floor. Yes I have worked with nearshoring teams, but then Skype works, and these teams never did great anyway. Even if you are an employee in a big consultancy firm, you usually only need tings from your 'daily colleagues'.

### Working Remote

At my University, we are remotely located on another Campus, and my supervisor works 91km further away. Even if you regularly see your supervisor(s), chances are still very high that you need things from others working at remote locations, possibly even other Universities and other countries. One of the things I really like about the academic world is working together with different people from different universities. Guess what our preferred way of communicating is? Right. 

Some PhD students dare to introduce things like Slack, but without the proper critical mass (and support), these things will never be put into the spotlight, to be ultimately shoved aside in favor for... You guessed right again! 

The problem with email is not email itself. It is the asynchronous process of mailing a request and receiving a response. I am not saying we should introduce a system where everybody checks their mail every five minutes, as obviously email is not meant to be a communication system where everybody drowns in. But in reality, I have never seen it as bad as in academia. I receive ten mails on average each day, and I'm just a simple PhD student. Nine of those mails are mailing groups, research group news, Faculty news, or the election of the new Dean: things the delete button is made for. 

The overburdening principle of faculty members, as explained above, combined with the email system as the default way of communicating, rapidly generates a huge overhead. It is not uncommon that I receive mails from a professor _three months after my initial mail_, containing something in the lines of 'sorry it got lost in the heap'. That is just sad. 

My email life as a software developer was non-existing. I never opened GMail or a mail client more than twice each day, now I aim for checking at least once an hour. I became addicted, craving those highly anticipated responses, almost screaming _GIMME THAT FEEDBACK_. It of course never comes. 

## 4. The Academic Year

Working in an academic context of course also means coming in contact with students. Students who study in a steady pace, neatly divided into 2 semesters. This also requires the academic staff to adjust to that time frame, as they are the one teaching the students. Software developers are also locked in a certain time frame: the cadence of the iteration. 

See what I did there? A semester, compared to a typical iteration, is more than 12 weeks, not just two or three. Students get assignments, need to finish reading their manuals by the end of the semester, before proving what they are worth during the exam period. That usually means _late feedback_, also for a student. While there are many promising initiatives taken to expedite these feedback moments (for instance by the introduction of multiple smaller assignments during the semester), the baseline has not moved yet, and I doubt it ever will. 

That said, the impact of this semester system is bigger than you might think: it also impacts all other reasons we talked about so far. The academic staff is used to working within semesters, and will usually reserve the bulk of their research work in free moments in-between, or in the summer holiday period. Most conferences also take place from June to September because of that. This phenomenon makes sure that professors' time is further compressed during the academic year, further reducing the chance of getting frequent feedback. Remember that in case of curriculum renewals, a lot of preparation before the start of the year also has to be carried out. 

Instead of the **steady pace** we preach for in the software development world, the Academic Year is a frantic way of dividing time and work into two huge unmanageable blocks each year. This makes trying to introduce recurring meetings even more difficult. 

## 5. Stigma

The psychology of work has a big influence on the way you work in a particular environment. Different stigma's attached to that environment strengthen a pre-defined way of thinking about how to work. If the agile philosophy in a company penetrates every single thing they do there, it will become a part of the company culture. The current academic culture, unfortunately, makes things more difficult to quickly adapt. 

### 'Things go slower here'

Everybody knows about the semester system, and everybody knows that academic staff is very busy. These well-known 'truths'/'rumors' further magnify what's already there. In the end, you almost expect no reply the first week when sending out an email. This stigma does not help at all, and possibly makes things even worse. The expectation that everything is simply slower also puts an abrupt halt to people who still think things can be done a bit quicker. 

Of course, one of the celebrated reasons why things need to go slower, is the lengthy time to think, tinker, and possibly invent stuff, aiming for high-impact published work that can only be the result of a good long session of reading, thinking, and re-reading. The lack of this kind of freedom in the industry is indeed visible in the general lack of quality of a lot of end products. Pragmatism is clearly a word invented in the industry as an excuse to declare things done. Things need to be rolled out, clients need to be served, and the quicker we can do that, the more money we can make. However, academia has been spying on the private world and sadly also evolving towards this model of lower-quality high-output: the classic _publish or perish_ system. 

Extreme dogmatism is not much better than extreme pragmatism, but the first does require more time. A cumbersome machine that is more difficult to turn does not exactly yell _agility_. 

### 'You work alone here'

The second stigma starts to take shape when working on a PhD, and is further strengthened during the years. As said before, I would love to see a 'pair PhD' system like pair programming. I could generalize this into a proposal for 'pair researching' kind of work since the way you work does not change after obtaining your degree. Everybody knows (and shows) that _the_ way to work is to work alone. That is just the way it has to be. 

And that could not be more wrong. Yes, academics regularly work together, and yes, collaboration happens across the globe, more so than in the industry. However, there is a very big difference between _collaborating_ on a project, and intimately _working together_, side by side, on a project. In the end, a collaborative project is just a project where the work is divided and you sync now and then using meetings. The stigma that you are 'supposed' to do it all by yourself is still present, and that only makes things worse. 

Even in the industry, HR experts declare that research work is mostly carried out alone, depicting the lone researcher in a white coat, tucked away in his lab, experimenting with perhaps chemical flasks? The stereotype of the programmer sitting in a basement typing like a maniac, all by himself, has been replaced by the lone researcher. Nowadays, programmers program in teams. Sure, researchers are part of a research group, and sure, they proudly self-declare they're part of a team. But that team does not know what effectively working together is, they merely collaborate now and then. This claim will no doubt upset people, unable to understand the difference, until also worked for a few years in the industry. 

# So, what do I do about it?

Not much, honestly. With enough critical mass, a company culture can be turned around. But given the sheer size of something like a University, do not get your hopes up. Instead, try do work with what you've got/can find. That does not mean you should blindly accept all reasons why agile and academia don't go together. Here are a few tips for each reason: 

1. Ask for feedback on your abstract, your setup, and every single semi-finished section if you can. Don't limit this to supervisors. Remember to expect feedback on layout that is not relevant yet. Do not give up if there's no response. When peer reviewing for conferences or journals, try to accept that this indeed is late feedback - and that probably is better than none at all. When receiving peer-reviewed feedback, be ready to put it into perspective. 
2. Do not skip on the demo's - instead, do these for yourself every 'iteration'. It is still possible to work in chunks for yourself. Try to find like-minded people, possibly outside of your daily working environment, maybe even outside of University. Talk to these people regularly, and not only about your work itself. 
3. I would love to say 'stop emailing people'. Effective advice would be 'start spamming reminders' but that only makes things worse. I honestly still do not have a better idea on how to reach people you don't know that well. 
4. Accepting the semester system and adapting yourself to it is the only way you will survive it, especially if you're also a teaching assistant like me. 
5. Never, ever, blindly accept that culture. Put your own culture and way of working before the University's way of working where possible: at least that's an advantage of working alone. 

These tips honestly still don't do much. In the end, it it still frustrating to receive late feedback instead of early, especially when you're used otherwise. Luckily we humans are very adaptive. Before you know it, you won't even remember what it was like to work in an agile environment... 

