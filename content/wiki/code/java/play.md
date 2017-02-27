+++
title = "play"
draft = false
tags = [
    "code",
    "java",
    "play"
]
date = "2013-03-12"
+++
# Play! Framework 1.2 

:exclamation: Heel interessante `.gitignore` default configuratie voor Play terug te vinden op https://github.com/github/gitignore

### Dependencies Toevoegen 

Toevoegen in dependencies.yml - default maven2 repo is niet nodig:

```
require:
    1. play -> crud
    2. org.easytesting -> fest-assert 1.4
```

Daarna altijd `play dependencies --sync` of eventueel `play eclipsify` en F5 op eclipse project.

#### Lokale repository als directory 

```
repositories:
    1. Local_repo:
        type: iBiblio
        root: "file:///C:/Documents%20and%20Settings/Jefklak/.m2/repository/"
        contains:
            1. be.klak -> *
            2. ch.ntb -> *
```

#### Test libraries 

**Niet mogelijk om apart te packagen**! Tenzij met speciale `id`, maar dan moet je de hele tijd bij `play run` switchen en de juiste id als parameter meegeven... 

### Entities 

#### Querying 

```java
  List<JPABase> entities = Entity.findAll();
```

#### Creating 

```java
@Entity
public class Thing extends Model {
   public String name;
}
```

-> Geen `@Id` nodig, dit zit bij Play1 in uw `Model` class. Dit is dus **niet zo voor play2**.

#### Testing 

Extending van `UnitTest` voor "integratietesten":

```java
public class HorseIntegrationTest extends UnitTest {

	@Test
	public void canBePersisted() {
		new Horse("joske").save();
		List<JPABase> horses = Horse.findAll();
		
		assertEquals(1, horses.size());
		assertEquals("joske", ((Horse) horses.iterator().next()).name);
	}
}

```

