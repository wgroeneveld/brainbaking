---
title: "486 Upgrade 2: The SD Card HDD"
date: '2020-09-23'
subtitle: "Getting tired of loud hard drives? Here's a flash solution."
tags:
  - 486
  - retro
categories:
  - hardware
---

The [revived 486 PC](/post/2020/09/reviving-a-80486/) came with a Conner CFS210A `213` MB hard drive. As mentioned then, I like _silent_ computers, so the first thing I did was flick out the low-end 12V PSU fan. That improved next to nothing thanks to the old HDD that seemed to take of as soon as the power switch was flipped. Next to the noise problem, a more pressing issue appeared: after a week of fiddling with the PC, things started crashing. It got worse: `COMMAND.COM` and master boot record stuff broke, requiring a boot floppy in order to access files on the hard drive. 

`CHKDISK.EXE` ran for hours, fixing broken files and sectors here and there. I was hopeful. Rebooting successfully started DOS but spewed a whole lot of errors: most games and windows refused to work. It turns out that the "repaired" files were gone missing. The perfect time to throw out the noisemaker and take a closer look at flash alternatives. The popular Compact Flash to IDE adapters come with a metal bracket, making it easy to install. But who uses CF nowadays? SD to IDE adapters with chips that convert the signal are cheap on eBay, and my old MacBook Air has a native SD slot, making the decision easy for me.

![](../sdhdd.jpg "IDE adapter (left), 12V adapters (down), 8GB SD card (right).")

The aluminum case is custom-made by my father-in-law and allows me to install the "drive" as any other external device: through the front of the PC case. 

Unfortunately, this 486 upgrade was not a simple plug-and-play case... 

### Problem 1: Recognizing and formatting

How many cylinders, heads and sectors per track does an SD-to-IDE adapter have? The AWARD BIOS of course failed to auto-detect the adapter and I had no idea what to enter. Google ushered me to [WHATIDE.COM](https://archive.org/details/whatide), a small utility that reports the hard drive geometry. 

`FDISK` allowed me to create `500MB` partitions, while in theory, DOS 6.22 can handle up to `2GB` in `FAT16`. Apparently, older motherboards - like mine - do not support this. According to VOGONS, [Dynamic Drive Overlay](https://www.vogons.org/viewtopic.php?f=61&t=42113) software such as _Ontrack Disk Manager_ (downloadable at [Phils Computer Lab](https://www.philscomputerlab.com/ontrack-disk-manager.html)) fixes this by tricking the BIOS into thinking it's a small HDD, while in fact it can contain several partitions of `2GB` (four times: my SD card is `8GB`). Other retro PC bloggers experimented with fast SD cards and concluded that you're limited to the bus speed anyway, so don't fret on which SD card to use. 

![](../ontrack.jpg "A fancy Disk Manager splash screen greets you on startup.")

The Disk Manager creates a special MBR "overlay" that fools the BIOS. This means that booting from floppy's through the conventional BIOS system will not work as the HDD cannot be mounted without knowledge of this system. If floppy booting is desired, Ontrack gives the user two seconds to jam spacebar on time. So, booting through A: means booting through C: and pressing space. Still following? Good. More problems ahead. 

### Problem 2: Reinstalling DOS

Advices such as "[Configuring MS-DOS Properly](https://www.cubic.org/docs/configuring.htm)" that dictate what to put in `CONFIG.SYS` and `AUTOEXEC.BAT` have to wait: my DOS floppy's refused to be recognized as proper installation disks. _Please insert disk 1_. It's in there, take a better look! (Presses Enter). _Please insert disk 1_. Argh!!

It turns out that the label needs to be _exactly_ "DISK (SPACEx6) 1" (six hard spaces). Renaming did not work, low level disk image writers on *NIX systems such as `dd` did not work. Only [WinImage for Windows](https://www.winimage.com/winimage.htm) successfully revitalized the floppy's and allowed me to finally install an OS. 

### Problem 3: Mounting the SD on modern systems

Sadly, OSX did not recognize the SD card. Only after a few hours of cursing I started realizing the dynamic drive overlay could be the culprit. VOGONs to the rescue (again): user ozzmosis was able to mount his card using the `offset` parameter, thereby skipping the special MBR and jumping directly to the `FAT16` partition itself. 

I coupled `mount` with [unison](https://github.com/bcpierce00/unison), a two-way command line synchronization tool that backs up the whole HDD contents to a Dropbox directory. That way, my OSX and Windows machines **can** in fact access the 486 files. My first thought, `rsync`, is problematic with two-way syncing and file-deletion. I use the following script:

```
sudo mount -t vfat -o offset=64512,noexec,rw,umask=0000 /dev/sdb /mnt
sudo unison -auto -perms 0 /mnt/ /home/wouter/Dropbox/486/
sudo umount  /mnt
```

I ended up deleting the three other partitions on the SD card, as `2GB` is more than any DOS user would ever want, and I had trouble looking up the exact offsets of the other partitions. 

This is what the (open) PC case looks like now:

![](../pccase.jpg "The PC Case, after installing the SD-to-IDE front slot.")

I was a bit too quick taking that photograph as things were getting cramped: the IDE cable of the adapter seemed to push against the spinning header of the floppy drive, preventing floppy's to be read. The issue was resolved after flipping both drives. 

Now all that is left is adding a nice retro `1"` [doming sticker](https://www.domingfactory.nl/vierkante-doming-sticker) on the case! And I will keep an eye out on garage sales for that eighties `5.25"` floppy drive...
