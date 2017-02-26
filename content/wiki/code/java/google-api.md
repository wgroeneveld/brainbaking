+++
title = "google-api"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "google-api"
]
date = "2013-03-12"
+++
# Google-api 

## Google Endpoints Client lib 

##### Genereren van java files 

```bash
Timestamp: Tue Dec 11 12:41:31 CET 2012
#!/bin/sh

echo "--- COMPILING..."
mvn clean compile

echo "--- REMOVING OLD FILES & COPYING TO WEB-INF..."
rm -rf ./war/WEB-INF/devices-*
rm -rf ./war/WEB-INF/classes
cp -rf ./target/classes ./war/WEB-INF/

echo "--- GENERATING ENDPOINTS..."
/Users/jefklak/development/appengine/bin/endpoints.sh get-java-client-lib be.klak.gatecontrolweb.DevicesController

echo "--- EXTRACTING SOURCE JAR..."
cd ./war/WEB-INF
rm -rf devices
unzip devices-v1-java.zip
cd devices
unzip `ls | grep sources.jar`
cp -rf com ~/development/gatecontrol/receiver/src/main/java

echo "--- DONE!"```

##### maven deps voor de client 

```xml
		<dependency>
			<groupId>com.google.oauth-client</groupId>
			<artifactId>google-oauth-client</artifactId>
			<version>1.13.1-beta</version>
		</dependency>
		<dependency>
			<groupId>com.google.api-client</groupId>
			<artifactId>google-api-client</artifactId>
			<version>1.13.2-beta</version>
		</dependency>
		<dependency>
			<groupId>com.google.http-client</groupId>
			<artifactId>google-http-client-jackson2</artifactId>
			<version>1.13.1-beta</version>
		</dependency>

```

oauth is de enige compile dependency die aangeduid staat, maar api-client is nodig voor de algemene http transport - zie http://code.google.com/p/google-api-java-client/
Een client call maken kan je dan zo doen:

```java
		NetHttpTransport transport = new NetHttpTransport();

		// laatste param is voor credentials mee te geven
		Devices devices = new Devices.Builder(transport, new JacksonFactory(), null).build();
		try {
			devices.houses().all().execute().getItems();
		} catch (IOException e) {
			e.printStackTrace();
		}

```

`JacksonFactory` zit blijkbaar nergens in buiten in de `google-http-client-jackson2` lib.

Authenticatie etc: **zie [google-api-java-client OAuth2 wiki](http://code.google.com/p/google-api-java-client/wiki/OAuth2)**