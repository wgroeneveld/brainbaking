---
title: "Tracking and privacy concerns on websites"
date: '2020-06-01'
subtitle: "I redesigned Brain Baking to get rid of trackers!"
tags:
  - webdesign
  - privacy
---

Thanks to another great "internet stumble", I came across [Laura Kalbag's blog](https://laurakalbag.com/) and her stance on [privacy and tracking](https://laurakalbag.com/i-dont-track-you/). She's been giving talks on the subject and created ad- and track-blocking software. Ever since the European GDPR, cookie banners have annoyed website visitors, but how many of us simply press "Accept, now get on with it"? I did a few experiments, and the results are downright **scary**. 

Take a look at HLN.be, "Het Laatste Nieuws", a Belgian newspaper website. Opera informs me the SSL certificate is valid:

![](/img/privacy/cookies-hln.png)

Wait, what? **75 cookies in use**? Did I give my consent for every single one of those? You bet I did not! Luckily, I browse with "protection on" these days, and my protection of choice is not an Adblocker plugin using Google Chrome but Opera's built-in security systems. Pay special attention to the console errors in the above screenshot: `net::ERR_BLOCKED_BY_ADBLOCKER`. I do not want to know what happens when I turn it off. 

Where do these nasty things come from? Who's keeping an eye on me and should I be tracking the trackers? Good question. Here's another screenshot of the _Sources_ tab, to get an idea of where all the data (and thus, trackers) are coming from at hln.be:

![](/img/privacy/servers-hln.png)

These servers are serving data when my adblocking system is turned _off_. `tentacles.smartocto.com`? A quick look at that webites says things like "make every story count" and "translate strategy into actionable notifications". Smells like they're shipping off tracking data to one of those analytics companies that live on this kind of shit.

Let's try another more authorative news website in Belgium, vrt.be/nws. This time, I let Opera inform me on what was blocked and what was not. It blocks both ads and trackers (image pixels, javascript). 

![](/img/privacy/blocks-vrt.png)

It still contains 12 blocked trackers. Most of those are downright advertisers, but others are more subtle. The most common one is of course _Google Analytics_.

> Google has it's tentacles across 80% of the entire internet. <span>Laura Kalbag</span>

### I don't want that for my visitors!

Enough investigation, time for some introspection. What happens when I expose this website to the above tools? Opera blocked one tracker: Google Analytics. The server tab contains the following servers: 

- Google Fonts
- Google CDN: Bootstrap
- Google Analytics
- Font Awesome Icons
- Another CDN: jQuery
- Goodreads scripts on the about page

It is unavoidable that these endpoints can get access to your visitor's _referer_ URL, and possibly the IP. That means loading a static resource such as a `.woff2` font or a `.css` stylesheet actually comes **at a cost** - the cost of giving away your wherabouts. Time for some refactoring. 

I threw out Bootstrap, jQuery, and Font Awesome, and refactored my Hugo theme to utilize [Sass](/post/2020/05/hugo-extended) (reducing the mean load of an uncached page with more than `200kb`!). Next, I threw out Google Analytics in favor for [Fathom](https://usefathom.com), another small and privacy-focused self-hosted go container (netting me another `40kb`). Then, I hosted all third-party libraries I used myself. So rest assured, Google does not know you were here! This is how the Fathom dashboard looks like:

![the Fathom dashboard](/img/privacy/fathom.png)

The commenting system I self-host is Commento, a fast, privacy-focused commenting platform. It does come with cookies if you decide to login, but then again: it’s on my own SSL-verified domain. Disqus, the popular and standard static website commenting system, has been known before to be [coming with hidden costs](https://replyable.com/2017/03/disqus-is-your-data-worth-trading-for-convenience/).

> Is Your Data Worth Trading for Convenience?

When a YouTube video is embedded into one of these pages, it will run in “no cookie” mode. That means content will be served from youtube-nocookie.com, preventing Google from tracking my visitors. I'd rather self-host `.webm`/`.mp4` content, but copying over someone else's video raises another concern: copyrights. 

I added these privacy measures to the [no-copyright footer](/no-copyright-no-tracker).

### But what about my Social embeds?

Good question. Simple answer: **get rid of them**. 

For Goodreads on this website, I wrote a node script that acts as an anti-corruption layer to fetch the embedded JS code, thus avoiding any cookies. Book cover images are of course still offloaded - although I could also download those. 

For Facebook integraion on my other website [Red Zuurdesem](https://redzuurdesem.be), things were a bit more difficult. The problem is that I rely on Facebook to build a community there. As Laura suggested, "_Post content to your own website first, then push to third-parties_". Facebook page posts are copied into `.md` files that are searchable using lunr.js. 

For the "classic" Facebook widget - well, I cheated... by taking a screenshot:

![the Facebook Widget](/img/privacy/fbwidget.png)

Sometimes, the simplest solutions are the best. I bet nobody notices it's static content. I might even go out on a limb here and retake the screenshot once in a while. This gives me the freedom of throwing out the ugly Facebook JS API and token system that has to be renewed every few months (and comes with tons of "free" cookies!). Good riddance.

For Twitter integration on another website of mine called [Jefklak's Retro Game Codex](https://jefklakscodex.com), I simply rip images and videos to self-host them. A private Twitter account acts as a bridge between my Nintendo Switch and my website - currently, there's no other way to transfer images and videos (besides Facebook). Hooray for HTML5 `<video/>` tags!

### Creating a website does not stop after writing HTML tags...

There are so many things to take into consideration. I've never given them much thought, until now, and I have to say I'm glad I'm learning. From what I gather so far, the following things need to be taken into consideration:

1. Site speed. People flee after waiting for more than two seconds (I know I do). Compress images, use interlaced mode and cache headers, ...
2. Responsiveness. Everything should be in relative `rem` and not in absolute `px`, use `srcset` image attributes, write `@media` CSS queries, ...
3. Security. Use (self-signed) SSL `https://` certificates. Provide base security levels for your [own vps](/post/2020/04/vps). Use honey pots for form submissions.
4. Continuous integration/deployment. Setup a node/hugo build chain. Make things easy to commit and revert if neccessary. Have a backup plan?
5. Privacy. Don't track visitors, track traffic instead!
6. Licences. Which copyright system are you applying? Did you attribute your sources correctly? 
7. Accessibility. Use contrasting colors, write `alt` tags, ...

I haven't looked at that last part yet - _accessibility_. To be continued!

