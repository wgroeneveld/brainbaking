+++
title = "gems"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "ruby",
    "gems"
]
date = "2015-01-28"
+++
# Ruby Gems 

### Gemfile dependencies installeren 

  1. Heb je ruby geïnstalleerd? Dan is `gem` beschikbaar.
  2. Heb je `bundler` geïnstalleerd? Dan is `bundler` beschikbaar. Indien neen: `gem install bundler`.
  3. Is er een `Gemfile` beschikbaar? Gebruik dan bundler met `bundle install` om alles lokaal te installeren.

#### Problemen met installeren van packagse 

##### Building native extension: Makefile target pattern contains no %. Stop. 

Probleem met Gemfile > 2.3.0 en Ruby 1.9.3 samen met Ruby devkit. Zie [Native gem installation doesn't work on Windows with >= 2.4.0 #977](https:*github.com/rubygems/rubygems/issues/977) en [Google discussion group](https:*groups.google.com/forum/#!topic/rubyinstaller/k19SeJijpKU/discussion)

Oplossing: revert gems naar een oudere versie met `gem update --system 2.3.0`.

##### FetchError: SSL_Connect returned1 ######

```
Gem::RemoteFetcher::FetchError: SSL_connect returned######1 errno0 state=SSLv3 read server certificate B: certificate verify failed (h
ttps://rubygems.org/gems/kramdown-1.2.0.gem)
An error occurred while installing kramdown (1.2.0), and Bundler cannot
continue.
Make sure that `gem install kramdown -v '1.2.0'` succeeds before bundling.
```

Op te lossen door `gem update --system` uit te voeren.
Lees [hier](http:*stackoverflow.com/questions/10246023/bundle-install-fails-with-ssl-certificate-verification-error) meer over, of [hier](http:*ga.be/blog/2013/10/02/fixing-rubygems-ssl-issues-certificate-verify-failed/) voor de Mac oplossing.