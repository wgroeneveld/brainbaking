+++
title = "knockout"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "frameworks",
    "knockout"
]
date = "2013-03-12"
+++
# Knockout JS 

## Paged client-side table zelf voorzien 

:exclamation: Zie http://jsfiddle.net/rniemeyer/5Xr2X/

> The basic idea is that you have a dependentObservable that represents the rows in your current page and bind your table to it. You would slice the overall array to get the rows for the page. Then, you have pager buttons/links that manipulate the page index, which causes the dependentObservable to be re-evaluated resulting in the current rows.

Op deze manier met `dependentObservable`:

```javascript
var myns = {};
myns.DisplayFields = function(jsondata) {
    var viewModel = {
        fields: ko.observableArray(jsondata),
        sortByName: function() { //plus any custom functions I would like to perform
            this.items.sort(function(a, b) {
                return a.Name < b.Name ? -1 : 1;
            });
        },
        pageSize: ko.observable(10),
        pageIndex: ko.observable(0),
        previousPage: function() {
            this.pageIndex(this.pageIndex() - 1);
        },
        nextPage: function() {
            this.pageIndex(this.pageIndex() + 1);
        }
    };

    viewModel.maxPageIndex = ko.dependentObservable(function() {
        return Math.floor(this.fields().length / this.pageSize());
    }, viewModel);

    viewModel.pagedRows = ko.dependentObservable(function() {
        var size = this.pageSize();
        var start = this.pageIndex() * size;
        return this.fields.slice(start, start + size);
    }, viewModel);

    ko.applyBindings(viewModel);
};
```


## Layout JS Update trigger nodig? 

(Via [Stack overflow](http://stackoverflow.com/questions/5598751/knockoutjs-utilizing-jquery-tablesorter-with-a-jquery-tmpl-generated-table))

Stel dat na het updaten van de DOM door `KnockoutJS`, er nog styling nodig is door bvb `jQuery`. <br/><br/>
Zelf de event aanroepen zoals `$(el).repaint()` werkt altijd maar is enorm vervelend. `Knockout` ondersteutn ook *binding handlers*:

```javascript
ko.bindingHandlers.triggerUpdate = {
    update: function (element, valueAccessor) {
        ko.utils.unwrapObservable(valueAccessor()); //need to just access the observable to create the subscription
        $(element).trigger("repaint"); // or whatever you'll need
    }
}
```

Het element binden:

```html
<table id######"mytable" data-bind"triggerUpdate: items">
```

`triggerUpdate` is een zelf aangemaakte *binding handler*. Voor meer info, zie http://knockoutjs.com/documentation/custom-bindings.html

## JS Logica in data-* volledig scheiden 

**Probleem**: Knockout gebruikt veel `data-` HTML5 attributen om gedrag van elementen te bepalen. <br/><br/>
Dit zou ideaal gezien opgesplitst moeten worden (unit testable etc):

```html
<button type######"submit" data-bind"enable: languageToAdd().length > 0, click: addLanguage">Add</button>
```

**Oplossing**: Schrijf een stukje custom JS dat de `data-bind` attribuut zelf zet gebaseerd op een ander model dan uw klassiek `viewModel` - bvb. `bindingsModel`.

Bijvoorbeeld:

```javascript
var bindings = {
   inputs: ['name', 'bio', 'twitterHandle', 'state', 'photoUrl'],
   options: ['languages'],
   custom: { languageToAdd: 'value: languageToAdd, valueUpdate: "afterkeydown"' }
};

modelBinder.createBindings(bindings);
```

Dit is het custom gedeelte:

```javascript
var modelBinder = {};
modelBinder.createBindings = function (bindlist) {
    function setBinding(id, value) {
        var el = document.getElementById(id);
        if (el) {
            el.setAttribute('data-bind', value);
        }
    }
    
    for(var inputsKey in bindlist.inputs) {
        if (bindlist.inputs.hasOwnProperty(inputsKey)) {
            setBinding(bindlist.inputs[inputsKey], 'value: ' + bindlist.inputs[inputsKey]);
        }
    }
        
    for(var optionsKey in bindlist.options) {
        if (bindlist.inputs.hasOwnProperty(optionsKey)) {
            setBinding(bindlist.options[optionsKey], 'options: ' + bindlist.options[optionsKey]);
        }
    }
        
    for(var key in bindlist.custom) {
        if (bindlist.custom.hasOwnProperty(key)) {
            setBinding(key, bindlist.custom[key]);
        }
    }
};
```

Zodat we in HTML enkel dit hebben:

```html
<button type######"submit" id"languageToAdd">Add</button>
```

Bron: http://userinexperience.com/?p=633