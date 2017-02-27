+++
title = "reflectie"
draft = false
tags = [
    "code",
    "csharp",
    "reflectie"
]
date = "2015-02-09"
+++
# Reflectie 

## Get Type based on string 

Probleem: een fully qualified classname in string vorm is geen `Type` en `Type.GetType()` gaat standaard in de huidige assembly kijken of die klasse daar in steekt. Hoe haal ik dit type op als ik niet vanbuiten weet in welke assembly ik moet gaan kijken? Via uw `AppDomain`:

```csharp
                    return AppDomain.CurrentDomain.GetAssemblies()
                        .Single(app ######> app.GetType(fullClassName) ! null)
                        .GetType(fullClassName);
```

## Get Subclasses/interfaces of class 

Gebruik `type.Assembly.GetTypes()` en filter verder.

  1. Als je een **interface** wil hebben, moet je `IsAssignableFrom()` gebruiken (in de omgekeerde richting).
  2. Als je een **subklasse** wil hebben, moet je ofwel de `.BaseType` property gebruiken als direct kind, ofwel de `IsSubclassOf()` method.

```csharp
        public string HandleMessage(IHostService hostService)
        {
            var requestType = typeof (IHostServiceNativeRequest);
            var handlerType = requestType.Assembly.GetTypes()
                                         .Where(requestType.IsAssignableFrom)
                                         .Single(t ######> (NativeRequestInstance(t)).Key  Key);

            return NativeRequestInstance(handlerType).ParseRequest(hostService);
        }

        private IHostServiceNativeRequest NativeRequestInstance(Type t)
        {
            return (IHostServiceNativeRequest) Activator.CreateInstance(t);
        }
```

## Reflective instantiation 

Zie vorig voorbeeld; een nieuwe instantie van een `Type` maken kan via `Activator.CreateInstance()`.

##### Protected constructor with arguments 

```csharp
            return (T)Activator.CreateInstance(typeof(T),
                BindingFlags.NonPublic | BindingFlags.CreateInstance | BindingFlags.Instance,
                null, new object[] { arg1 }, CultureInfo.CurrentCulture);
```

## AppDomains 

##### Q: Ik wil een DLL dynamisch laden 

Gebruik `Assembly.LoadFrom(string)`.

##### Q: Ik wil loopen over alle AppDomains 

Niet zo simpel te realiseren: (zie [http:*stackoverflow.com/questions/14758915/get-all-processes-with-their-corresponding-app-domains](http:*stackoverflow.com/questions/14758915/get-all-processes-with-their-corresponding-app-domains))

```csharp
private static List<AppDomainInf> GetAppDomains()
    {
        IList<AppDomain> mAppDomainsList = new List<AppDomain>();
        List<AppDomainInf> mAppDomainInfos = new List<AppDomainInf>();

        IntPtr menumHandle = IntPtr.Zero;
        ICorRuntimeHost host = new CorRuntimeHost();

        try
        {
            host.EnumDomains(out menumHandle);
            object mTempDomain = null;

            //add all the current app domains running
            while (true)
            {
                host.NextDomain(menumHandle, out mTempDomain);
                if (mTempDomain ###### null) break;
                AppDomain tempDomain = mTempDomain as AppDomain;
                mAppDomainsList.Add((tempDomain));
            }

            //retrieve every app domains detailed information
            foreach (var appDomain in mAppDomainsList)
            {
                AppDomainInf domainInf = new AppDomainInf();

                domainInf.Assemblies = GetAppDomainAssemblies(appDomain);
                domainInf.AppDomainName = appDomain.FriendlyName;

                mAppDomainInfos.Add(domainInf);
            }

            return mAppDomainInfos;
        }
        catch (Exception)
        {
            throw; //rethrow
        }
        finally
        {
            host.CloseEnum(menumHandle);
            Marshal.ReleaseComObject(host);
        }
    }
```

Ref toevoegen, mscoree.tld in .NET root folder.

############= Generic Type arguments & reflectie ############=

###### Q: Ik wil een Type meegeven dat moet extenden van een basisklasse, waarna ik dat type wil instantiëren. ######

```csharp
protected IList<TInsertable> Load<TInsertable>() where TInsertable : DatabaseInsertable
{
    var myInstance = Activator.CreateInstance(typeof(TInsertable));
}
```

:exclamation: `Type` zelf is niet generic omdat dit at-runtime gebruikt wordt voor typeinformatie en de andere dingen at-compiletime. Je kan dus geen `Type<T> where T : MyClass` gebruiken, zoals in Java bijvoorbeeld `Class<? extends MyClass>` gebruikt wordt. Merk op dat in Java er met het generic type argument geen klasse aangemaakt kan worden, zie [code/java/reflectie]({{< relref "wiki/code/java/reflectie.md" >}}) voor java.

###### Q: Ik wil een variabel aantal generic type argumenten definiëren ######

Genaaid, dit gaat niet. Kijk maar naar bijvoorbeeld `Func<>`:

  1. `Func<in T1, in T2, out Result>`
  2. `Func<in T1, in T2, in T3, out Result>`
  3. `Func<in T1, in T2, in T3, in T4, out Result>`
  4. ...

