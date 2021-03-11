---
title: Always have a Diaster Recovery Plan
subtitle: One OVH data center was destroyed by fire last night
date: 2021-03-11
categories: 
    - braindump
tags:
    - vps
---

A relatively quiet Wednesday morning. I wrote a few JS files, fiddled a bit more with my attempts to get [Webmentions working](/post/2021/03/the-indieweb-mixed-bag/). Timeouts appeared. Huh? Check _brainbaking.com_. No response. Huh? Try to login into my VPS administration panel. More timeouts. Huh-wuh?

![](../ovh-fire.jpg "Uh-oh. This can't be good...")

SBG2, one of [OVHcloud's](https://www.ovh.com/) data centers in Strasbourg, [was completely destroyed](https://twitter.com/olesovhcom/status/1369770805064855552) by a fire last night. Luckily, everyone got out in time. Well, except for all VPS servers... Mine is hosted in the adjacent SBG1, and 1/3th of that center is also gone. 

The first thing my wife posted on Instagram? _"Dear sir/madam. [Fire - exclamation mark!](https://www.youtube.com/watch?v=xqQ6Z-HmAqY) Fire - exclamation mark!"_ - who's the nerd now?

We were recommended to _"activate your disaster recovery plan"_. Cool. I didn't have any, except for a few shoddy bash scripts I wrote about [last year](/post/2020/04/vps/). That poor man's backup plan clearly was _not_ sufficient... I hastily reserved another VPS in Gravelines, just below 
Dunkirk. DNS IP settings borked, no failover plan, no automatic backups... Getting static websites back up and running in no-time is not a problem. However, my wife's Wordpress instance was much more painful.

And of course, I forgot to backup the CalDAV and Mastodon databases, and a portion of my wife's Moodle instance... 

So yeah. Wednesday sucked. Time to put Ansible/Docker on the priority queue... 