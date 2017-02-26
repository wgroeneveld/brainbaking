+++
title = "profiling"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "profiling"
]
date = "2013-05-17"
+++
# Profiling 

Voor JMX, monitoring en andere: zie [code/java/monitoring]({{< relref "wiki/code/java/monitoring.md" >}})

### Verschillende profilers  

  * `jconsole`: provided in JDK
  * `visualvm`: provided in JDK
  * `Eclipse Memory Analyzer`: http://www.eclipse.org/mat/
  * `YourKit`: http://www.yourkit.com/

Remote connecten gaat meestal via JMX, behalve your YourKit:

#### Remote connecten met YourKit 

Zie http:*www.yourkit.com/docs/12/help/profiling_j2ee_remote.jsp en http:*www.yourkit.com/docs/95/help/agent.jsp - Je moet een `agentpath` JVM param meegeven om dit te kunnen doen:

```
-agentpath:/usr/yourkit/libyjpagent.so######delay10000,sessionname=Tomcat
```

Zet niet te veel opties in agentpath om dingen te optimaliseren of het proben van de PermGen stack werkt niet. Je kan dit bekijken in YourKit door hier op te klikken:

<img style='' src='/img//code/java/yourkit.png|'>

#### Wanneer wat gebruiken? 

##### Ik wil mijn geheugengebruik in het oog houden 

Kan met eender welke profiler, VisualVM is het leukste qua GUI.

##### Ik wil de stack van een OutOfMem uit een heapdump halen 

Kan met VisualVM of de Eclipse tool

##### Ik wil de veel voorkomende problemen automatisch uit een heapdump halen 

Er worden rapporten gegenereerd door de eclipse tool

##### Ik wil live de PermGen space analyseren 

Kan enkel met YourKit door middel van probes.