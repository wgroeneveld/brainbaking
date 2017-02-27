+++
title = "linq"
draft = false
tags = [
    "code",
    "csharp",
    "linq"
]
date = "2014-01-29"
+++
# Collections, Iterating, ???, Linq (profit) 

## yield hocus pocus 

Zie [The implementation of iterators in C#](http://blogs.msdn.com/b/oldnewthing/archive/2008/08/12/8849519.aspx) - wordt uitgelegd hoe `yield` door de compiler geïnterpreteerd wordt. 

Hiermee is het mogelijk om heel snel uw eigen `IEnumerable` te maken. 

>  “yield”, [...] which allows you to quickly write iterators without worrying about preserving state.

## Folding, selecting, etc 

### Closing over the loop variable 

Main article: http://blogs.msdn.com/b/ericlippert/archive/2009/11/12/closing-over-the-loop-variable-considered-harmful.aspx

Opgelet met `foreach` en de manier waarop die geïmplementeerd is (onder C# 5):

```csharp
  {
    IEnumerator<int> e = ((IEnumerable<int>)values).GetEnumerator();
    try
    { 
      int m; // OUTSIDE THE ACTUAL LOOP
      while(e.MoveNext())
      {
        m = (int)(int)e.Current;
        funcs.Add(()=>m);
      }
    }
    finally
    { 
      if (e != null) ((IDisposable)e).Dispose();
    }
  }
```

de variabele `m` verandert constant. Wanneer we in een loop dan een `delegate` gebruiken die de variabele uitleest, krijgen we op moment van executie slechts de laatste waarde!

```csharp
var values = new List<int>() { 100, 110, 120 };
var funcs = new List<Func<int>>();
foreach(var v in values) 
  funcs.Add( ()=>v );
foreach(var f in funcs) 
  Console.WriteLine(f()); // print 120, 120, 120, whoops??
```

### side-effects 

Zie ook [foreach vs ForEach](http://blogs.msdn.com/b/ericlippert/archive/2009/05/18/foreach-vs-foreach.aspx): `LINQ` is ontwikkeld om side-effect free te werken, dit wil zeggen dat er altijd een nieuwe collectie aangemaakt wordt. De volgende code is niet voldoende om in een method een lijst te sorteren:

```csharp
private void sortMe(IEnumerable<string> toSort) {
  toSort.ToList().Sort(); // ToList() returns a new list! as it should be
}
```

### naming 

  1. Gebruik `Select()` in plaats van de JS `transform()`. 
  2. `Aggregate` is een native `foldLeft` - gebruik `Reverse` om van achter naar voor te beginnen. 
  3. `All` retrourneert een boolean en is om te controleren of er elementen in een collectie zitten, niet om te transformen of te loopen!

### Achterliggende implementatiedetails 

http://community.bartdesmet.net/blogs/bart/archive/2008/08/17/folding-left-right-and-the-linq-aggregation-operator.aspx