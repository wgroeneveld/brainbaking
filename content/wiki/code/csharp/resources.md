+++
title = "resources"
draft = false
tags = [
    "code",
    "csharp",
    "resources"
]
date = "2015-10-09"
+++
# C# Resources 

## In Tests 

Zie [code/csharp/testing]({{< relref "wiki/code/csharp/testing.md" >}})

## Web config 

Zie http://msdn.microsoft.com/en-us/library/dd465326(VS.100).aspx

`.NET 4` voorziet een manier om de `Web.config` file automatisch te **transformeren** afhankelijk van uw build configuratie (Debug, Release, custom). Je hebt hier 2 files:

  * Web.config (base)
  * Web.[BuildConfigName].config (transformer)

Wat in de tweede file staat, gaat toegepast worden op de eerste file. Je kan dus niet zomaar zaken copypasten en overschrijven, maar moet tags die je wil replacen **XDT** transformaties op definiëren:

```xml
<appSettings>
  <add key######"Bla" value"blie"/>
</appSettings>
```

met transformer

```xml
<appSettings xdt:Transform="Replace">
  <add key######"Bla" value"bloebloe"/>
</appSettings>
```

Zal de hele `appSettings` tag vervangen in de base file. Vergeet dat attribuut en er gebeurt niets. 

## Embedded resources ophalen 

```csharp
        private Stream GetIconAsStream(string icon)
        {
            return Assembly.GetExecutingAssembly()
                           .GetManifestResourceStream(
                               "Full.Namespace.Of.Class.dir.to.image" +
                               icon);
        }

        private void CopyIconsToDir(string dir, params string[] iconNames)
        {
            foreach (var icon in iconNames)
            {
                var downloadStream = GetIconAsStream(icon);
                var tmpFileCreate = File.Create(dir + "<br/><br/>" + icon);
                downloadStream.CopyTo(tmpFileCreate);
                tmpFileCreate.Close();
                downloadStream.Close();
            }
        }
```

## .CSPROJ file inlezen & parsen 

Waarom is dit handig? Om bijvoorbeeld te kunnen kijken welke files allemaal included zijn in uw project en met een test alle SQL files verplicht te laten embedden. <br/><br/>
(Op die manier staan ze niet als "Content" in de XML structuur). Regex op loslaten of XML parsen.

```csharp
        private static string ReadProjectFile()
        {
            var dbAssembly = typeof(AbstractUpdater).Assembly;
            * format: 'file:*/C:/Sources/project/UnitTestproject/bin/Debug/project.UnitTest.DLL'
            var projectDir = dbAssembly.CodeBase.Substring(0, dbAssembly.CodeBase.IndexOf(".UnitTest", StringComparison.InvariantCulture));
            var csprojFile = Directory.GetFiles(projectDir.Replace("file:///", ""), "*.csproj")[0];

            var csproj = File.ReadAllText(csprojFile);
            return csproj;
        }
```

## Managed resources disposen 

:exclamation: Zie [Dispose Pattern @ MSDN](http://msdn.microsoft.com/en-us/library/b1yfkh5e(v=vs.110).aspx); volgende template:

```csharp
public class DisposableResourceHolder : IDisposable {
 
    private SafeHandle resource; // handle to a resource

    public DisposableResourceHolder(){
        this.resource = ... // allocates the resource
    }

    public void Dispose(){
        Dispose(true);
        GC.SuppressFinalize(this); // tell the GC disposing it isn't needed anymore
    }

    protected virtual void Dispose(bool disposing){
        if (disposing){
            if (resource!= null) resource.Dispose();
        }
    }
}
```

#### using() 

De .NET CLR vertaalt

```csharp
using (MyResource myRes = new MyResource())
{
    myRes.DoSomething();
}
```

naar

```csharp
{ // limits scope of myRes
    MyResource myRes= new MyResource();
    try
    {
        myRes.DoSomething();
    }
    finally
    {
        // Check for a null resource.
        if (myRes!= null)
            // Call the object's Dispose method.
            ((IDisposable)myRes).Dispose();
    }
}
```

Moet dan uw object de interface `IDisposable` implementeren? Harde cast toch?

#### Java VS C# 

Beiden plaatsten objecten in een finalizer queue maar het uitvoeren hiervan is nooit gegarandeerd (crash process, iets anders dat kan gebeuren, ...). `IDisposable` kan gebruikt worden om managed resources op te kuisen, **maar moet manueel aangeroepen worden** door clients die dit object gebruiken - hier is ook nog niets van gegarandeerd! Behalve in een `using(obj) { }` block - hierna wordt `Dispose()` aangeroepen, ook als er ondertussen een of andere Exception opgetreden is. In Java 6 en lager moet je dit met `try { } finally { }` manueel doen. 

Zie [java resources wiki pagina]({{< relref "wiki/code/java/resources.md" >}})