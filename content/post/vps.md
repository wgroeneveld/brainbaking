---
title: "DIY: Hosting stuff on your own VPS"
date: '2020-04-13'
subtitle: "Migrating to, securing and backing up your own server."
tags:
  - server
  - linux
  - vps
  - security
published: true
---

Hosting static websites on Github Pages is not a chore - on the contrary, it's free and very easy to set up: you only need a `CNAME` file with your domain in, and some plan to serve files from a branch or the `/docs` dir. However, as soon as you want something _more_ than only static HTML files, you're stuck. My wife built her site in [Webnode](https://webnode.com) and has looked countless times at migrating to (or from) Wordpress. I could cut costs and host these myself, with the added bonus to host just about anything! MySQL, Postgres, Node, Java, Go, ... - whatever the need, I'll deploy it. I was looking at [Commento](https://commento.io) myself to finally enable comments on my [Hugo](https://gohugo.io)-enabled static sites. 

### 1. Renting private server space

Requirements:

1. Hosted nearby - preferably in Belgium.
2. Cheap! Not more than 10 EUR/month
3. Fast - meaning 4GB of RAM at minimum.
4. Some bandwidth/HDD breathing space.

I ticked all boxes except the first one - [ovh.net](https://ovh.net) costs 7 EUR/month for a 4Gig VPS with 40GB SSD space, but it's hosted in Strasbourg. Still, our nameservers from [Antagonist.nl](https://antagonist.nl) are in Netherlands anyway, so that's halfway there! I am sure there are cheaper options available but my experience tells me hosting various things requires at least 4GB RAM.

Yes, I could create my own nameserver. No, I don't want to over-complicate things. 

### 2. Installing and configuring your VPS

Okay, we have SSH access to a brand new OpenStack-based Ubuntu server. What to do next?

#### A. Secure the SSH channel

The first thing to do - beside changing the root password - is to change `sshd_config` to listen to another port than the default `22`. Also, reject root login (`PermitRootLogin no`). Create a new user that can login and add him/her to the `sudo` group. Restart the service with `/etc/init.d/ssh restart`.

Next, to counter simple DoS attacks, install the fail2ban service. I left default config alone, it only checks SSH and seemed OK for me. `service fail2ban restart`.

#### B. Configure a firewall

I'm getting suspicious: now I have the responsibility of securing my own server, and I'm far from a Linux Network expert... After scrolling through a few articles on the 'Net, it seemed like a good idea to configure `iptables` to block unwanted traffic.

- Accept loopback and established traffic
- Accept input at ports `80` (HTTP), `443` (HTTPS), your custom SSH port
- If you must, whitelist certain IP ranges, such as [Cloudflare's IP list](https://www.cloudflare.com/ips/ )
- Drop all the rest. 

You can back up and restore tables using `iptables-save > file` and `iptables-restore < file`. Remove rules using `-X`, `-F` and `-P INPUT/OUTPUT/FORWARD ACCEPT`. Check using `sudo iptables -L`. 

Install package `iptables-persistent` to not lose the configuration after a server reboot. If something goes wrong, check `/var/log/kern.log` if you enabled logging using `iptables -A INPUT -j LOG`. 

#### C. Configuring the mailserver

If the shit hits the fan... I'd like to know about it. So, a local mail-only server is not a bad idea. It will also be used by Commento when approving or rejecting comments. However, installing `postfix` proved to be _very_ painful. After a few hours, I managed to get it to work, but Google still thinks the mail is spam. To fix that, I'll have to setup DKIM someday. 

First, make sure you get a wildcard certificate (see below) to enable SSL. Add this to the `/etc/postfix/main.cf` config:

```
smtpd_tls_cert_file=/etc/letsencrypt/live/brainbaking.com/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/brainbaking.com/privkey.pem
smtp_use_tls=yes
smtp_tls_loglevel=1
smtpd_tls_received_header = yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
```

Next, add a TXT DNS record with value `"v=spf1 include:_spf.google.com ~all"`, that makes Google less suspicious of your outgoing e-mail. 

In case you missed something in the initial pkg configuration wizard, use `dpkg-reconfigure postfix`. Configure postfix to only use localhost outbound mail via IPv4/v6:

```
myhostname = brainbaking.com
myorigin = $myhostname
mydestination = $myhostname, localhost.$myhostname, localhost
relayhost = 
mynetworks = 127.0.0.1/32 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = loopback-only
inet_protocols = all
home_mailbox = mail/
```

One last - very annoying - thing is that I did not want outgoing mail to have the From address 'user@vps12345.ovh.net'. I wanted it to be 'user@brainbaking.com'. Even with the `myorigin` and `myhostname` properties set, this would not work if you don't provide the `mail` command with a From address. Add this to your config: `smtp_generic_maps = hash:/etc/postfix/generic`. That file contains only one line that maps my unwanted address to the real one: `user@vps12345.ovh.net user@brainbaking.com`. Restart the service after that: `sudo systemctl restart postfix`.

### 3. Hosting static sites on your VPS

Now that the VPS is (somewhat) secure, let's install `nginx` and configure our websites. I followed a few tutorials, listed in the resources below. After that, I felt comfortable enough to dabble in the config files myself. 

You first need to know that the previous setup was like this:

{{<mermaid>}}
graph LR;
    Browser[Browser]
    NS[DNS Nameserver]
    Cloud[Cloudflare NS/SSL]
    Github[Github Pages]
    Browser --> NS
    NS --> Cloud
    Cloud --> Github
{{< /mermaid >}}

I leveraged Cloudflare's free SSL certificates to secure my static websites. Now that we have our own VPS, we'd like to alter the schematic like so:

{{<mermaid>}}
graph LR;
    Browser[Browser]
    NS[DNS/NS Nameserver]
    VPS[Own VPS + SSL]
    Browser --> NS
    NS --> VPS
{{< /mermaid >}}

That would involve modifying `NS` records at my domain host, resulting in a downtime of several hours until the new DNS records are correctly propagated. Bigger companies resolve this by installing their own nameservers.  

It would also involve `certbot` to generate SSL certificates using Let's Encrypt. I was pleasantly surprised at the ease of configuration - certbot also gets auto-installed in the root's `crontab` to auto-renew certificates. 

#### A. Configuring nginx

I first tried to configure the webserver to serve files using HTTP, and disabled Cloudflare's SSL settings. Only then I could let certbot fetch a new certificate and configure my HTTPS settings. After that, the VPS was in charge of SSL, and I could safely modify the NS records. To check whether the NS changes have been propagated successfully, use `dig A +short domain.com` or `dig NS`.

Setting up HTTPS for the root and www subdomain:

```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    root /var/www/brainbaking;
    index index.html;
    server_name brainbaking.com www.brainbaking.com;

    location / {
      try_files $uri $uri/ =404;
    }

    # SSL
    ssl on;
    ssl_certificate /etc/letsencrypt/live/brainbaking.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/brainbaking.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # security
    include nginxconfig.io/security.conf;

    # additional config
    include nginxconfig.io/general.conf;
}
```

[nginxconfig.io](https://nginxconfig.io) provides bread and butter config partials, such as security headers:

```
# security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

# . files
location ~ /\.(?!well-known) {
    deny all;
}
```

and general caching config:

```
# favicon.ico
location = /favicon.ico {
    log_not_found off;
    access_log off;
}

# robots.txt
location = /robots.txt {
    log_not_found off;
    access_log off;
}

# assets, media
location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
    expires 30d;
    access_log off;
}

# svg, fonts
location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
    add_header Access-Control-Allow-Origin "*";
    expires 7d;
    access_log off;
}

# gzip
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;
```

If you are interested at redirecting HTTP traffic to HTTPS, you can do that too:

```
server {
  listen 80;
  listen [::]:80;
  server_name .brainbaking.com;

  location / {
    return 301 https://$host$request_uri;
  }
}
```

#### B. Configuring subdomains

Since I wanted to add subdomains to host other websites, including Commento, I needed a wildcard certificate. That was much trickier to get to work, but after some digging, this command worked for me:

`certbot certonly --manual --preferred-challenge=dns --email [yourmail] --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d brainbaking.com -d *.brainbaking.com`

It is _crucial_ that you provide two `-d` flags: one for the root domain and one for the wildcard subdomain. I forgot the first one, resulting in browsers denying requests to the website and a headache. Certbot verifies if you own the domain using a `TXT` record in the DNS entry. After that, the SSL certificate can be used in any config for that domain. 

For instance, hosting Commento and setting up a reverse proxy to redirect to the local Commento server running at port `8080`:

```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name commento.brainbaking.com;

    location / {
      proxy_pass http://localhost:8080/;
      proxy_set_header X-Real-IP $remote_addr;
    }

    # SSL (same as above)
```

I had to disable the Content-Security-Policy security header for the dashboard to work correctly. 

#### C. Setting up auto-builds

Using source control and Hugo, building static pages is easy: `hugo` - done. Before, I did that myself and checked in the `/docs` directory - which is stupid, considering something like Travis could do that for me. I deleted all generated files from the source repo. 

On the server, I cloned repositories in `/var/dev/[repo]`. The sites get served in `/var/www/[repo]`. A simple script auto-builds these things, and `cron` runs it hourly: `0 * * * * /var/dev/build.sh >> /var/dev/build-output.log 2>&1`. Check the crontab using `crontab -e`, and check logs using `sudo grep CRON /var/log/syslog`. The buildfile is very simple:

```sh
#!/bin/bash

sites=( site1 site2 site3 )

for site in "${sites[@]}"
do
    echo "building site $site"
    cd /var/dev/$site
    RESULT=$(git pull | grep 'Already up to date')
    if [ -z "$RESULT" ]
    then
        /usr/local/bin/hugo --cleanDestinationDir --destination /var/www/$site/
    else
        echo "nothing to do for $site"
    fi
done
echo "done building."
```

I considered other options:

1. Host Jenkins. It's a fairly heavy Java process that should be kept on a separate CI server. Overkill.
2. Use Travis and SSH tunnel built artifacts. That would mean extra security exposures, and a pain to configure using public/private keys. Did that before, and was not keen on doing it again.
3. Use a simple script. Check.

### 4. Hosting dynamic sites on your VPS

Now that we have nginx up and running, I wanted to install the Wodpress chain to see how easy it would be to serve PHP content. It turned out to be quite easy. Install the required php and mariadb packages (don't use `apt install php` - it comes with a bunch of crap). Change what you need in `/etc/php/7.2/fpm/php.ini` and restart the `php7.2-fpm` service. Create a user and database in MariaDB and `wget` the latest Wordpress release. (I followed along a nice tutorial, linked below) That's it, it works! Oh wait, nginx config:

```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    root /var/www/wordpress;
    index index.php index.html index.htm;
    server_name wordpress.brainbaking.com;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    access_log /var/log/nginx/wordpress_access.log;
    error_log /var/log/nginx/wordpress_error.log;

    client_max_body_size 64M;

    location ~ \.php$ {
        try_files $uri =404;
        include /etc/nginx/fastcgi_params;
        fastcgi_read_timeout 3600s;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 128k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
    }

    # SSL (same as above)
}
```

Same problem with the Content-Security-Policy security header. 

Do not forget to 'harden' your Wordpress install after configuring things in `wp-config.php`. Use `chown :www-data` for the wp-content dir. `chmod` dirs at 755, your config at 640, and the rest at 660. 

#### C. Setting up auto-backups

Since there's nothing to build, but databases do introduce the problem of backups, I again resorted to a simply DIY method as a 'good-enough' means to handle the problem. Instead of downloading (`git clone/pull`) and building, like the static sites, I would periodically  upload (`git push`) database backups and www files:

```sh
#!/bin/bash
NOW=`perl -e 'print time;'`

# sync www files
rsync --update -raz /var/www/wordpress ./www/
rm -rf ./www/wordpress/wp-config.php

# backup mysql
rm -rf ./www/wordpress/wpdb.*
mysqldump --defaults-file=/etc/mysqldump.cnf --add-drop-table --databases wpdb > ./www/wordpress/wpdb.sql
bzip2 ./www/wordpress/wpdb.sql
rm -rf ./www/wordpress/wpdb.sql

# auto-commit to github
git add .
git commit -am "autocommit server sync at $NOW"
git push
```

Since the private Github repository keeps track of changes for me, I do not need to worry about frequency of backups and taking backups of already hacked sites. Alternatives I considered:

1. Get a decent backup service on the VPS provider. Costs too much extra. Not worth it.
2. Zip everything in /var/www and SSH tunnel it to somewhere.
3. Zip everything and upload it to the private Git repo. Files too big, no incremental changes.  
4. Serve everything in Docker containers and back these up 'somewhere'. Overkill and difficult to configure.

To reduce the security risk of adding my git credentials to the VPS server that would cause damage to other repositories, I created another Github user that's only allowed to push to that one repo. 

I ended up extending this script to also sync crucial config files (nginx, postfix, crontab and iptable exports, ...). In case I had to start over from scratch, I at least had something. I know it's a very poor solution to 'backup the server', but hey, it's something. SSL certificate backups are not required, just generate a new pair. 

### 5. Monitoring your VPS

There are so many ways to actively or passively monitor a Linux server! I tried to pick the right option for me but almost drowned in the possibilities:

1. Host the whole Elastic Stack yourself. Java processes, and way too much services for my humble sites with low traffic. 
2. Use Nginx Plus. Costing.
3. Use what your VPS provides. Okay but not expandable.
4. Host the [Cockpit-Project](https://cockpit-project.org) yourself.

Option 4 looked very appealing once I learned it's built using node/modern JS frameworks such as React. It's also very easy to write your own modules. I enabled nginx' stub_status module that once will hopefully integrate with Cockpit. For the moment, only `curl http://127.0.0.1/nginx_status` works. This, together with mailing when something is on fire, is still on the TODO list. 

Also, I wonder whether or not Cockpit introduces more security problems: someone with bad intentions that knows the endpoint and login/password will wreck everything. Then again, the same applies for SSH. 

### 6. Wrapping it up

I had a lot of fun (re-)learning Linux Sysadmin skills and setting up things the way I want them to be. I know linux config files can be messy and all-over-the-place, so treating them as code and checking them in is one step. Auto-testing and using things like Docker containers is the next big thing, but I am not sure if I am willing to push it that far for simple websites like these.

There are still big holes in my security plan. You are welcome to drop a line in the comments below to suggest improvements. Right now, the biggest problem is probably the login/password of the VPS host provider, Cockpit, SSH, Github and DNS domain provider - they all can potentially break everything. 

### Resources

- https://www.nginx.com/blog/monitoring-nginx/
- https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-16-04
- https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy
- https://www.rosehosting.com/blog/how-to-install-wordpress-with-nginx-on-debian-10/
- https://medium.com/@jgefroh/a-guide-to-using-nginx-for-static-websites-d96a9d034940
- https://docs.ovh.com/nl/vps/tips-beveiliging-vps/
- https://www.rosehosting.com/blog/how-to-set-up-a-firewall-with-iptables-on-ubuntu-and-centos/
