+++
title = "phantomjs"
draft = false
tags = [
    "code",
    "javascript",
    "testing",
    "phantomjs"
]
date = "2013-03-12"
+++
# Test automatisatie: PhantomJS 

Een experiment om mijn `JasmineTestRunner` uit te breiden (of volledig op te splitsen) van **Rhino + Envjs 1.2** naar **PhantomJS 1.4** (liefst 1.5 maar dit moet ik nog compilerend krijgen onder Windows). 

### Phantom.js test code 

#### Start script 

```javascript

console.log("loading");
var page = new WebPage();

// Is nodig omdat anders in uw testpagina console.log() niets doet. 
page.onConsoleMessage = function(msg) {
	console.log("debug from page: " + msg);
};

/**
 * Phantom JS 1.4 tests voor EnvJS "fixes" die ik heb moeten erin hacken.
 * Alles werkt blijkbaar native, hoera!
 *
 * TODO:
 * -----
 * # Waarom werken relatieve paden niet met openen van de pagina (crash Phantom)
 * # Waarom werken script includes niet, lokaal op relatief pad? Absoluut = access denied
 *   -> Een HTTP pad opgeven werkt wel, zoals jQuery.com include. 
 *   -> Zolang dit niet goed werkt kunnen we niet naar de jasmine HTML suite gaan! 
 * # testen van set/clearTimeout en set/clearInterval
 * # Heb ik Rhino dan nog wel nodig? Hoe kan ik phantomjs output evalueren en dan in een TestRunner knallen?
 * 
 * Jasmine integratie
 * ------------------
 * Custom XML reporters, zie
 *  - http://code.google.com/p/phantomjs/wiki/ExternalArticles
 *  - http://code.google.com/p/phantomjs/wiki/TestFrameworkIntegration
 *  - https://github.com/detro/phantomjs-jasminexml-example
 **/
page.open('D:<br/><br/>Profiles<br/><br/>BVERBEKE<br/><br/>Desktop<br/><br/>phantomjs-1.4.1-win32-dynamic<br/><br/>test.html', function(status) {

	console.log("should have printed 'yoo' AND 'sup?', include from test.js??");
	console.log("");
	
	var testHTML = page.evaluate(function() {
		return document.getElementById('test').innerHTML;
	});
	
	var isKnopHidden = page.evaluate(function() {
		return $("#hiddenKnop").is(":hidden");
	});
	
	var whichIsFocussed = page.evaluate(function() {
		return document.activeElement.id;
	});
	
	var divHeightCSSGetterTest = page.evaluate(function() {
		return $("#test").css("height");
	});
	
	var jQueryCheckedSelectorTest = page.evaluate(function() {
		$("#check").click();
		return $("#check").is(":checked");
	});	
	
	console.log("got testHTML " + testHTML);
	console.log("is knop hidden? (should be) --> " + isKnopHidden);
	console.log("which is focussed? (should be textarea) --> #" + whichIsFocussed);
	console.log("div height? (should be 100px) --> " + divHeightCSSGetterTest);
	console.log("checkbox checked? (should be true) --> " + jQueryCheckedSelectorTest);
	
	phantom.exit();
});
```

#### Test.js script 

```javascript
console.log("supp??");
```

#### Test.html resources 

```html
<!DOCTYPE HTML PUBLIC "-*W3C*DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

	<head>
		<script type######"text/javascript" src"test.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	</head>
	<body>
	<div id="test">bla</div>
	<form>
		<input type######"button" id"knop"></input>
		<textarea id="text">eerste val</textarea>
		<input type######"button" id"hiddenKnop" value="hidden"></input>
		<input type######"checkbox" id"check"></input>
	</form>
	
		<script type="text/javascript">
		console.log("yoo");
		document.getElementById("test").innerHTML = "nieuwe blabla";
		
		$("#test").html("jquery nieuwe blabla").css("height", "100px");
		$("#hiddenKnop").hide();
		$("#text").focus();
		
		console.log("is knop hidden? (should be) --> " + $("#hiddenKnop").is(":hidden"));
		
		</script>
	</body>

```

#### Console Output bovenstaande 

```
D:<br/>Profiles<br/>BVERBEKE<br/>Desktop<br/>phantomjs-1.4.1-win32-dynamic>phantomjs start.js
loading
debug from page: yoo
debug from page: is knop hidden? (should be) --> true
should have printed 'yoo' AND 'sup?', include from test.js??

got testHTML jquery nieuwe blabla
is knop hidden? (should be) --> true
which is focussed? (should be textarea) --> #text
div height? (should be 100px) --> 100px
checkbox checked? (should be true) --> true
```

### Phantom.js uitvoeren 

Downloaden (1.4 voor windows...) op http://code.google.com/p/phantomjs/downloads/list, zit Qt4 libs in. Dan met:

-> `phantomjs start.js`

Die dan met `page.open()` een webpagina inlaadt. Blijkbaar werkt `<script/>` tags evaluaten nog niet voor bepaalde paden? 

#### Relatieve paden probleem 

Mogelijke oorzaak: `Qt 4.8.0` die URLs anders behandelt. Wordt gerevert vanaf `4.8.1` en zou ook moeten werken met `4.7.0`. Vereist zelf compileren van PhantomJS... 

