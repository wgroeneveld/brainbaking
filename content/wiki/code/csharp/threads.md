+++
title = "threads"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "threads"
]
date = "2013-12-06"
+++
# Threads 

### Locking en singletons 

See [C#In Depth: Implementing the Singleton pattern in C#](http://csharpindepth.com/Articles/General/Singleton.aspx)

een `lock()` is heel duur om uit te voeren, daarom wordt er een null check hierrond nog eens geschreven, dat heet **double-check locking**:

```csharp
        internal static ContextViewPresenter instance;
        private static readonly Object syncRoot = new Object();
        public static ContextViewPresenter Instance
        {
            get
            {
                if (instance ###### null)
                {
                    lock (syncRoot)
                    {
                        if (instance ###### null)
                        {
                            instance = new ContextViewPresenter(UserEnvironmentDataProviderSingleton.Instance);                            
                        }
                    } 
                }
                return instance;
            }
        }
```

############ Thread-local static variables ############

In java kan men `ThreadLocal<>` gebruiken om iets per thread te storen (zoals de gebruiker van een webpagina die per request van de `WebServlet` één nieuwe Thread aanmaakt). <br/><br/>
In C# kan dit ook met de attribute `[ThreadStatic]` voor een field te plaatsen. 

:exclamation: Opgelet met ASP.NET - IIS heeft dan een shared threadpool geconfigureerd waar jij geen controle over hebt. Dit wil zeggen dat x threads herbruikt worden, en dus ook uw threadlocal storage. 

Oplossing(en): (zie ook [hier](http://piers7.blogspot.be/2005/11/threadstatic-callcontext-and_02.html))

  1. Clear waarde op einde van elke request
  2. Gebruik `HttpContext` van ASP.NET zelf in plaats van `[ThreadStatic]`. (Zou probleem kunnen zijn in uw domein laag...)