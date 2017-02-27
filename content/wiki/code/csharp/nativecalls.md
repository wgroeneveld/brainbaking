+++
title = "nativecalls"
draft = false
tags = [
    "code",
    "csharp",
    "nativecalls"
]
date = "2013-12-13"
+++
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