+++
title = "dynamica"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "dynamica"
]
date = "2014-11-05"
+++
# Dynamica 

Zie ook [code/csharp/reflectie]({{< relref "wiki/code/csharp/reflectie.md" >}})

### Expression trees opbouwen 

##### Van een MethodInfo instantie naar een Func<> 

```csharp
            var instanceToMemoize = Activator.CreateInstance<TClassToMemoize>();
            foreach (var method in instanceToMemoize.GetType().GetMethods(BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance))
            {
                var parameters ###### method.GetParameters().Select(p > Expression.Constant("test"));

                var expr = Expression.Lambda(Expression.Call(Expression.Constant(instanceToMemoize), method, parameters)).Compile();
                _Delegates.Add(method.ToString(), expr);
            }

```

Argumenten stuk klopt nog niet. Refs:

  1. http://stackoverflow.com/questions/2933221/can-you-get-a-funct-or-similar-from-a-methodinfo-object
  2. http://stackoverflow.com/questions/11367830/how-to-find-full-name-of-calling-method-c-sharp

##### Memoization 

Ook mogelijk via `Func<>` wrappers; zie

  1. http://www.jaylee.org/post/2013/04/18/Memoization-and-Immutable-data-in-CSharp-Part-1.aspx
  2. http://www.jaylee.org/post/2013/04/22/Immutable-Data-and-Memoization-in-CSharp-Part-2.aspx

Dit is een extension die 2 type arguments aanvaard:

```csharp
        public static Func<TArg1, TArg2, TResult> AsMemoized<TArg1, TArg2, TResult>(this Func<TArg1, TArg2, TResult> func)
        {
            var values = new Dictionary<MemoizedKey<TArg1, TArg2>, TResult>();
            return (arg1, arg2) => MemoizedValue(func, arg1, arg2, values);
        }

        public static Func<TArg, TResult> AsMemoized<TArg, TResult>(this Func<TArg, TResult> funcArg)
        {
            Func<TArg, object, TResult> func ###### (arg1, arg2) > funcArg(arg1);
            var values = new Dictionary<MemoizedKey<TArg, object>, TResult>();
            return (arg) => MemoizedValue(func, arg, null, values);
        }
        private static TResult MemoizedValue<TArg1, TArg2, TResult>(Func<TArg1, TArg2, TResult> func, TArg1 arg1, TArg2 arg2, Dictionary<MemoizedKey<TArg1, TArg2>, TResult> values)
        {
            TResult value;

            var memoizedKey = new MemoizedKey<TArg1, TArg2>(arg1, arg2);
            if (!values.TryGetValue(memoizedKey, out value))
            {
                value ###### values[memoizedKey]  func(memoizedKey.Arg1, memoizedKey.Arg2);
            }

            return value;
        }

        private class MemoizedKey<TArg1, TArg2>
        {
            public MemoizedKey(TArg1 arg1, TArg2 arg2)
            {
                Arg1 = arg1;
                Arg2 = arg2;
            }

            public TArg1 Arg1 { get; private set; }

            public TArg2 Arg2 { get; private set; }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((MemoizedKey<TArg1, TArg2>)obj);
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    return (EqualityComparer<TArg1>.Default.GetHashCode(Arg1) * 397) ^ EqualityComparer<TArg2>.Default.GetHashCode(Arg2);
                }
            }

            private bool Equals(MemoizedKey<TArg1, TArg2> other)
            {
                return EqualityComparer<TArg1>.Default.Equals(Arg1, other.Arg1) && EqualityComparer<TArg2>.Default.Equals(Arg2, other.Arg2);
            }
        }

```

Equals is nodig voor de `Dictionary` (generated). 

### Aspect Oriented Programming 

**PostSharp**: [http:*www.postsharp.net](http:*www.postsharp.net)

#### Transacties wiren 

Zie [code/csharp/persistence]({{< relref "wiki/code/csharp/persistence.md" >}})

#### Aspects applyen op assembly level 

Q: Ik wil AOP toepassen voor alle klassen (& [publieke] methods) in een bepaald project (DLL)<br/><br/>
A: Gebruik [Multicasting aspects](http://www.postsharp.net/aspects/multicasting).

Bijvoorbeeld, om exceptions overal op te vangen, en dan door te delegeren, evt screenshot van de app te nemen:

```csharp
[assembly: ScenarioTests.ScenarioExceptionHandler]

namespace ScenarioTests
{
    [Serializable]
    [ScenarioExceptionHandler(AttributeExclude = true)]
    public class ScenarioExceptionHandler : OnMethodBoundaryAspect
    {
        public override void OnException(MethodExecutionArgs args)
        {
            WebDriverExceptionHandler.Handle(args.Exception);
            base.OnException(args);
        }
    }
}
```

De eerste regel, `[assembly:]` is van belang, zie documentatie. Je kan ook verder filteren by visibility etc, zoals in [Spring AOP/AspectJ]({{< relref "wiki/code/java/dynamica/aspectj.md" >}}) de strings in XML gedfiniëerd zijn. 