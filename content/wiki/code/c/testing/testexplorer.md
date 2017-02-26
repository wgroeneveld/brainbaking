+++
title = "testexplorer"
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
    "testexplorer"
]
date = "2013-09-05"
+++
# Visual Studio 2012 Test Explorer framework 

**Waarom**?

  1. Integratie VStudio, zelfde manier om te "runnen" als C# testen
  2. __unmanaged__ (native) C++ code testen zonder vettige `/cli` mode die nodig is.
  3. Voor mixed team C#/C++ misschien beter/makkelijker?

**Waarom niet**?

  1. Weeral iets anders, Team Test buiten? Wat gaat het zijn voor VS3013?
  2. Niet 100% dezelfde syntax als C# (toch al closer, maar bvb geen attributes etc)
  3. VS2012 only momentel, dus 2008 = kinkloppen

Voorbeeld project in VS2012: <img style='' src='/img//code/c/testing/math_testexplorer_vs2012.zip|'>

#### Assertions schrijven 

Gebruik namespace `CppUnitTestFramework` - voorbeeld:

```c
#pragma once
#include "stdafx.h"
#include "CppUnitTest.h"
#include "PlusStub.cpp"
#include "../Math/Plus.h"
#include "../Math/Calculator.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace calc
{
	TEST_CLASS(CalculatorTest)
	{
	private:
		int nStartValue;
		Calculator* calc;

		void CreateCalcSUT()
		{
			calc = new Calculator(nStartValue);
		}

	public:
		/*testcase template:
		TEST_METHOD(Classname_Functionname_SpecialParams_ExpectedResult)
		{
		param specialParam = specialvalue;
		...
		param expectation = whatYouExpect;
		...
		(SUT creation)
		(call methods)
		...
		assert(s)
		}*/


		TEST_METHOD_INITIALIZE(InitialiseDefaults)
		{
			calc = NULL;
			nStartValue = 5;
		}

		TEST_METHOD_CLEANUP(CleanupObjects)
		{
			delete calc;
		}

		TEST_METHOD(Calculator_Constructor_NoArgument_GetValueZero)
		{
			int nExpectedValue = 0;
			calc = new Calculator();
			Assert::AreEqual(nExpectedValue, calc->GetValue());
		}

		TEST_METHOD(Calculator_Constructor_Five_GetValueFive)
		{
			nStartValue = 5;
			int nExpectedValue = 5;
			CreateCalcSUT();
			Assert::AreEqual(nExpectedValue, calc->GetValue());
		}

	};
}
```

<img style='' src='/img//code/c/testing/cppunittesting.png|'>

Zelfde manier om assertions te schrijven. 
:exclamation: dit test project heeft GEEN `/clr` flag, dus is ook __unmanaged__, dat is het voordeel. 

Zoals gezien op screencap is dit volledig geïntegreerd met VStudio 2012.

[Meer informatie over het nieuwe cpp testing framework 'Test Explorer'](http://msdn.microsoft.com/en-us/library/hh270864.aspx)