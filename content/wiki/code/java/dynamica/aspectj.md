+++
title = "aspectj"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "dynamica",
    "aspectj"
]
date = "2013-03-12"
+++
# Loadtime weaving met aspectJ 

## Spring weaving 

Zie **demo projectje**: <img style='' src='/img//code/java/dynamica/weaving-test.zip|'>

:exclamation: Vanaf versie 3.0 moet `spring-instrument` in plaats van `spring-agent` gebruikt worden! (bestaat niet meer)

Zie http://static.springsource.org/spring/docs/3.1.0.RELEASE/reference/htmlsingle/#aop

Weavers:

  1. **aspectj jar** `-javaagent:C:<br/>dvl.home<br/>env<br/>aspectj<br/>aspectjweaver-1.6.11.jar`
  2. **spring-instrument jar** `-javaagent:C:/dvl.home/prj/comeet/tools/spring-instrument-3.1.0.RELEASE.jar`

#### Wat heb je nodig om loadtime weaving te laten werken 

##### applicationContext.xml 

  * met spring-configured (zelfde als `org.springframework.beans.factory.aspectj.AnnotationBeanConfigurerAspect` bean, zie [spring docs](http://static.springsource.org/spring/docs/3.0.0.RC2/reference/html/ch07s08.html))
  * met `load-time-weaver` op

```xml
<?xml version######"1.0" encoding"UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http:*www.springframework.org/schema/beans http:*www.springframework.org/schema/beans/spring-beans-3.0.xsd
                           http:*www.springframework.org/schema/context http:*www.springframework.org/schema/context/spring-context-3.0.xsd">

    <context:spring-configured/>
    <context:component-scan base-package="be.test"/>    
    <context:load-time-weaver/>    
</beans>
```

##### juiste manier van opzetten beans 

-> Een bean die `@Component` annotated is waar een andere bean die `@Configurable` ge-`new`t wordt, die via `@Autowired` injecties bevat

bijvroobeeld:

-> `SomeBean`

```java
@Component
public class SomeBean {

	private final SomeBeanToInject someBeanToInject;

	@Autowired
	public SomeBean(SomeBeanToInject someBeanToInject) {
		System.out.println("creating some bean, got injected: " + someBeanToInject);
		this.someBeanToInject = someBeanToInject;
	}

	public OtherBean createOtherBean() {
		return new OtherBean();
	}
}
```

-> `OtherBean`

```java
@Configurable
public class OtherBean {

	private SomeBeanToDynamicallyInject someBeanToDynamicallyInject;

	@Autowired
	public void setSomeBeanToDynamicallyInject(SomeBeanToDynamicallyInject someBeanToDynamicallyInject) {
		System.out.println("Setting some dynamically injected bean! : " + someBeanToDynamicallyInject);
		this.someBeanToDynamicallyInject = someBeanToDynamicallyInject;
	}
}
```

-> `SomeBeanToDynamicallyInject`

```java
@Component
public class SomeBeanToDynamicallyInject {
	public String message = "dynamically injected";
}
```

#### AspectJ en Junit testing 

De annotatie `@EnableLoadTimeWeaving` heb je **NIET** nodig. Het is ook niet nodig om java config klasse te verwijzen, de context xml pikt dit met component scanning op!

```java
@ContextConfiguration(locations = { "../../applicationContext.xml" })
@RunWith(SpringJUnit4ClassRunner.class)
public class SomeBeanTest {

	@Autowired
	private SomeBean someBean;

	@Test
	public void someBeanIsDynamicallyInjected() {
		Assert.assertTrue(someBean.createOtherBean().isDynamicallyInjected());
	}
}
```

:exclamation: **Unit- en Integratietesten opsplitsen in andere source folders**! Waarom?<br/><br/>
Omdat, ééns als een class file ingeladen is door de JVM, deze in het geheugen blijft zitten, en de volgende keer dat een andere test binnen dezelfde suite deze wilt gebruiken en verwacht dat die enhanched is (dus `@Autowired` geïnjecteerd), dit niet zo is, omdat een vorige gewone unit test hier een `new` van gedaan heeft en dit reeds in het geheugen steekt. 

Is hier een oplossing voor? `ClassLoader` cache clearen op een of andere manier? Zie http://members.iinet.net.au/~macneall/Java/ClassReloading.html -

> Java classes themselves are dumped from memory when the classloader that loaded them is garbage collected. So the way to dynamically reload a class is to make sure that you control the classloader for that class. So when, all the references to instances of that class are gone, and you null the classloader itself, the runtime should collect the class itself. Then, next time an object of that class is used, it needs to be loaded again.

Probleem doet zich voor met `mvn clean install` maar soms niet in eclipse?? 

## aop.xml configuratie 

Deze wordt blijkbaar gebruikt om te bepalen wat er precies gewoven moet worden - als die er NIET is gaat hij by default alles weaven en een warning tonen in de console log:

```
[AppClassLoader@17943a4] warning javax.* types are not being woven because the weaver option '-Xset:weaveJavaxPackages=true' has not been specified
```

File moet in **src/main/resources/META-INF/aop.xml** staan (op classpath). Content bvb:

```xml
<?xml version="1.0"?>

<aspectj>
    <aspects>
        <weaver options="-Xlint:ignore -nowarn">
            <include within="@org.springframework.beans.factory.annotation.Configurable be.bla.blie..*" />
        </weaver>
    </aspects>
</aspectj>
```

##### options 

  1. `-Xlint:ignore -nowarn` negeert alle warnings dat bepaalde zaken niet gewoven kunnen worden
  2. `-verbose` print meer debuginfo
  3. `-showWeaveInfo` print wat wanneer gewoven wordt. 