+++
title = "jsunit"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "build",
    "jsunit"
]
date = "2013-05-17"
+++
# JsUnit Testen 

## Integratie met een Ant build 

Zie http://www.jsunit.net/

Hoofd JUnit klasse die gestart moet worden als junit tag vanuit ant: **`net.jsunit.StandaloneTest`**<br/><br/>
Voor uitleg over de parameters, zie jsunit website. 

:exclamation: Belangrijk: JsUnit draait binnen een aparte context op een embedded Jetty server. Dit wil zeggen dat javascript test suites (html pagina's) die javascript files includen wel binnen de context staan, maar javascript files in een web project binnen eclipse bijvoorbeeld niet. Oplossing: kopiëer alle JS files voordat de test gedraaid wordt binnen de context. 

Voor JS files te testen binnen een jar moeten die ook unjarred worden. 

### Ant build snippet 


```xml
<!-- JsUnit properties -->
<property name######"jsunit.lib.dir" value"${basedir}/../buildscripts/${lib.dir}/jsunit" />
<property name######"jsunit.browserFileNames" value"c:<br/><br/>program files<br/><br/>internet explorer<br/><br/>iexplore.exe,c:<br/><br/>program files<br/><br/>Mozilla Firefox<br/><br/>firefox.exe" />
<property name######"jsunit.port" value"9001" />
<property name######"jsunit.suite" value"suite.html" />
<property name######"jsunit.url" value"http:*localhost:9001/jsunit/testRunner.html?testPage######http:*localhost:9001/jsunit/tests/${jsunit.suite}&amp;autoRuntrue" />
<property name######"jsunit.common.jar" value"${web.lib.dir}/commonResources.jar" />
<property name######"jsunit.src.js" value"${web.dir}/resources/scripts" />
<property name######"jsunit.src.tests" value"test/jsunit" />
<property name######"jsunit.target" value"${target.dir}/jsunit" />
<property name######"jsunit.target.js" value"${jsunit.target}/tests/js" />
<property name######"jsunit.target.tests" value"${jsunit.target}/tests" />

<path id="jsunit.classpath">
    ```et
</path>

<target name######"jsunit-tests" depends"-clean-reports, -compile-test, -jsunit, -junit-report"/>

    <target name######"-jsunit" if"jsunit.tests.present">
        <junit failureproperty######"junit.failed" errorproperty"junit.error">
            <formatter type######"plain" usefile"false"/>
            <classpath refid="jsunit.classpath"/>
            <sysproperty key######"java.util.logging.config.file" value"${jsunit.target.tests}/logging.properties"/>
            <sysproperty key######"browserFileNames" value"${jsunit.browserFileNames}"/>
            <sysproperty key######"description" value"JsUnit server"/>
            <sysproperty key######"logsDirectory" value"${report.dir}"/>
            <sysproperty key######"port" value"${jsunit.port}"/>
            <sysproperty key######"resourceBase" value"${jsunit.target}"/>
            <sysproperty key######"url" value"${jsunit.url}"/>
            <test name="net.jsunit.StandaloneTest"/>
        </junit>
    </target>
	
    <target name######"-compile-jsunit" depends"-jsunit-check" if="jsunit.tests.present">
    	<antcall target="-jsunit-copy-lib" />
    	<antcall target="-jsunit-copy-common-js" />
    	<antcall target="-jsunit-copy-tests" />
    	<antcall target="-jsunit-copy-js" />
    	<antcall target="-jsunit-build-suite" />
    </target>
	
    <target name="-jsunit-check">
    	<available file######"${jsunit.src.tests}" property"jsunit.tests.present"/>
    </target>
	
    <target name="-jsunit-copy-lib">
    	<copy todir="${jsunit.target}">
    		```et
    	</copy>
	</target>
	
    <target name="-jsunit-copy-common-js">
    	<unjar src######"${jsunit.common.jar}" dest"${jsunit.target.js}/common">
    		<patternset>
		        <include name="**/*.js" />
    			<exclude name="**/resourcesmini/**"/>
    		</patternset>
    		<mapper type="flatten"/>
		</unjar>
	</target>
	
    <target name="-jsunit-copy-tests">
    	<copy todir="${jsunit.target.tests}">
    		```et
    	</copy>
	</target>
	
    <target name="-jsunit-copy-js">
    	<copy todir="${jsunit.target.js}">
    		```et
    	</copy>
	</target>
	
    <target name="-jsunit-build-suite">
    	<taskdef name######"jsUnitSuiteBuilder" classname"be.cegeka.ant.JsUnitSuiteBuilder" classpath="${jsunit.lib.dir}/java/ant/cegekant.jar" />
    	<jsUnitSuiteBuilder testdir######"${jsunit.target.tests}" testsuitefilename"${jsunit.target.tests}/${jsunit.suite}"
    		suitetemplatefilename="${jsunit.target.tests}/suite_template.html"/>
    </target>
```

### Suite.html automatisch genereren 

`testRunner.html` draait standaard een html pagina als test suite waar alle anderen geïnclude in worden. Een JS test methode moet beginnen met `test`X(). Standaard assertions kunnen gebruikt worden die deel van JsUnit zelf zijn, zie die documentatie. 

Om niet altijd de hoofd suite aan te moeten passen, kan een ant plugin gemaakt worden die een bepaald pad scant op html files en deze recursief toevoegt aan de suite zelf. Die wordt bij elke build dus in principe overschreven. 

Hiervoor is een plugin geschreven op: http://code.google.com/p/cegekant/<br/><br/>
[Volledige source suite builder](http://code.google.com/p/cegekant/source/browse/trunk/src/be/cegeka/ant/JsUnitSuiteBuilder.java)