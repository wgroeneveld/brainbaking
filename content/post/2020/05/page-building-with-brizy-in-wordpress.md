---
title: Page Building with Brizy in Wordpress
date: '2020-05-26'
bigimg: /img/brizy.jpg
subtitle: Shortcodes and custom hacks incoming...
tags:
  - php
  - webdesign
  - wordpress
  - brizy
---

As you may have read, I'm quite the [Hugo.io fan](/post/hugo-extended) and I build all my websites using this static website generator. As cool and tech-savvy it is, projects like [forestry.io](https://forestry.io/) exist to leverage Hugo's powers into the world of teams an non-technical bloggers. However, it still requires things like _committing_ and does not come with a lot of custom design options. 

My wife has been blogging on and off for more than five years now, and she's been using things like Blogspot, Webnode, Wix and Wordpress. Not content with any of those, about a month ago she started creating yet another blog, calling in my help with the code portions. She's never content with the design options the free templates offer, and would like to design things herself, without having a lot of knowledge of CSS/HTML. 

That's where things like Webnode and Wix come in: a lot of illustrators and designers create their own website using **blocks**: they are **page builders**, where drag and dropping is possible and (ugly) CSS/HTML is scaffolded. Since both Webnode and Wix are paid solutions, and both do not enable you to host it yourself, we decided to go for the Wordpress option again, more specifically with a page builder plugin: _[Brizy](https://brizy.io)_.

> The most user-friendly website builder in town <span>According to the Brizy website</span>

See for yourself:

{{< youtube KUv-NqDR-8s >}}

Amazing, right? 

Not quite. 

It's all good as long as you are creating _pages_. Pages are static webpages in Wordpress. But when it comes to designing the layout of your blog posts, or _posts_, things get ugly. Brizy of course also offers a paid version which comes with premium page blocks and more options, but we contented with the free version. I have to admit that creating pages with the free version was surprisingly easy (and maybe even a bit fun too). 

