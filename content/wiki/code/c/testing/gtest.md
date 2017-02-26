+++
title = "gtest"
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
    "gtest"
]
date = "2014-03-26"
+++
# Google Test 

Downloaden op https://code.google.com/p/googletest/downloads/list

**Waarom**?

  1. Platform onafhankelijk
  2. Snelheid
  3. Geen gezeik met Managed C++, compatibel met "eender wat" (enige vereiste: `cc` compiler variant)
  4. Wordt veel gebruikt (Chromium, Stack overflow)

**Waarom niet**?

  1. slechte of geen integratie met VStudio (zie onder)
  2. wéér een andere syntax dan MS .NET testen
  3. beetje awkward assertions

#### Assertions schrijven 

```c
#include "../BaseCode/BaseCode.h"

#include "gtest/gtest.h"

TEST(MyTestCase, MyTest_Success)
{
    EXPECT_EQ(2, MySum(1, 1));
}

TEST(MyTestCase, MyTest_Failure)
{
    EXPECT_EQ(3, MySum(1, 2));
}
```

Waarbij dan `BaseCode` uw system under test zaken bevat (waar `MySum` defined is)

#### Builden met scons en g++ 

Tested in Cygwin Win7 & OSX 10.9

```python
Import('env')
env ###### env.Clone(CPPPATH  './:./include')

env.Append(CXXFLAGS = ['-g', '-Wall', '-Wextra', '-pthread'])
gtest ###### env.Library(target  'gtest', source = ['src/gtest-all.cc', 'src/gtest_main.cc'])

Return('gtest')
```

Zie [code/build/scons]({{< relref "wiki/code/build/scons.md" >}})

#### Builden met Visual Studio 

<img style='float: left;' src='/img//code/c/testing/screenshot.png|'>

Zie http://leefrancis.org/2010/11/17/google-test-gtest-setup-with-microsoft-visual-studio-2008-c/

Er zijn 2 `.sln` files voorzien in de msvc subdir bij de zipfile, één voor statische links en één voor dynamische. Afhankelijk van uw project (.DLL of .LIB gegenereerde uitkomst), ga je één van beiden moeten compileren. Als je van plan bent om `/MDd` te gebruiken (dll + debugging), gebruik dan `gtest-md.sln`. 

Daarna kan je een nieuwe solution maken, package naar executable om de test zelf te runnen (om gtest testen te draaien). Verander deze dingen in het project:

  1. General > Configuration type  = Application (.EXE)
  2. C/C++ > General > Additional Include dirs naar gtest/include verwijzen
  3. C/C++ > Preprocessor > definitions toevoegen `_VARIADIC_MAX=10`
  4. Code generation > Runtime library op `/MDd` of `/MTd` juist zetten (zie boven)
  5. Linker > Additional Library directories > gtest/Debug (staan reeds binaries indien compiled)
  6. Linker > Input > Additional dependencies = gtestd.lib;gtest_maind.lib;(rest)
  7. Linker > System > SubSystem Console `/SYBSYSTEM:CONSOLE`
  8. Linker > Input > Module Definition file leeg (indien van DLL naar EXE veranderd kan hier wat brol in zitten)

#### Visual Studio 2012 en STD problemen 

Fouten als 

```
1>a:<br/>gtest<br/>include<br/>gtest<br/>gtest-printers.h(550): error C2977: 'std::tuple' : too many template arguments
1>          b:<br/>program files (x86)<br/>microsoft visual studio 2012<br/>vc<br/>include<br/>utility(73) : see declaration of 'std::tuple'
```

Op te lossen met een preprocessor macro _VARIADIC_MAX=10, zie http://stackoverflow.com/questions/12558327/google-test-in-visual-studio-2012

##### Integratie met Visual Studio 2008/2010 

[GoogleTestAddin](http://googletestaddin.codeplex.com/documentation) (kopieer 2 files naar C:<br/>Users<br/>bkwog<br/>Documents<br/>Visual Studio 2008<br/>Addins, map misschien nog aanmaken)

Niet super nuttig, een knopje om testen snel te herdraaien (of één die geselecteerd is), beter dan post-build actie zie boven... 

#### Integratie met Visual Studio 2012 

[Google Test Adapter](http://visualstudiogallery.msdn.microsoft.com/f00c0f72-ac71-4c80-bf8b-6fe381548031) plugin (1.1 - geen actieve development?)