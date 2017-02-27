+++
title = "troubleshooting"
draft = false
tags = [
    "code",
    "javascript",
    "troubleshooting"
]
date = "2013-03-12"
+++
# JS Troubleshooting 

## Debugging 

### Gecko 

Slechts één adres nodig: http://getfirebug.com/

### Internet Explorer 

#### < IE 6 #####

De "officiële" web developer toolbar in IE6 kan totaal niets met javascript debugging aanvangen. Hiervoor gebruik je best "web development helper": http://projects.nikhilk.net/WebDevHelper - Die maakt het mogelijk om JS statements uit te voeren en normaal gezien fatsoenlijke error logging uit te voeren. HTTP calls (zoals ajax) loggen gaat hier ook mee. 

:exclamation: Een voorwaarde om het bovenstaande te laten werken is "**disable external script debugging**" uitzetten in IE via: Extra > Options > Advanced > Surfing > "foutopsporing in scripts uitschakelen" uitvinken.

Via de Microsoft Script Debugger (zonder een toolbar te installeren maar toch script debugging te enablen) kan je ook bekijken op welke lijn de fout zich voordoet: wanneer er een fout in IE tevoorschijn komt, druk op "start debugging" en klik op "OK" om een nieuw profiel te starten. De regel waar de cursor op staat is het "probleemgeval". 