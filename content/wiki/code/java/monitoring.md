+++
title = "monitoring"
draft = false
tags = [
    "code",
    "java",
    "monitoring"
]
date = "2014-04-15"
+++
# Monitoring 

## JBOSS As a Windows service & monitoring params 

https://community.jboss.org/wiki/JBossNativeWindows

Als JBoss via `jbossvc.exe` als een windows service geconfigureerd is, lijkt het moeilijk om `JAVA_OPTS` mee te geven om JMX poorten in te stellen e.a. (debugging misschien) - zie onder. Die executable callt basically `run.bat`, dus alle customizaties gewoon daar doen.

Staat standaard dit in:

```
set JAVA_OPTS######-Dprogram.name%PROGNAME% %JAVA_OPTS%
```

## Java JMX Monitoring 

Op de JVM: gebeurt met **JMX**.

##### Enablen 

Params voor JMX te enablen op de queue:

```
-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port######3000 -Dcom.sun.management.jmxremote.sslfalse -Dcom.sun.management.jmxremote.authenticate=false"
```

##### JMX URLs opbouwen 

```service:jmx:rmi:*/jndi/rmi:*server.com:3000/jmxrmi```

indien de remote server op server.com draait op poort 3000 (zie boven). Drie slashen na 1ste rmi, twee na de 2de en 1 tussen jndi en rmi in.

##### Java Monitoring console 

Opstarten van **jconsole.exe** in JVM bin folder, gebruik bovenstaande URL. <br/><br/>
Dan is het mogelijk om jmx-exposed beans te inspecten en remote methods uit te voeren, plus de draaiende JVM te monitoren qua geheugen etc. 

##### Spring gebruiken om beans te exposen 

```java
	<bean class="org.springframework.jmx.export.MBeanExporter">
		<property name="beans">
			<map>
				<entry key######"bean:nameBeanName" value-ref="someBean" />
			</map>
		</property>
		<property name######"registrationBehaviorName" value"REGISTRATION_IGNORE_EXISTING" />
	</bean>
```

## Geheugen monitoren 

Kan bijvoorbeeld met **VisualVM** - je kan met JMX connecten en dan een dump nemen op de remote locatie waar de JVM op draait. Als er een `PermGen space` out of memory zich voor doet kunnen we de dump file analyseren en er hopelijk iets nuttig uit halen. 

##### Automatisch een dump nemen na out of memory 

Doen met volgende JVM params:

```
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/log/tomcat/dumps
```

Zorg ervoor dat het heap dump path schrijfbaar is... 

##### PermGen en reflectie 

Als er een hele hoop klassen tegelijk aangemaakt worden (inner classes = PermGen space, objecten zitten gewoon op de heap, beginnend met eden), komt de PermGen space misschien in het gedrang. Aan te passen met:

```
-XX:MaxPermSize=400M
``` 

:exclamation: Deze worden blijkbaar door de JVM standaard niet garbage-collected. Zie http://stackoverflow.com/questions/3334911/what-does-jvm-flag-cmsclassunloadingenabled-actually-do - je kan dit wel forceren met de volgende parameters:

```
-XX:+CMSPermGenSweepingEnabled
-XX:+CMSClassUnloadingEnabled 
```

Er wordt daar een voorbeeld aangehaald ivm JAXB die een hoop proxy objecten tegelijk aanmaakt via `java.lang.reflect.Proxy`. Een entity root kopiëren door middel van relfectie cloning zou bijvoorbeeld ook een potentiëel probleem kunnen zijn. 