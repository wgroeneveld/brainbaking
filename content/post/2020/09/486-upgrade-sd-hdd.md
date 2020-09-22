---
title: "A 486 Upgrade: The SD Card HDD"
date: '2020-09-23'
concept: true
subtitle: "Getting tired of loud hard drives? Here's a flash solution!"
tags:
  - retro
  - hardware
categories:
  - braindump
---

```
sudo mount -t vfat -o offset=64512,noexec,rw,umask=0000 /dev/sdb /mnt
sudo unison -auto -perms 0 /mnt/ /home/wouter/Dropbox/486/
sudo umount /mnt
```

[unison](https://github.com/bcpierce00/unison)

[Configuring MS-DOS Properly](https://www.cubic.org/docs/configuring.htm)

Floppy disk image writer: [WinImage for Windows](https://www.winimage.com/winimage.htm) or simply `dd` on *NIX systems (that did not work properly for some reason: the MS-DOS installation did not recognize disk 1, even with the six hard spaces in the name)