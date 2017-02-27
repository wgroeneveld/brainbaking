+++
title = "jquery"
draft = false
tags = [
    "code",
    "javascript",
    "frameworks",
    "jquery"
]
date = "2013-03-12"
+++
# Jquery 

## Eigen CSS filters maken 

```javascript
$.expr[':'].external = function(elem,index,match) {
    var url = elem.href || elem.src,
        loc = window.location;
    return !!url.match(new RegExp('^' + loc.protocol + '//' + '(?!' + loc.hostname + ')' ));
};
 
// You can now use it within your selectors:
 
// Find all external anchors:
$('a:external');
 
// Find all external script elements:
$('script:external');
 
// Determine if link is external:
$('a#mylink').is(':external'); // true/false
```

Via [Things you may not know about jQuery](http://james.padolsey.com/javascript/things-you-may-not-know-about-jquery/)


## Data meegeven aan events 

```javascript
for(myObj in myObjects) {
  $('.tr').bind('click', myObj, function(e) {
     e.data.doeIets(); // .data ##### myObj
  });
}
```

Werkt ook voor `live()`.