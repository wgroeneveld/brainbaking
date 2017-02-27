+++
title = "handlebars"
draft = false
tags = [
    "code",
    "javascript",
    "frameworks",
    "handlebars"
]
date = "2013-03-12"
+++
# Handlebars 

Algemene uitleg ea:

  1. http://javascriptissexy.com/handlebars-js-tutorial-learn-everything-about-handlebars-js-javascript-templating/#more-621
  2. http://handlebarsjs.com/
  3. http://tryhandlebarsjs.com/

### Yeoman integratie 

Zie https://github.com/yeoman/yeoman/wiki/Handlebars-integration en [code/javascript/frameworks/yeoman]({{< relref "wiki/code/javascript/frameworks/yeoman.md" >}})

Maakt gebruik van `grunt` - Zie https://github.com/gruntjs/grunt-contrib-handlebars/

Aanpassingen in `Gruntfile.js`:

```javascript
  grunt.initConfig({

    // Project configuration
    // ---------------------

	handlebars: {
		compile: {
			files: {
				"app/scripts/templates.js": [
					"app/templates/*.hbs"
				]
			}, 
			options: {
				amd: true,
				processName: function(filename) {
					return filename
						.replace('app/templates/', '')
						.replace(/<br/>.hbs$/, '');
				}
			}
		}
	},
// ...

    watch: {
      handlebars: {
      	files: [
      		'app/templates/*.hbs'
      	],
      	tasks: 'handlebars reload'
      },
// ...

  grunt.loadNpmTasks('grunt-contrib-handlebars');
};

```

`grunt handlebars` compileert dan alles in "app/templates" (.hbs files) naar "app/scripts/templates.js". Als je `amd: true` meegeeft in `options` wrapt de grunt task dit in `define(['handlebars'], function(Handlebars) { ... });`. Handlebars heeft geen AMD module, meer hierover, zie requirejs.

### Templates (async) laden 

Standaard worden templates included in de `HTML` met een `<script/>` tag op deze manier:

```html
<script id######"header" type"text/x-handlebars-template">
 <div> Name: <img style='margin-left: auto; margin-right: auto;' src='/img/headerTitle'> </div>
</script>
```

Dit wordt snel een dikke knoeiboel als er heel veel files zijn in één HTML file. Oplossingen:

  1. Gebruik RequireJS 
  2. Laadt ze via `jQuery.ajax` in op moment dat het nodig is: http://stackoverflow.com/questions/8366733/external-template-in-underscore

Blijkbaar is er een plugin in AMD/RequireJS dat het mogelijk maakt om text in te laden, zo:

```javascript
// The define function is part of the AMD mechanism for loading 
define([
    'jquery',
    'underscore',
    'handlebars',
// Require.js text plugin loads the HTML template pages
    'text!templates/user_account.html',
    'text!templates/user_profile.html'], 
function ($, _, Backbone, HandleBars, UserAccount_Template, UserProfile_Template) {
 ...
});
```