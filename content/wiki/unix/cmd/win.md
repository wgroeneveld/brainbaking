+++
title = "win"
draft = false
tags = [
    "unix",
    "cmd",
    "win"
]
date = "2013-04-05"
+++
# Windows stuff 

#### list processes 

Te doen via:

  * `tasklist`
  * `wmic process get [caption/commandline/...]`
  * `wmic process list | more`

#### Kill specific process 

##### By window title 

`taskkill /F /FI "WINDOWTITLE eq Administrator:  STUBS"`

:exclamation: er zijn TWEE SPATIES tussen Administrator en uw eigenlijke title. Hoe zet je dan die title in een bat of cmd file? 

`TITLE STUBS`

##### By commandline 

Stel: een `java` proces draait met een bepaalde jar, maar je weet niet welke je moet afschieten omdat er nog een server draait. Oplossing: zoek op commandline:

`wmic process where (commandline like '%stubs.jar%') delete`

:exclamation: het `%` teken moet je escapen in een cmd of bat file omdat dit blijkbaar iets met argumenten te maken heeft (wuh?). Dit doe je door er 2 naast elkaar te plaatsen: `like %%stubs.jar%%`