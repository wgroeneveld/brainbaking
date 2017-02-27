+++
title = "edwin-shortcuts"
draft = false
tags = [
    "code",
    "scheme",
    "edwin-shortcuts"
]
date = "2013-03-12"
+++
# MIT-Scheme Edwin shortcuts 

Afkortingen: C ###### Control, M  ALT (don't ask...)

### File manipulatie 

| **afkorting** | **gevolg** |
| C-X s  | save alle open files van alle buffers (vraagt per buffer...) |
| C-X C-S | save zonder vragen |
| C-X C-F | find file of open nieuwe onbestaande (enter drukken = in buffer files browsen) |

### Buffer stuff 

| **afkorting** | **gevolg** |
| C-U C-V | repeat last command |
| C-C C-C | break operation ('Quits') - in case of unlimited iterative recursive loop |
| C-X [hoedje] | vergroot huidige buffer met één lijn |
| C-X (getal) | open (getal) aantal buffers |
| C-X o | toggle buffer (visible) |
| C-X b | switch buffer met naam |
| C-X k | kill buffer (vraagt evt bevestiging) |
| M-o | evaluate buffer contents |
| C-J | indent bij nieuwe line |
| TAB | indent huidige regel (<> tab x lijnen prepended) |
| C-X h | selecteer de hele buffer inhoud |

:exclamation: Vergeet niet dat het nodig is om een file te saven in een andere buffer als ge `load()` gebruikt en die probeert te evalueren, zoals bijvoorbeeld een unit test... 

### Text manipulatie etc 

| **afkorting** | **gevolg** |
| C-A | ga naar begin lijn |
| C-K | kill line |
| M-W | copy selected |
| C-<space> | select stuff |
| C-Y | niet yank maar paste... Jup. |
| C-X u | undo (stackable) |