In Brizy, you can create a 'page' that acts as a template for blog detail pages, but it 'forgets' to add the actual blog content. I'm sure there's another way in the paid version, but I solved that by using a lot of shortcodes: enter [Shortcode Ultimate](https://getshortcodes.com). Adding `[su_post field="post_content"]` in a block does generate an error in Brizy's preview mode, but works outside of that. 

Actually, injecting post content using that shortcode comes with a big shortcoming: it does not parse shortcodes inside posts themselves (`[caption]`, `[embed]`, ..). Solution? A custom filter:

```php
function su_post_content_filter($value) {
    return apply_shortcodes($value);
}
```

The `apply_shortcodes()` [function](https://make.wordpress.org/core/2020/02/13/wordpress-5-4-introduces-apply-shortcodes-as-an-alias-for-do-shortcode/) in Wordpress parses the shotcodes in the argument for us. I have found the Wordpress function reference to be quite complete and useful. However, it is quite a mess: there are `do_` functions, `apply_` ones, lots of methods `echo` stuff, resulting in me having to capture `stdout` to return it:

```php
function blog_detail_comments_shortcode() {
    ob_start();
    comments_template();
    $html = ob_get_contents();
    ob_end_clean(); 
    return $html;
}
add_shortcode('blog_detail_comments', 'blog_detail_comments_shortcode'); 
```

Yuck. What a mess. But now I can use `[blog_detail_comments]` inside a Brizy template to render the Wordpress blog comments partial - yay! I had to create the following shortcodes myself to get the job done:

- `blog_detail_comments` - comments form
- `blog_detail_footer` - a span with blog detail date and categories
- `show_categories` - a list of all categories, used in the sidebar
- `show_current_category` - a list of current categories

#### The Blog Overview page

This page usually contains a list of latest blog entries. Shortcodes Ultimate does not support pagination - great. I grew tired of reinventing the wheel and installed yet another plugin to do the work for me:

```
[display-posts pagination="true" image_size="thumbnail" include_excerpt="true" excerpt_length ="30" include_date="true" category_display="true" category_label="" include_excerpt_dash="false" image_size="medium" date_format="d/m/Y"]
```

The result is not great. Instead of utilizing URLs such as `/page/2/`, as the default Wordpress templates do, now we're stuck with `/blog/?dps_paged=3` - that is, unless I intervene and rewrite things. Yet. Again. Yuck. 

#### The Blog Detail page

{{< figure src="/img/brizy_invalid.png" title="Did I do something wrong?" >}}

A lot of shortcodes are needed here. Blog title, blog contents, blog metadata (the detail footer), blog comment forms, showing a list of categories, a list of most popular or recent posts in the sidebar, ... The problem for my wife is that while designing this page, there are no placeholders available, so it's a bit of a guess how it will turn out to be. 

Oh, did I mention that I had to style these things myself? Since you can't use the Brizy Editor to apply a font? That means duplication. And that means more shit when my wife decides to use another font on all pages: the shortcodes won't budge. 

#### The Category page

Right, "terms" in Wordpress. Are you using tags or categories? Or did you create your own taxonomy? What's with all the complexity when I just want a simple way to sort and organize my blog posts? Here, I used another self-made shortcode, `[show_current_category]`, that is a wrapper around `[display-posts]` to apply the category filter scraped from the request URL (usually something like `/category/blabla`):

```php
$show_current_category_in = FALSE;
function show_current_category_shortcode() { 
    global $show_current_category_in;
    if($show_current_category_in == TRUE) return '';
    $show_current_category_in = TRUE;
    $cat = str_replace('/', '', str_replace('category', '', $_SERVER['REQUEST_URI']));
    
    ob_start();
    
    echo "<div class='brz-rich-text'><h2 style='font-family: \'Playfair Display\', serif'>Categorie: $cat</h2></div><hr/>";
    echo do_shortcode('[display-posts category="' . $cat . '" posts_per_page="100" image_size="thumbnail" include_excerpt="true" excerpt_length="30" include_date="true" category_display="true" category_label="" include_excerpt_dash="false" image_size="medium" date_format="d/m/Y"]');
    
    $html = ob_get_contents();
    ob_end_clean(); 
    return $html;
}
```

I'm ashamed to even post this on the internet. One of the finest hacks I've ever written, I think. The ugly boolean variable is needed because when a Brizy template gets included as part of the results, it triggers the Wordpress function `get_the_excerpt()` from `[display-posts]`. And the excerpt of this category template page includes the show current category shortcode - back to square one. I'm sure there are better ways to do this, but I lost my patience (and temper) trying to debug this mess, pasting `$e = new \Exception; var_dump($e->getTraceAsString());` in random places. 

### The Wordpress mess

I'm slowly but surely starting to detest the Wordpress mess we've made. A few other things that bother me:

1. Sass transpilation? The wordpress admin page offers a nice and easy way to edit inline source files of the themes, but they are CSS-only. 
2. Same problem with ES6. I had to transpile the big `preview.js` JS file from Brizy myself because somehow inline SVGs did not get replaced in Safari. Turns out there was actually a JS syntax error!  
2. Plugin hell. Which plugin to use for SEO or image optimization? Oh, this one seems cool. Nope, not modified in a year. Oh and this one? Nope, freemium shit. What about... Hours later: fuck it, pick a random one. 
3. The theme child/parent thing is a mess. In the end, I copied the `twentytwenty` dir over to do some heavy lifting - being well aware of things possibly breaking in future Wordpress versions. 

### The Brizy mess

Brizy allows you to save "blocks" as global blocks so they can be reused on different pages. That's very handy, and my wife easily creates other pages with the same header and footer using a swift drag-and-drop move. However, since the logo is included in the header, and we accidentally uploaded the wrong one, I swapped the image out on the server. Guess what, on most other pages, the wrong version was still there:

```
user@vps:/var/www/kristienwp/wp-content/uploads/brizy$ find . -name 'testlogokristien.png' | wc -l
389
```

Wait, what? 

Yup:

```
./455/assets/images/iW=652&iH=any/testlogokristien.png
./455/assets/images/iW=151&iH=69&oX=1&oY=0&cW=150&cH=69/testlogokristien.png
./455/assets/images/iW=326&iH=any/testlogokristien.png
./455/assets/images/iW=328&iH=any/testlogokristien.png
./455/assets/images/iW=300&iH=136&oX=0&oY=0&cW=300&cH=136/testlogokristien.png
./3682/assets/images/iW=150&iH=68&oX=0&oY=0&cW=150&cH=68/testlogokristien.png
./3682/assets/images/iW=106&iH=48&oX=0&oY=13&cW=106&cH=23/testlogokristien.png
./3682/assets/images/iW=145&iH=any/testlogokristien.png
./3682/assets/images/iW=246&iH=112&oX=0&oY=0&cW=246&cH=112/testlogokristien.png
./3682/assets/images/iW=212&iH=96&oX=0&oY=26&cW=212&cH=46/testlogokristien.png
./3682/assets/images/iW=310&iH=142&oX=0&oY=0&cW=310&cH=142/testlogokristien.png
```

Brizy duplicates images from global bocks for each page, and for each page, Brizy duplicates images for each (mobile) device used in `srcset` attributes of `img` tags. `26` images for one page ID. 

There goes my [nginx caching strategy](/post/vps). What a mess. Should I write a bash script to create symlinks? That does not change anything for the clientside webbrowser. What a mess. 

### So, trash Brizy and use something else?

Perhaps. But now that we invested a couple of weeks in this Wordpress + Brizy + custom hacks combination, my wife is content. She's even thinking about using the same setup to port one of her websites from Webnode, a paid and hosted service. It's intuitive to use and it works - for the most part. The shortcodes should not change often, and the blog detail and category brizy templates are not that difficult to maintain if you ignore the errors in the editor. 

Oh, and don't bother paying for the coupled "Optimize Images" [shortpixel.com](https://shortpixel.com/pricing-one-time) plugin thing - simply execute `find . -name "*.jpg" -exec convert {} -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB {} \;`. With complements of Google's [Image Optimization Tips](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/image-optimization). 

As long as you don't try to peek behind the scenes and into the source code, all is well... 

