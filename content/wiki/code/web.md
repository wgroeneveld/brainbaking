+++
title = "web"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "web"
]
date = "2013-03-12"
+++
# Website Styles 

## Quick Links 

  * http://htmldog.com/
  * http://www.alistapart.com/


### CSS Stuff 

  * :exclamation: http://lesscss.org/ - Less.js Will Obsolete CSS! `LESS` implementatie in Javascript
  * http://www.andybudd.com/ CSS centered blog

#### Centering a div met margin auto 

Zie http://www.andybudd.com/archives/2004/02/css_crib_sheet_3_centering_a_div/

```css
body {
	text-align: center;
	min-width: 600px;
}

#wrapper {
	margin:0 auto;
	width:600px;
	text-align: left;
}
```

#### Spaties tussen een link en bovenstaande blocks 

Gegeven structuur:

```html
<div clas="div">
  <a href######"#" clas"link">bla</a>
</div>
```

Hoe kan ik de div vergroten zodat die de link bevat maar de link zelf `margin-top` bevat? zo:

```css
.div a .link {
  display: block;
  margin-top: 10px;
}
```

Zonder `display: block` wordt een link als `inline` gerenderd. Inline betekent alles naast elkaar. Zie http://www.quirksmode.org/css/display.html