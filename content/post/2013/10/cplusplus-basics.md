+++
title = "C++ Basics"
subtitle = "C++ basics for a Java developer"
archived = true
draft = false
tags = [
    "c++"
]
date = "2013-10-01"
+++

## Scope 

C++ heeft block level scope, net als Java, alleen is het mogelijk om een variabele binnen een for loop dezelfde naam te geven als een die buiten die block gedefiniëerd is, terwijl dat in Java niet gaat:

```c
int j;
for(int i = 0; i < 10; i++) {
  int j = i + 1; // compile fout in java
}
```

### Pointer scope  

[auto_ptr](https://en.wikipedia.org/wiki/Auto_ptr) kan gebruikt worden om een pointer automatisch te verwijderen met `delete` wanneer deze scope verliest - alle andere zaken moet je zelf opkuisen. 
:exclamation: Dit is deprecated in C++ 11, gebruik [unique_ptr](https://en.wikipedia.org/wiki/Smart_pointer#unique_ptr)

Voorbeeld van wikipedia:

```c
#include <iostream>
#include <memory>
using namespace std;
 
int main(int argc, char **argv)
{
    int *i = new int;
    auto_ptr<int> x(i);
    auto_ptr<int> y;
 
    y = x;
 
    cout << x.get() << endl; // Print NULL
    cout << y.get() << endl; // Print non-NULL address i
 
    return 0;
}
```

## overloading: 'virtual' 

In java wordt by default het diepste gedefiniëerde element opgeroepen, in C++ ben je verplicht `virtual` te gebruiken als "optimalisatie" wordt dit standaard niet gedaan... Voorbeeld:

```c
class Simple
{
public:
	Simple() : someMember(3) {}
	virtual int guessNumber();
	int someMember;
};
```

```c
#include "simplecpp.h"

int Simple::guessNumber()
{
	return 5;
}
``` 

Als je nu `guessNumber()` wil overschrijven in een subklasse kan dit:

```c
#include "simplecpp.h"

class Complexer : public Simple
{
public:
	Complexer() {}
	int guessNumber();
};
```

Merk op, te overschrijven method heropsommen in header file... (??) - hier hoeft geen `virtual` meer bij dan.

```c
#include "complexer.h"

int Complexer::guessNumber()
{
	return 10;
}
```

Wat is hier de uitkomst van:

```c

#include "complexer.h"
#include <iostream>

int main()
{
	Simple* simple = new Complexer();
	std::cout << simple->guessNumber();
	delete simple;
}
```

10. Haal `virtual` weg. 5. <br/><br/>
Definiëer `Complexer` zo:

```c
Complexer* complexer = new Complexer();
```

En het is altijd 10.

## Initialisatie 

(Voorbeelden van bovenstaande)

```c
#include "complexer.h"
#include <iostream>

int main()
{
	Simple simpleInitialized; // oops, I created something?
	// Simple simpleInitialized = NULL; cannot convert from 'int' to 'Simple' (#define NULL 0)

	Simple* simplePtr;

	std::cout << "<br/>n initialiezd: " << simplePtr->someMember;
	// Run-Time Check Failure #3 - The variable 'simplePtr' is being used without being initialized

	delete simplePtr;
}
```

Wat is hier speciaal aan?

  1. In C++ wordt altijd een object aangemaakt als je ze declareert. In Java niet!
  2. In C++ is `NULL` gedefiniëerd als `#define NULL 0` - je kan dus niet zomaar iets toekennen hieraan. In C++ 11 heb je `nullptr`
  3. Je kan wel een pointer declareren zonder een waarde toe te kennen, en dit geeft dan een run-time fout (zou bvb een `NullPointerException` gooien in java)

## Typecasting 

Uitgebreide uitleg: zie http://www.cplusplus.com/doc/tutorial/typecasting/

In C++ is één impliciete conversie mogelijk door middel van de constructor, bijvoorbeeld:

```c
class Something
{
 public:
   Something(int i) : myVar(i) {}
 private:
  int myVar;
}

int getal = 10;
Something something = getal; // use constructor
```

Om dit tegen te gaan kan je altijd het `explicit` keyword gebruiken, zodat je dit moet doen:

```c
Something something = Something(getal); // expliciet oproepen constructor
```

Je kan `staic_cast<Type>(var)` gebruiken om explicit constructors aan te roepen, zo kunnen ze dan toch nog gecast worden. 

## C++ 11 goodies 

Algemeen: [How C++ 11 helps boost your productivity](http://www.informit.com/articles/article.aspx?p=1910142)

  1. [Lambdas](http://www.codeproject.com/Articles/277612/Using-lambdas-Cplusplus-vs-Csharp-vs-Cplusplus-CX) zijn mogelijk
  2. `nullptr`
  3. `auto` keyword, zoals `var` in C# - dit is typesafe en door de compiler zelf bepaald. 
  4. 100% multithreading support, zie hieronder

# Linking obj/dlls 

Probleemstelling: verschillende **solutions**, code over solutions heen willen gebruiken. 

Dit compileert by default altijd, maar tijdens het linken van de gecompileerde files loopt het mis. Waarom? Omdat er geen `dllexport` voorzien is. 
<br/><br/> Op te lossen:

```c
#ifndef RESOURCE_UTILS_H
#define RESOURCE_UTILS_H

#include "Utility.h"

#ifdef _DLL
  #define DllExImport __declspec(dllexport)
#else
  #define DllExImport __declspec(dllimport)
#endif


class DllExImport ResourceUtils
{
public:
  static RAIIObject<HICON> getIcon(int resourceId);
  static RAIIObject<HICON> getIcon(HINSTANCE resourceHandleInstance, int resourceId);

private:
  ResourceUtils() {}
};

#endif
```

in de cpp file hoeft niets speciaal meer te staan. 

#### Functies exposen voor native calls 

Zelfde principe om klassen te exposen met `_ _declspec(dllexport)`. Gebruik eventueel std calls (C# heeft dit nodig): `DllExImport MyStruct* _ _stdcall GetSignals();`.

#### Properties van solutions 

##### Die de te exporteren code bevat 

  1. Configuration type: Dynamic Libraray (DLL)
  2. Incremental linking: Yes (/INCREMENTAL)
  3. Link Linkage Deps: Yes
  4. Output file: *.dll

##### Die de code bevat die gebruik maakt van de dll 

  1. Linker; Input: Additional dependencies ../OtherSolution.lib

### Shared libraries linken in Unix 

`declspec` is Win32 specifiek. Lees alles over GCC Visibility in [GNU GCC Wiki on Visibility](http://gcc.gnu.org/wiki/Visibility). Komt op dit neer:

```c
#if defined(_MSC_VER)
    //  Microsoft 
    #define EXPORT __declspec(dllexport)
    #define IMPORT __declspec(dllimport)
#elif defined(_GCC)
    //  GCC
    #define EXPORT __attribute__((visibility("default")))
    #define IMPORT
#else
    //  do nothing and hope for the best?
    #define EXPORT
    #define IMPORT
    #pragma warning Unknown dynamic link import/export semantics.
#endif
```

Zie ook [How to write shared Libraries](http://www.akkadia.org/drepper/dsohowto.pdf) by Ulrich Drepper.

# MFC 

:exclamation: MFC en AFX [is hetzelfde](http://en.wikipedia.org/wiki/Microsoft_Foundation_Class_Library):

> One interesting quirk of MFC is the use of "Afx" as the prefix for many functions, macros and the standard precompiled header name "stdafx.h". During early development what became MFC was called "Application Framework Extensions" and abbreviated "Afx". The name Microsoft Foundation Classes (MFC) was adopted too late in the release cycle to change these references

### Strings in MFC 

Gebruik `CString` - werkt niet op non-win32 omgevingen.

##### Formatting 

Formatten kan bijvoorbeeld met `string.Format(_T("%s in %d"), otherString, otherDecimal);`

:exclamation: Om een string te intialiseren en toe te kennen moet je wel de `_T` macro gebruiken

##### Substringen 

`Find` is hetzelfde als `indexOf` in andere talen. 

```c++
CString HostServiceProxy::GetCouponFromResponseString(CString response)
{
  CString couponKey ###### _T("Coupon");
  CString couponPart = response.Mid(response.Find(couponKey) + couponKey.GetLength());

  return couponPart.Left(couponPart.Find(_T(";")));
}
```

### Resource handling 

Icons en images worden opgeslagen in .rc files die als resources in de code gekoppeld kunnen worden aan bijvoorbeeld een `CButton`. Hoe? 

```c
  HANDLE hImage = ::LoadImage(AfxGetResourceHandle(), MAKEINTRESOURCE(resourceId), IMAGE_ICON, 16, 15, LR_DEFAULTCOLOR);
  if(hImage ###### NULL)
    ASSERT(FALSE);  

  HICON image = static_cast<HICON>(hImage);
```

`HICON` is van `WinDef.h` en `::LoadImage` zit op `WinUser.h`. Zie [MSDN doc](http://msdn.microsoft.com/en-us/library/windows/desktop/ms648045(v=vs.85).aspx) voor LoadImage. 

#### De juiste resource handle vastkrijgen ####

Als je een MFC DLL maakt, gaat `AfxGetResourceHandle()` verwijzen naar de resource handle van uw DLL zelf. Als je dus resources wil vastpakken van een andere DLL heb je pech. Als je geen MFC DLL maakt kan je dit aanpassen met ` AFX_MANAGE_STATE(AfxGetStaticModuleState( ))`. **Dit gooit echter linking errors** ( error LNK2005: _DllMain@12 already defined) indien je dit vanuit een MFC DLL aanroept - dan is dit niet nodig. 

Meer uitleg hierover: zie http://support.microsoft.com/kb/161589

:exclamation: de Afx resource handle kan **altijd** gewijzigd worden door leuke dingen te doen als:

```c
  HINSTANCE old = AfxGetResourceHandle();
  AfxSetResourceHandle(GetModuleHandle("andereModule"));
```

Gebruik daarom best `::GetModuleHandle(char*)` bij `::LoadImage`. 

#### Resources op het juiste moment terug vrijgeven ####

Resources worden meestal gewrapped in kleine objectjes die bij de constructor de resource alloceren en bij de destructor deze terug vrijgeven in plaats van in `try { ... }` zoiets te moeten doen in Java. Dit pattern is [RAII](http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization) of "Resource Acquisition Is Initialization". Voorbeeld:

```c
template<class TObject>
class RAIIObject
{
public:
  explicit RAIIObject(const TObject& obj) : m_Object(obj) {}
  RAIIObject() {}
  ~RAIIObject() {ReleaseObject();}
  RAIIObject<TObject>& operator######(const TObject& obj) {if(&obj ! &m_Object) {ReleaseObject(); m_Object = obj;} return *this;}
  RAIIObject<TObject>& operator######(const RAIIObject<TObject>& obj) {if(&obj ! this) {ReleaseObject(); m_Object = obj;} return *this;}
  TObject& GetObject() {return m_Object;}
  const TObject& GetObject() const {return m_Object;}
  operator TObject&() {return m_Object;}
  operator const TObject&() const {return m_Object;}
private:
  void ReleaseObject();
  TObject m_Object;
};

template<> inline void RAIIObject<HICON>::ReleaseObject() {::DestroyIcon(m_Object); m_Object = NULL;}
template<> inline void RAIIObject<CBrush>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CBitmap>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CFont>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CMenu>::ReleaseObject() {m_Object.DestroyMenu();}
```

# Preprocessing 

## Handige macro's 

##### Exception/Debug informatie expanden 

```c++
#define _ERROR_STR2(a) #a
#define _ERROR_STR(a) _ERROR_STR2(a)
#define ERROR_INFO(fn) _T(_ERROR_STR(__FILE__" line: "__LINE__" function: "fn))
```

Te gebruiken als `someFn(ERROR_INFO("bla"))`. Merk op dat `__FUNCTION__` of `__FUNC__` ook gebruikt kan worden, afhankelijk van de C++ compiler, maar dit is geen deel van de standaard (vanaf C++ v11).

De `#a` notatie wordt gebruikt om iets te [stringifyen](http://gcc.gnu.org/onlinedocs/cpp/Stringification.html) in de preprocessor, vandaar de delegate:

> Sometimes you may want to convert a macro argument into a string constant. Parameters are not replaced inside string constants, but you can use the ‘#’ preprocessing operator instead. When a macro parameter is used with a leading ‘#’, the preprocessor replaces it with the literal text of the actual argument, converted to a string constant. Unlike normal parameter replacement, the argument is not macro-expanded first. This is called stringification.

# Threading 

Handige links:

  1. [Thread synchronization for beginners](http://www.codeproject.com/Articles/7953/Thread-Synchronization-for-Beginners)

## Thread-safe Singleton pattern 

Bijna onmogelijk in C++ < v11 blijkbaar? 

Onderstaand voorbeeld gebruikt Win32 code (`WaitForSingleObject`) en een mutex om te wachten:

```c++
#pragma once
#include <WinBase.h>

class AddinProcessService 
{
    static AddinProcessService *singletonInstance;
  AddinProcessService() : m_coupon(_T("")), m_hostServiceAddress(_T("")) {}

  public:

  inline const CString& GetHostServiceAddress() const
  {
    return m_hostServiceAddress;
  }
  inline const CString& GetCoupon() const
  {
    return m_coupon;
  }
  inline void SetCoupon(CString coupon)
  {
    m_coupon = coupon;
  }
  inline void SetHostServiceAddress(CString address) 
  {
    m_hostServiceAddress = address;
  }

    static AddinProcessService* getSingletonInstance()
    {
    static volatile int initialized = 0;
    static HANDLE mtx;

    if (!initialized)
    {
        if (!mtx)
        {
          HANDLE mymtx;
          mymtx = CreateMutex(NULL, 0, NULL);
          if (InterlockedCompareExchangePointer(&mtx, mymtx, NULL) != NULL)
            CloseHandle(mymtx);
        }

        WaitForSingleObject(mtx, 0);
        if (!initialized)
        {
          libInitInternal();
          initialized = 1;
        }
        ReleaseMutex(mtx);
    }
    return singletonInstance;
    };

private:
  CString m_hostServiceAddress;
  CString m_coupon;

  static void libInitInternal()
  {
    singletonInstance = new AddinProcessService();
  }
};

```

:exclamation: Vergeet niet in de cpp file uw singletonInstance pointer te declareren, anders krijg je linker errors: `AddinProcessService* AddinProcessService::singletonInstance;`

In UNIX kan men [pthreads](https://computing.llnl.gov/tutorials/pthreads/) gebruiken, ongeveer op deze manier:

```c++
static Foo &getInst()
{
  static Foo *inst = NULL;
  if(inst ###### NULL)
  {
    pthread_mutex_lock(&mutex);
    if(inst ###### NULL)
      inst = new Foo(...);
    pthread_mutex_unlock(&mutex);
  }
  return *inst;    
}
```

Dan kan je `#ifdef WIN32` gebruiken om te switchen tussen beide implementaties.

#### C++ 11 multithreading

Vanaf C++ 11 zijn multithreads 100% native supported, dit wil zeggen dat manueel locken met een `mutex` overbodig wordt. Bovenstaande singleton kan gereduceerd worden tot (merk het **static** keyword op, dat is het belangrijkste voor de autolock):

```c++
static Singleton& get(){
  static Singleton instance;
  return instance;
}
```

Voor meer info, zie http://stackoverflow.com/questions/11711920/how-to-implement-multithread-safe-singleton-in-c11-without-using-mutex

# Win32 API specifics 

#### Get Loaded DLL info from given process 

huidig proces: `GetCurrentProcessId()` - dit is een `HANDLE`. 

```c++
CString ExceptionHandler::GetLoadedDllInfo() const
{
  CString dlls = _T("");
  HANDLE process = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, GetCurrentProcessId());
  if(process ###### NULL)
  {
    return dlls;
  }

   HMODULE hMods[1024];
   DWORD cbNeeded;
   BOOL modules = EnumProcessModules(process, hMods, sizeof(hMods), &cbNeeded);
   if(!modules)
   {
     return dlls;
   }

  for (int i = 0; i < (cbNeeded / sizeof(HMODULE)); i++)
  {
    TCHAR szModName[MAX_PATH];

    if (GetModuleFileNameEx(process, hMods[i], szModName, sizeof(szModName) / sizeof(TCHAR)))
    {
      dlls.Format(_T("%s, %s"), dlls, szModName);
    }
  }

  CloseHandle(process);
  return dlls;
}
```

Hiervoor moet je `#include <psapi.h>` includen én de psapi.lib file mee linken! Zie [EnumProcessModules MSDN](http://msdn.microsoft.com/en-us/library/windows/desktop/ms682631(v=vs.85).aspx).

# C++ Native calls uitvoeren 

#### Voorbeeld project 

Wat is het probleem: 

  1. Ik wil Native C++ methods kunnen aanroepen vanuit C#. Dit kan met de `DllImport` attribute.
  2. Ik wil structs kunnen remarshallen die uit de native code komen. Dit kan met `StructLayout` en `PtrToStructrue`. 
  3. Ik wil een char* mappen op een C# string: gebruik `[MarshalAsAttribute(UnmanagedType.LPStr)]` in uw C# struct. 
  4. Ik wil parameters mee kunnen geven: gebruik de juiste calling method (STD of DECL) instelling, zie `CallingConvention` op `UnmanagedFunctionPointer`.

```c++
#pragma once

#ifdef _DLL 
#define DllExImport __declspec(dllexport) 
#else 
#define DllExImport __declspec(dllimport) 
#endif

struct MyStruct
{
  char* id;
  char* description;
};

DllExImport MyStruct* __stdcall GetSignals();
```

```c++
#include "stdafx.h"
#include "TestClass.h"

DllExImport MyStruct* __stdcall GetSignals()
{
  static MyStruct a[] =
  {
    { "id1", "desc1" },
    { "id2", "desc2" },
    { "id3", "desc3" }
  };
  return a;
}
```

```csharp
namespace structArrayImportTest
{
    #region

    using System;
    using System.Runtime.InteropServices;

    #endregion

    internal class StructImporter
    {
        // Charset.Ansi is not needed it seems
        [DllImport("kernel32.dll", EntryPoint = "LoadLibrary")]
        private static extern IntPtr LoadLibrary(
            [MarshalAs(UnmanagedType.LPStr)] string lpLibFileName);

        [DllImport("kernel32.dll", EntryPoint = "GetProcAddress")]
        private static extern IntPtr GetProcAddress(IntPtr hModule,
                                                    [MarshalAs(UnmanagedType.LPStr)] string lpProcName);

        [DllImport("kernel32", SetLastError ###### true, EntryPoint  "GetProcAddress")]
        private static extern IntPtr GetProcAddressOrdinal(IntPtr hModule, IntPtr procName);

        [DllImport("kernel32.dll", EntryPoint = "FreeLibrary")]
        private static extern bool FreeLibrary(int hModule);

        [StructLayout(LayoutKind.Sequential)]
        public class MyStruct
        {
            [MarshalAsAttribute(UnmanagedType.LPStr)]
            public string _id;
            [MarshalAsAttribute(UnmanagedType.LPStr)]
            public string _description;
        }

        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        public delegate IntPtr fGetSignals();

        public fGetSignals GetSignals;

        public void Import()
        {
            IntPtr lib = LoadLibrary(@"C:<br/>Users<br/>bkwog<br/>Documents<br/>Visual Studio 2012<br/>Projects<br/>structArrayExportTest<br/>Debug<br/>structArrayExportTest.dll");
            // gebruik dumpbin /exports [bla.dll] om ordinal & name van exported functions te bepalen.
            IntPtr signalsHandle = GetProcAddressOrdinal(lib, new IntPtr(1));
            GetSignals = (fGetSignals) Marshal.GetDelegateForFunctionPointer(signalsHandle, typeof (fGetSignals));
            IntPtr myStructs = GetSignals();

            int structSize = Marshal.SizeOf(typeof(MyStruct));
            Console.WriteLine(structSize);

            for (int i = 0; i < 3; ++i)
            {
                // What's the difference between toInt32 & 64 here? Both work...
                IntPtr data = new IntPtr(myStructs.ToInt64() + structSize * i);
                MyStruct ms = (MyStruct)Marshal.PtrToStructure(data, typeof(MyStruct));

                Console.WriteLine("id: " + ms._id + " - descr: " + ms._description );
            }
        }

    }
}
```

#### Calling convention 

In te stellen via C++ project settings -> advanced -> calling convention, voor alles, of per functie met `__stdcall`. C# werkt hiet default mee. Aanpasbaar in het attribute, zie boven.

Als de calling convention niet overeen zou komen, krijg je bij het uitvoeren in de C# code de volgende fout:

>  call to PInvoke function 'structArrayImportTest!structArrayImportTest.StructImporter+fGetSignals::Invoke' has unbalanced the stack. This is likely because the managed PInvoke signature does not match the unmanaged target signature. Check that the calling convention and parameters of the PInvoke signature match the target unmanaged signature.

#### dumpbin 

Als je niet met ordinals wenst te werken maar de volledige naam van de functie kan jet met `dumpbin.exe` dit achterhalen:

```
C:<br/>Program Files (x86)<br/>Microsoft Visual Studio 10.0<br/>Common7<br/>IDE>dumpbin /exports TfsAdmin.exe structArrayExportTest.dll
Microsoft (R) COFF/PE Dumper Version 10.00.40219.01
Copyright (C) Microsoft Corporation.  All rights reserved.


Dump of file TfsAdmin.exe

File Type: EXECUTABLE IMAGE

Dump of file structArrayExportTest.dll

File Type: DLL

  Section contains the following exports for structArrayExportTest.dll

    00000000 characteristics
    52A888CA time date stamp Wed Dec 11 16:46:18 2013
        0.00 version
           1 ordinal base
           2 number of functions
           2 number of names

    ordinal hint RVA      name

          1    0 00011113 ?GetSignals@@YAPAUTestStruct@@XZ
          2    1 000110E6 ?GetSize@@YAPAHXZ

  Summary

        1000 .data
        1000 .idata
        3000 .rdata
        3000 .reloc
       11000 .rsrc
        8000 .text
       10000 .textbss
```

Merk op dat de functie `GetSignals` hier niet die naam heeft, maar `?GetSignals@@YAPAUTestStruct@@XZ`! 