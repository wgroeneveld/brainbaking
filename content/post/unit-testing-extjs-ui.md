---
title: Unit Testing Extjs UI with Siesta
bigimg: /img/Unit Testing Extjs UI with Siesta.jpg
aliases:
    - /unit-testing-extjs-ui-with-siesta/
date: '2014-12-23'
subtitle: An attempt to replace instable Webdriver tests with Siesta UI tests
tags: [ 'unit testing', 'javascript', 'extjs', 'siesta']
---

### WebDriver & js-heavy frameworks ###

Writing scenario tests for javascript-heavy UI webpages can be really difficult. It gets complicated pretty quickly if you're using a lot of async calls or a lot of javascript-heavy UI components. On our current project, we use Extjs as the UI layer in a single-page aspx page to bootstrap our Extjs app. Extjs is a (heavyweight) javascript framework for creating windows, panels, grids, buttons, menus, ... like you're used to when using client/server desktop applications. You define components on a view, behavior on a controller, and data and the way it's loaded on the model.

The problem with Javascript-heavy frameworks like this is that if your team does not have a lot of experience using JS in general, it can get extremely messy and cluttered. Which it did, coupled with a lot of regression (a misplaced ";" could break an entire part of the application), we needed an automated way to catch up with those bugs. 
Since I have a lot of experience with WebDriver, we started using it to write scenario tests when the application is deployed. A test should emulate customer behavior: click on a menu, expect a window to be opened, fill in a form and expect something else to happen. It's not isolated but tests everything together. 

WebDriver is great, but since a lot of javascript events are happening in the background it's very difficult to write a easily usable DSL to manipulate the UI. One has to wait for ajax calls to finish, for DOM elements to appear or disappear, and so on. Tests became instable and failed sometimes, even sometimes on the CI build but never on your development environment. It takes more and more time to find & fix those things. 

### A possible solution: Siesta ###

[Siesta](http://www.bryntum.com/products/siesta/) is a product from Bryntum especially written to unit test Extjs applications, focussing on the UI. Sounds nice, so we decided to check it out as a possible alternative to WebDriver. As the website states:

> Siesta is a JavaScript unit testing tool that can help you test any JavaScript code and also perform testing of the DOM and simulate user interactions. The tool can be used together with any type of JavaScript codebase – jQuery, Ext JS, NodeJS, Dojo, YUI etc. Using the API, you can choose from many types of assertions ranging from simple logical JS object 

Sounds good, right? 

The setup isn't too difficult, after a few hours of fiddling I managed to bootstrap our Extjs application using this index.js file:

var Harness = Siesta.Harness.Browser.ExtJS;

		Harness.configure({
		    title       : 'Test Suite',
		    loaderPath  : { 
		        'Ext': '../extjs',
		        'Ext.ux': '../extjs/ux',
		        'MyApp': '../app'
		    },
		    preload     : [
		        // version of ExtJS used by your application
		        '../extjs/resources/css/ext-all.css',
		        '../resources/css/workb.css',

		        // version of ExtJS used by your application
		        '../extjs/ext-all-debug.js',
		        './app-vars.js',
		        {
		            text: "Ext.Loader.setConfig({ 'Ext': '../extjs', 'Ext.ux': '../extjs/ux', 'MyApp': '../app' })"
		        },
		        '../extjs/overrides/javascript-overrides.js',
		        '../extjs/overrides/PFW-overrides.js',
		        '../app/app.js'
		    ]
		});

		Harness.start(
		    'tests/001_sanity.t.js',
		    'tests/002_window.t.js'
		);

Some pitfalls: `loaderPath` isn't evaluated in the preload so you have to reset it with `Ext.Loader.setConfig()` and I had to alter our app.js file. Our directory structure looks like this:

root
-- app
-- extjs
---- ux
-- siesta
---- tests

So you have to watch out for relative paths like `appFolder` in app.js:

	Ext.application({
	    name: 'MyApp',
	    appFolder: (_siesta ? '../' : '') + 'app',

After that, you can start writing tests. Looking at the examples, the test flow looks a lot like our current WebDriver tests (wait for rows present, wait x seconds, click on this, do that). Here's a simple test to create a view and check if the grid has some rows:

	StartTest(function(t) {
	    t.diag("Creating some window");

	    var view = Ext.create('MyApp.view.SomeOverview', {
	    	renderTo: Ext.getBody() // required
	    });
	    var grid = view.down("grid");

	    t.chain(
	        { waitFor : 'rowsVisible', args : grid }
	    );
	});

![siesta view test in action]({{urls.media}}/siesta.png)

Siesta also comes with it's downsides though.

  - JS Test code is really messy. Chaining, async calls, ugly data setup for stores, ... A simple test can get complicated fast and requires advanced JS knowledge not everybody in our team has. 
  - `waitFor` exposes the same problems we have with our current WebDriver tests, so it's not that much of an improvement
  - Test data setup cannot be reused from our backend integration tests (we use the builder pattern there to create data in the DB)
  - Creating a view to test doesn't test the controller and vice versa. Still too low level for us. 

The biggest problem is that it's still more an integration/unit test than a scenario test and quite tightly coupled to your implementation. Since our implementation is far from perfect, Siesta is not the optimal solution for us. For example, we create stores inside our views and load them in `initComponent()`. No way to provide a stub store with some dummy data. We'd have to refactor 200+ views to create tests. Of course tests should be written before the implementation... 

If you would like to know more about Siesta or JS BDD testing, take a look at

  - [Pivotallabs blog post](http://pivotallabs.com/sencha-touch-bdd-part-5-controller-testing/)
  - [Siesta API doc: Getting started](http://www.bryntum.com/docs/siesta/#!/guide/siesta_getting_started)