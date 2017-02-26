+++
title = "teamtest"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "c",
    "testing",
    "teamtest"
]
date = "2013-07-17"
+++
# Visual Studio 2005 TeamTest Framework 

Hoofdartikel (2005, C# voorbeelden): http://msdn.microsoft.com/en-us/library/ms379625(v=vs.80).aspx

**Waarom**?

  1. Zelfde syntax als built-in C# unit tests voor Visual Studio
  2. Makkelijker te lezen dan bvb [code/c/testing/gtest]({{< relref "wiki/code/c/testing/gtest.md" >}})
  3. Garbage collector van Managed C++, joepie (?)
  4. Toch mogelijk om unmanaged native C++ te testen (zie onder), integratie VStudio.

**Waarom niet**?

  1. Dropped support voor VS2012? zie [code/c/testing/testexplorer]({{< relref "wiki/code/c/testing/testexplorer.md" >}}) in de plaats (native C++)
  2. `/cli` flag miserie (zie onder)
  3. Onduidelijke syntax voor hardcore C++ users die niet aan C# gewend zijn

## Visual Studio 2008 

Hiervoor moeten we een apart test project aanmaken dat met **/CLR** flag compileert om de .NET test suites te gebruiken (`using namespace	Microsoft::VisualStudio::TestTools::UnitTesting;`):

Project > configuration properties > General > Common Language Runtime support

<img style='float: left;' src='/img//code/c/testing/clr_unittests.png |'>

Dit staat op `/clr:safe` indien je met VStudio 2008 een nieuwe test aan maakt via menu Test > New Test > Unit Test

Een voorbeeld header file om te testen:

```c
class MyClass {
public:
	MyClass() {};

	int addUp(int one, int two);
};
```

```c
#include "myclass.h"
#include <iostream>
using namespace std;

int MyClass::addUp(int one, int two)
{
	return one + two;
}
```

#### Managed test code schrijven 

Gebruik dezelfde manier als .NET Unit Testing framework met attributes - dit vereist dus de CLR flag. Voorbeeld:

```c
#include "stdafx.h"
#include "../libtest/myclass.h"

using namespace System;
using namespace System::Text;
using namespace System::Collections::Generic;
using namespace	Microsoft::VisualStudio::TestTools::UnitTesting;

namespace unittests
{
	[TestClass]
	public ref class MyClassTest
	{

	public: 

		[TestMethod]
		void AddOne()
		{
			Assert::AreEqual(3, MyClass().addUp(1, 2));
		};
	};
}
```

**Assert** heeft een hoop static methods

#### een externe klasse testen die van een lib komt 

Als je vanuit je test project wil refereren naar productie code/projecten, kan dit een probleem zijn:

```
MyClassTest.obj : error LNK2028: unresolved token (0A00000A) "public: __thiscall MyClass::MyClass(void)" (??0MyClass@@$$FQAE@XZ) referenced in function "public: void __clrcall unittests::MyClassTest::AddOne(void)" (?AddOne@MyClassTest@unittests@@$$FQ$AAMXXZ)
MyClassTest.obj : error LNK2028: unresolved token (0A00000B) "public: int __thiscall MyClass::addUp(int,int)" (?addUp@MyClass@@$$FQAEHHH@Z) referenced in function "public: void __clrcall unittests::MyClassTest::AddOne(void)" (?AddOne@MyClassTest@unittests@@$$FQ$AAMXXZ)
MyClassTest.obj : error LNK2019: unresolved external symbol "public: int __thiscall MyClass::addUp(int,int)" (?addUp@MyClass@@$$FQAEHHH@Z) referenced in function "public: void __clrcall unittests::MyClassTest::AddOne(void)" (?AddOne@MyClassTest@unittests@@$$FQ$AAMXXZ)
```

Dat wil zeggen, het compileert, maat het linkt niet. Oplossing: Voeg dit toe aan uw `stdafx.cpp`: 

```c
#pragma comment(lib, "../Debug/libtest.lib")
```

gegeven dat "libtest" uw project under test is. Vanaf dan kan je normaal header files includen in uw test cpp file, zie boven.

#### een externe klasse testen die van een DLL komt 

Er wordt pas een `.lib` file gegenereerd wanneer je `declspec(dllexport)` definiëert - wanneer niets exported is, kan er ook niets imported worden... Dus `myClass` aanpassen:

```c

#ifdef FRIENDCLASS_EXPORT
    #define FRIENDCLASS __declspec(dllexport)
#else
    #define FRIENDCLASS __declspec(dllimport)
#endif

class FRIENDCLASS MyClass {
public:
	MyClass();

	int addUp(int one, int two);
};
```

En dan het libtest project compileren met de extra preprocessor definitie `FRIENDCLASS_EXPORT` zodat in commandline `/D "FRIENDCLASS_EXPORT"` erbij komt. Zie ook [MSDN Preprocessor definitions](http://msdn.microsoft.com/en-us/library/hhzbb5c8(v=vs.80).aspx), nu kunnen we hierop checken in de code met `#ifdef`. Bovenstaande code doet een export wanneer gedefiniëerd, en een import anders - dit gebeurt wanneer we de header file includen vanuit onze test cpp file. 

#### Debugging 

:exclamation: [Debug information format flags](http://msdn.microsoft.com/en-us/library/958x11bc(v=vs.80).aspx): `/ZI` ("Edit and Continue feature", retry drukken bij assertion failure) is **niet** ondersteund in combinatie met `/cli`. Debuggen gaat wel op `/Zi` niveau. 