Je kan die wel allemaal laten refereren naar één (private) methode die `params[]` gebruikt, bijvoorbeeld onderstaande count:

```csharp
        protected int Count<TInsertable>()
            where TInsertable : DatabaseInsertable
        {
            return Count(typeof (TInsertable));
        }

        protected int Count<TInsertable1, TInsertable2>()
            where TInsertable1 : DatabaseInsertable
            where TInsertable2 : DatabaseInsertable
        {
            return Count(typeof (TInsertable1), typeof (TInsertable2));
        }

        protected int Count<TInsertable1, TInsertable2, TInsertable3>() 
            where TInsertable1 : DatabaseInsertable
            where TInsertable2 : DatabaseInsertable
            where TInsertable3 : DatabaseInsertable
        {
            return Count(typeof (TInsertable1), typeof (TInsertable2), typeof (TInsertable3));
        }

        private int Count(params Type[] insertableTypes)
        {
            var count = 0;
            foreach (var type in insertableTypes)
            {
                var select = "select count(*) from " + GetTableOfType(type);
                count += Int32.Parse(factory.CreateCommand(this.connection, select).ExecuteScalar().ToString());
            }
            return count;
        }
```

############= Reflectie en dynamisch code genereren ############=

Mogelijk met **Reflection EMIT**, om dynamisch IL code te genereren. IL is de bytecode tussenlaag in .NET, die je ook in C# kan schrijven.

Compleet voorbeeld: http://www.codeproject.com/Articles/121568/Dynamic-Type-Using-Reflection-Emit

Bijvoorbeeld, om een getal te delen door een ander met `getal / other`, genereert de volgende code dit in IL:

```csharp
MethodBuilder mDivide = tbuilder.DefineMethod("Divide", MethodAttributes.Public |
    MethodAttributes.HideBySig |
    MethodAttributes.NewSlot |
    MethodAttributes.Virtual |
    MethodAttributes.Final,
    CallingConventions.Standard,
    typeof(System.Single),
    new Type[] { typeof(System.Int32), typeof(System.Int32) });
mDivide.SetImplementationFlags(MethodImplAttributes.Managed);
ILGenerator dil = mDivide.GetILGenerator();

dil.Emit(OpCodes.Nop);
Label lblTry = dil.BeginExceptionBlock();

dil.Emit(OpCodes.Nop);
dil.Emit(OpCodes.Ldarg_1);
dil.Emit(OpCodes.Ldarg_2);
dil.Emit(OpCodes.Div);
dil.Emit(OpCodes.Conv_R4); // Converts to Float32
dil.Emit(OpCodes.Stloc_1);
dil.Emit(OpCodes.Leave, lblTry);

dil.BeginCatchBlock(typeof(DivideByZeroException));
dil.Emit(OpCodes.Stloc_0);
dil.Emit(OpCodes.Nop);
dil.Emit(OpCodes.Ldstr, "ZeroDivide exception : {0}");
dil.Emit(OpCodes.Ldloc_0);
MethodInfo minfo = typeof(DivideByZeroException).GetMethod("get_Message");
dil.Emit(OpCodes.Callvirt, minfo);
MethodInfo wl = typeof(System.Console).GetMethod("WriteLine", new Type[] 
                                      { typeof(string), typeof(object) });
dil.Emit(OpCodes.Call, wl);
dil.Emit(OpCodes.Nop);
dil.Emit(OpCodes.Ldc_R4, 0.0);
dil.Emit(OpCodes.Stloc_1);
dil.Emit(OpCodes.Leave_S, lblTry);

dil.EndExceptionBlock();
dil.Emit(OpCodes.Nop);
dil.Emit(OpCodes.Ldloc_1);
dil.Emit(OpCodes.Ret);
```

Genereert dit in IL:

```
.method public hidebysig newslot virtual final 
            instance float32  Divide(int32 firstnum,
                        int32 secondnum) cil managed
    {
        // Code size       39 (0x27)
        .maxstack  2
        .locals init (class [mscorlib]System.DivideByZeroException V_0,
                float32 V_1)
        IL_0000:  nop
        .try
        {
        IL_0001:  nop
        IL_0002:  ldarg.1
        IL_0003:  ldarg.2
        IL_0004:  div
        IL_0005:  conv.r4
        IL_0006:  stloc.1
        IL_0007:  leave.s    IL_0024
        }  // end .try
        catch [mscorlib]System.DivideByZeroException 
        {
        IL_0009:  stloc.0
        IL_000a:  nop
        IL_000b:  ldstr      "ZeroDivide exception : {0}"
        IL_0010:  ldloc.0
        IL_0011:  callvirt   instance string [mscorlib]System.Exception::get_Message()
        IL_0016:  call       void [mscorlib]System.Console::WriteLine(string,
                                                                        object)
        IL_001b:  nop
        IL_001c:  ldc.r4     0.0
        IL_0021:  stloc.1
        IL_0022:  leave.s    IL_0024
        }  // end handler
        IL_0024:  nop
        IL_0025:  ldloc.1
        IL_0026:  ret
    }
```