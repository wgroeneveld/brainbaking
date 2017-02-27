+++
title = "htaccess"
draft = false
tags = [
    "code",
    "htaccess"
]
date = "2015-01-06"
+++
# .htaccess stuff 

Basisprincipe van rewriterules: altijd `RewriteEngine On` en `RewriteBase /` toevoegen.

Daarna: `RewriteCond` slaat enkel op **éérstvolgende** `RewriteRule` regel.

#### Request exceeded the limit of 10 internal redirects due to probable configuration error 

[bron](http://stackoverflow.com/questions/1611506/request-exceeded-the-limit-of-10-internal-redirects-due-to-probable-configuratio)

Gebruik `!^map/` voor de rule om bepaalde folders uit te sluiten als ze al herschreven zijn.

#### square bracket rules: rewrite flags 

[zie ook docs](http://httpd.apache.org/docs/2.2/rewrite/flags.html)

  1. NC: case insensitive
  2. L: stop processing other rules (final)
  3. R=123: redirect HTTP code

#### Redirecten - moved 

[bron](http://enarion.net/web/htaccess/migrate-domains/)

Van oud naar nieuw domeinnaam:

```
RewriteCond %{HTTP_HOST} savesourdough.com$ [NC]
RewriteRule ^(.*)$ http://www.redzuurdesem.be/$1 [L,R=301]
```

  1. Kan ook om bvb van `www` naar `http` of omgekeerd te redirecten.
  2. `^(.*)$` catcht alles achter het domein in een parameter `$1`

#### Redirecten - verschillende domeinen 

```
RewriteEngine On

#ADD TRAILING SLASH TO DIRECTORY IF NONE EXISTS
RewriteRule ^([^<br/>.]+[^/])$ http://%{HTTP_HOST}/$1/ [L]

RewriteCond %{HTTP_HOST} ^(www.)?site1.com$ [NC]
RewriteCond %{REQUEST_URI} !site1/ [NC]
RewriteRule ^(.*)$ /site1/$1 [L]

RewriteCond %{HTTP_HOST} ^(www.)?site2.com$ [NC]
RewriteCond %{REQUEST_URI} !site/ [NC]
RewriteRule ^(.*)$ /site2/$1 [L]
```