+++
title = "serverside"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "serverside"
]
date = "2013-03-12"
+++
# JS Serverside draaien 

### JS Server Parsers 

#### Java: Rhino 

Vooral gericht op serverside integratie met bijvoorbeeld Java EE.

Zie http://www.mozilla.org/rhino/

#### C++: Google V8 

Wordt bijvoorbeeld gebruikt in __Google Chrome__.

Zie http://code.google.com/p/v8/

-> Ook via CLI aan te spreken in .NET - zie http://jint.codeplex.com/

#### C: SpiderMonkey 

Wordt bijvoorbeeld gebruikt in __Mozilla Firefox__.

Zie http://www.mozilla.org/js/spidermonkey/

### Headless DOM Manipulatie 

Omdat serverside Javascript geen `window` object als toplevel scope bestaat, kunnen we ook geen DOM manipulatie uitvoeren. Er is hier echter een oplossing voor, bovenop bijvoorbeeld Rhino: `env.js`. Meer achtergrondinfo is hier te vinden: http://ejohn.org/blog/bringing-the-browser-to-the-server/

Envjs is een laag die het mogelijk maakt om aan de serverkant zelfs aan **screen scraping** te doen, door bijvoorbeeld:

```javascript
window.location = 'http://www.google.com';
var wowContentsAreAwasom = jQuery('#interesting').html();
```

Dit zónder de browser effectief open te hebben! Dit is ook makkelijk voor **test integratie**, bijvoorbeeld __QUnit__ testen met integratietesten die DOM manipulatie uitvoeren, te integreren in de build. Aangezien een Ant build Java is, kunnen we Rhino gebruiken samen met Envjs om de QUnit testen te runnen, en met een aangepaste report generator dit zelfs als JUnit test report te outputten. 