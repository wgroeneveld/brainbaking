---
title: Productivity Tools on all platforms
date: '2018-08-28'
subtitle: Matching my most frequently used tools on OSX, Linux and Windows
tags:
  - Productivity
  - tools
published: true
---

I've grown so accustomed to some of Neal Ford's [The Productive Programmer](https://www.goodreads.com/book/show/3411606-the-productive-programmer?from_search=true) "power tools" that each time I install a new OS or get a new laptop, I start with my list of cant-live-without tools. I don't usually switch between OSes a lot, but my recent switch of work environment has opened up the possibility to boot Linux again, next to Windows 10 or of course my beloved own laptop with OSX. 

Problem is, none of those tools seem to be 100% cross-platform or work **exactly** the same as I expect them to work. That can be a pain if I work on Ubuntu at work but on OSX at home, or if I need to switch to Windows for a student project. Alternatives almost always exist, so here's a short overview of my tooling usage with their counterparts on each OS. 

Don't forget to take a look at the publication date of this page as especially Unix tools have the bad habit of dying within a few years... I will try to keep this up to date when I adopt another tool. 

### 100% Cross-platform tools

1. IDEA IDEs like CLion, PyCharm and IntelliJ
2. Opera
3. Spotify
4. Any great editor: Sublime Text, Visual Studio Code, GVim

The newer version of Opera has built-in adblock support and reduces battery drain for up to an hour compared to (lots of) open tabs with Chrome! My Macbook Air's battery is slowly giving up so that's a major factor for me. Opera's JS eninge uses the same one as Chrome by the way. 

Shortcut usage in IDEs or editors can be confusing if you're used to the CMD or ALT keys of a Mac (or vice versa). 

### Quicklaunching

**OSX**: CMD+Space is all you need. There are tools that enhance the experience but I find them unneeded since El Capitan. 

**Ubuntu**: Unity's "dash" thing does almost what I want: it searches in possible software and files and it's (a bit) customizable. The only problem is mapping it to CMD (or CTRL)+Space. I had to install the **CompizConfig Settings Manager** and go to Desktop -> Ubuntu Unity Plugin -> Launcher to fiddle with the available key options. 

### Multitouch

**OSX**: built-in. Of course...

**Ubuntu**: Again a bit of a pain, even if it comes with a lot of flexibility. Scrolling with both fingers works out of the box, but swiping combined with a browser does not - ALT+LEFT/RIGHT need to be mapped to swiping. [Fusuma](https://github.com/iberianpig/fusuma) is a small Ruby tool that monitors input and executes things based on a config file. It does not work with 2 finger motions meaning I have to do an unnecessary context switch between OSX and Ubuntu... 

### Clipboard histroy

**Windows**: Happy [CLCL](https://www.nakka.com/soft/clcl/index_eng.html) user for years.

**OSX**: Can't remember, will fill in later 

**Ubuntu**: [Diodon](https://launchpad.net/diodon) does exactly what I need after mapping ALT+C to command `/usr/bin/diodon`.

### Terminals

**Windows**: Install [Cmder](http://cmder.net) and never look back. The cygwin toolchain can also be installed, I'm not sure if GCC is included with Cmder.

**OSX**: Install [iTerm2](https://www.iterm2.com) and never look back. 

**Ubuntu**: Still evaluating whether the default gnome-terminal is sufficient for me. You have to remap the creation of a new tab to CTRL+T in the settings if you're used to iTerm. [Guake](http://guake-project.org) and [Terminator](https://launchpad.net/terminator) seem like good fits, but the default terminal isn't that far away with CTRL+ALT+T. 

#### Custom commands

That's simply a matter of configuring your `.bashrc` or `.bash_profile` files - given you think the bash shell is good enough. I've used the Z shell for years but for what I do now, Bash is more than enough. I'm not a big fan of installing a lot of power tools for the sake of installing them. 

### Misc OS Things

##### Quick access to development folder

OSX's Finder makes it easy to create shortcuts for directories that have been heavily used, like my `~/development` dir where all repositories live. Luckily, Ubuntu's file manger also has this feature:

<center>
    <img src="/img/files_linux.png" class="bordered" />  
</center>

##### Taking screenshots of areas

Emulating OSX's CMD+ALT+4 on Ubuntu works by mapping CTRL+ALT+4 in the Keyboard shortcut manager to `gnome-screenshot -a`. 

For Windows 10, if ALT+Screenshot or Win+Screenshot don't suffice (the problem is uniformity with other OSes here!), the snipping tool will work but doesn't have a shortcut bind to it. In the windows menu, rightclick on snipping tool after searching for it and set a shortcut key in tab "Shortcut". CTRL+Screenshot then creates a new screenshot for an area. 

##### Auto-expand directories when hovering files

Very annoying but it seems that Gnome has this option disabled by default and you have to re-enable it with `gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover true` in a CLI.

##### Window movement shortcuts

This can get very far, I have used Fvwm once and spent weeks on perfecting my shortcut configuration for windows and window management. Luckily that time of fiddling about is over and I must say that the Win+Left/Right key combination in Windows (and Ubuntu) works quite well. Win+Up does nothing in Ubuntu though, so get ready to fiddle again if you want them to work exactly like in Windows... 

For OSX, [Spectacle](https://www.spectacleapp.com) is a requirement. 