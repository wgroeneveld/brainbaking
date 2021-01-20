---
title: Digitizing journals using DEVONthink
subtitle: Migrating from Evernote to a secure and decentralized solution
date: 2021-01-01
bigimg: devonexport.jpg
categories:
    - learning
tags:
  - journaling
keywords: [devonthink, digitizing journals, digitalizing journals, from evernote to devonthink, scanning journals, tagging journals, scanning hand-written journals]
---

In 2017, I wrote a practical [guide to keeping a journal](post/2017/07/journaling-in-practice/), which also contained a digitalizing part involving Evernote. Since then, a few things happened that ultimately made me close my Evernote account for good, and resort to other methods I'd like to explain here.

## Why I Quit Evernote

### 1. Privacy and Security

The primary reason to quit Evernote was taking back control of my own data. I don't want to throw my whole life on "the cloud" anymore - even if it's encrypted at rest on Google Cloud servers - to which I do not have any key, by the way. Oh, and 
[Evernote employees can read your notes](https://lifehacker.com/evernote-employees-can-read-your-notes-and-theres-no-w-1790099958)? I've also heard stories of disappearing notes. Although that never happened here, it's kind of scary. 

So, I purposely looked for a **decentralized** solution that does _not_ force me to store my very personal data somewhere else besides on my own hardware. With DEVONthink, you can still sync between multiple devices using Dropbox, with client-side encryption. Making backups is a simple matter of zipping a single directory, and doing whatever the hell I want with it. The note database can also be encrypted, although I simply rely on [FileVault](https://support.apple.com/en-us/HT204837)'s disk encryption instead.

### 2. Functionality

DEVONthink has so many bells and whistles that it is impossible for me to list them here. Take a look at [the official website](https://www.devontechnologies.com/apps/devonthink). Of course, if you're a minimalist, that can also be a bad thing. Luckily, most features are discrete and the main UI is clean and can be customized to your liking. A few things I particularly liked, compared to the Evernote OSX application:

- Proper Markdown support, custom CSS, WikiLinks, ...
- Smart AI that suggests related notes.
- A scriptable interface using AppleScript (not great, but it works) 
- Smart Rules that lets you auto-tag, move, rename, ...

### 3. Speed

DEVONthik is _blazingly fast_ on my [M1 MacBook Air](/post/2020/12/developing-on-apple-m1-silicon/). It literally takes a single second to boot, while the Electron-based Evernote app takes its sweet time. By then, I'm over the _"quickly, jot that down or I'll lose it!"_ pattern. Okay, that's a lie, I only take notes in my analog journal, but still. 

### Disatvantages of DEVON Tech.

- **It's expensive**. True, but it's a _one-time_ cost, not a yearly one! With Evernote increasing its prices to `$7` a month, after two years you've almost covered the Pro edition. However, what I actually like about the price is that it forces me to _actually make use of it_. After all, I paid quite a bit of money (at once) on a single product. Better make the most of it, then!
- **You're limited to Mac tech**. Also true. Although I don't mind, I do wish I had an iPhone right now, because DEVONthink To Go is not available for Android, and that does sting. Avoiding vendor lock-in is important, especially as you want your note-taking system to last preferably your entire life. Export options are plenty, and notes are simply files in folders. 

## Migrating from Evernote to DEVONthink

My Evernote journal stack was easily exported into a weird `.enex` format that turned out to contain a simple XML structure. A few [parsing gists](https://gist.github.com/evernotegists/6134552) helped me cook up a script to automatically import this data into DEVONthink. Yes, there's a Import menu, but it requires Evernote to be installed, and by then, my account as already closed. 

The [DEVON community](https://discourse.devontechnologies.com/t/easy-capture-of-pdf-from-web/4137/3) helped with tips on [importing](http://myproductivemac.com/blog/devon-think-part-3-importing-and-indexing14102015) and [image importing](https://wp.honekamp.net/2019/01/04/automate-storing-of-images-with-pythonista-and-devonthink/), and I ended up with a Python script that combines AppleScript (using [appscript](https://pypi.org/project/appscript/), which is deprecated and "unsupported", but still works on Big Sur) to command DEVONthink and raw python to parse the XML structure:

```python
    journaldb = self.devon.create_record_with({k.type:k.group,k.name: filename.replace(".enex", "")},in_=db)
    self.devon.create_record_with({k.type:k.picture, k.tags: tags, k.name: title, k.data: url},in_=journaldb)
```

In order to pass the URL, the Base64-encoded image data from the `.enex` export is first copied to a local file. The full gist code is [available here](https://gist.github.com/wgroeneveld/25139d401840bbfd65e0152a5791ba3f).

## How to Digitize Hand-written Journals

### 1. Scanning

Since the Android Evernote scanner app - which worked quite well, to be honest - isn't an option for me anymore, I needed to find another way to efficiently digitize my stuff. After reading [Mark Koester's guide](http://www.markwk.com/digitalize-paper-journals.html) on digitalizing journals with a scanner app, I decided to give [Genius Scan](https://www.thegrizzlylabs.com/genius-scan) a try. Others I've tried are Adobe Scan (requires login, nope!) and Smart Doc Scanner (too clumsy to quickly scan multiple pages).

Scanning an entire journal (240 pages) took `20`min. However, the app only managed to identify and properly cut the pages about `30%` of the time, and regularly rotates scans even though I don't want that. I do like writing with a lot of colors, pasting pieces of cut-out papers and images in-between. That might have confused it. Furthermore, the quality of the scans themselves isn't great (even after selecting the _"Highest"_ image quality), compared to the scans made by the Evernote app. I'm not sure whether I can recommend it, but it's the best of the worst. I tried both scanning single pages and two pages at once (by opening up the journal) and the latter worked much better.

Although Genius Scan quickly lets you create a single PDF document for each journal, I don't want a _single_ file: I want separate files for each page to tag in DEVONthink. No problem: after transferring the PDF to your workstation, use ImageMagick: `convert -density 150 journal.pdf -quality 90 journal.jpg` creates `journal-i.jpg` for each page (`48`s for 248 pages on the [Apple M1](/post/2020/12/developing-on-apple-m1-silicon/) - `300`dpi creates blown-up `4`MB files that I don't need). Then, simply drag these into DEVONthink after creating a new group for the journal and the painful tagging process can begin... 

As for note names, I used the pattern `#XPYYY` where `X` was the journal index and `YYY` was the page number. A very handy feature of DEVONthink is the _Automatic WikiLinks_ one that creates linkks to journal pages if you mention them in a note. This does not work if a note starts with a hashtag. I converted these using the Script - Rename - Rename using RegEx menu. Do _not_ rename them on disk: this will corrupt your note DB. I simply replaced `#` with `b` (for "book"). I've seen others use a timestamp in their filename, but that makes linking even more difficult.

![](../devon-wikilink.jpg "Autocompleting links to journal pages in Markdown.")

### 2. Tagging

_Fast_ tagging is an art. With DEVONtink and a bit of shortcut trickery, you'll do just fine. Select a scanned picture. Click on "Tags" on the right and add some. Press Enter. Use `CTRL+TAB` and `DOWN` to quickly go to the next. If you didn't touch your trackpad, just click again to re-enter the next set of tags. I usually browse through the same physical journal in case I feel like re-reading or the scanned image is a bit blurry. This process takes about `1.5`hrs per journal. A few more tips:

- If you're obsessed about structure: DEVONthink supports hierarchical tags.
- Don't overdo it. I used to tag way too much, or use too fine-grained things. If you, like me, use tags primarily to quickly _find_ stuff, be mindful of the name and amount. 

### 3. Other metadata

With Evernote, I [used to annotate]((post/2017/07/journaling-in-practice/)) each individual note with the correct date as appearing on the physical paper. I stopped doing that because it takes too much time, and it is irrelevant: either the date stamp, positioned in a corner, is also scanned, or I can deduce the period by simply looking at the _Location_: each group is labeled as follows:

```
Book XX MMYYYY - MMYYYY
```

Where `XX` is a simple serial number and both dates denote the beginning and ending period of that particular notebook. If, for some reason, that still isn't enough, I simply locate the physical copy and look at that one instead. For me, the digital versions are never meant to replace the originals: they are merely there as a backup and a quick way to find notes. 

![](../devon-notes.jpg "Tags (left), Journals (Middle), selected Page and tags (right).")

If that is not enough for you, DEVONthink offers the ability to add custom metadata fields. 

## So I'm a DEVONthinker now. What's next?

Customize your setup. Browse through online DEVONthink [productivity tips](http://myproductivemac.com/blog/making-devonthink-and-hazel-play-nicely1522017). Read Stefan Imhoff's [Zettelkasten Note-taking Method](https://www.stefanimhoff.de/zettelkasten-note-taking-devonthink/) with DEVONthink. I'm far from a note-taking ninja myself, and it's very inspiring to read how others tackle this. As he put it:

> Putting notes into folders is the beginners’ approach.

The Zettelkasten method basically equals to the practice of _non-linear note-taking_:

1. You take notes. Good, but not great.
2. You also tag notes. Better, as it groups them into clusters, but still not great. 
3. You create links between tags/notes. Congrats, you're _zettlekast_-ing!

Remember, digitizing your journal is _only the beginning_. So we're officially a note-taking newbie now. On to level 2! 
