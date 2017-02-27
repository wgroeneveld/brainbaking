+++
title = "vi"
draft = false
tags = [
    "unix",
    "vi"
]
date = "2013-03-12"
+++
# Vi(m) tips & tricks 

### Externe tutorials en manuals 

  * http://www.aip.de/~weber/doc/gs/node137.html - short basic editing intro
  * http://www.cs.fsu.edu/general/vimanual.html - full vi manual
  * http://hea-www.harvard.edu/~fine/Tech/vi.html - complete key binding guide

  * http://vim.wikia.com/wiki/Word_wrap_without_line_breaks -> Zeer goede Vi wiki
  * http://www.oualline.com/vim-cook.html

Dé Vi Man page: http://vimdoc.sourceforge.net/htmldoc/help.html

### Basic editing 

^ Command      ^ Function ^
| e | start editing mode @ cursor position |
| a | start editing mode @ AFTER cursor position |
| R | start replace mode @ cursor position |
| ! | override command by forcing |
| u | undo |
| U | undo everything without changing line |
| redo | redo last change |
| ~ | change case upper/lower |
| w | move cursor to beginning of next word |
| b | move cursor to beginning of previous word |
| [x]w/b | move cursor to beginning/end of xth word |
| % | move cursor to matching bracket (waar cursor op staat, bvb {} in java) |
| 0 | move cursor to beginning of current line |
| $ | move cursor to end of current line |
| G | move cursor to end of current file |
| [x]G | move cursor to xth line of current file |
| CTRL+F | move cursor page forward |
| CTRL+B | move cursor page backward |
| d$ | delete everything from cursor to end of line |
| dG | delete everything from cursor to end of file |
| :q | quit window (CTRL+C) |
| :q! | force quit without save |
| :w | save file |
| :x | quit with save |

:exclamation: Restarten van editing mode force-override (`:e!`) alle changes aan de huidige file, handig als "undo all".

Undo werkt als een toggle tussen undo en redo in Vi compatible, maar in Vim *stackt* dit. <br/><br/>
`uu` maakt dus in Vim 2 wijzigingen ongedaan, maar in Vi "undo" de "undo" (dus nul-operatie).


### Faster bash editing & testing in Vi 

Makkelijker om tijdens het editeren van een scriptje het direct te kunnen testen zonder de vi editor te verlaten, juist? <br/><br/>
Dit is mogelijk met:

```:! [command]```

Om de output te pasten in de editor ergens, gebruik `:r! [command]` ((`:r` paste de inhoud van een bestand in de editor zonder !)) .<br/><br/>
Om tijdelijk de editor te verlaten en terug te keren naar een shell, gebruik `:shell`. Terug switchen kan door uit te loggen met `exit`, zodat je terug in de editor terecht komt zoals je ze verlaten hebt. 

### Visual mode and formatting 

Vi kan automatisch geselecteerde lijnen formatteren (indent) met "`######`". Hiervoor moeten in visual mode (`SHIFT+V`) x aantal lijnen geselecteerd worden (pijltjes naar boven/beneden in visual mode auto-select die lijnen). Om uit visual mode te gaan, `SHIFT+G`. Druk daarna op ``. 

Combinatie om alles te selecteren en formatteren: `ggVG=`:
  1. `gg` ga naar begin van file
  2. `V`: (hoofdletter) enter visual mode
  3. `G`: (hoofdletter) exit visual mode, op zelfde lijn = selecteer alles
  4. `=`: formatteer heel de boel.

### Multi-file editing 

Laat vi meerdere files editeren door `vi [file1] [file2] ...` uit te voeren. Edit alle files in current path door `vi *`.

### Finding stuff 

^ Command      ^ Function ^
| / | type a query and press enter to find something |
| ? | type a query and press enter to find something |
| n | zoek volgende gevonden item |
| N | zoek vorige gevondenn item | 

Find & replacing:

```:%s/[search pattern]/[replace pattern]```

Vervangt in alle files.

#### Switchen tussen files 

Open files list = "*buffer*" in Vi.

^ Command      ^ Function ^
| :ls of :buffers | show open buffers (zie onder) |
| :reg | show open buffers én verwijderde/vroeger aangemaakte (0-9) |
| :e [file] | add file to buffer list |
| :n | goto next file in list |
| :b [file] | switch to next file ((with TAB autocompletion: zet `set wildmenu` in `.vimrc`)) |
| :b | switch to last visited file |
| :[x]b | switch to xth file |
| :bp | switch to previous buffer |
| :bn | switch to next buffer |
| CTRL+SHIFT+6| switch to next buffer in row |

`:ls` ziet er zo uit:

```
  1 %a   "./checkin.pl"            line 1
  2 #    "./grabakamailogs.pl"     line 1
  3      "./grabwmlogs.pl"         line 0
```

`%` toont huidige actieve file, `#` toont alternatieve. 

#### Tegelijkertijd bekijken van files 

^ Command      ^ Function ^
| CTRL+W v  | split into tabs vertically |
| CTRL+W s | split into tabs horizontally |
| CTRL+W c | close current window |
| CTRL+W o | close all windows but active |
| CTRL+W up | focus upper window |
| CTRL+W down | focus lower window |
| CTRL+W _ | maximize current window |
| :[x]sb | switch to xth file in buffer using split windows |

#### Open file sessies bewaren in Vi 

Bewaar een huidige sessie met x open buffers:

```:mksession! ~/today.ses```

Terug openen van die sessie:

```vim -S ~/today.ses```

### Command History window 

Het beu om constant hetzelfde commando in te typen? Voer een eerder uitgevoerd commando uit, zoals `history` in bash! Hoe? http://vim.wikia.com/wiki/Using_command-line_history

  * **Search history**: `/ [CTRL+F]` of `q/`
  * **Command history**: `: [CTRL+F]` of `:q`
  * Begin met slash of dubbelpunt en gebruik pijltjes om te scrollen in history
  * `:his` geeft een kort overzicht zonder een apart window te openen

Hierin kan je ook weer commando's zoals zoeken binnen het history window gebruiken! om dit te sluiten, zelfde als sluitshortcut window (`:q`).

### .vimrc preferences 

#### Command history vergroten 

```
:set history=1000
```

#### Shortcut keys mappen 

voorbeeld:

```
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
```

### Boeiende plugins 

  * Jasmine JS Vim: https://github.com/claco/jasmine.vim
  * Vim Coffeescript hilighting: https://github.com/kchmck/vim-coffee-script
