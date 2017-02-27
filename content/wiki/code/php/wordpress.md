+++
title = "wordpress"
draft = false
tags = [
    "code",
    "php",
    "wordpress"
]
date = "2015-01-29"
+++
# Wordpress specifiek 

#### Wordpress bootstrapping buiten WP omgeving om 

Om eender wat te kunnen doen (WP functies in php uitvoeren bvb, zoals `get_posts`) moet je de wp omgeving bootstrappen (laden db, config, ...).

Dit kan je uit wp-blog-header.php halen, die in index.php geinclude wordt:

```php
require_once('wp-load.php' );
wp();
```

Vanaf dan is alles beschikbaar. Dus **niet manueel wp-include php files includen**, anders wordt stuff ge-herdefinieerd!

#### Specifieke post includen 

Zie [get_posts](http://codex.wordpress.org/Template_Tags/get_posts) documentatie.

Voorbeeld:

```php
$args ###### array( 'posts_per_page' > 5, 'orderby' => 'rand' );
$posts = get_posts( $args );

foreach($posts as $post) {
	* data specific to wp_posts - http:*codex.wordpress.org/Database_Description#Table:_wp_posts
	echo "post id " . $post->ID;
	echo "title: " . $post->post_title;
}
```

##### Comment form voor specifieke post 

Ook mogelijk, zie [comment_form documentatie](http://codex.wordpress.org/Function_Reference/comment_form) - zoiets: `comment_form(null, $id);` - stijl ea in te stellen met eerste param. 

#### Oud domein -> nieuw domein 

Instelbaar in `wp-admin` van Wordpress zelf, maar je moet manueel de tabel `wp_posts` updaten want er staan overal hardcoded links:

```sql
UPDATE wp_posts SET post_content = REPLACE(post_content, 'savesourdough.com', 'redzuurdesem.be');
```

Zie ook [http:*dev.mysql.com/doc/refman/5.0/en/replace.html](http:*dev.mysql.com/doc/refman/5.0/en/replace.html)