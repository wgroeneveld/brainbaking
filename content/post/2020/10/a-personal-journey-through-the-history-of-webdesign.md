---
title: 'A journey through the history of webdesign'
subtitle: 'Using personal websites and the Internet Archive'
categories:
  - webdesign
date: 2020-10-04
---

While browsing through archives of _very_ old files, I rediscovered backups of websites I once made. It felt a bit like scrolling [thehistoryofweb.design](https://thehistoryofweb.design/), an interactive journey through the history of webdesign. Thanks to the Internet Archive project, revisiting these now-offline websites was not only a very personal and nostalgic ride for me, but also an educational one. 

Why not let the websites speak for themselves and follow the history together with me, from 1998 to 2020? I resurrected the static sites that weren't available at archive.org. The point here is not to "[revel in riches](https://scryfall.com/card/xln/117/revel-in-riches?utm_source=api)" (ha!), but to inspect trends from yesteryear and compare them with how websites look like today.  

### [1998](/museum/1998): Marquee, bgsound, iframes, applets

My first website, created more than 22 years ago, is still full of surprises. I was 13 and had no idea of what I was doing. Still, I managed to scrape together a decent looking webiste, filled with sound advice on how to write Visual Basic 6 code, and of course information on games. As soon as you open the site, you'gre greeted with a nice looking background and GIF animation, and a a `<bgsound/>` tag that should start playing a MIDI file in Internet Explorer 4. 

![](../site-1998.jpg "A part of my personal website in 1998.")

[View the 1998 website here](/museum/1998). It was hosted on _uunet.be_, an ISP provider in Belgium. If you were not content with that offer, _geocities.com_ offered more disk space. 

The following techniques were considered cool back then:

- Java applets
- If using Javascript, remember to use `alert()`
- `<iframe/>`s
- Make things pop! Use background images, GIFs, add snow flake JS code when appropriate, spam `<marquee/>`, `<bgsound/>`, and `<font/>`. 
- Pre-process graphics in _Corel Draw_ (remember that?)

### [2000](/museum/2000): Macromedia Flash, Cookies

Since 1998, the popularity of Macromedia Flash exploded. The simplicity involved in creating morphing shapes allowed any website owner to have a classic but fancy "intro page", before continuing on to "index2.html". Since then, Flash was thé thing to include in any site. That was before 2005 when adobe decided to buy Macromedia. Before Sublime Text, there was another brilliant piece of Macromedia software: _DreamWeaver_. 

![](../site-2000.jpg "'aWhile Soft', my personal website in 2000.")

[View the 2000 version here](/museum/2000). [View the revised 2001 version here](https://web.archive.org/web/20010705221029/http://www.awhilesoft.f2s.com/). Another artifact of webdesign history: _visitor counters_. Most in 1998 were hosted, but on this page I managed to hack together my own using cookies. 

Posting news of course required changes in the HTML source code itself. I can't remember what tools I used back then, and the header code does not reveal that. However, there are two interesting things to see in the source:

```js
<!-- Begin
function right(e) {
if (navigator.appName == 'Netscape' && 
(e.which == 3 || e.which == 2))
return false;
else if (navigator.appName == 'Microsoft Internet Explorer' && 
(event.button == 2 || event.button == 3)) {
alert("You're not allowed to use 'RightCLick'.");
return false;
}
return true;
}

document.onmousedown=right;
document.onmouseup=right;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
if (document.layers) window.captureEvents(Event.MOUSEUP);
window.onmousedown=right;
window.onmouseup=right;
//  End -->
```

Everyone was very protective of their precious source codes and I somehow thought it would be a good idea to try and disable right clicks. Built-in browser developer tools did not exist yet so pressing `F12` or `CMD`+`ALT`+`J` would do nothing. 

The second interesting thing are the browser-specific stylesheets! The difference between Internet Explorer and Netscape Navigator was already causing trouble in webdesign land. Compatibility issues would only be getting worse as other browsers emerged. 

### [2002](https://web.archive.org/web/20021128122545/http://awhile.gamingclones.com/): PHP & MySQL, banners, navigation in Tables

![](../site-2002.jpg "'aWhile [D3$!GN]', of my websites in 2002.")

[View the 2002 version here](https://web.archive.org/web/20021128122545/http://awhile.gamingclones.com/).

I got rid of the flashy colors - what a relief. The dark scheme nowadays is still attractive to me, even if modern browsers (and websites) include better support for accessibility. The second thing that thankfully disappeared in the early 2000s are frames. Instead, the navigation was usually built with simple `<TABLE/>` elements - going back to basics with `<LI/>` and style positioning was not yet that common. 

Since then, most of my websites became _dynamic_: they included some sort of server-side scripting, such as PHP to retrieve comments/newsitems/etc. Most designs were made from scratch, even though PHP frameworks existed. CakePHP saw the light in 2005. 

Content-wise, the very first website from 1998 contained three main items (1. code 2. games 3. about me). Since 2002, I started building multiple websites, and **aWhile [D3$!GN]** was my "code"-page - that's the reason it was hosted on "_gamingclones.com_", the game part that was never really finished. This separation is still visible today. Take a look [at gamingclones.com here](https://web.archive.org/web/20040120171650/http://gamingclones.com/). It also has a nice graphical banner made in Photoshop. Since 2003, I was a big fan of `font-family: Verdana, Tahoma, Arial`.

### [2004](/museum/2004): xHTML Validation, Clean design

![](../site-2004.jpg "'Jefklaks Tux 'n' Tips in 2004.")

[View the 2004 version here](/museum/2004).

Somehow, the green scheme stuck with me for almost twenty years. I guess that's the curse of having a surname like _Greenfield_ (literally translated). During university, I was spoon-fed Linux and it tasted great - so much so that I started compiling my own patchset for the Linux `2.4` and the "new" `2.6` kernels back then. Using cool things like Gentoo `2004.1` (after dipping my toes in the Linux world using SuSE Linux `6.3`, just before Novell bought it in 2003) and the Fvwm window manager resulted in a lot of hours fiddling with config files that I wanted to share with the world. This website was the result of that work. 

Third-party `XHTML` and `CSS` checker sites became popular and you could proudly wear fancy badges to claim you effectively did not forget a single slash in all your tags. Good job! Since I still wanted to include gaming tips next to the Linux trickery, I decided to split the site on entry and let the visitor choose:

![](../site-2004-choice.jpg)

The main colors changed, but the rest of the webdesign stayed the same. It was a simple, clean website with few PHP tricks. I slowly but surely started to care more about the **contents** than the look-and-feel. The background hover effects were done using CSS `:hover` instead of the usual JavaScript trickery.

Oh, and I replaced Gentoo with FreeBSD 5.3 - although Fvwm was there to stay.  

### [2006](https://web.archive.org/web/20070605081137/http://www.jefklak.com/): PmWiki, configuring before developing

In 2006, I grew tired of having to build websites time and time again from scratch. As _content_ was my prime concern now, I started looking at Wiki solutions and came up with a heavily hacked version of [PmWiki](https://www.pmwiki.org/) using custom scripts and themes. It was to be used on "jefklak.com", a retro gaming website focused on articles and guides. 

![](../site-2006.jpg "'Jefklak's Codex', The 2006 PmWiki version.")

[View the 2006 version here](https://web.archive.org/web/20070605081137/http://www.jefklak.com/).

PmWik does not rely on MySQL but instead writes content to flat files on the webserver itself, including edit history. This reduced hosting costs significantly and made saving and restoring backups easier. I still fondly remember PmWiki and would gladly recommend it over bloated wiki frameworks such as MediaWiki. 

This was actually the first website that attracted quite a lot of visitors, mainly because of my [Baldur's Gate 2](https://jefklakscodex.com/tags/baldurs-gate-2/) guides and _DOOM_ DS port project. Every single article written in that period has been ported to [jefklakscodex.com](https://jefklakscodex.com/) - a perhaps more appropriate domain name. PmWiki made it easy to expose RSS/Atom feeds that I used for the first time.

Website licensing became a thing: I employed [Creative Commons 3](https://web.archive.org/web/20070623074422/http://www.jefklak.com/Main/AboutLegal). Internet Explorer 7 became the minimum as IE6 behaved like carp with my stylesheets. [Usage statistics](https://web.archive.org/web/20070623071942/http://www.jefklak.com/stats) from 2007 are also archived. 

### [2010](https://web.archive.org/web/20110207214638/http://www.jefklak.be/): DokuWiki, Wordpress, content migration issues

![](../site-2010.jpg "'Jefklak.be' in 2010, migrated to Wordpress.")

[View the 2010 version here](https://web.archive.org/web/20110207214638/http://www.jefklak.be/).

For a long time, I stopped caring about my websites because of my work. Since 2004, I did not own a Brain Baking/personal/tech-based website anymore, and PmWiki was giving me trouble. I can't remember why I did switch, but I decided to move everything to Wordpress. And then the site got hacked because I didn't update the Wordpress version regularly. 

For my work as a software developer, I was always looking for snippets of certain scripts we often re-used. A colleague at work mentioned he hosted a code-wiki using [DokuWiki](https://www.dokuwiki.org/dokuwiki). That re-sparked my interest in a personal (sub)site. The color scheme changed for the better and I got rid of a lot of unnecessary JavaScript code.

As said before, I cared more about my content and wrote scripts to convert from PmWiki to DokuWiki (and later to Markdown for Hugo). In all honesty, the webdesign of the sites in this area could have done better. Fiddling with a custom Wordpress theme only fueled my frustration with these kinds of tools. 

### [2013](https://web.archive.org/web/20140805175940/http://brainbaking.com/): Brain Baking, static site generation

![](../site-2013.jpg "'Brain Baking' in 2013 with ruhoh.")

[View the 2010 version here](https://web.archive.org/web/20140805175940/http://brainbaking.com/).

In 2013, I finally saw the light with _static_ site generation tools and thankfully kicked out Wordpress and the like, including any ugly PHP script files that were involved. An early version of [ruhoh](https://www.staticgen.com/ruhoh) was not that mature compared to Hugo 0.x, but it finally allowed me to write in Markdown. _Separation of concerns_: content here, layout there. 

The _Brain Baking_ name/idea also gave way to more tech blogging, as my work provided me with ample things to write about (unit testing), including my recent interests in self-improvement and journaling. 

I hated the themes though. 

### What does the future offer?

More simplicity and qualitative content, I hope. 

All Brain Baking articles since 2013 have been preserved on this very website, and content from jefklak.com/be has been revived and migrated to [jefklakscodex.com](https://jefklakscodex.com) since 2018.

I couldn't be happier with Hugo and my custom theme that focuses on [accessibility](/post/2020/06/designing-with-accessibility-in-mind/) and [privacy](/post/2020/06/tracking-and-privacy-on-websites/). A lot of good _and_ bad memories come rushing back to me whenever I see `$_POST['id']`. Of course, fifteen years ago, I didn't know what I was doing and PHP3 did not offer object-oriented programming. 

I sometimes have the feeling I still don't know what I'm doing... 

