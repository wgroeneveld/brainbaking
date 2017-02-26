+++
title = "encoding"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "encoding"
]
date = "2013-03-12"
+++
# Page Encoding 

Alles zou in UTF-8 mode moeten staan. Daarvoor moeten verschillende dingen aangepast worden.
Een goede manier om te proberen of dit werkt is in een inputfield ALT+456 te typen
Dat zou *╚* moeten genereren, een 90° gedraaide dubbelgelijnde hoek. 

Inspect via debug in een action geeft op de form dan normaal ǈ als het niet correct geëncode is. 
De waarde naar de DB kopiëren en dan terugkomen terwijl de DB niet correct geëncode is geeft *+* weer dan.
De waarde op inspect geeft vreemde vierkante tekens als uw struts filter niet correct gemapt is (zie onder).
Dit is nodig om POST gegevens te kunnen decoderen vanuit UTF-8!

## Eclipse console output naar UTF-8 

http://paranoid-engineering.blogspot.com/2008/05/getting-unicode-output-in-eclipse.html

  1. add -Dfile.encoding=UTF-8 to your eclipse.ini
  2. make sure your Eclipse Console font supports Unicode. You can try it out by typing unicode characters directly to console with keyboard. Console Font is set in Window -> Preferences -> General -> Appearance -> Colors and Fonts -> Debug -> Console Font
  3. if you are NOT using Windows, set your system encoding to UTF-8. You should now see Unicode characters in Console after restarting Eclipse.
  4. if you are using Windows or do not want to change your OS encoding, you will have to avoid using System.out stream directly. Instead, wrap it up with java.io.printstream:```java
PrintStream sysout = new PrintStream(System.out, true, "UTF-8");
sysout.println("<br/>u2297<br/>u0035<br/>u039e<br/>u322F<br/>u5193");
```
  1. if you are using Log4J with Console Appender, make sure to set the encoding property to UTF-8. Example:```java
#TRACE appender
log4j.appender.stdout.trace=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.trace.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.trace.encoding=UTF-8
log4j.appender.stdout.trace.layout.ConversionPattern=%p [%c] - %m%n
log4j.appender.stdout.trace.Threshold=TRACE
```

##Tomcat server in UTF-8 zetten

http://wiki.apache.org/tomcat/FAQ/CharacterEncoding#Q3
Vooral: 
Set URIEncoding="UTF-8" on your <Connector> in server.xml

##Zet uw webpagina rendering in UTF-8

  1. Overal in jsps charencoding=UTF-8 ipv ISO plaatsen (in de header en in de jsp directive)
  2. Voor struts: een filter maken die op de request de encoding manueel naar UTF-8 plaatst (zie apache link bovenaan)<br/><br/> Die doet het volgende in de filter:```java
	 public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
				ServletException {
		  request.setCharacterEncoding("UTF-8");
		  chain.doFilter(request, response);
	 }
```
  1. In struts-config de controller in UTF-8 encoden

##Oracle database server in UTF-8 zetten

Voor DBAs, niet te vergeten natuurlijk, anders worden speciale chars die niet in ISO liggen incorrect opgeslaan.
Men kan zelf controleren welke encoding momenteel gebruikt wordt met

```sql
SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERSET'
```

Kan bvb. *WE8MSWIN1252* uitkomen.

