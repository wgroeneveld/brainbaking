---
title: "Programming on the Apple M1 Silicon"
date: '2020-12-27'
bigimg: macbookairs.jpg
subtitle: "Is early adoption a good idea as a software developer?"
tags:
  - apple
  - macbook air
keywords:
    - m1 programming
    - apple m1 development
    - m1 apple java
    - m1 jdk
    - apple m1 gradle
    - big sur productivity tools
    - java arm64
    - netbeans m1 apple
    - intellij m1 apple
    - gba m1 apple
    - arduino m1 apple
    - go m1 apple
    - python m1
    - hugo m1 apple
    - pandoc m1 apple
    - mactex m1 apple
    - javascript m1 apple
    - javascript arm64
categories:
  - hardware
  - programming
---

Ever since I read Kay Singh's Apple Silicon M1: [Black. Magic. Fuckery](https://singhkays.com/blog/apple-silicon-m1-black-magic/) article, I couldn't stop wanting one. My 2012 MacBook Air was in need of a replacement, and although still _very_ serviceable for a 8+year old laptop, not upgrading OSX and a shortened battery lifespan were getting irritating. So, Santa (well, you know) bought me a M1 2020 MacBook Air. At first, I wanted to hold off for a while, after many of the developer tools I use were officially supporting ARM64. But hey, what the heck. 

As there's not a lot of information out there on the M1 from a developers perspective, except [a few](https://steipete.com/posts/apple-silicon-m1-a-developer-perspective/) [other blogs](https://medium.com/before-semicolon/is-m1-mac-worthy-or-good-for-developers-developer-review-3ed832f4105e) here [and there](https://codetober.com/software-development-on-the-new-m1-macbook-pro-13/), I wanted to chime in and share my initial findings. Bear in mind that this will very likely change in the near future, as many developers are starting to support the new architecture. An interesting site to check whether your software works is [isapplesiliconready.com](https://isapplesiliconready.com/) and [doesitarm.com](https://doesitarm.com/kind/developer-tools/) - although these are not always up to date and sometimes provides false information! Be sure to go after the source yourself.

Whatever you do, be sure to upgrade Big Sur to `11.1` first - that will take a while (and eat up more HDD space). I went with the `512GB` Air version with eight cores. I don't care about CPU throttling - even with the 25% performance hit, it still outperforms heavyweight Intel MacBook Pros! 

## Productivity tools

