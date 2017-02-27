+++
title = "linking"
draft = false
tags = [
    "code",
    "c",
    "linking"
]
date = "2014-03-26"
+++
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