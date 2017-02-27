+++
title = "karma"
draft = false
tags = [
    "code",
    "javascript",
    "testing",
    "karma"
]
date = "2013-05-17"
+++
# Karma (Testacular) 

Ook integratie met [code/javascript/testing/phantomjs]({{< relref "wiki/code/javascript/testing/phantomjs.md" >}}) mogelijk.

### Installatie 

Om de Karma testen gedraaid te krijgen moet Node geïnstalleerd zijn samen met karma (`npm install karma -g`)

Voor de **ANSI console** in eclipse: http://www.mihai-nita.net/eclipse/ installeren

Voor de Karma Phantom launcher in eclipse: dit importeren (launch file)

```xml
<?xml version######"1.0" encoding"UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key######"org.eclipse.ui.externaltools.ATTR_LOCATION" value"${workspace_loc:/vitrine/src/test/javascript/test.bat}"/>
<stringAttribute key######"org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value"${workspace_loc:/vitrine/src/test/javascript}"/>
</launchConfiguration>
```

Debuggen met eclipse gaat blijkbaar niet, daarvoor moet je best http://www.jetbrains.com/webstorm/ gebruiken. Wat ik nog heb bijgeleerd van jasmine: een individuele test tijdelijk draaien die je door `iit()` te gebruiken ipv `it()` (twee i's). 

Referentiemateriaal:

Angular & service mocking: 
  1. http://docs.angularjs.org/guide/dev_guide.services.testing_services
  2. http://docs.angularjs.org/api/ngMock.$httpBackend

Jasmine
  1. https://github.com/pivotal/jasmine/wiki/Spies

Karma
  1. https://github.com/angular/angular-seed/ 
  2. http://karma-runner.github.io/0.8/intro/configuration.html

Node - config
  1. https://npmjs.org/doc/config.html#proxy

```
npm config set proxy http://proxy.be:8080
npm config set https-proxy http://proxy.be:8080
```

### Integratie in maven 

```xml
			<plugin>
				<groupId>org.codehaus.mojo</groupId>
				<artifactId>exec-maven-plugin</artifactId>
				<version>1.2.1</version>
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
					<skip>${skipTests}</skip>
					<successCodes>
						<successCode>0</successCode>
						<successCode>1</successCode><!-- on failing test, don't get a build 
							error -->
					</successCodes>
					<executable>${basedir}/src/test/javascript/build.bat</executable>
					<workingDirectory>${basedir}/src/test/javascript</workingDirectory>
				</configuration>
			</plugin>
```

Bovenstaande `skip` config houdt dus ook rekening met bvb `mvn clean install -DskipTests` - de `test` phase van maven wordt **niet** geskipped maar de testen wel door de `maven-failsafe-plugin` - bijgevolg worden goals die aan de test fase hangen ook nog uitgevoerd. 

```bash
@echo off

set PHANTOMJS_BIN=C:<br/><br/>dvl.home<br/><br/>prj<br/><br/>vitrine<br/><br/>tools<br/><br/>phantomjs<br/><br/>phantomjs.exe
karma start --log-level=debug --single-run
```

:exclamation: Opgelet in **windows** met de paden, geen quotes gebruiken en dubbele backslashes wél gebruiken, anders werkt het niet en blijft karma hangen. 
### Een voorbeeld conf file voor een Angular app 

```javascript
basePath = '.';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  '../../main/webapp/js/lib/jquery*.js',
  '../../main/webapp/js/lib/angular.min.js',
  '../../main/webapp/js/lib/angular-*.js',
  '../../main/webapp/js/**/*.js',
  'lib/*.js',
  'specs/*.js'
];

// Nodig voor Jenkins en in de build te integreren: singleRun ipv autoWatch
autoWatch = true;
//singleRun = true;

browsers = ['PhantomJS'];
reporters = ['dots', 'junit'];

junitReporter = {
  outputFile: '../../../target/surefire-reports/be.vdab.vitrine.javascripts.xml',
  suite: 'unit'
};

```