Zie ook

  1. http://code.google.com/p/phantomjs/issues/detail?id=231 en 
  2. http://stackoverflow.com/questions/9261803/phantomjs-is-not-loading-scripts-correctly-from-html-page-with-tests

Mottige tijdelijke oplossing:

```javascript
page.open("url", function() {
  page.injectJs("filename"); // rel.path is OK here.
});
```

##### Oplossing in Windows: werk met absoluut path dat de base HTML include 

:exclamation: Bovenstaande `.page.open(absoluteUrl)` vervangen door:

```javascript
page.open(require('fs').absolute('test.html'), function() {});
```

Vanaf dan werken ook relatieve `<SCRIPT/>` tag includes! 

### Evalueren in page context en in Phantom context 

`page.evaluate()` wordt in een sandbox uitgevoerd, geen mogelijkheid tot closure scope én geen mogelijkheid tot toegang van het `phantom` object. Hoe kunnen we dan argumenten meegeven, of objecten of functies? 

Hier is een "hackje" voor:

```javascript
function evaluate(page, func) {
    var args = [].slice.call(arguments, 2);
    var str = 'function() { return (' + func.toString() + ')(';
    for (var i ###### 0, l  args.length; i < l; i++) {
        var arg = args[i];
        if (/object|string/.test(typeof arg)) {
            str += 'JSON.parse(' + JSON.stringify(JSON.stringify(arg)) + '),';
        } else {
            str += arg + ',';
        }
    }
    str = str.replace(/,$/, '); }');
    return page.evaluate(str);
}

var page = require('webpage').create();
var func = function() {
    console.log('hello, ' + document.title + '<br/>n');
	
    for (var i ###### 0, l  arguments.length; i < l; i++) {
        var arg = arguments[i];
        console.log(typeof arg + ':<br/>t' + arg);
    }
};
page.onLoadFinished = function() {
    evaluate(page, func, true, 0, function() {
		return require('fs').read
	});
    phantom.exit(0);
};
page.open('http://www.google.com/');
```

Wat helaas NIET werkt is het volgende:

```javascript
var func = function() {
  arguments[0]('bla.html');
}

page.onLoadFinished = function() {
  var read = require('fs').read;
  evaluate(page, func, read);
};
```

Waarom niet? `ReferenceError: Can't find variable: require`.

Hoe kan ik dan `Phantom`/`commonJs` variabelen gebruiken? Voorlopig niet? Feature request voor 1.6 - zie http://code.google.com/p/phantomjs/issues/detail?id=132

### PhantomJS en jQuery Ajax 

Werkt maar niet in `async: false` mode. Zie http://code.google.com/p/phantomjs/issues/detail?id######463&thanks463&ts=1332850556

```javascript
page.evaluate(function() {
	console.log("ajaxying");
  jQuery.ajax({
	async: false,
	dataType: 'html',
	url: 'test.html',
	success: function(data) {
		console.log("--success!!");
		console.log(data);
		console.log("--");
	}
  });		
});
```

Print:

```
--success!!

--
```

?? Async mode moet uit staan voor jasmine fixtures te kunnen laden... 

### Phantomjs en Jasmine integratie 

Werkend met **jasmine 1.1.0**: zie uitgewerkt voorbeeld op https://github.com/detro/phantomjs-jasminexml-example/

Het komt basically hierop neer:

  * een js file die de suite.html inleest en wacht tot jasmine klaar is met runnen
  * een custom reporter van jasmine die JUnit XML genereert. Wanneer dit klaar is schrijft de suite.html opener met phantom code de file weg. 
  * een maven plugin om de executable te draaien en de XML naar de juiste `surefire-reports` directory weg te schrijven.

#### in pom.xml 

```xml
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>1.1</version>
                <executions>
                    <execution>
                        <id>jsunit</id>
                        <phase>test</phase>
                        <goals>
                            <goal>exec</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <executable>phantomjs.exe</executable>
                    <workingDirectory>${project.js.test.directory}/lib</workingDirectory>
                    <arguments>
                        <argument>run-jasmine.js</argument>
                        <argument>./../suite.html</argument>
                        <argument>${project.build.directory}/surefire-reports</argument>
                    </arguments>
                </configuration>
            </plugin>
```

### Phantomjs en QUnit integratie 

Geïntegreerd met maven:

  1. http://kennychua.net/blog/running-qunit-tests-in-a-maven-continuous-integration-build-with-phantomjs
  1. http://code.google.com/p/phantomjs-qunit-runner/

#### Fixtures inladen 

Voor zover de QUnit documentatie aanwezig is, zijn fixtures child DOM elementen van `#fixtures`, een div die buiten het scherm float:

> The #qunit-fixture element can be used to provide and manipulate test markup, and it's content will be automatically reset after each test (see QUnit.reset). The element is styled with position:absolute; top:-10000px; left:-10000; - with these, it won't be obstructing the result, without affecting code the relies on the affected elements to be visible (instead of display:none).

Wordt dus automatisch gereset, maar we hebben dan ook `jQuery.ajax` nodig om externe files in te laden -> zelfde probleem! 