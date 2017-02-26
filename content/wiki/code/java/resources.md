+++
title = "resources"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "resources"
]
date = "2014-01-29"
+++
# Resource handling 

## Opkuisen in try/finally block 

Vanaf **Java 7** zit er ook ARM (automatic resource block management) in met een aanpassing op de `try` blocks:

```java
try (
FileInputStream stockQuoteReader = new FileInputStream("StockQuotes.txt");
FileOutputStream stockQuoteWriter = new FileOutputStream("StockQuotes.txt")
) {
      int var;
      while((var###### stockQuoteReader.read()) ! -1 )
            stockQuoteWriter.write();
  }
```

> The new construct extends try blocks to declare resources much like is the case with for loops. Any resource declared within a try block opening will be closed. Hence, the new construct shields you from having to pair try blocks with corresponding finally blocks that are dedicated to proper resource management. A semicolon separates each resource

Zie ook: http:*javarevisited.blogspot.com/2011/09/arm-automatic-resource-management-in.html#ixzz2rnNBbT9G en http:*www.oracle.com/technetwork/articles/java/trywithresources-401775.html

Opgelet:

  1. Whatever resource we are using should be subtypes of **AutoCloseable** other wise will get compile time error.
  2. The resources which we are using are closed in reverse order means stockQuoteWriter.close() will be called first then stockQuoteReader.close().

Read more: http://javarevisited.blogspot.com/2011/09/arm-automatic-resource-management-in.html#ixzz2rnNnTi8b

#### Java VS C# 

Zie [csharp resources wiki pagina]({{< relref "wiki/code/csharp/resources.md" >}})

`AutoClosable` is een interface die te vergelijken is met `IDisposable` in C#.