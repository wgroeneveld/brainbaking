+++
title = "home"
draft = false
tags = [
    "code",
    "python",
    "home"
]
date = "2014-03-05"
+++
# Python 

```python
class Pythonic:
    `'I can access this doc using instance.__doc__, holy cow?`'
    def __init__(self, arg, *args, **dict):
        pass
```

:flushed:

> The `pass` statement in Python is like a empty set of curly braces (`{}`) in Java or C.

## Simpele server opstarten 

Waarom? Om **lokale files** makkelijk te kunnen serven (handig voor JS)

```
python -m SimpleHTTPServer 8080
```

Poof.

## Python 2 vs 3 

  * in py3 is `print` een functie geworden, gebruik dus `()`
  * de `SimpleHTTPRequestHandler` klassen ea zijn verhuisd naar `http.server`, gebruik `from http.server import SimpleHTTPRequestHandler, HTTPServer`
  * `super()` kan zonder argumenten gebruikt worden