Before getting to the programming part, let's take a look at the basic tools I couldn't live without. First, install **[iTerm 2](https://iterm2.com/)**. It's already M1-ready, and Big Sur moved from Bash to Zsh, another good shell I still know from my Gentoo days. Check out technofob.com's [oh-my-zsh config](https://technofob.com/2020/12/24/the-ultimate-mac-m1-terminal-iterm2-oh-my-zsh-zsh-syntax-highlighting/) for colors and such, and maybe add [extras](https://gist.github.com/knadh/123bca5cfdae8645db750bfb49cb44b0) in your `~.zsh`.

Now that you have a shell, we need cmdline stuff. The master branch of Homebrew is ARM64-complaint and you can [install two homebrews](https://soffes.blog/homebrew-on-apple-silicon) for the bottles that are still lagging behind - or compile them from source using `brew install --build-from-source`. I've successfully built these from source: sqlite, openssh, python3.9, imagemagick. I set up the M1 homebrew version in `/opt/homebrew` - and so far, every installation didn't need a Rosetta alternative - yet.

A few other critical pieces of software:

Already running native:

- The [Brave](https://brave.com/) nightly build. Most Chromium-based browsers work.
- [Rectangle](https://rectangleapp.com/), the upgraded Spectacle one.

Still on Rosetta - but development on the way:

- [Clipy](https://github.com/Clipy/Clipy) clipboard utility, the upgraded ClipMenu one. [Alfred](https://www.alfredapp.com/) is a bit too bloated for me, but it's M1 ready, if you think Spotlight isn't enough.
- Hopefully Opera someday soon. 
- [Sublime Text 3](https://www.sublimetext.com/3). Preview builds of Visual Studio code are already released.
- [Evernote](https://discussion.evernote.com/forums/topic/131507-apple-silicon-m1-version-of-evernote-10/). It runs on Electron, a known-to-be CPU hungry JS shell. The Rosetta one works, but is a bit sluggish and uses a significant amount of battery.
- Update jan. 2021: The latest [GIMP](https://www.gimp.org/downloads/) 2.10 is finally released for OSX, but there are known Big Sur issues. I didn't run into a single one. 

[Spotify is a mess](https://www.reddit.com/r/spotify/comments/jyrsxw/when_will_spotify_support_the_new_m1_macbooks/), according to some, while others claim that Rosetta is "good enough". I'd like to run as much stuff as possible native, I guess we'll have to wait. For now, "it just works", but as Evernote, is far from optimized.

![](../mbairsvs.jpg "Left: M1 MacBook Air 2020. Right: x86_64 MacBook Air 2012. Note the differences in screen size. The Gold is a bit more Pink than I'd like, but it's growing on me!")

## Java development

The Azul community released [ARM64 Java builds](https://www.azul.com/downloads/zulu-community/?os=macos&architecture=arm-64-bit&package=jdk ) that are blazingly fast. There are [other solutions](https://izziswift.com/java-jdk-for-apple-m1-chip/), but the Zulu builds I tested so far are great. They even ported the JDK13/JDK11/JDK8 older ones. I settled for v15, since Gradle does not like Java 16 yet, according to the [compatibility matrix](https://docs.gradle.org/current/userguide/compatibility.html ). Gradle `6.7` builds fine with the ARM64 development kit. 

The biggest hurdle for me was **JavaFX**, the UI libraries we use to teach students the Model-View-Controller principle. It [reportedly](https://nequalsonelifestyle.com/2020/11/23/apple-silicon-benchmarks-pt2-javafx/) works under Rosetta, but I wanted to try it native anyway, and got a nice `no toolkit found` exception, not unlike [this one](https://github.com/javafxports/openjdk-jfx/issues/237). Funnily enough, it _builds_ fine, but it does not _execute_: JavaFX looks for a native UI renderer and cannot find one. 

Installing JDKs with different architectures turned out not to be problematic, and I can quickly switch between both using an alias:

```
alias jdkarm="export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-15.jdk/Contents/Home"
jdkarm
alias jdkx86="export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-15.0.1.jdk/Contents/Home"
export PATH_TO_FX=/Users/wgroeneveld/development/java/javafx-sdk-15.0.1/lib
```

Paths shouldn't be hardcoded, but `/usr/libexec/java_home -a` didn't work for me. Building this [sample FXML project](https://github.com/KULeuven-Diepenbeek/db-course/tree/main/examples/jdbc-fxml-start) using `./gradlew clean build` took about a second natively:

- ARM64: `1378`ms
- x86_64 Rosetta2: `9646`ms! (second time: `2459`ms, still almost double)
- x86_64 MacBook Air 2012: `14590`ms (second time: `3200`ms)

![](../javaperformance.jpg "Lower is better. Compile performance in ms.")

As you can see, combining Rosetta with another "Virtual" Machine is not a particularly great idea. Remember that the 2012 MacBook Air only has `4GB` of memory, with eight year old tech.

### NetBeans IDE

NetBeans: 12.2 includes Big Sur/Rosetta2 support, but is not running natively. It auto-detects the JDK ARM64 build, which is even more annoying, as setting the default Java Platform is a pain. The "best" way is to manually override `netbeans_jdkhome` in [netbeans.conf](https://developer.apple.com/forums/thread/664759). Compared to IntelliJ, NetBeans truly is a piece of shit. Of course, the x86_64 setting also slows down NetBeans itself, not only the project you wish to compile/run. 

### IntelliJ IDE

IntelliJ: 2020.3 ARM64 [test builds](https://youtrack.jetbrains.com/issue/JBR-2526) are available. It seems that the Rust debugger is not hitting the breakpoints. There's also a preview [PHPStorm build](https://blog.jetbrains.com/phpstorm/2020/12/phpstorm-2020-3-1-rc/), although I haven't tried it yet. After opening a Gradle `6.3` project, IntelliJ complains about an invalid Gradle configuration, claiming that JDK15 isn't compatible with this version of Gradle, although it builds fine on cmdline. Fixing the distribution URL in gradle-wrapper.properties to `6.7.1` does the trick:

```
distributionUrl=https\://services.gradle.org/distributions/gradle-6.7.1-bin.zip
```

After that, the Azul JDK combined with the IntelliJ preview build is a snappy experience and pleasant to work with. Debugging works fine, just as a few third-party libraries I tried - as long as you stay away from JavaFX.

## .NET Development

I still need to try this with Rider and Mono. Khalid Abuhakmeh wrote about his experience in a [jetbrains blogpost](https://blog.jetbrains.com/dotnet/2020/12/11/net-development-on-apple-silicon/), concluding that it was pleasant to work with .NET on the M1. Bear in mind that he's talking about Rosetta.

## C/C++/Cross-compiling

First, get Xcode from the App Store. Yoink, `12GB`!

Next, the **CLion** IDE: the debugger cannot be launched, official ARM support is currently not there yet, but they're [working on it](https://youtrack.jetbrains.com/issue/CPP-23494#focus=Comments-27-4615098.0-0) (last update: 25th of December). One of the perks of being an early adopter, I guess... I don't want to try this in Rosetta as I only need CLion every odd semester for my teaching activities, and hopefully, by then it'll be okay.

Until then, I'll compile and debug cmdline. **CMake** works flawlessly, using the master version of brew: `==> Pouring cmake-3.19.2.arm64_big_sur.bottle.tar.gz`. Using it to compile the `1.10` release of Google Test gives C++11 errors so you'll have to add a `-DCMAKE_CXX_STANDARD=17` flag to CMake as per [this ticket](https://github.com/google/googletest/issues/1519). Compiling itself was extremely quick, compared to what I'm used to on my 2012 MacBook Air. 

### Game Boy Advance

Cross-compiling **GBA stuff** using [pacman](https://github.com/devkitPro/pacman/releases/latest) worked flawlessly, obviously in Rosetta mode. I doubt it will ever be released natively. Cross-compiling the whole [gba-sprite-library](https://github.com/wgroeneveld/gba-sprite-engine), including four demo projects, took `15343`ms. I was surprised that this worked without any problems, and a Rosetta-enabled mGBA happily plays my binaries! On the 2012 laptop, it takes more than twice that long: `32950`ms.

### Arduino

After finding not so promising [Reddit posts](https://www.reddit.com/r/arduino/comments/jwpuuu/arduino_on_new_apple_macbooks_with_m1_chip/), I had to try it out myself. A [Github issue](https://github.com/arduino/Arduino/issues/10836) tells us Rosetta is supported and "somewhere in the future" native support should be coming - Linux ARM64 builds are already available. 

After installing the Arduino IDE (which runs on a JRE, by the way), right-clicking and pressing "Get Info" reveals _Kind: Application (Intel)_. It boots up fairly slowly, but compiling and uploading work without problems. Performance is a non-issue here, you won't be compiling megabytes of C code anyway. 

## JavaScript

Node `15.5.0` and its package manager have native bottles uploaded in the master Homebrew repository. Everything works flawlessly after a `brew install npm`. Do yourself a favor and install a Chromium-based browser to check out [Lighthouse](https://developers.google.com/web/tools/lighthouse/).

## Go

It's been a while since I programmed in Go, but Dids created [a gist](https://gist.github.com/Dids/dbe6356377e2a0b0dc8eacb0101dc3a7) entitled _"Compile Go for Apple Silicon (M1)"_, where he explains how to compile Go natively. I have yet to try it out.

## Python

Although python `3.8` comes included with Big Sur, python `3.9` compiled without any issues from source using Homebrew. However, since OSX always seems to come with an annoyingly old `2.7` version, you have to create a symlink in `/usr/local/bin` to set the default version to 3.9. You may also need to re-link Python:

```
brew unlink python && brew link python
sudo ln -s -f /opt/homebrew/bin/python3.9 /usr/local/bin/python
sudo ln -s -f /opt/homebrew/bin/pip3.9 /usr/local/bin/pip
```

## Writing

**Hugo** extended works like a charm on ARM64. Pfew! 

As for my needed **LaTeX** tools: the [MacTeX about ARM page](https://www.tug.org/mactex/aboutarm.html) tells me that full native support will arrive in spring 2021. Until then, Rosetta to the rescue (it also requires `6.7GB`...). I do hope that switching will not be problematic, as I can't wait until then. 

As for **pandoc** that converts my Markdown to LaTeX, compiling from source downloads the x86_64 version of the [GHC](https://www.haskell.org/ghc/) Haskell compiler. As expected, compilation crashed:

```
ghc@8.8: The x86_64 architecture is required for this software.
Error: An unsatisfied requirement failed this build.
```

So, I reverted to the [x86 installer pkg](https://pandoc.org/installing.html), which seems to work fine. After the necessary installations, I re-compiled a recently accepted ICSE paper (involving make, pandoc, panflute, pdflatex, bibtex, yaddayadda), and it took `7700`ms on the 2012 Air, while the Rosetta x86_64 version took `4447`ms. Consider me happy! It will be _very_ interesting to see this number further reduced in spring 2021. 

## Virtualization

The universal memory structure of the M1 architecture has its advantages, but these obviously fade when dual booting. Furthermore, using something like VirtualBox gets you into [further trouble](https://codetober.com/software-development-on-the-new-m1-macbook-pro-13/) by evenly splitting RAM. It [looks like](https://forums.virtualbox.org/viewtopic.php?f=8&t=98742) VirtualBox support will never be coming as it requires a x86 CPU.

Alternative options are [Parallels](https://www.parallels.com/blogs/parallels-desktop-apple-silicon-mac/), which has a technical preview already published, and VMWare Fusion, which announced [on Twitter](https://twitter.com/VMwareFusion/status/1326229094648832000) that they're working on it. 

As of now, there is no possibility for me to run my virtual image of Linux for the Operating Systems course I'm teaching. I guess I'll be using a Dell laptop for this purpose... I don't mind, my 2012 MacBook Air didn't have the required memory to comfortably work with it anyway, so I already resorted to another machine.

## So... Is it worth it?

It depends. If you're like me, and you have been waiting for a long time to upgrade, now is the best possible time to take the plunge. However, if you already own a more recent MacBook (I hope it's with a decent keyboard: this one types lovely, compared to my wife's 2017 _butterfly_ keyboard on the MacBook Pro - what a train-wreck), it might be a better idea to wait half a year. 

Currently, with the software I daily use, about `50%` of them are running under Rosetta. It is impressive nonetheless: it is seamless and still very fast - except if you're a Java developer and somehow have to support JavaFX. Don't forget that the M1 chip comes with other awesome perks:

- `18h` battery life (more like 10+ with regular compile jobs, but still great)
- Greatly improved screen compared to my 2012 laptop
- I finally bought a `QUERTY` one.
- `8GB` is more than `4GB`.
- We used the 2020 Air to video-call (using browser-based [Jitsi](https://meet.jit.si/)) over Christmas, while we used the 2012 Air during Christmas Eve - the fan went on and it crashed once.
- The instant-on effect is _amazing_, compared to waiting up to ten seconds.
- I can finally play [Baldur's Gate III](https://www.reddit.com/r/macgaming/comments/k5sf57/baldurs_gate_3_on_apple_m1_performance_review/)! 

Like Kay said: Black. Magic. Fuckery!
