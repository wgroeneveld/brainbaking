+++
title = "java"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java"
]
date = "2013-05-17"
+++
# Java Stuff 

## Inhoudsopgave 

<img style='' src='/img/indexmenu>java|js context navbar nocookie'>

## Snippets 

#### Upcasting hacks & tricks 

Vies van `instanceof`? Gebruik `isAssignableFrom` om op een abstracte logica te implementeren die een interface nodig heeft enkele niveaus verder.<br/><br/>
Op die manier hebben we geen diamond inheritance nodig! Check it out:

```java
    @SuppressWarnings("unchecked")
    final void generateUidIfNotYetFilledIn() {
        if (HasUid.class.isAssignableFrom(this.getClass())) {
            HasUid hasUid = (HasUid) this;
            if (isEmpty(hasUid.getUid())) {
                hasUid.setUid(getEntityUidGenerator().generateFor((Class<? extends HasUid>) this.getClass()));
            }
        }
    }
```

#### ReplaceAll case Insensitive 

Geen `StringUtils` van apache commons method beschikbaar als `replaceIgnoreCase`... Stom!

```java
public class Main {
  public static void main(String[] argv) throws Exception {
    String str = "Abc abc";

    String result = str.replaceAll("(?i)abc", "DEF");

    System.out.println("After replacement:<br/>n" + "   " + result);

  }
}
```

Vergeet niet speciale regex karakters te escapen zoals `<br/><br/>[` de *brackets* etc.

## Pitfalls 

#### Java versies 

  1. Java 7 & java 6 mixen: gebruik `-XX:-UseSplitVerifier` als VM argument wanneer exceptions zoals "expecting invalid stackmap frame..." zich voordoen. - Wat doet dit arumgent eigenlijk? [Java 7 Bytecode verification](http://chrononsystems.com/blog/java-7-design-flaw-leads-to-huge-backward-step-for-the-jvm.)

#### APIs 

  1. `Arrays.asList()` retourneert een *read-only* lijst! `add()` throwt een `UnsupportedOperationException`. 
  2. guava's `transform()` ea zijn **lazy-loaded**, let op met transacties en inner class state! 