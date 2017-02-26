+++
title = "packages"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "python",
    "packages"
]
date = "2014-03-05"
+++
# Package Management 

Pain in the ass. Geen built-in beschikbaar, gebruik **pip**. Zie http://stackoverflow.com/questions/4750806/how-to-install-pip-on-windows

Installatie (windows dan) - let op, hangt zelfs van minor versie van python af:

  1. Install setuptools http://www.lfd.uci.edu/~gohlke/pythonlibs/#setuptools
  2. Install pip http://www.lfd.uci.edu/~gohlke/pythonlibs/#pip

Alternatief: grab [get-pip.py](https://raw.github.com/pypa/pip/master/contrib/get-pip.py) en laat evalueren door python, haalt automatisch ook setuptools af. 

Vanaf dan `pip install [package]` (voeg python base dir/Scripts toe aan uw `PATH`). Packages worden dan (als binary) ook in de scripts folder gedownload. 

##### Upgrades uitvoeren 

> To upgrade an existing setuptools (or distribute), run pip install -U setuptools