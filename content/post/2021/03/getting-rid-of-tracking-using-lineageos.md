---
title: "Getting rid of trackers using LineageOS"
date: '2021-03-01'
subtitle: "Exit Google. Enter Life."
tags:
  - privacy
categories:
  - learning
---

Since dipping my toes into the subject of [privacy](/tags/privacy), I kept on exploring more opportunities to take back my own data. This started out quite innocent with a few [changes to this site](/post/2020/06/tracking-and-privacy-on-websites/), that evolved into taking great care [not to spill my data](/post/2021/01/digitizing-journals-using-devonthink/) to "the cloud". Thank you, [Laura](https://laurakalbag.com) and [Daniel](https://ineed.coffee). It seems that a pattern emerges here. Consistently pulling the plug - I love it. 

Since January this year, I migrated form GMail to [ProtonMail](https://protonmail.com) and took that opportunity to finally settle with a short address on my own domain. The trouble is, simply installing the ProtonMail app on Android does next to nothing if your contacts and address book is are managed by Google. After importing the contacts into Proton, it is still a hassle to create a new one without opening the secure app. So, it was time to go cold turkey on this one. _Project Exit Google_. To do that, I needed more than a secure e-mail provider. I needed a whole new OS[^others]. _Enter [LineageOS](https://lineageos.org/)_.

[^others]: Others have solved this issue by trading Android [for iOS](https://kevq.uk/why-im-ditching-android). I think that's a bit ridiculous. Sure, Apple is less keen on making money through advertising than Google, but don't tell me iCloud services won't track you. Still, idle Android phones [send data to Google ten times more often](https://www.bleepingcomputer.com/news/google/idle-android-phones-send-data-to-google-ten-times-more-often-than-ios-devices-to-apple/) than iOS devices to Apple.

> LineageOS is a privacy-focused open source Android OS. 

## 1. The Installation

I'll be honest with you: it was a pain, and it took several days to get it just right. I have an older Sony XZ1 Compact smartphone, one that according to Google can only run up to Android 9. Well, wrong! With LineageOS, you not only get rid of all Google-focused services and unwanted tracking, you also get the latest Android features as a bonus.

That is, if you manage to get it installed. The [downloads builds](https://download.lineageos.org/) already gave me trouble: no build for the XZ1. Thankfully, [getdroidtips.com](https://www.getdroidtips.com/lineage-os-17-sony-xperia-xz1-compact/) has published a bunch of phone-specific tutorials - only these proved to be very confusing: which tool do I need first? Flash the what now? Reboot how many times? Put that where?

The concept is as follows:

1. Unlock your phone using the [Android Debug Bridge](https://developer.android.com/studio/command-line/adb).
2. Flash a recovery image of [TWRP](https://twrp.me/).
3. Use TWRP in recovery mode to prepare the installation by formatting/cleaning/...
4. Flash a bootable LineageOS image using TWRP.
5. Reboot and pray.
6. If you must: flash an [Open GApps](https://opengapps.org/) image - of course I didn't.

Unfortunately, I first got stuck in a boot loop due to incompatible TWRP/Lineage versions. The combination `lineage-17.1-20201217-UNOFFICIAL-v1.7-lilac` and `twrp-3.5.0-0-20210117-lilac.img` solved that. Next, I had issues with hard disk encryption that went away after repeatedly trying to wipe various things in TWRP. Do not forget to make a backup of your stuff...

## 2. It boots. Now what?

Great! Did you configure encryption settings?

![](../lineage-splash.jpg "My Lineage Home Screen.")

Now all we need to do is to find decent replacements for Google's convenient services and apps. Don't get me wrong, I love Google products. I just don't like the free tracking that comes with it. I've read bloggers complaining about "going back to the Dark Ages" because of the loss of Google fluff. Fortunately, using LineageOS feels far from being stuck with secondary-choice material. 

Lineage is basically a cleaned-up vanilla Android. As you can see from the screenshot above, you can still install any software you'd like, although some might not work that perfectly, since the Google Play store is gone. ProtonMail's push notifications don't work, for instance - but that is a good thing, right? Instead, Lineage relies on the [Aurora Store](https://auroraoss.com/) and of course [F-Droid](https://f-droid.org/en/packages/). The first is an anonymous shell on top of the Play Store, and the latter... well, is kind of the junkyard, since sadly not many developers choose to push to the F-Droid repository. Of course, installing a downloaded `.apk` file works just as well. Yes, both stores will still auto-update your apps. Yes, your favorite banking app still works (at least mine does).

### Privacy-aware communication apps

Below is a list of apps I've tried and now rely on:

- _Messaging_: [Telegram](https://telegram.org/), [Signal](https://www.signal.org/), ... all work. Sadly, so does WhatsApp.
- _Email_: the ProtonMail app (although honestly not that great)
- _Social Media_: [Tusky](https://tusky.app/) is a great Mastodon client!

I also use Proton to manage my contacts. After importing from my Google Account before installing Lineage, I now can import/export using a `vCard` file (although Lineage's default Contact app did not understand `v4.0`: simply replace all occurrences of `4` to `3` in the file itself). The process is not automated, but hey. New contacts by default reside in the smartphone, all I need to do is now and then pressing "import" again. Bye bye, Google-kept sensitive data of all my friends and family[^cont]. 

[^cont]: Note that using WhatsApp also means that _all_ your contacts are sent to their servers. Try this: open up the WhatsApp settings `->` Account `->` Request account info. This is [not the case with Signal](https://signal.org/legal/)!

### Privacy-aware Google Maps alternatives

- _City navigation_: [HERE WeGo](https://wego.here.com/) worked great and has an acceptable privacy policy.
- _Hiking_: [OsmAnd](https://osmand.net/) uses Open Streetmap data and has the ability to seamlessly download map data. It's not great for in-car use, though.

I thought finding a decent alternative was going to be difficult, but I was pleasantly surprised by these two. Give them both a go, even if you're on the vanilla Android OS! If all else fails, you can still surf to maps.google.com.

### A privacy-aware Google Calendar alternative

Here's where things get a bit more complicated. I heavily relied on Google Calendar's ease of use and sync capabilities to inform my wife of things I've planned (or the other way around), and she's on iOS. Furthermore, I wanted my MacBook to also use the same calendar: what's the purpose of a digital calendar if it does not synchronize? 

After a few hours of fiddling, I had a [Radicale CalDAV server](https://radicale.org/3.0.html) up and running on my own domain, that even works with SSL and the usual encryption stuff. Granted, data is not (yet) stored encrypted at rest, but at least it's on my own VPS! On Lineage, install [DAVx5](https://www.davx5.com/) - it integrates nicely with the default calendar app. I also rely on [ICSx5](https://icsx5.bitfire.at/) to sync my academic calendar using a `.ics` link. Both work perfectly. 

### Privacy-aware cloud syncing

If you must use data syncing using a third party cloud such as iCloud/Google Drive/Dropbox, you still can. Simply use [Cryptomator](https://cryptomator.org/) and encrypt everything client-side before sending it to the server. There are mobile clients available, and although it is a bit on the heavy side, it works. 

For me though, I decided against using it. My photos are _not_ synced, and I like that now. When I want to transfer something to another machine, I simply share locally through Bluetooth or using the nice [OpenMTP](https://openmtp.ganeshrvel.com/) Android File Transfer app for MacOS.

### Others

![](../lineage-bandcamp.jpg "Looks a lot like stock Android!")

A few other apps I regularly use that worked flawlessly on LineageOS:

- Firefox Mobile with the [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) plugin
- Goodreads
- [FreeOTP](https://freeotp.github.io/)[^otp]
- Bandcamp ([You Shouldn't Use Spotify](/2021/02/you-shouldnt-use-spotify/))
- Spotify (Don't believe everything I write)
- [AnySoftKeyboard](https://anysoftkeyboard.github.io/)

[^otp]: Backup your settings before reinstalling your phone! I locked myself out of my Paypal account because of that... 

After stress testing LineageOS for two weeks, I can safely say I'm impressed. Even the battery life somewhat improved. Granted, I am not a heavy smartphone user. I hate carrying the thing around and sometimes "forget" it, much to my wife's frustration. But still - I thought getting rid of Google Calendar and others would involve more headaches. I have deleted most e-mails, all my photos, calendar items, and contacts from my Google account, and have not regretted it once. However, _do not delete your entire Google account_. It now serves as a good spam e-mail address! Give those pesky car salesman your GMail address and they'll think they've got you. Ha!

If you also experimented with the OS, let me know what you think of Lineage. Which programs did not work that well? Did you experience any trouble with the Google withdrawal plan? [Toot me](https://chat.brainbaking.com/@wouter)!
