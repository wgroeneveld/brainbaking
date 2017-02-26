+++
title = "testing"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "testing"
]
date = "2013-03-12"
+++
# Testing in Java 

<img style='' src='/img/indexmenu>code/java/testing|js'>

## Acceptatietesten 

Zie >> [code/java/testing/selenium]({{< relref "wiki/code/java/testing/selenium.md" >}})

## Mocking 

### Static mocking met PowerMock 

`PowerMock` gebruikt een eigen Classloader om klassen in te laden. Als er veel testen powermock gebruiken gaat de build alsmaar trager worden. Om te vermijden dat de boel dicht slibt een speciale annotatie gebruiken:

```java
@RunWith(PowerMockRunner.class)
@PrepareForTest({WebApplicationContextUtils.class, SecurityManager.class })
@PowerMockIgnore({"org.apache.log4j", "org.apache.commons.logging", "org.apache.struts.util" })
public class Test {
  public void setUp() {
    PowerMockito.mockStatic(SecurityManager.class);
  }
  
  ...
}
```

Het is **niet** meer nodig om in combinatie met mockito ook nog eens de `@Mock` initializatie te doen (met `MockitoAnnotations.initMocks(this);` - dit gebeurt vanzelf)