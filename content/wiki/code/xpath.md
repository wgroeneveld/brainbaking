+++
title = "xpath"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "xpath"
]
date = "2013-03-12"
+++
# Xpath snippets 

## Nuttige Xpath functies 

##### contains 

```
*div[@role='listbox' and not(contains(@style, 'display: none'))]*li[1]
```

##### not 

Is dus een functie en geen operator in xpath! Zie boven

##### starts-with 

zie `contains()`

##### true 

Iets dat altijd waar is.

## Finding Elements by Content 

```xml
//*[.='cat']
```

Haal alle elementen op die de tekst cat bevatten. Gebruik dus *.=*<br/><br/>
Meer info op: http://www.exampledepot.com/egs/org.w3c.dom/xpath_GetElemByText.html

## Tag attributes afgaan 

```xml
//img[@src='bla.png']
```

Meestal wil je slechts een deel van die source hebben, dan de functie `contains()` gebruiken.<br/><br/>
Meer info ivm **functies** op: http://www.w3schools.com/Xpath/xpath_functions.asp 

##### Kind selecteren 

Verder gaan met tweede selector:

```
*div[@id='bla']*input
```

= Selecteer alle inputs onder een div met ID `bla`.

## Snel Xpath expressies testen in Firefox 

Kan met deze plugin: [Xpath checker](https://addons.mozilla.org/en-US/firefox/addon/1095)