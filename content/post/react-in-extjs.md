---
title: Migrating from Extjs to React gradually
bigimg: /img/Migrating from Extjs to React gradually.jpg
date: '2016-01-26'
subtitle: Migrating from Extjs to React gradually
tags: ['javascript', 'extjs', 'react' ]
---

We were looking for a few alternatives to our big ExtJS 4 application. Since it's not that easy to completely migrate from one front-end framework to the next, a possible solution would be to start developing new parts in another framework. There's a lot of domain logic spread in Ext views and controllers - which shouldn't be there, we are well aware of that. Let's call it "legacy" :-) 

The application right now uses Extjs as UI and C# as backend, and lets ext do the loading of the views/controllers (living in app.js like most ext applications). There's no ecosystem set up like modern javascript applications - build systems like Grunt, Gulp, node package managers, Browserify, ... are all not used. We do use sencha command to minify stuff. To be able to develop new modules without having to worry about extjs, one of the possibilities would be to use iframes. That enables us to (scenario) test the module using it's own routing. It's wrapped inside an Extjs view with an iframe:

		Ext.define('App.view.utilities.desktop.ReactWindow', {
		    extend: 'Ext.form.Panel',
		    alias: 'widget.App_view_utilities_desktop_ReactWindow',

		    bodyPadding: 5,
		    width: 600,

		    layout: {
		        type: 'vbox',
		        align: 'stretch'
		    },

		    initComponent: function() {
		        var me = this;

		        var dynamicPanel = new Ext.Component({
		            autoEl: {
		                tag: 'iframe',
		                style: 'border: none',
		                src: me.url
		            },
		            flex: 1
		        });

		        Ext.apply(me, {
		            title: 'React',
		            defaults: {
		                labelWidth: 120
		            },
		            items: [dynamicPanel]
		        });
		        me.callParent();
		    }
		});

When the module is triggered in the main app, we simply add the panel to the desktop:

        this.addPanel(Ext.create('App.view.utilities.desktop.ReactWindow', {
            url: 'react/mod/someurl/'
        }));

Our app structure in the GUI folder would be something like this:

[GUI]<br/>
* global.asax<br/>
* default.aspx<br/>
**** [app] -> extjs<br/>
**** [react] -> reactjs<br/>

That's simple enough. But how would one be able to open new Ext panels from within the React sub-application? That would be done via custom events thrown to the parent window. Catching these is just a matter of adding this to some controller in Extjs:

        window.addEventListener('react', function(e) {
            me.onReactEvent(e.detail, e);
        });

The `detail` property is part of a custom event, thrown in a react component. This below might be some cell component, taken from the [fixed-data-table](https://facebook.github.io/fixed-data-table/) example:

	class MyLinkCell extends React.Component {
		clicked(e) {
			const el = e.target;
			const eventObj = {
				'detail': {
					'type': 'downloadlink',
					'url': 'react/some/detail/url' 
				}
			};

			console.log('clicked - "react" event thrown:');
			console.dir(eventObj);
			if(window.parent) {
				window.parent.dispatchEvent(new CustomEvent('react', eventObj));
			}
		}

	  render() {
	    const {rowIndex, field, data} = this.props;
	    const link = data[rowIndex][field];
	    return (
	      <Cell>
	        <a onClick={this.clicked} href='#'>{link}</a>
	      </Cell>
	    );
	  }
	}

Of course this is more or less the same when for instance using Angular2 instead of React, the custom event is part of the JS standard, see [Creating and triggering events](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events) from MDN. 

To be able to use source maps in conjunction with Browserify/Watchify, I had to tweak some parameters in package.json:

	`watchify index.js --verbose -d -t babelify --sourceMapRelative . --outfile=bundle.js`

Things we still need to research:

  - How well does React compare to Angular2 in terms of components? For instance react doesn't include [routing](http://www.kriasoft.com/react-routing/) by default. We'll need to rewrite some already-extjs-custom components in the target framework.
  - How should we include the build ecosystem (npm, gulp/grunt/browserify, ...) into our C# build solution and Teamcity build? Will [http://reactjs.net/](http://reactjs.net/) help for instance? 
  - Can we use [http://reactjs.net/](http://reactjs.net/) to render serverside components?
  - Which build tool should we use? We're being overwhelmed by choice: bower/npm as package manager, I've seen stuff like [Webpack in conjunction with React](http://www.christianalfoni.com/articles/2015_10_01_Taking-the-next-step-with-react-and-webpack), ... The list is huge if you've not kept up with the JS technology news. 

One of the things we liked a lot was typescript or ES6 and the ability to use `=> ()` and promises. Enabling this requires a transpiler or a polyfill like [Babel JS](https://babeljs.io/), but maybe this as a build step in sencha command will also ease some pain we're having with the current Ext code. 