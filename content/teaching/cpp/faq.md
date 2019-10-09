---
title: 'FAQ'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Neem ook eens een kijkje bij de [Installatieinstructies!](/teaching/cpp/installaties)

### MinGW installatie problemen

#### Error RES Fout op Win omgevingen

Zie ook [https://sourceforge.net/p/mingw-w64/bugs/413/](https://sourceforge.net/p/mingw-w64/bugs/413/) - 'oplossing' is een aantal keer hetzelfde bestand opnieuw te proberen downloaden & installeren. Antivirus die moeilijk doet kan ook een probleem zijn. 

### Problemen met build omgevingen

#### SH.exe was found in your path

Fout:

<pre>
sh.exe was found in your PATH, here:
C:/Program Files/Git/user/bin/sh.exe
For MinGW make to work correctly sh.exe must NOT be in your path.
</pre>

Oorzaak: je Cygwin `/bin` folder zit in de `PATH` omgevingsvariabele, terwijl je MinGW gebruikt als compilatieomgeving. Verwijder de Cygwin bin folder. Zie [Installatieinstructies](/teaching/cpp/installaties). 

#### Cygheap base mismatch detected

Fout:

<pre>
  2 [main] git 2004 C:/cygwin/lib/git-core/git.exe *** fatal error - cygheap base mismatch detected - 0x61242860/0x6123790.
This problem is probably due to using incompatible versions of the cygwin DLL.
Search fro cygwin1.dll using the WIndows Start->Find/Search facility and delete all bu the most recent version.  The most recent version *should* reside in x:\cygwin\bin, where 'x' is the drive on which you have installed the cygwin distrubtion. Rebooting is also suggested if you are unable to find another cygwin DLL.  
</pre>

Oorzaak: je werkt met verschillende Cygwin-like omgevingen die niet compatibel zijn met elkaar. Bijvoorbeeld Cmder.exe en Cygwin, of CLion en Cmder en Cygwin, of zelfs WAMP Server. Elke omgeving komt met een eigen `cygwin1.dll` bestand. 

Oplossingen:

1. Een van de omgevingen deïnstalleren.
2. Switch naar MinGW in plaats van Cygwin (zie [Installatieinstructies](/teaching/cpp/installaties)).
3. Zoek in de Verkenner naar de DLL en verwijder degene die niet gebruikt worden.

### Het project builden

#### Zeer veel Google Test fouten bij het linken

Fout:

<pre>
[100%] Linking CXX executable flyingstuff.elf
cd /d C:\Development\github\gba-sprite-engine\cmake-build-debug\demos\demo1-basicfeatures && "C:\Program Files\JetBrains\CLion 2018.2.1\bin\cmake\win\bin\cmake.exe" -E cmake_link_script CMakeFiles\flyingstuff.elf.dir\link.txt --verbose=1
CMakeFiles/unittest.dir/gbatest.cpp.obj: In function `GBASuite_AssertionWorks_Test::TestBody()':
C:/Development/github/gba-sprite-engine/test/gbatest.cpp:15: undefined reference to `testing::internal::GetBoolAssertionFailureMessage[abi:cxx11](testing::AssertionResult const&, char const*, char const*, char const*)'
CMakeFiles/unittest.dir/spritetest.cpp.obj: In function `SpriteSuite_CollidesWith_B_Right_Of_A_Does_Not_Collide_Test::TestBody()':
C:/Development/github/gba-sprite-engine/test/spritetest.cpp:227: undefined reference to `testing::internal::GetBoolAssertionFailureMessage[abi:cxx11](testing::AssertionResult const&, char const*, char const*, char const*)'
CMakeFiles/unittest.dir/spritetest.cpp.obj: In function `SpriteSuite_CollidesWith_B_Half_In_A_On_X_Axis_Collides_Test::TestBody()':
C:/Development/github/gba-sprite-engine/test/spritetest.cpp:234: undefined reference to `testing::internal::GetBoolAssertionFailureMessage[abi:cxx11](testing::AssertionResult const&, char const*, char const*, char const*)'
CMakeFiles/unittest.dir/spritetest.cpp.obj: In function `testing::AssertionResult testing::internal::CmpHelperEQFailure<int, unsigned int>(char const*, char const*, int const&, unsigned int const&)':
C:/Development/github/googletest/googletest/include/gtest/gtest.h:1435: undefined reference to `testing::internal::EqFailure(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, bool)'
CMakeFiles/unittest.dir/scenetest.cpp.obj: In function `testing::AssertionResult testing::internal::CmpHelperEQFailure<int, unsigned long long>(char const*, char const*, int const&, unsigned long long const&)':
C:/Development/github/googletest/googletest/include/gtest/gtest.h:1435: undefined reference to `testing::internal::EqFailure(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, bool)'
CMakeFiles/unittest.dir/allocatortest.cpp.obj: In function `AllocatorSuite_Allocate_Sprite_Pointers_Reservers_Some_Tile_Space_Test::TestBody()':
C:/Development/github/gba-sprite-engine/test/allocatortest.cpp:79: undefined reference to `testing::internal::GetBoolAssertionFailureMessage[abi:cxx11](testing::AssertionResult const&, char const*, char const*, char const*)'
</pre>

Oorzaak: je Google Test libraries zijn gecompileerd met **een andere Toolchain** dan waar je het project mee probeert te compileren! Cygwin VS MinGW problemen. 

Oplossing: compileer Google Test opnieuw in dezelfde Toolchain - bijvoorbeeld in MinGW. Ga naar `gooletest\googletest\build`, verwijder alle bestaande bestanden met `rm -rf *` en volg opnieuw de [Installatieinstructies](/teaching/cpp/installaties). 

#### No rule to make target ligbtest.a needed by test/unittest. Stop.

Fout:

<pre>

mingw32-make.exe[2]: *** No rule to make target 'C:\Development\github\googletest\googletest/build/libgtest.a', needed by 'test/unittest'.  Stop.
mingw32-make.exe[1]: *** [CMakeFiles\Makefile2:148: test/CMakeFiles/unittest.dir/all] Error 2
mingw32-make.exe[1]: *** Waiting for unfinished jobs....
mingw32-make.exe[2]: Entering directory 'C:/Development/github/gba-sprite-engine/cmake-build-debug'
mingw32-make.exe[2]: Leaving directory 'C:/Development/github/gba-sprite-engine/cmake-build-debug'
mingw32-make.exe: *** [Makefile:132: all] Error 2
</pre>

Oorzaken:

1. Je hebt Google Test nog niet gecompileerd
2. Je `GTEST_DIR` omgevingsvariabele staat niet naar de juiste Google Test submap
3. `libgtest.a` en `libgtest_main.a` zitten niet in de build subfolder van de Google Test map


#### CMake: Check for working C++ compiler: broken

Fout:

<pre>
C:\Users\11401165\.CLion2018.2\system\cygwin_cmake\bin\cmake.exe -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=C:/devkitPro/devkitARM/bin/arm-none-eabi-gcc.exe -DCMAKE_CXX_COMPILER=C:/devkitPro/devkitARM/bin/arm-none-eabi-g++.exe -G "CodeBlocks - Unix Makefiles" /cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master
-- The CXX compiler identification is GNU 8.1.0
-- Check for working CXX compiler: /cygdrive/c/devkitPro/devkitARM/bin/arm-none-eabi-g++.exe
-- Check for working CXX compiler: /cygdrive/c/devkitPro/devkitARM/bin/arm-none-eabi-g++.exe -- broken
CMake Error at /cygdrive/c/Users/11401165/.CLion2018.2/system/cygwin_cmake/share/cmake-3.12.2/Modules/CMakeTestCXXCompiler.cmake:45 (message):
  The C++ compiler
 
    "/cygdrive/c/devkitPro/devkitARM/bin/arm-none-eabi-g++.exe"
 
  is not able to compile a simple test program.
 
  It fails with the following output:
 
    Change Dir: /cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master/cmake-build-debug/CMakeFiles/CMakeTmp
    Run Build Command:"/usr/bin/make.exe" "cmTC_a9bf5/fast"
    /usr/bin/make -f CMakeFiles/cmTC_a9bf5.dir/build.make CMakeFiles/cmTC_a9bf5.dir/build
    make[1]: Entering directory '/cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master/cmake-build-debug/CMakeFiles/CMakeTmp'
    Building CXX object CMakeFiles/cmTC_a9bf5.dir/testCXXCompiler.cxx.obj
    /cygdrive/c/devkitPro/devkitARM/bin/arm-none-eabi-g++.exe    -Wno-narrowing    -std=gnu++11 -o CMakeFiles/cmTC_a9bf5.dir/testCXXCompiler.cxx.obj -c /cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master/cmake-build-debug/CMakeFiles/CMakeTmp/testCXXCompiler.cxx
    arm-none-eabi-g++.exe: error: /cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master/cmake-build-debug/CMakeFiles/CMakeTmp/testCXXCompiler.cxx: No such file or directory
    arm-none-eabi-g++.exe: fatal error: no input files
    compilation terminated.
    make[1]: *** [CMakeFiles/cmTC_a9bf5.dir/build.make:66: CMakeFiles/cmTC_a9bf5.dir/testCXXCompiler.cxx.obj] Error 1
    make[1]: Leaving directory '/cygdrive/c/Users/11401165/Desktop/gba-sprite-engine-master/gba-sprite-engine-master/cmake-build-debug/CMakeFiles/CMakeTmp'
    make: *** [Makefile:121: cmTC_a9bf5/fast] Error 2
</pre>

Het probleem is dat je **Cygwin** gebruikt op een Windows omgeving met een cross-compiler als `arm-none-eabi-g++`. De cross-compiler kan geen UNIX pad interpreteren, zoals `/cygdrive/c/Users/11401165`, maar wel `C:\Users\11401165`. Bijgevolg worden bestanden om te compileren niet gevonden.

De oplossing is switchen van De Cygwin naar de MinGW omgeving. Lees hier meer over in [de installatieinstructies](/teaching/cpp/installaties).

#### CMake: The C++ compiler is not able to compile a simple test program

Fout:

<pre>
-- The CXX compiler identification is GNU 8.1.0
-- Check for working CXX compiler: C:/Development/devkitpro/devkitARM/bin/arm-none-eabi-gcc.exe
CMake Error: Generator: execution of make failed. Make command was: "nmake" "/nologo" "cmTC_e5080\fast"   
The C++ Compiler

"C:/Development/devkitpro/devkitARM/bin/arm-none-eabi-gcc.exe"

is not able to compile a simple test program.
</pre>

Herkenbaar aan: **nmake** keyword. Probleem? CMake wilt `nmake` gebruiken, de Visual Studio variant, niet `make`. Oplossing: start het commando met `cmake ./../ -G "Unix Makefiles"` of voeg `SET(CMAKE_GENERATOR "Unix Makefiles")` toe aan je CMakeLists.txt. 