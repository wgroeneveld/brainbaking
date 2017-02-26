+++
title = "classes"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "classes"
]
date = "2014-01-29"
+++
# Classes 

## Dynamically creating instances 

Gebruik `Activator`:

```csharp
Activator.CreateInstance(type) as MyType
```

## Overrides en shadowing: 'new' en 'virtual' 

Zie onder andere:
  1. http://stackoverflow.com/questions/1014295/new-keyword-in-method-signature
  2. http://stackoverflow.com/questions/9892468/java-is-there-java-equivalent-for-c-sharp-new-keyword-in-method-signature-how

In java zijn alle methods `virtual`, dat wil zeggen dat ze overschrijfbaar zijn (`@Override`) zodat de method in de diepst geneste polymorfe structuur gebruikt wordt. In C# is daarvoor het keyword `virtual` nodig:

```csharp
public class A
{
   public virtual void One();
   public void Two();
}

public class B : A
{
   public override void One();
   public new void Two();
}

B b = new B();
A a = b as A;

a.One(); // Calls implementation in B
a.Two(); // Calls implementation in A
b.One(); // Calls implementation in B
b.Two(); // Calls implementation in B
```

De concretere klasse moet dan overriden met `override` dat niet gaat als het niet `virtual` is (je kan ook niet overerven waarbij een klasse `sealed` is, zoals `final` in java). Wat hier wel opmerkelijk is, is het gebruik van het keyword `new` in de tweede method "Two". Hierbij kan je de eerste implementatie toch nog hiden, maar je moet wel upcasten! Misschien is dit nog handig bij het schrijven van legacy testen?

Het is in java niet mogelijk om een `final` method te overriden. (Private telt natuurlijk niet mee...) In C# is het [wel mogelijk om halverwege de chain te sealen](http://msdn.microsoft.com/en-us/library/aa645769(v=vs.71).aspx)!

## Closures en Lambda's 

Interessante links:

  1. [Lambda expressions MSDN C# programming guide](http://msdn.microsoft.com/en-us/library/bb397687.aspx)
  2. [Expression Trees MSDN](http://msdn.microsoft.com/en-us/library/bb397951.aspx) hier worden lambda's gebruikt voor LINQ

### Passing on 'work' to a method, to execute the lambda 

In Java:

```java
public interface Workable<T> {
  public T work();
}

public class MyWork extends Workable<MyObj> {
  public MyObj work() {
    // do stuff here 
  } 
}

public class Executer {
  public <T> T doStuff(Workable<T> w) {
     prepare();
     T result = w.work();
     cleanup();
  }

  public MyObj createMyObj() {
    return doStuff(new MyWork());
  }
}
```

Basically, gebruik interfaces. Pijnlijk en verbose. In C# kan je `() =>` gebruiken om een anonieme method aan te maken, en `Func<>` als type gebruiken. <br/><br/>
Concreet voorbeeld:

```csharp
        internal virtual T Execute<T>(Func<T> work)
        {
            Connection.Open();
            var transaction = Connection.BeginTransaction();
            try
            {
                var retVal = work.Invoke();
                transaction.Commit();
                return retVal;
            }
            catch (Exception)
            {
                transaction.Rollback();
                throw;
            }
            finally
            {
                Connection.Close();
            }
        }
        
        public bool BlaBla()
        {
          return Execute(() =>
          {
              // do query stuff in here.
              return true;
          });
        }
```

##### Q: Wat is het verschil tussen een Lambda (>()) en een delegate? ######

A: niets; zie voorbeeld:

```csharp
Func<string, int> giveLength = delegate(string text) { return text.Length; };
Func<string, int> giveLength ###### (text > text.length);
```

de `=>` notatie is nieuwer. 


###### Q: Wat is het verschil tussen een expression type en een anonymous type? ######

http://stackoverflow.com/questions/299703/delegate-keyword-vs-lambda-notation

> If you assign the lambda to a delegate type (such as Func or Action) you'll get an anonymous delegate.
If you assign the lambda to an Expression type, you'll get an expression tree instead of a anonymous delegate. The expression tree can then be compiled to an anonymous delegate.
Edit: Here's some links for Expressions.

Zeer interessant artikel: http://weblogs.asp.net/scottgu/archive/2007/04/08/new-orcas-language-feature-lambda-expressions.aspx

############ Nested (inner) classes in C# ############

http://blogs.msdn.com/b/oldnewthing/archive/2006/08/01/685248.aspx - C# heeft geen referentie naar de outer class (`$0` die in Java er impliciet is), bijgevolg moet je dit zelf bijhouden. 

Zie ook http://stackoverflow.com/questions/4770180/anonymous-inner-classes-in-c-sharp

############ Modules as anonymous inner classes, JavaScript pattern ############

```javascript
var Mod = (function(consoleDep) {
	
	function yo() {
		consoleDep.log("yo");
	}

	return {
		hi: yo
	};

})(console);

Mod.hi();
```

equals

```csharp
        private interface ILoggable
        {
            void Log(string msg);
        }

        private class Console : ILoggable
        {
            public void Log(string msg)
            {
                Debug.WriteLine(msg);
            }
        }

        [TestMethod]
        public void TestMe()
        {
            var Mod ###### new Func<ILoggable, Dictionary<string, Action>>((consoleDep) >
                {
                    Action yo ###### () > consoleDep.Log("yo");

                    return new Dictionary<string, Action>
                        {
                            { "hi", yo }
                        };
                })(new Console());
            Mod["hi"]();
        }

```

Problemen

  * cannot assign lambda expression to an implicitly-typed local variable (`var` bij de yo ipv `Action`)
  * duck typing for module dependencies??

############= Enums in C# ############=

Zie ook http://stackoverflow.com/questions/469287/c-sharp-vs-java-enum-for-those-new-to-c

> Enumerations in the CLR are simply named constants. The underlying type must be integral. In Java an enumeration is more like a named instance of a type. That type can be quite complex and - as your example shows - contain multiple fields of various types.

Optie 1: gebruik **extensions** (nog altijd een switch nodig omdat het type in algemene vorm binnen komt)

Optie 2: maak uw eigen enum klasse door immutable readonly classes te maken:

```c#
class Planet
{
  public static readonly Planet EARTH = new Planet("earth");

  private string name;
  private Planet(string name)
  {
    this.name = name;
  }
  
  public static IEnumerable<Planet> Values
  {
    // return set of planets
  }
}
```