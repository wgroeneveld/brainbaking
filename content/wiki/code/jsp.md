+++
title = "jsp"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "jsp"
]
date = "2013-03-12"
+++
# JSP snippets 

## Inhoudsopgave 

<img style='' src='/img/indexmenu>code/jsp|js context navbar nocookie'>

## Algemeen 

### Variables in jsp pages with “included” pages 

Probleem: `<c:set/>` gebruikt om een variabele in een pagina te maken, daarna een subpagina geïnclude. Die heeft geen toegang tot die variabele??

Oplossing: 

n JSP there are two ways of including other jsp pages.

`<%@include file="/include.jsp"%>`
and

`<jsp:include page="include.jsp" />`
If you use the former, then any variable declared on the parent JSP will be in scope in the include.jsp (of course Eclipse will not see this as you surmised) as it is effectively copied in by the compiler.

## Spring Tags 

#### Bind errors aanwezig? 

http://static.springsource.org/spring/docs/1.2.x/taglib/tag/BindErrorsTag.html

```jsp

<form:form commandName="model">
  <c:set var######"errorsOccured" value"false"/>
  <spring:hasBindErrors name="model">
     <c:set var######"errorsOccured" value"true"/>
  </spring:hasBindErrors>
  
  foutjes? ${errorsOccured}
</form>
```

Werkt in combinatie met default Spring `Validator` interface. Bij Webflow is het nodig om het volgende toe te voegen in de xml:

```xml
<evaluate expression="action.bindAndValidate" /><!-- this -->
<evaluate expression="action.doStuff(x, y)" />
```

## Struts 

### Properties quotes 

Enkele properties gebruiken als value werkt **niet**, men moet ze escapen door dubbele (enkele) quotes te gebruiken:

```
dit is een `vette test` voor {0}
```

Output: `dit is een 'vette test' voor x` indien x als parameter wordt meegegeven. <br/><br/>
Met enkele quote werkt parameter parsing ook niet.<br/><br/>
Zelfde probleem met Spring MVC/WebFlow. Heeft te maken met de manier waarop Struts `Properties.load()` gebruikt om de properties files te parsen.
