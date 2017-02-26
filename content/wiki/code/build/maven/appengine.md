+++
title = "appengine"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "build",
    "maven",
    "appengine"
]
date = "2013-03-12"
+++
# Maven Google Appengine 


#### maven-cli-plugin gebruiken als semi-hot-deployer 

Zie [Mavenizing my project](http://blog.cloudme.org/2010/04/mavenizing-my-project/)

In plaats van betalende JRebel kan je bvb. voor GAE de jetty server op zetten met `gae:run`, maar alles in webapp ziet hij niet als een change. 

  * In Tab1: `mvn gae:run`.
  * In Tab2: `mvn cli:execute` en dan commando's `compile war` in aparte tab die de eerste tab (nog actieve maven) oppikt dan.

Andere mogelijkheid is natuurlijk voor niet-GAE dingen, `jetty:run` gebruiken (zie [code/build/maven]({{< relref "wiki/code/build/maven.md" >}})). 

:exclamation: de plugin is **niet werkend met maven 3**, zie https://github.com/mrdon/maven-cli-plugin/wiki/Maven-3.0-Support - 

```
INFO]
[INFO] --- maven-cli-plugin:1.0.6:execute (default-cli) @ gatecontrolweb ---
[INFO] Waiting for commands...
maven2> clean
[INFO] Executing: org.apache.maven.plugins:maven-clean-plugin [clean]
[ERROR] Unable to complete running command: clean
java.lang.RuntimeException: org.apache.maven.plugin.MojoExecutionException: Unable to execute mojo
	at org.twdata.maven.cli.commands.ExecuteGoalCommand.run(ExecuteGoalCommand.java:111)
	at org.twdata.maven.cli.CliShell.interpretCommand(CliShell.java:48)
	at org.twdata.maven.cli.CliShell.run(CliShell.java:29)
	at org.twdata.maven.cli.AbstractCliMojo.displayShell(AbstractCliMojo.java:144)
	at org.twdata.maven.cli.AbstractCliMojo.access$000(AbstractCliMojo.java:22)
	at org.twdata.maven.cli.AbstractCliMojo$1.run(AbstractCliMojo.java:116)
Caused by: org.apache.maven.plugin.MojoExecutionException: Unable to execute mojo
	at org.shaded.mojoexecutor.MojoExecutor.executeMojo(MojoExecutor.java:106)
	at org.twdata.maven.cli.MojoCall.run(MojoCall.java:31)
	at org.twdata.maven.cli.commands.ExecuteGoalCommand.runMojo(ExecuteGoalCommand.java:125)
	at org.twdata.maven.cli.commands.ExecuteGoalCommand.run(ExecuteGoalCommand.java:104)
	... 5 more
Caused by: java.lang.UnsupportedOperationException
	at org.apache.maven.plugin.internal.DefaultPluginManager.executeMojo(DefaultPluginManager.java:90)
	at org.shaded.mojoexecutor.MojoExecutor.executeMojo(MojoExecutor.java:104)
	... 8 more
```

Tof...

#### maven-endpoint-plugin 

:exclamation: Google App Engine **endpoint metadata** genereren via maven kan ook en is een totaal andere plugin: http://code.google.com/p/maven-endpoint-plugin/

Hiervoor moet je de volgende repository gebruiken (zit niet in de central repo):

```xml
	<repositories>
		<repository>
			<id>cbreleases</id>
			<url>https://repository-michael.forge.cloudbees.com/release</url>
			<releases>
				<enabled>true</enabled>
			</releases>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
		</repository>
	</repositories>
	<pluginRepositories>
		<pluginRepository>
			<id>cbreleases</id>
			<url>https://repository-michael.forge.cloudbees.com/release</url>
			<releases>
				<enabled>true</enabled>
			</releases>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
		</pluginRepository>
	</pluginRepositories>
```

#### maven-gae-plugin 

Laatste versie van de "officiele" plugin op https://github.com/maven-gae-plugin/maven-gae-plugin

Een compleet voorbeeld gebaseerd op de jsp archetype:

```xml
<?xml version######"1.0" encoding"UTF-8"?>
<project xmlns######"http:*maven.apache.org/POM/4.0.0" xmlns:xsi"http:*www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http:*maven.apache.org/POM/4.0.0 http:*maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <!-- The Basics -->
  <groupId>com.myapp.test</groupId>
  <artifactId>testapp</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>war</packaging>

  <name>lkjm</name>

	<dependencies>

    <!-- Google App Engine meta-package -->
    <dependency>
      <groupId>net.kindleit</groupId>
      <artifactId>gae-runtime</artifactId>
      <version>${gae.version}</version>
      <type>pom</type>
    </dependency>

		<dependency>
			<groupId>org.datanucleus</groupId>
            <artifactId>datanucleus-core</artifactId>
            <version>${datanucleus.version}</version>
            <scope>runtime</scope>
        </dependency>

		<dependency>
			<groupId>javax.transaction</groupId>
			<artifactId>jta</artifactId>
			<version>1.1</version>
		</dependency>

		<!--
			J2EE Servlet API. We need it to compile IndexServlet class. You can
			probably remove it, if you don't explicitly use Servlets
		-->
		<dependency>
			<groupId>org.apache.geronimo.specs</groupId>
			<artifactId>geronimo-servlet_2.5_spec</artifactId>
			<version>1.2</version>
			<scope>provided</scope>
		</dependency>

		<!--
			Make use of JSP tags. Remove, if you don't use JSPs
		-->
		<dependency>
			<artifactId>standard</artifactId>
			<groupId>taglibs</groupId>
			<version>1.1.2</version>
			<type>jar</type>
			<scope>runtime</scope>
		</dependency>

		<!-- These dependencies are here just for enabling logging -->
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>1.6.1</version>
		</dependency>

		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-classic</artifactId>
			<version>0.9.24</version>
		</dependency>

		<!-- Test scope -->
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.5</version>
			<scope>test</scope>
		</dependency>

		<!--
			GAE libraries for local testing as described here:
			http://code.google.com/appengine/docs/java/howto/unittesting.html
		-->
		<dependency>
			<groupId>com.google.appengine</groupId>
			<artifactId>appengine-api-labs</artifactId>
			<version>${gae.version}</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>com.google.appengine</groupId>
			<artifactId>appengine-api-stubs</artifactId>
			<version>${gae.version}</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>com.google.appengine</groupId>
			<artifactId>appengine-testing</artifactId>
			<version>${gae.version}</version>
			<scope>test</scope>
		</dependency>

        <dependency>
            <groupId>javax.jdo</groupId>
            <artifactId>jdo2-api</artifactId>
            <version>2.3-eb</version>
            <exclusions>
                <exclusion>
                    <groupId>javax.transaction</groupId>
                    <artifactId>transaction-api</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
	</dependencies>

	<build>
		<plugins>
			<!--
				This plug-in "enhances" your domain model objects (i.e. makes them
				persistent for datanucleus)
			-->
			<plugin>
				<groupId>org.datanucleus</groupId>
				<artifactId>maven-datanucleus-plugin</artifactId>
				<version>1.1.4</version>
				<configuration>
					<!--
						Make sure this path contains your persistent classes!
					-->
					<mappingIncludes>**/model/*.class</mappingIncludes>
					<verbose>true</verbose>
					<enhancerName>ASM</enhancerName>
					<api>JDO</api>
				</configuration>
				<executions>
					<execution>
						<phase>compile</phase>
						<goals>
							<goal>enhance</goal>
						</goals>
					</execution>
				</executions>
				<dependencies>
					<dependency>
						<groupId>org.datanucleus</groupId>
						<artifactId>datanucleus-core</artifactId>
						<version>${datanucleus.version}</version>
						<exclusions>
							<exclusion>
								<groupId>javax.transaction</groupId>
								<artifactId>transaction-api</artifactId>
							</exclusion>
						</exclusions>
					</dependency>
					<dependency>
						<groupId>org.datanucleus</groupId>
						<artifactId>datanucleus-rdbms</artifactId>
						<version>${datanucleus.version}</version>
					</dependency>
					<dependency>
						<groupId>org.datanucleus</groupId>
						<artifactId>datanucleus-enhancer</artifactId>
						<version>1.1.4</version>
					</dependency>
					<dependency>
						<groupId>javax.jdo</groupId>
						<artifactId>jdo2-api</artifactId>
						<version>2.3-ec</version>
						<scope>runtime</scope>
					</dependency>
				</dependencies>
			</plugin>

			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-war-plugin</artifactId>
				<version>2.1-beta-1</version>
				<configuration>
					<webResources>
						<resource>
							<directory>src/main/webapp</directory>
							<filtering>true</filtering>
							<includes>
								<include>**/appengine-web.xml</include>
							</includes>
						</resource>
					</webResources>
				</configuration>
			</plugin>

			<!--
				The actual maven-gae-plugin. Type "mvn gae:run" to run project, "mvn
				gae:deploy" to upload to GAE.
			-->
			<plugin>
				<groupId>net.kindleit</groupId>
				<artifactId>maven-gae-plugin</artifactId>
				<version>0.9.5</version>
			</plugin>

			<!--
				Upload application to the appspot automatically, during
				release:perform
			-->
			<plugin>
				<artifactId>maven-release-plugin</artifactId>
				<configuration>
					<goals>gae:deploy</goals>
				</configuration>
			</plugin>

			<!-- Java compiler version -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>2.0</version>
				<configuration>
					<source>1.6</source>
					<target>1.6</target>
				</configuration>
			</plugin>
		</plugins>
	</build>

	<!-- Specify hard-coded project properties here -->
	<properties>

	  <!-- Sets the project's default encoding.
         http://docs.codehaus.org/display/MAVENUSER/POM+Element+for+Source+File+Encoding -->
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

		<!--
			This is just for "eclipse:eclipse" goal to always attempt downloading
			sources
		-->
		<downloadSources>true</downloadSources>

		<!--
			Specify AppEngine version for your project. It should match SDK
			version pointed to by ${gae.home} property (Typically, one used by
			your Eclipse plug-in)
		-->
		<gae.version>1.6.5</gae.version>

		<!--
			Upload to http://test.latest.<applicationName>.appspot.com by default
		-->
		<gae.application.version>test</gae.application.version>

        <datanucleus.version>1.1.5</datanucleus.version>
	</properties>

	<profiles>
		<!--
			We can configure our integration server to activate this profile and
			perform gae:deploy, thus uploading latest snapshot to the
			http://1.latest.<applicationName>.appspot.com automatically
		-->
		<profile>
			<id>integration-build</id>
			<properties>
				<gae.application.version>stage</gae.application.version>
			</properties>
		</profile>

		<!--
			This profile will activate automatically during release and upload
			application to the http://2.latest.<applicationName>.appspot.com (We
			might want to set the 2nd version as our applications Default version
			to be accessible at http://<applicationName>.appspot.com)
		-->
		<profile>
			<id>release-build</id>
			<activation>
				<property>
					<name>performRelease</name>
					<value>true</value>
				</property>
			</activation>

			<properties>
				<!--
					During release, set application version in appengine-web.xml to 2
				-->
				<gae.application.version>release</gae.application.version>
			</properties>
		</profile>
	</profiles>

</project>
```

Hiermee kan je:

  1. `mvn gae:unpack` uitvoeren om de GAE SDK in uw maven repo te unpacken zodat `${gae.home}` niet nodig is in de pom (vanaf 0.9.5)
  1. `mvn gae:run` uitvoeren om een devserver te starten

##### Andere versie 

Een oudere versie (??) is deze:

```xml
			<plugin>
				<groupId>com.google.appengine</groupId>
				<artifactId>appengine-maven-plugin</artifactId>
				<version>${appengine.target.version}</version>
			</plugin>
```

Hiermee kan je:

  1. `mvn appengine:devserver` gebruiken om lokaal een jetty op te starten, en 
  1. `mvn appengine:update` om te deployen via de commandline. 