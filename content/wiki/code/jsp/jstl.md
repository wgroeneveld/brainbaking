+++
title = "jstl"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "jsp",
    "jstl"
]
date = "2013-03-12"
+++
# JSTL Snippets 

## Installatie 1.2 

Requirements: Web container 2.5 `http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd` (dit is stricter dan de voorgaande!)

Jars kopiëren naar WEB-INF lib.<br/><br/>
standard-x.jar mag verwijderd worden dit is een oude versie. jstl-api en jstl-impl moeten aanwezig zijn. 

Hierna is het mogelijk om met *`$`* expressies te gebruiken in jsps. 

:exclamation: **Opgelet** - dollar wordt aan de server kant geëvalueerd, dat wil zeggen dat dit een conflict geeft met [TrimPath Javascript Templates](http://code.google.com/p/trimpath/wiki/JavaScriptTemplates) die aan de client kan geëvalueerd worden. 

## Datums formatteren 

Doen met:

```xml
 <fmt:formatDate pattern######"dd/MM/yyyy" value"${entity.date}" />
```

:exclamation: **Opgelet** - Voor JSTL 1.2 kan value wel een EL expressie zijn, daarvoor niet.<br/><br/>
Hiervoor dien je deze taglib te gebruiken: `*http:*java.sun.com/**jsp**/jstl/fmt//`

Het standaard pattern is brol, en dat altijd meegeven is vervelend. Uw eigen tag maken en `setPattern()` aanroepen werkt, maar gebruik de juiste klasse om af te leiden!

```java
public class DisplayDateTag extends org.apache.taglibs.standard.tag.rt.fmt.FormatDateTag { 
  @Override
  public void setValue(Date value) {
     super.setValue(value); // 'cause JSP uses reflection...
  }
}
```

In plaats van `org.apache.taglibs.standard.tag.el.fmt.FormatDateTag`. Waarom?

> Actually, there are two taglib directives that correspond to the JSTL core  library because in JSTL 1.0 the EL is optional. All four of the JSTL 1.0 custom tag libraries have alternate versions that use JSP expressions rather than the EL for specifying dynamic attribute values. Because these alternate libraries rely on JSP's more traditional request-time attribute values, they are referred to as the RT libraries, whereas those using the expression language are referred to as the EL libraries. Developers distinguish between the two versions of each library using alternate taglib  directives. The directive for using the RT version of the core library is shown in Listing 8. Given our current focus on the EL, however, it is the first of these directives that is needed.

Zie http://www.ibm.com/developerworks/java/library/j-jstl0211.html.

:exclamation: **Opgelet** - Om EL expressies goed te kunnen doorgeven Ipv. te evalueren op de JSP moet dit in de TLD staan:

```xml
        <attribute>
            <name>value</name>
            <required>true</required>
            <rtexprvalue>true</rtexprvalue> <!-- belangrijk -->
        </attribute>
```