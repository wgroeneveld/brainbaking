---
title: "Hugo Extended: More static site processing power!"
date: '2020-05-15'
subtitle: "Sass, Transpiling, Search functionality - what's not to like?"
aliases:
  - /post/hugo-extended/
tags:
  - hugo
  - babel
  - sass
categories:
  - webdesign
published: true
---

This week, Hugo `0.7` has been released. And while it's a minor release, it's nonetheless something to be excited about: finally a `babel` pipeline is available. That means transpiling new ES6+ JS code to older compatible versions is now possible as part of your Hugo buildchain! I took the opportunity to redesign one of my websites, [redzuurdesem.be](https://redzuurdesem.be), and leveraged a few new (at least to me) Hugo features that make designing and developing a (static) website a lot more pleasant. I would like to give an overview of things I've successfully used - and hopefully will make it into Brain Baking someday! 

### Sass

The [Sass language](https://sass-lang.com/guide) compiles to CSS and makes building complex websites much easier. That is, a few important tricks make the syntax of Sass more compact and easier to maintain compared to regular CSS. The problem is: browsers parse CSS, not Sass. In typical JS projects, you compile Sass as part of the buildchain. Using **Hugo Pipes** it is ridiculously easy to process these files ([explained here](https://gohugo.io/hugo-pipes/scss-sass/)):

```html
{{- $options := (dict "targetPath" "css/styles.css" "outputStyle" "compressed" "enableSourceMap" "true") -}}
{{- $styles := resources.Get "sass/main.sass" | resources.ExecuteAsTemplate "main.sass" . | resources.ToCSS $options | resources.Fingerprint "sha512" }}
<link rel = 'stylesheet' href = '{{ $styles.Permalink }}' integrity = '{{ $styles.Data.Integrity }}'>
```

Done! This does require the 'Hugo Extended' binary release instead of the regular release builds, which include these special build pipeline systems. The above even minifies the CSS (`compressed`). 

### Transpiling using Babel

I'm sure you all see this coming: the transpile step is also a Hugo pipe. It does require a bit more work compared to Sass, though, but the actual usage, including minification, is just as easy:

```html
{{- $scripts = resources.Get $mainScriptPath | resources.ExecuteAsTemplate $mainScriptPath . | babel | resources.Minify | resources.Fingerprint "sha512" }}
<script src = '{{ $scripts.Permalink }}'></script>
```

The magic pipe keyword here is `babel`. However, without installing the necessary node packages, it will not work. You will need the following `devDependencies` in your `package.json` file:

- `"@babel/cli": "^7.8.4"`
- `"@babel/core": "^7.9.6"`
- `"@babel/preset-env": "^7.9.6"`

Without a preset, there is nothing to do, but without the core and the cli components, the babel command will simply fail. I tried globally installing these, but that did not seem to work. 

To facilitate easy local debugging in different browsers, I skipped the babel and minify steps using a Hugo directive:

```html
{{- if (ne hugo.Environment "development") }}
{{- end }}
```

Be warned though! The babel step failed or produced some kind of syntax problem, and I did not see this locally. It was only when it was deployed in production that I found out something was broken. Whoops. 

### Search functionality in a static website

There are a couple of [search functionality options](https://gohugo.io/tools/search/) that gohugo.io lists, of which [lunrjs](lunrjs.com) is a minimalistic JS package that indexes and searches. The problem with that is that we need to provide an index JSON file where all our Markdown posts are gathered, including things you want to be searched such as tags. 

Thanks to [this blog post](https://codewithhugo.com/hugo-lunrjs-search-index/) and the accompanying [GitHub Gist](https://gist.github.com/HugoDF/aac2e529f79cf90d2050d7183571684b), things became rather easy. In essence, we want to execute the following steps:

1. Build an index file that lunrjs can gobble up.
2. Let lunrjs do the searching.
3. Display search results with links to relevant articles.

Step one is done by parsing all Markdown files and adding everything you want to be searchable - see Gist file. Step two is also not too difficult:

```javascript
fetch('/js/indexfile.json').then((res) => {
  return res.json();
}).then((data) => {
  const index = lunr.Index.load(data);
  const matches = index.search(searchString);
});
```

The trouble is that our `matches` variable only contains a `ref` property to link back to the document itself. Lunrjs somehow does not return the indexed metadata... So you have to map the matches array to your indexed articles. I did that in Hugo:

```html
<script src="https://unpkg.com/lunr/lunr.js"></script>
{{ $p := slice }}
{{ range (where .Site.RegularPages "Section" "!=" "") }}
  {{ $post := dict "link" .RelPermalink "title" .Title "content" (substr .Plain 0 200) -}}
  {{ $p = $p | append $post -}}
{{ end }}
<script>
window.searchposts = JSON.parse(
  {{ $p | jsonify }}
);
</script>
```

Now you cam `map()` the indexed `ref` property on `searchposts.link`. I have not yet found a better way of doing this. It seems a bit redundant to have Hugo generate another 'index' - these can get out of sync, resulting in search results not being displayed. 

You can try out the result [here](https://redzuurdesem.be/zoeken/). It is nothing fancy, and although you can build a dynamic search-as-you-type searchbox, I simply used a HTTP form:

```html
<form method="GET" action="">
  <input id="searchtxt" placeholder="search!" name="q" type="text" />
  <button type="submit" class="button">Search</button>
  <a href="/search">Empty</a>
</form>
```

The `GET` is on purpose: the URL can be bookmarked, and the query string can be plucked from the URL in JS using:

```javascript
const query = new URLSearchParams(window.location.search);
const searchString = query.get('q') || "";
```

To conclude, when building your site using Hugo, you should not forget to run the index creation script. It might be a good idea to link Hugo to node in the `packages.json` `scripts` properties: `npm run index && npm run build`.