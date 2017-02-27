+++
title = "yeoman"
draft = false
tags = [
    "code",
    "javascript",
    "frameworks",
    "yeoman"
]
date = "2013-03-12"
+++
# Build tools: Yeoman, Grunt, RequireJS ea 

Zie ook integratie met [code/javascript/frameworks/handlebars]({{< relref "wiki/code/javascript/frameworks/handlebars.md" >}}). 

Help nodig? Vast? >>

  * http://gruntjs.com/installing-grunt
  * http://yeoman.io/commandline.html
  * http://requirejs.org/docs/api.html
  * https://github.com/twitter/bower
  * https://npmjs.org/doc/

Meer info over Yeoman, tooling support, scaffolding, etc:

  * https://plus.google.com/115133653231679625609/posts/h8shHWJtcKd

## Deploying 

#### Naar een FTP server 

Gebruik `grunt-ftp-deploy` node plugin: https://github.com/zonak/grunt-ftp-deploy

```javascript
'ftp-deploy': {
  build: {
    auth: {
      host: 'server.com',
      port: 21,
      authKey: 'key1'
    },
    src: '/path/to/source/folder',
    dest: '/path/to/destination/folder',
    exclusions: ['/path/to/source/folder/**/.DS_Store', '/path/to/source/folder/**/Thumbs.db', 'dist/tmp']
  }
}
```

:exclamation: auth key ref verwijst naar `.ftppass` in working dir

## Testing 

#### Mocha 

Zie http://visionmedia.github.com/mocha/

Built-in support voor yeoman. Verschil met jasmine:

  1. mocha heeft geen assertions. Yeoman gebruikt by default [http://chaijs.com/|chaiJS] assertions.
  2. mocha heeft geen spies. 

#### Jasmine 

Integratie met Grunt mogelijk met https://github.com/creynders/grunt-jasmine-task en dan in `Gruntfile.js`:

```javascript
grunt.loadNpmTasks('grunt-jasmine-task');
jasmine: {
  all: ['specs/specrunner.html']
},
```

## Package managing 

Modules worden via de node package manager, `npm` geïnstalleerd, al dan niet globaal met de `-g` flag:

```
sudo npm install grunt-contrib-handlebars --save-dev
```

`-g` betekent **niet** lokaal installeren maar in een bin folder op het systeem. Waarom/wanneer het ene of het andere kiezen? http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/

## RequireJS 

Zie requirejs.org/docs/api.html

#### AMD Structuur 

Main file:

```javascript
require.config({

});
 
require(['app'], function(app) {
	// main module which fires up everything
});
```

Na includen van Rjs in html:

```html
    <script data-main######"scripts/main" src"scripts/vendor/require.js"></script>
```

Gaat rjs afhankelijk van `data-main` de hoofd JS file inladen (bovenstaande). That's it!

Module files:

```javascript
define(['dep1', 'dep2'], function(dep1, dep2) {

  // dep1, dep2 accessible & loaded

  return {
    api: function() { ... }
  };

});
```

Rjs gaat eerst dep1 en dep2 laden en dan de bovenstaande code pas. Hiervoor moeten natuurlijk beide andere APIs ook `AMD` wrapped zijn. [AMD](https://github.com/amdjs/amdjs-api/wiki/AMD) staat voor **"Async Module Definition"**

#### Wat doe ik als een API geen AMD gebruikt  

Gebruik `shim` config van Rjs: requirejs.org/docs/api.html#config-shim

```javascript
require.config({
  shim: {
  	'handlebars': {
  		exports: 'Handlebars'
  	}
  },

  paths: {
    jquery: 'vendor/jquery.min',
    handlebars: './../components/handlebars/handlebars.runtime'
  }
});
 
require(['handlebars'], function(Handlebars) {
	// gogo!
});
```

Wat is hier gebeurd:

  * `jquery` en `handlebars` includen wordt via een bepaald pad ingeladen in plaats van het standaard pad
  * `handlebars` gaat gewrapped worden in een AMD module, die `Handlebars` als variabele exporteert. 

#### Hoe verander ik mijn (relatieve) include paden 

Als je `grunt` gebruikt, in `Gruntfile.js` de hoofd Rjs config file alteren:

```javascript
    rjs: {
      // no minification, is done by the min task
      optimize: 'none',
      baseUrl: './scripts',
      wrap: true,
      name: 'main'
    },
```

Bovenstaande gaat altijd vanaf mapje scripts beginnen lezen. 