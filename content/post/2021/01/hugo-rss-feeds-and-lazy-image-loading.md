---
title: RSS Feeds, Hugo, and Lazy Image Loading
subtitle: Where's my content? It's a tarp!
date: 2021-01-05
tags:
  - hugo
  - rss
keywords: [hugo, rss, lazy image loading, lazy loading, rss images, hugo rss images, hugo noscript]
categories:
  - webdesign
---

## Full RSS Content in Hugo

Just a quick one I wanted to get out there in case you are, like me, using [Hugo](/post/2020/05/hugo-extended/) to power a blog. Apparently, in 2017, the default [behavior changed](https://discourse.gohugo.io/t/full-text-rss-feed/8368/3) from using the `.Content` to the `.Summary` variable in the default [rss.xml](https://github.com/gohugoio/hugo/blob/master/tpl/tplimpl/embedded/templates/_default/rss.xml). 

---

**Update, 12 March 2021**: This article officially became obsolete! Just use `loading="lazy"` - a lot less complicated and already [decent browser support](/notes/2021/03/12h18m06s14/). Yay for upgrades!

---

What's the big deal? I had no idea, until I started using a proper RSS reader today - the open source [NetNewsWire](https://ranchero.com/netnewswire/) for Mac. This is what your RSS feed will look like:

![](../netnewswire.jpg "My Apple M1 article in an RSS reader. Where's all the text?")

The above screenshot might mislead you into thinking I simply captured only a part - I did not. That's the `.Summary`, right there. Since reading all "the news" in one place sounds intriguing, and I'd like other visitors to enjoy my _full_ blog posts in these tools too, I'd have to change the default behavior. That can be easily done by copy-pasting the default into `layouts/_default/rss.xml` and altering it to your liking - such as swapping `.Summary` for `.Content`.

However, that brings us to to problem number two.

## Lazy loading and RSS Feeds

Recently, after trying to maximize my [Lighthouse](https://developers.google.com/web/tools/lighthouse/) score, especially on performance levels, I implemented [lazysizes](https://github.com/aFarkas/lazysizes), a simple solution to lazy load `<img/>` tags, thereby reducing the critical path for a single page to load. That requires a custom `render-image.html` (only available when using the Goldmark Markdown renderer) in `_default/_markup/` that looks like this:

```html
<figure>
    <a href="{{ .Destination | safeURL }}" class="lbox">
        <noscript>
            <img src="{{ .Destination | safeURL }}" {{ with .Text }} alt="{{ . }}"{{ end }} {{ with .Title}} title="{{ . }}"{{ end }}>
        </noscript>     
        <img class="lazyload" data-src="{{ .Destination | safeURL }}" {{ with .Text }} alt="{{ . }}"{{ end }} {{ with .Title}} title="{{ . }}"{{ end }}>
    </a>
    {{ with .Title }}
        <figcaption>{{ . }}</figcaption>
    {{ end }}
</figure>
```

Do not forget the `<noscript/>` tag in case JavaScript is disabled or the visitor will not see any images![^tip] Same goes for the RSS feed: your `index.xml` that NetNewsWire loads will see an image tag, but not a `src` attribute. To fix that, I replaced the content, like so:

[^tip]: Try it your for yourself by disabling JS in your browser. Your blog should be accessible to anyone - no CSS, no JS, [accessibility options](/post/2020/06/designing-with-accessibility-in-mind/) - try to include everyone.

```html
{{ $lazyLoadImg := "<img class=\"lazyload\" data-src=" }}
{{ $eagerLoadImg := "<img src=" }}
{{ $content := .Content | replaceRE $lazyLoadImg $eagerLoadImg | safeHTML }}      
<description>
  {{ $content }}
  ]]>
</description>
```

I know the documentation mentions `render-image.rss.xml` as a separate RSS renderer, but it [as reported](https://discourse.gohugo.io/t/how-does-render-image-rss-xml-work/29935) before, it currently does not work (v0.79.1).

**Update, 9 Jan. 2021**: It seems that the RSS reader [Feedly](https://feedly.com/) processes `<noscript/>` tags, resulting in two displayed images instead of one. Another `replaceRE` to replace the tag fixes that, although it's starting to get messy... 

## Featured images in RSS feeds

I still wasn't satisfied. Some blog posts use a "big image" (or "featured image" masthead), that is part of the article header, and is currently not shown in the RSS reader. After inspecting the RSS specifications, it seems that a `<img/>` tag in the description is the only way to do it (provided a `CDATA` wrapper is present), as opposed to twitter cards that have a dedicated tag for this. So, the above description tag was extended, and now looks like this:

```html
<description>
  {{ `<![CDATA[ ` | safeHTML }}
  {{ if .Params.bigimg }}
    <p>
      <img hspace="5" src="{{ $baseurl }}bigimg/{{ .Params.bigimg }}"/>
    </p>
  {{ end }}

  {{ $content | safeHTML }}
  ]]>
</description>
```

Let's inspect the changes with our RSS reader:

![](../netnewswire2.jpg "Yes, a featured image and the rest of the text!")

Scrolling down also reveals properly loaded images, hooray! Do not forget to add feed metadata to the `<header/>` tag so that NetNewsWire can automatically detect the location of your RSS feed:

```html
<link href="{{ .RelPermalink }}" rel="alternate" type="application/rss+xml" title="Brain Baking" />
<link href="{{ .RelPermalink }}" rel="feed" type="application/rss+xml" title="Brain Baking" />
```

[Enjoy my RSS feeds](/subscribe)!
