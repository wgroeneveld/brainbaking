+++
title = "play2"
draft = false
tags = [
    "code",
    "java",
    "play2"
]
date = "2013-03-12"
+++
# Play 2.0 

## Testing in Play 2.0 

### Controller testen 

een controller "action" (= method vanuit route) testen doen we op een "functionele" manier in plaats van de method direct aan te roepen:

**controller**

```java
	public static Result buyHorse() {
		Form<Horse> horseForm = form(Horse.class);
		Horse horse = horseForm.bindFromRequest().get();
                System.out.println(horse.id);
        }
```

**unit test**

```java
	@Test
	public void buyHorse() {
		HashMap<String, String> map = new HashMap<>();
		map.put("id", "12");

		callAction(HorseMarket.buyHorse(), new FakeRequest().withFormUrlEncodedBody(map));
	}
```

Waarbij hierboven `HorseMarket` de routes ref is en niet de `HorseMarket` controller klasse zelf - deze:

```java
import static controllers.routes.ref.HorseMarket;
```

:exclamation: De bovenstaande test zal "12" afdrukken, gegeven dat `setId()` gegenereerd is. <br/><br/>
Play2 genereert blijkbaar getters & setters voor EBean Modellen volgens https://github.com/playframework/Play20/wiki/JavaEbean:

  > Play has been designed to generate getter/setter automatically, to ensure compatibility with libraries that expect them to be available at runtime (ORM, Databinder, JSON Binder, etc). If Play detects any user-written getter/setter in the Model, it will not generate getter/setter in order to avoid any conflict.
  
Wordt voor testing blijkbaar niet gegenereerd?

### Integratie testen en EBean 

Zie ook http://blog.matthieuguillermin.fr/2012/03/unit-testing-tricks-for-play-2-0-and-ebean/

De database moet gesetup worden door alles met `runningFakeApplication()` te draaien (static onder `play.test.Helper`):

```java
@Test
public void save() {
  running(fakeApplication(), new Runnable() {
    public void run() {
      // Here is your real test code
      Company company = new Company("My Company");
      company.save();
      assertThat(company.id).isNotNull();
    }
  });
}
```

Dit is heel omslachtig en moet overal in een test gedaan worden. Oplossing: voorzie een static `@BeforeClass` dit éénmalig de setup doet:

```java
public class BaseModelTest {
  public static FakeApplication app;
 
  @BeforeClass
  public static void startApp() {
    app = Helpers.fakeApplication(Helpers.inMemoryDatabase());
    Helpers.start(app);
  }
 
  @AfterClass
  public static void stopApp() {
    Helpers.stop(app);
  }
}
```

Dan heb je de `Runnable` van de eerste code niet meer nodig.

##### EBean enhancer als javaagent gebruiken 

Testen draaien in Eclipse in plaats van in de play2 console kan je doen door `-javaagent:/path/to/ebean/ebean-x.y.z-agent.jar` mee te geven met JRE env. <br/><br/>
Hiervoor moet je eerst EBean zelf nog downloaden want de agent zit **niet** in de play2 local repo: http://www.avaje.org/download.html

## Setup 

  * Voor IntelliJ: http://jetbrains.dzone.com/articles/configuring-intellij-idea
  * Voor Eclipse: https://groups.google.com/forum/#!topic/play-framework/U44m-kOG3bk

## Dependencies 

Play 1.2 Dependency management werkt via `dependencies.yml`: http://www.playframework.org/documentation/1.2.1/dependency

Play 2.0 werkt met Scala en **SBT** als dep management: https://github.com/playframework/Play20/wiki/SBTDependencies <br/><br/>
SBT staat voor [Simple Build Tool](http://brizzled.clapper.org/id/92/) <- meer info & vergelijkingen met Gradle, Ivy ea. 

Volg de volgende stappen:

  1. Pas Build.scala aan - zie onder
  2. Draai in de `play` console `eclipse` (zoals classpath updating: `mvn eclipse:eclipse`)

```scala
import sbt._
import Keys._
import PlayProject._

object ApplicationBuild extends Build {
    val appName         = "main"
    val appVersion      = "1.0"

    val appDependencies = Seq(
    	"org.easytesting" % "fest-assert" % "1.4" % "test"
      // Add your project dependencies here,
    )

    val main = PlayProject(appName, appVersion, appDependencies).settings(defaultJavaSettings:_*).settings(		
                // The following line is NOT NEEDED by default! 
		resolvers += "Maven2 Repository" at "http://repo1.maven.org/maven2"
    )
}
```

Play dependency tree printen gaat ook - voor meer commando's, zie `help` in de `play` console. 

## Querying 

Gegeven de entiteit:

```java
@Entity
public class Auto {
  @Id
  public Long id;
}
```

en de volgende test:

```java
public class AutoIntegrationTest {
  @Test
  public void canBePersisted() {
     new Auto().save();
  }
}
```

#### In Play 2.0 

`List<Auto> autos = Ebean.find(Auto.class).findList();`

#### In Play 1.2 

`List<Auto> autos = Auto.list();`