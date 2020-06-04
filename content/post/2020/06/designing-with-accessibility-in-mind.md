---
title: "Designing websites with accessibility in mind"
date: '2020-06-04'
subtitle: "A little bit of effort makes your site more inclusive for everyone."
tags:
  - webdesign
  - accessibility
---

In my last post about [webdesign](/tags/webdesign) called "[tracking and privacy on websites](post/2020/06/tracking-and-privacy-on-websites/)", I ended with a list of things you need to take into account when building a website - of which **accessibility** is one that is most often overlooked. Something I'm also guilty of. Here's my report of an effort to open up Brain Baking for everyone and to learn how to design websites with accessibility in mind.

### 1. Use Semantic HTML5 tags

This might not come as a shocker to anyone, but it's still not that frequently applied, sadly. Most bootstrap-based websites are just a pile of `<div/>` and `<span/>` containers chunked together with some CSS styling thrown on top. A template or downloaded theme might be rendered as:

```html
<div class='topbar'>
    <span class='link'>
        <a/>
    </span>
</div>
<div class='container'>
    <div class='sect1'>bla at today</div>
    <div class='txt' style='text-align: justify;'>hello</div>
    <div class='meta'>more related stuff</div>
</div>
<div class='copyright'>Brain baking</div>
```

Instead of relying on `display: block`, write something like this:

```html
<nav>
    <ol>
        <li><a/></li>
    </ol>
</nav>
<main>
    <header>bla <time>at today</time></header>
    <article>hello</article>
    <article>more related stuff</article>
</main>
<footer>Brain baking</footer>    
```

The structure stays the same, but the elements change. The end result is exactly the same in your conventional browser, but it's easier to crawl by search engines - and especially software for people with disabilities. 

Other things to keep in mind:

- Use `<button/>` when it's a button, not a link. `aria-label` is there for hidden labels such as the sandwich nav-button for mobile browsers on this site.
- Use labels in forms. Avoid use of placeholder values to label or explain input. 
- etc...

### 2. Respect headings and paragraphs

Also easy to achieve! Just like I promised: making your website accessible for everyone is just a matter of keeping a few extra rules in mind. Just like a Word or LaTeX document, when writing an article or paper, you start with your header. That's a `<h1/>` tag. Subheader? `<h2/>`, and so on. Do not skip a number! Wrap paragraph text in a simple `<p/>` tag.

My templates contained a lot of header tags just to get the font size right. Obviously, that is _wrong_: use the `font-size` CSS property if you really need to. That meant I regularly jumped from `<h2/>` to `<h4/>` just for styling purposes. 

### 3. Think about contrast

Style a link as a link: with `text-decoration: underline`! Remember that it will otherwise be hard to tell the difference between a link and just text, even if the color is (slightly) different or if it's in bold. Not everyone will see the difference. Of course you can make exceptions in the navigation bar. 

Chrome Dev Tools makes it very easy to check whether the color you've employed has enough contrast. It will take background colors, font size, and font weight into account. In the Elements tab, inspect an element and filter the Styles tab to the right on 'color'. Click on the color to inspect the calculated contrast:

![](../contrast.jpg "The contrast ratio 4.58 is OK according to the standards.")

Furthermore, also deliberately think about your font styling and sizing. Fonts should have a `font-display: swap` CSS attribute to avoid flickering (or not rendering if a `.woff2` file fails to load). Since monitor resolutions are higher than ever, why should you be stuck with `font-size: 12px`? Don't use hard-coded `px` or `pt` but use relative `em` and `rem`, and keep "14pt" as a reference for desktop browsers. I detest websites that still have this incredibly small hard-to-read font that hurts even my eyes.

### 4. About images... Use `<figure/>`

I guess it's unnecessary to emphasize the use of the `alt` attribute in case anyone cannot see the images or they do not get loaded. This does not have anything to do with accessibility, but is almost never filled in (at least by me, whoops). HTML5 comes with a `<figure/>` tag that finally makes it easy to include a caption - like we're so used to do in LaTeX - using the `<figcaption/>` tag.

However, in my article source, which is in Markdown `.md` files, the standard way of including an image is:

```md
![alt text](img.jpg "title")
```

And since I did not want to pollute the files with Hugo shortcodes, I came up with an alternative, thanks to [this blog post from godo.dev](https://www.godo.dev/tutorials/hugo-image-figure-wrap/):

```html
<article>
  {{ $reAltIn := "<p><img src=\"([^\"]+)\" alt=\"([^\"]*)\" /></p>" }}
  {{ $reAltOut := "<figure><a href=\"$1\" class=\"lbox\"><img src=\"$1\" alt=\"$2\"></a></figure>" }}
  {{ $altContent := .Content | replaceRE $reAltIn $reAltOut | safeHTML }}

  {{ $reAltTitleIn := "<p><img src=\"([^\"]+)\" alt=\"([^\"]*)\" title=\"([^\"]+)\" /></p>" }}
  {{ $reAltTitleOut := "<figure><a href=\"$1\" class=\"lbox\"><img src=\"$1\" title=\"$3\"></a><figcaption>$3</figcaption></figure>" }}
  {{ $finalContent := $altContent | replaceRE $reAltTitleIn $reAltTitleOut | safeHTML }}

  {{ $finalContent }}
</article>
```

It effectively replaces any generated `<img/>` tags with `<figure/>` wrappers, also including a link and a class that helps my lightbox script function the way it should. You can see the result for yourself in the image above, with caption. If you use a `title` attribute, the `alt` attribute can be skipped. 

### 5. Inspect your site - without CSS and JS.

The Opera plug-ins ".no { CSS }" and "JavaScript toggle On and Off" make it easy to do that with two button clicks. The result - after modifications, of course - is this:

![](../nocss.jpg "This article viewed without CSS and JS.")

I'm getting this sudden 1995 retro vibe, don't you? Now why on earth would you go back to this look? Because if you don't, you won't know how it looks like for special browsers that help people with disabilities navigating the Internet. For example, my `<svg/>` icons did not contain native `height` and `width` attributes, and their `viewBox` said "make it big!" but my CSS said "no no, keep things small". Without CSS, things get ugly pretty fast... 

Also, what doesn't get loaded without JavaScript? Cookies broke? Form submission gone to hell? In my case, article comments served from Commento will not load, and for the moment I think that's unavoidable, unless I come up with a form of static caching that is currently not provided. 

### 6. Don't know what to alter? Use analysis tools.

Besides the websites [www.webaccessibility.com](www.webaccessibility.com) and the [WAVE web accessibility evaluation tool](https://wave.webaim.org), there's actually something better, and it's again built-in into DevTools: it's called **Lighthouse**, and can be booted up in the "Audits" tab. Lighthouse will also tell you what to alter to speed up things, so it's not an "accessibility-only" tool.

![](../lighthouse.jpg "A Lighthouse report on a Brain Baking article")

Sadly, scoring more than `65%` on accessibility is proving to be difficult, since most issues come from Commento's lack of form labeling and usage of `alt` in avatar images. At least I'm no longer flunked!
