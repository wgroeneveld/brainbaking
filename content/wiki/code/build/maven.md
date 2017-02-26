+++
title = "maven"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "build",
    "maven"
]
date = "2013-06-05"
+++
# Maven2 Build stuff 

:exclamation: **properties** guide: http://docs.codehaus.org/display/MAVENUSER/MavenPropertiesGuide

## javascript files automatisch minify-en 

```xml
	<profiles>
		<profile>
			<id>minify</id>
			<build>
				<plugins>
					<plugin>
						<groupId>org.apache.maven.plugins</groupId>
						<artifactId>maven-war-plugin</artifactId>
						<version>2.1.1</version>
						<configuration>
							<warSourceExcludes>**/js/**</warSourceExcludes>
						</configuration>
					</plugin>
					<plugin>
						<groupId>net.tqh.plugins</groupId>
						<artifactId>uglifyjs-maven-plugin</artifactId>
						<version>1.0</version>
						<configuration>
							<sourceDirectory>src/main/webapp/js</sourceDirectory>
							<outputDirectory>target/${project.name}-${version}/js</outputDirectory>
						</configuration>
						<executions>
							<execution>
								<phase>prepare-package</phase>
								<goals>
									<goal>uglify</goal>
								</goals>
							</execution>
						</executions>
					</plugin>
				</plugins>
			</build>
		</profile>
	</profiles>
```

Bron: https:*github.com/mishoo/UglifyJS - maven plugin gebruikt `Rhino` om dit uit te voeren. Kan ook met `node` uitgevoerd worden - gebruik bij voorkeur `r.js` (zie http:*requirejs.org/docs/optimization.html) 

## Argumenten als system property meegeven aan testen 

Maven forkt by default dus `-Dbla=blie` gaat niet werken, dit is een property voor het maven java commando, maar niet voor de test zelf.

Oplossing: ` mvn test -DargLine######"-Dsystem.test.propertytest"`

