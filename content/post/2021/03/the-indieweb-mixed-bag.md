---
title: The IndieWeb Mixed Bag
subtitle: Thoughts about the (d)evolution of blog interactions
date: 2021-03-09
tags:
    - privacy
    - accessibility
categories:
    - webdesign
---

It's that time again: I started fiddling with my blog code - for the _nth_ time. Kev Quirk calls it [pissing around with the code](https://kevq.uk/the-wonderful-world-of-wordpress-wizardry-for-working-with-websites/). That was meant negatively, and one of the reasons for him to switch back from Jekyll to Wordpress. I, however, like _pissing around_ because I like _pissing_ - or coding, just for the sake of it. After all, _Brain Baking_ is a big side project that helps me learn and discover new things, blogging technology included. 

## So, what changed?

I discovered the [IndieWeb](https://indieweb.org/), perhaps an integral part of what Aral Balkan likes to call the [Small Web](https://ar.al/2020/08/07/what-is-the-small-web/). Many IndieWeb W3C standards have been around for almost twenty years! I have no idea why I only came across it a few weeks ago. Since then, I've been trying to refactor parts of my site to support the IndieWeb standards, and I'm starting to see why.

It's a _big hassle_.

There's this thing with `h-card`, `e-content` and `u-url` meta-classes that have to be added in order for your HTML content to be machine-parsable. Verification can be done with any [microformats2-parser](https://aimee-gm.github.io/microformats-parser/) or the nice website [indiewebify.me](https://indiewebify.me). That meant messing around with the templates - again - as of course many components were not properly placed within each other. Author information should be on the root page of your domain, syndication links should have proper meta classes, etc etc. 

## But why?

Now we're getting somewhere! One compelling component of the IndieWeb movement is **Webmentions**. A webmention is a logical evolution from `pingback` links from the hopefully long lost XML era that nobody ever implements unless they happen to run a Wordpress website. With Webmentions, you notify others when you've written an article and linked theirs - or written a comment on theirs. 

The concept is a webmention is that instead of commenting on someone else's domain, you _own your data_. Want to write a comment or remark? Post it on _your own_ site and send a webmention instead. This idea is also called [POSSE](https://indieweb.org/POSSE): _Publish On your Site, Syndicate Elsewhere_. As opposed to PESOS: _Publish Elsewhere, Syndicate to your Own Site_. A very intriguing concept that got my full attention. 

Until I started thinking about the ramifications of POSSE. It would be cool if the [Switch supported POSSE](/notes/2021/03/04h08m47s31/) instead of having me post screenshots to a private Twitter account. It would be great if we had access to the ecosystem of the target _silo_ (a centralized social platform) when simply interacting with our own site. [Jamie Tanna](https://www.jvt.me/mf2/2021/02/hvjtd/) uses [Indigenous](https://indigenous.realize.be/) to publish content to his site. Oh, you'll need to implement a few microservices (micropub/sub) in order to get that working... And you'll also lose context. So, again: why?

I like the idea of webmentions, because as an academic, I also like the idea of correctly citing each others work. In theory, writing something like this should automatically post webmention notifications to the people I mentioned in this article. A link to this article should appear on their page. Note that I'm using the word _should_ here. A few major problems prevent me from smiling instead of sighing: 

- The responsibility for sending webmentions is the web blog owner. Many blogs do not send them out and only receive them because [webmention.io](https://webmention.io/) makes it semi-easy to implement. Yes, many efforts like [webmention.app](https://webmention.app/) exist to automate this, but none work effectively, and they all still require you to run the scripts. 
- Being dependent on something like webmention.io defeats the purpose of a _Small Web_: now I'm still using a big central silo to receive my stuff!
- As for POSSE: that's simply ridiculous when thinking about something like Goodreads. I might also be interested in what others are reading, and not every context gets synced to my site with the IndieWeb tools. 

## So don't do it!

I wrote about my [Facebook PESOS attempt](/post/2020/06/tracking-and-privacy-on-websites/) before. I'd love to POSSE, but some questions that are posted there simply don't make it back, and as a community maintainer, I simply sometimes need to be there, even if I really, really hate that. 

**Blog comments**, another big debate. My evolution from Disqus to Commento to nothing to Mastodon to Webmentions says it all[^comm]: it's a hassle. People like [Evan Sheehan](https://darthmall.net/weblog/webmentions/) add a small form to each page where webmentions can be requested - although they should be sent automatically. But what about "normal", non-tech savvy people? What if they want to comment? Oh, they can just use [commentpara.de](https://commentpara.de/). Well, that doesn't work, and I've tried it - and it's another external liability. 

[^comm]: Managing comments is a hassle, as Kev and others agree. I got rid of these systems last year. If you like to chime in on the discussion, just toot or e-mail me. 

All these headaches made people not just leave the IndieWeb standards behind: they are actually leaving static website generators behind and reverting to Wordpress! Read about [Ru Singh](https://rusingh.com/2021/03/05/waving-thankful-goodbye-to-static-websites-and-more/) and [Chris Wiegman](https://chriswiegman.com/2020/08/hello-wordpress-my-old-friend/)'s reasons. It's mostly the convoluted workflow, and the hassle to get all the tools of their Jamstack-site just right. 

![](../blogchart.jpg "Courtesy of rakhim.org. I'm somewhere on the lower right...")

[What's a jamstack](https://jamstack.org/what-is-jamstack/) 🥞? I've been jamstack-ing more than four years and only just found out that there's an acronym/cool word for the counterpart of a LAMP-stack: a _Javascript + Microservices-stack_. Because if you're interested in receiving webmentions, you still need an end-point... 

Sleeves up, code out: 

- microservice endpoint: check, https://github.com/wgroeneveld/serve-my-jams
- javascript tools: check, https://github.com/wgroeneveld/jam-my-stack

Okay, so now, I can answer the _why_. Not because it will be heavily used, or the IndieWeb stuff feels like the future. The low adoption rate says it all... No, simply because I was bored and wanted to learn about modern JS frameworks. I had an excuse to code again. Yay!

Still, once I more or less finished a first revision of my own toolset (sending is up next), I felt a bit empty inside. What's the point? Who will _webmention_ me anyway? Those few other tech-related cooler bloggers? If you pay attention to the webmentions on other sites, you'll notice that `95%` of them are Twitter feeds, probably converted into webmentions by services like [brid.gy](https://brid.gy/). My point is that as far as **usability** goes, the IndieWeb standard completely falls apart. Sure, decentralization is the future. That's why I try to host and own my own data such as my [Mastodon Instance](https://chat.brainbaking.com/) - and that's the philosophy of the IndieWeb. 

But I can't ask my wife to stop posting on Instagram because she's giving her data away? I can't ask her to post it on her own Wordpress-site, after installing a bunch of [barely working](https://kevq.uk/removing-support-for-the-indieweb/) POSSES-related plug-ins? And I can't ask visitors of my own site to "webmention me!" if they don't have a site? 

Feel free to prove me wrong, though. Why don't you webmention this article?

## Who owns what data?

One of the key properties of POSSE-ing is that you include a url-shortened reference to the original article, like so: `(short.co 34yf1)`. Having to put up with visible junk metadata on Twitter is also a big concern for me. The theory behind it is good and logical, but without the silos supporting it, the implementation is just awful. Furthermore, without a reference, you won't know if it's POSSE or PESOS. Aren't you still giving your data away either way? On [Micro.blog](https://help.micro.blog/2018/twitter-differences/)'s help page, they explain the difference between Micro.blog and Twitter like so:

> But when you use Twitter, your content stays at Twitter. At Micro.blog, you can write short posts that appear in the Micro.blog timeline, as well as on your own blog that you control.

But almost everyone who uses webmention uses it to syndicate replies from others to their site, after POSSE-ing their microblog contents to Twitter. Just for the record: I use PESOS on my [fleeting notes](/notes), because it's coming from my own Mastodon/Pleroma instance anyway. 

So, in essence, you're still sending out data to big "evil" third party silos - possibly including media. That means from thereon, a snapshot of that data does _NOT_ belong to you anymore. You just gave it away! I [can't wrap my head](/notes/2021/02/27h17m51s39/) around that. Again, I think the _Own Your Data_ philosophy is great, and I fully support it. Otherwise, I wouldn't have taken the trouble to [install LineageOS](/post/2021/03/getting-rid-of-tracking-using-lineageos/). 

Maybe, a part of the blog technology fatigue is because of our own fanaticism... 
