+++
title = "freebsd"
draft = false
tags = [
    "unix",
    "freebsd"
]
date = "2013-03-12"
+++
# FreeBSD 

:exclamation: Manual waar alles instaat: http://www.freebsd.org/doc/handbook/ports-using.html

## Partitioning 

### chunk 'ad1s4 ;ad1s2 ,ad1s3 does not start on a track boundary 

Negeren, verder gaan door op OK te drukken. Wil zeggen dat er nog een partitie voor de huidige master staat (windows wss) die leeg is en niet in bounds zit. Ge kunt hier niet iets tussen steken, dan begint het paritioning systeem 3 aparte stukken aan te maken. 

Pas wel op met aanmaken van partities:
  1. ad0 is HDD1, dus ad0s0 is partitie 1
  2. da0 is SCSI1 (emu), dus waarschijnlijk een USB poort

[Meer informatie over disk organisation in FreeBSD](http://www.freebsd.org/doc/handbook/disk-organization.html)