**argLine** gebruiken. Zie:

  1. http://www.cowtowncoder.com/blog/archives/2010/04/entry_385.html
  2. [maven properties guide](http://docs.codehaus.org/display/MAVENUSER/MavenPropertiesGuide)

## Een single-deps jar mekan met maven assembly 

```xml
 <plugin>
            <artifactId>maven-assembly-plugin</artifactId>
            <configuration>
                <archive>
                    <manifest>
                        <mainClass>fully.qualified.MainClass</mainClass>
                    </manifest>
                </archive>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
            </configuration>
        </plugin>
    </plugins>
```

En dan met `mvn assembly:single` uitvoeren. Dit maakt in uw target dir een file genaamd `bla-1.0-SNAPSHOT-jar-with-dependencies.jar`. `java -jar [jar]` werkt dan.

## Een test jar maken met maven assembly 

Met `maven assembly` kan je files packagen na het compileren van tests maar voor het runnen. Op die manier kunnen we dus bvb class files in een jar packagen (of resources in een zip). Daarna manueel installeren in de repository ofzoiets. 

Plugin:

```xml
			<plugin>
				<artifactId>maven-assembly-plugin</artifactId>
				<version>2.2-beta-2</version>
				<executions>
					<execution>
						<id>create-test-dependency</id>
						<phase>process-test-classes</phase>
						<goals>
							<goal>single</goal>
						</goals>
						<configuration>
							<finalName>gatecontrol</finalName>
							<attach>false</attach>
							<descriptors>
								<descriptor>test-assembly.xml</descriptor>
							</descriptors>
						</configuration>
					</execution>
				</executions>
			</plugin>
```

De externe assembly file:

```xml
<assembly>
  <id>testjar</id>
  <formats>
    <format>jar</format>
  </formats>
  <includeBaseDirectory>false</includeBaseDirectory>
  ```ets
    ```et
      <directory>target/test-classes</directory>
      <outputDirectory>/</outputDirectory>
      <includes>
        <include>**</include>
      </includes>
    </fileSet>
  </fileSets>
</assembly>
```

:exclamation: test jars zijn precies niet **transitief** qua dependencies? <br/><br/>
Als je een test-jar (die dus op `scope test` staat) wil includen in je eigen `assembly:single` jar, kan je `classifier tests` gebruiken:

```xml
<dependency>
  <groupId>be.bla</groupId>
  <artifactId>bla-blie</artifactId>
  <scope>test</scope>
  <classifier>tests</classifier>
</dependency>
```

Dan wordt die test jar mee gepackaged, maar zijn dependencies blijbkaar niet? 

## Profiles en properties 

#### activeByDefault 

Zie http://java.dzone.com/articles/maven-profile-best-practices - **nooit** gebruiken! Waarom?

> This flag activates the profile if no other profile is activated. Consequently, it will fail to activate the profile if any other profile is activated. This seems like a simple rule which would be hard to misunderstand, but in fact it's surprisingly easy to be fooled by its behaviour. When you run a multimodule build, the activeByDefault flag will fail to operate when any profile is activated, even if the profile is not defined in the module where the activeByDefault flag occurs.

In plaats daar van:

```xml
<profile id="nofoobar">
    <activation>
        <property>
            <name>!foo.bar</name>
        </property>
    </activation>
</profile>
```

## JAXB generatie 

#### Genereer endpoints vanaf WSDL 

```xml
			<plugin>
				<groupId>org.codehaus.mojo</groupId>
				<artifactId>jaxws-maven-plugin</artifactId>
				<version>${org.codehaus.mojo.jaxws.maven.plugin.version}</version>
				<executions>
					<execution>
						<goals>
							<goal>wsimport</goal>
						</goals>
					</execution>
				</executions>
				<configuration>
					<wsdlDirectory>src/resources/wsdl</wsdlDirectory>
					<packageName>com.x.interfaces.ws</packageName>
					<sourceDestDir>${project.build.directory}/generated-sources/jaxws</sourceDestDir>
				</configuration>
				<dependencies>
					<dependency>
						<groupId>com.sun.xml.ws</groupId>
						<artifactId>jaxws-tools</artifactId>
						<version>${com.sun.xml.ws.jaxws.version}</version>
					</dependency>
				</dependencies>
			</plugin>
```

Zie http://rphgoossens.wordpress.com/2011/02/20/developing-a-contract-first-jax-ws-webservice/

Genereer de code met `mvn jaxws:wsimport` goal.

#### Genereer JAXB Java objecten vanaf XSD 

Zelfde pincipe, andere `goal`:

```xml
			<plugin>
				<groupId>org.jvnet.jaxb2.maven2</groupId>
				<artifactId>maven-jaxb2-plugin</artifactId>
				<version>${org.jvnet.jaxb2.maven2.maven.jaxb2.plugin.version}</version>
				<executions>
					<execution>
						<id>crm_generation</id>
						<goals>
							<goal>generate</goal>
						</goals>
						<configuration>
							<schemaDirectory>src/main/schema</schemaDirectory>
							<schemaIncludes>
								<include>y.wsdl</include>
							</schemaIncludes>
							<schemaLanguage>WSDL</schemaLanguage>
							<generatePackage>com.x.interfaces</generatePackage>
						</configuration>
					</execution>
				</executions>
			</plugin>
```

## Integratie met Ant 

Maven kan ook ant tasks uitvoeren. Dit door ant code te embedden in de pom.xml op de volgende manier:

```xml
		   <plugin>
		    <groupId>org.apache.maven.plugins</groupId>
		    <artifactId>maven-antrun-plugin</artifactId>
		     
		    <configuration>
		     <tasks>
		      <property name######"target.war" value"bla.war" />
		      <property name######"zip.name" value"bla.zip" />
		      
		      <ant antfile######"build.xml" inheritRefs"true" inheritAll="true">
		      	<target name="buildZip" />
		      </ant>
		     </tasks>
		    </configuration>
		    
		    <goals>
		     <goal>install</goal>
		    </goals>
		   </plugin>
```

Binnen de configuration tag zit ant code, met de ant tag roep ik een externe build xml aan. Op die manier kan je dus een ant buildfile volledig naast een pom.xml maven2 file plaatsen, en properties doorgeven! Die ant task wordt uitgevoerd met het commando `mvn antrun:run` of bij bepaalde geconfigureerde goals. 

Voorbeeld: http://maven.apache.org/plugins/maven-antrun-plugin/

#### Aan bepaalde phase hangen 

Zie http://www.avajava.com/tutorials/lessons/what-are-the-phases-of-the-maven-default-lifecycle.html

Om nog rap een property file te kopiëren, best aan `prapare-package` phase hangen (maven 2.1+):

```xml
	 <profiles>
	   <profile>
	     <id>env</id>
	     <activation>
	     	<property>
	     		<name>env</name>
	     	</property>
	     </activation>
	     <build>
	       <plugins>
	         <plugin>
	           <artifactId>maven-antrun-plugin</artifactId>
	           <executions>
	             <execution>
	               <phase>prepare-package</phase>
	               <goals>
	                 <goal>run</goal>
	               </goals>
	               <configuration>
	                 <tasks>
						<echo message="Env property detected, copying ${env} to output directory..." />
                   		<copy file######"src/main/resources/template/env.${env}.properties" tofile"${project.build.outputDirectory}/env.properties"/>
	                 </tasks>
	               </configuration>
	             </execution>
	           </executions>
	         </plugin>
         </plugins>
        </build>
       </profile>
     </profiles>
```

## Javadoc genereren 

Deze plugin nodig:

```xml
		    <plugin>
		        <groupId>org.apache.maven.plugins</groupId>
		        <artifactId>maven-javadoc-plugin</artifactId>
		        <version>2.7</version>
		        <configuration>
		          <reportOutputDirectory>release/doc</reportOutputDirectory>
		          <destDir>javadoc</destDir>
		          <doctitle>API for ${project.name} ${project.version}</doctitle>
		          <windowtitle>API for ${project.name} ${project.version}</windowtitle>
		        </configuration>
		   </plugin>
```

:exclamation: output dir = `${reportOutputDirectory}/${destDir}`<br/><br/>
Voorbeeld: http://maven.apache.org/plugins/maven-javadoc-plugin/examples/output-configuration.html

## Deployen met maven 

### Jetty integratie en auto-deploy 

#### jetty run 

Integratie met jetty en maven2: gebruik `mvn jetty:run` om automatisch de jetty server op te starten.<br/><br/>
Het is ook mogelijk om die te laten scannen voor resource changes met `scanIntervalSeconds` - server start automatisch (normaal gezien...)

```xml
			<plugin>
				<groupId>org.mortbay.jetty</groupId>
				<artifactId>maven-jetty-plugin</artifactId>
				<version>6.1.26</version>
				<configuration>
					<stopPort>9966</stopPort>
					<stopKey>comeet</stopKey>
					<scanIntervalSeconds>5</scanIntervalSeconds>
					<connectors>
						<connector implementation="org.mortbay.jetty.nio.SelectChannelConnector">
							<port>8089</port>
						</connector>
					</connectors>
				</configuration>
			</plugin>
```

:exclamation: Vanaf Jetty plugin 7 zijn packages hernoemd en zo, zie http://wiki.eclipse.org/Jetty en de migratie van 6->7->...9

##### Debug poort instellingen 

Gebruikt `MAVEN_OPTS` JVM parameters (omdat het proces niet geforked wordt?): http://docs.codehaus.org/display/JETTY/Debugging+with+the+Maven+Jetty+Plugin+inside+Eclipse

```
-Xdebug -Xnoagent -Djava.compiler######NONE -Xrunjdwp:transportdt_socket,address######4000,servery,suspend=y
```

##### JNDI Datasources definiëren 

Kan in webapp/WEB-INF/jetty-env.xml:

```xml
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-*Mort Bay Consulting*DTD Configure*EN" "http:*jetty.mortbay.org/configure.dtd">

<Configure class="org.mortbay.jetty.webapp.WebAppContext">

	<New id######"partnerwerkingDataSource" class"org.mortbay.jetty.plus.naming.Resource">
		<Arg>jdbc/partnerwerkingDataSource</Arg>
		<Arg>
			<New class="oracle.jdbc.pool.OracleDataSource">
				<Set name="URL">${database.url}</Set>
				<Set name="user">${database.user}</Set>
				<Set name="password">${database.password}</Set>
			</New>
		</Arg>
	</New>

</Configure>
```

wordt dan automatisch door `jetty:run` opgepikt. 

#### auto-start bij integratie testen (failsafe plugin) 

Als we aan bovenstaande plugin ook nog `executions` opgeven, start jetty automatisch bij `pre-integration-test` en stopt hij automatisch bij `-post-integration-test`:

```xml
				<executions>
					<execution>
						<id>start-jetty</id>
						<phase>pre-integration-test</phase>
						<goals>
							<goal>run</goal>
						</goals>
						<configuration>
							<scanIntervalSeconds>0</scanIntervalSeconds>
							<daemon>true</daemon>
						</configuration>
					</execution>
					<execution>
						<id>stop-jetty</id>
						<phase>post-integration-test</phase>
						<goals>
							<goal>stop</goal>
						</goals>
					</execution>
				</executions>
```

`daemon` moet op **true** staan omdat de bovenstaande plugin (jetty6) geen fork doet en dan natuurlijk geen testen gedraaid worden... 

### Tomcat deploy 

Op verschillende omgevingen deployen kan door verschillende profielen aan te maken in de pom.xml file, en dan als env. parameter `-Denv=[gewenste env value]` de te deployen mee te geven:

```xml
	<profiles>
		<profile>
			<activation>
				<property>
					<name>env</name>
					<value>test</value>
				</property>
			</activation>

			<properties>
				<server.url>http://blatomcat:8888/manager</server.url>
				<server.username>user</server.username>
				<server.password>pass</server.password>
			</properties>
		</profile>
	</profiles>
```

Die properties die hierboven staan worden dan in deze plugin ingevuld:

```xml
			<plugin>
				<groupId>org.codehaus.mojo</groupId>
				<artifactId>tomcat-maven-plugin</artifactId>
				<version>1.0-beta-1</version>
				<configuration>
					<url>${server.url}</url>
					<username>${server.username}</username>
					<password>${server.password}</password>
				</configuration>
			</plugin>
```

Uitvoeren met `mvn tomcat:deploy [-Denv=x]`<br/><br/>
Voorbeelden en meer uitleg: http://mojo.codehaus.org/tomcat-maven-plugin/
## War name veranderen 

Staat default op `${project.build.finalName}` wat neerkomt op artifactId-version.war.

Te veranderen door `<warName>blar</warName>` in `<configuration/>` te plaatsen in de `maven-war-plugin`.<br/><br/>
**Zonder** .war ext. dus.
Zie http://maven.apache.org/plugins/maven-war-plugin/war-mojo.html#warName

## Jar source code downloaden 

```
mvn dependency:sources
```

Ook mogelijk in de pom door per dependency `downloadSources` op `true` te zetten, of via de `eclipse:eclipse` goal plugin:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-eclipse-plugin</artifactId>
            <configuration>
                <downloadSources>true</downloadSources>
                <downloadJavadocs>true</downloadJavadocs>
                ... other stuff ...
            </configuration>
        </plugin>
    </plgins>
</build>
```

Vergeet niet dan als property `-DdownloadSources=true` mee te geven.

#### eclipse:eclipse genereert ook de .project file 

Library dependencies worden daar automatisch aan toegevoegd, maar alles staat onder **M2_REPO**/org/.../bla.jar en Eclipse moet weten waar lokaal de repository staat. Zie ook http://maven.apache.org/guides/mini/guide-ide-eclipse.html - Dit commando uitvoeren & eclipse herstarten:

`mvn -Declipse.workspace=<path-to-eclipse-workspace> eclipse:add-maven-repo`

#### Automatisch source files encoden 

Je kan met die plugin ook extra configuratie meegeven die de `.java` files qua encoding goed zet:

```xml
<additionalConfig>
	```
		<name>.settings/org.eclipse.core.resources.prefs</name>
			<content>
           				<![CDATA[eclipse.preferences.version######1${line.separator}encoding/<project>${project.build.sourceEncoding}${line.separator}]]>
			</content>
	```
</additionalConfig>
```
## Dependency tree tonen 

```
mvn dependency:tree > deptree.out
```

Produceert rommel in het volgend formaat:

```
[INFO] [dependency:tree {execution: default-cli}]
[INFO] be.--api:jar:2.21-SNAPSHOT
[INFO] +- be.-support:jar:7.21-SNAPSHOT:compile
[INFO] |  +- org.easytesting:fest-assert:jar:1.2:test (scope managed from compile)
[INFO] |  |  <br/>- org.easytesting:fest-util:jar:1.1:test
[INFO] |  +- com.thoughtworks.xstream:xstream:jar:1.3.1:compile
[INFO] |  |  <br/>- xpp3:xpp3_min:jar:1.1.4c:compile
[INFO] |  +- javax.ws.rs:jsr311-api:jar:1.1.1:compile
[INFO] |  +- org.objenesis:objenesis:jar:1.2:compile
[INFO] |  +- net.sf.ehcache:ehcache:jar:1.6.0:compile
[INFO] |  +- log4j:log4j:jar:1.2.15:compile
[INFO] |  |  <br/>- javax.mail:mail:jar:1.4:compile
[INFO] |  +- commons-codec:commons-codec:jar:1.3:compile
[INFO] |  +- jmimemagic:jmimemagic:jar:0.1.2:compile
[INFO] |  |  +- oro:oro:jar:2.0.8:compile
[INFO] |  |  <br/>- commons-logging:commons-logging:jar:1.1.1:compile (version managed from 1.0.4)
[INFO] |  +- commons-io:commons-io:jar:1.4:compile
[INFO] |  +- org.htmlcleaner:htmlcleaner:jar:2.1:compile
..
```

## Een bepaalde test draaien via Maven 

```
mvn test -Dtest=[testClass] -P [profile]
```

Waarbij `profile` het profiel is die de surefire plugin heeft - bijvoorbeeld:

```xml
<profile>
	<id>endtoend</id>
	<activation>
		<property>
			<name>endtoend</name>
		</property>
	</activation>
	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-surefire-plugin</artifactId>
				<executions>
					<execution>
						<phase>integration-test</phase>
						<goals>
							<goal>test</goal>
						</goals>
						<configuration>
							<testFailureIgnore>true</testFailureIgnore>
							<skip>false</skip>
							<argLine>-Xms128M -Xmx512M -XX:MaxPermSize=512M</argLine>
						</configuration>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
</profile>
```

:exclamation: Als een bepaalde jar nog deployed moet worden (naar Jetty bvb) voor het runnen van de test (scenario testen zoals selenium en webdriver), moet de `install` in plaats van `test` goal uitgevoerd worden. <br/><br/>
Het kan *ook* zijn dat nog zaken geïnstalleerd moeten worden in de lokale Maven repository (het root project) -> eerst `mvn clean install` op het root project doen (voor *vac* is dit zo). Dit is omdat het endtoend project daarop afhangt, en de compile dan faalt. 

## Een jar manueel in de repository installeren 

Gebruik het volgende commando:

> `mvn install:install-file -Dfile######x.jar -DgroupIdcom.group -DartifactId######jarName -Dversion1.0.0 -Dpackaging=jar`

Wens je dit in de **remote repository** te installeren, gebruik dan `mvn deploy:deploy-file` met als extra parameter de url van de repository via de `-Durl=repoUrl` optie. 

## De maven java compiler versie goed zetten 

Gebeurt in een plugin in de `build` fase:

```xml
	<build>
		<finalName>test</finalName>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<configuration>
					<encoding>UTF-8</encoding>
					<source>1.6</source>
					<target>1.6</target>
				</configuration>
			</plugin>
```