---
title: Bye autotools hello Scons 
bigimg: /img/Bye autotools hello Scons.jpg
date: '2014-03-26'
subtitle: Building C++ projects with Scons
tags: [ 'C++', 'python', 'build ecosystem' ]
---

Remember this? 

   - `./configure`
   - `make`
   - `make install`

That's not so bad, as long as you have the right compiler and linker flags configured, depending on the target OS. The real problem, however, is trying to figure out how to alter something if you didn't write the `Makefile` yourself. Or if you in fact did write it, but it was some time ago. Two days. No, four hours. 

### The problem

Try to study the autoconf and automake flow diagram, explained [on Wikipedia: the GNU build system](http://en.wikipedia.org/wiki/GNU_build_system). Headache coming up? Suppose we would like to use these ... uhm, "thingies", for a simple C++ project. 

First, let me define simple:

  - It has some (shared) library dependencies
  - The source lives in `src`
  - Since it's obviously written the TDD way, the tests live in `test`

Onward, to the `Makefile` creation station! 
This is a sample file, from the [Google Test Makefile](https://code.google.com/p/googletest/source/browse/trunk/make/Makefile):

	GTEST_DIR = ..

	USER_DIR = ../samples

	CPPFLAGS += -isystem $(GTEST_DIR)/include
	CXXFLAGS += -g -Wall -Wextra -pthread

	TESTS = sample1_unittest
	GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
	                $(GTEST_DIR)/include/gtest/internal/*.h

	all : $(TESTS)

	clean :
		rm -f $(TESTS) gtest.a gtest_main.a *.o

	GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)
	gtest-all.o : $(GTEST_SRCS_)
		$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	            $(GTEST_DIR)/src/gtest-all.cc

	gtest_main.o : $(GTEST_SRCS_)
		$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	            $(GTEST_DIR)/src/gtest_main.cc

	gtest.a : gtest-all.o
		$(AR) $(ARFLAGS) $@ $^

	gtest_main.a : gtest-all.o gtest_main.o
		$(AR) $(ARFLAGS) $@ $^

	sample1.o : $(USER_DIR)/sample1.cc $(USER_DIR)/sample1.h $(GTEST_HEADERS)
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/sample1.cc

	sample1_unittest.o : $(USER_DIR)/sample1_unittest.cc \
	                     $(USER_DIR)/sample1.h $(GTEST_HEADERS)
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/sample1_unittest.cc

	sample1_unittest : sample1.o sample1_unittest.o gtest_main.a
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

This first builds the gtest_main.a binary, to be able to link that with our test after the source (sample1.o) has been is built. The syntax is clumsy, simple files require me to have a deep knowledge how flags and linking work, and I don't want to specify everything in one block. 

As esr in his blog post [Scons is full of win today](http://esr.ibiblio.org/?p=3089) said, it's a maintenance nightmare. What to do? 

There are a few alternatives which aim to cover everything autotools does, such as `QMake` from Trolltech or `CMake` (that actually generates Makefiles. You're not helping, CMake!). Or, one could go for [Scons](http://scons.org/).

### build your software, better.

Scons starts with a single `SConstruct` file, which acts as the makefile. You can bootstrap the default build target using the `scons` command. (cleaning with `scons --clean`). The big deal here is that the contents of that file is simply python (2.7, I know)!

Want to write a utility function to gather all your `cpp` files? Fine, go ahead, `def mystuff():` (you do know this already exists, right? Use `Glob()`) Want to unit test these, and include them? Done. Want to split up everything per source directory? Use `SConscript` files and include these from within your root `SConstruct` using `SConscript('file', 'envVarToExport')`.

This is my blueprint construct file:

	env = Environment(CXX = 'g++')

	gtest = env.SConscript('lib/gtest/SConscript', 'env')
	src = env.SConscript('src/SConscript', 'env')
	out = env.SConscript('test/SConscript', 'env gtest src')

	# output is an array with path to built binaries. We only built one file - run it (includes gtest_main).
	test = Command( target = "testoutput",
	                source = str(out[0]),
	                action = str(out[0]) )
	AlwaysBuild(test)

Things to note:

  - Scons works with [Environments](http://www.scons.org/doc/2.3.1/HTML/scons-user.html#chap-environments) which can be shared and cloned (see below)
  - You can share variables with the second parameter
  - Executing after a build also works, passing in the result of conscripts.
  - Ensure to always build your test with `AlwaysBuild()`

This is the conscript which builds google test:

	Import('env')
	env = env.Clone(CPPPATH = './:./include')

	env.Append(CXXFLAGS = ['-g', '-Wall', '-Wextra', '-pthread'])
	gtest = env.Library(target = 'gtest', source = ['src/gtest-all.cc', 'src/gtest_main.cc'])

	Return('gtest')

Things to note:

  - Fetch the shared variables with `Import()` and return stuff with `Return()` (it's a function)
  - specify flags all you want. 
  - Building something? `Program()`, `Library()` or `SharedLibrary()`.

Source:

	Import('env')
	env = env.Clone(CPPPATH = './')
	src = env.Library(target = 'wizards', source = Glob('*.cc'))

	Return('src')

Things to note:

  - `Glob()` auto-reads all files in the current dir. 

And finally, test, linking both source and google test:

	Import('env', 'gtest', 'src')
	env = env.Clone()

	env.Append(LIBPATH = ['#lib/gtest', '#src'])
	env.Append(LIBS = [gtest, src])
	out = env.Program(target = 'wizards_unittests', source = Glob('*.cc'))

	Return('out')

Things to note:

  - Use the hashtag `#` to point to the root dir where the `SConstruct` file resides.
  - Linking is as simple as providing `LIBS` and the right path.

So where does that leave us? Yes there's still "syntax" to be learned, even if you're a seasoned python developer; you need to know which function to use for what, that's what the excellent [scons doc](http://www.scons.org/doc/2.3.1/HTML/scons-user.html) is for. I know it made my life a lot easier while trying to do something simple and this is only the tip of the iceberg. Scons is relatively popular according to Stack Overflow, the documentation is excellent and if all else fails you can write your own garbage in a full-fledged dynamic language.

The only really irritating bit is the python 2.7 dependency, so don't forget to use [virtualenv](https://pypi.python.org/pypi/virtualenv).

# In practice

The section below contains practical snippets used by myself in some point in the past, commented in Dutch. Feel free to grab a piece. 

  1. [SCons Wiki Frontpage](http://www.scons.org/wiki/FrontPage)
  2. [Single HTML Manpage](http://www.scons.org/doc/HTML/scons-man.html#lbAF)
  3. [SCons Construction Variables](http://www.scons.org/doc/0.96.90/HTML/scons-user/a3061.html) om bvb de compiler te specifiëren. 

### Opsplitsen SConstruct en SConscript 

Waarom? http://www.scons.org/doc/2.1.0/HTML/scons-user/c3356.html

Build output definiëren, duplicate source files, etc. Voorbeeld `SConstruct` file:

```python
SConscript('SConscript', variant_dir######'build', duplicate0)
```

Voorbeeld file om Google Test mee te (proberen) builden `SConscript`:

```python
def Glob( pattern ###### '*.*', dir  '.' ):
    import os, fnmatch
    files = []
    for file in os.listdir( Dir(dir).srcnode().abspath ):
        if fnmatch.fnmatch(file, pattern) :
            files.append( os.path.join( dir, file ) )
    return files

# construction variables: http://www.scons.org/doc/0.96.90/HTML/scons-user/a3061.html
env ###### Environment(CXX  'g++',
                                    CPPPATH = '../:./include')

# add to library search path env.Append(LIBPATH = ['/usr/local/lib/'])
# add to libraries link path env.Append(LIBS = ['SDL_image','GL'])

env.Append(CPPFLAGS = ['-isystem ./include'])
env.Append(CXXFLAGS = ['-g', '-Wall', '-Wextra', '-pthread'])

env.SharedLibrary(target ###### 'gtest_main.dll', source  ['../src/gtest-all.cc'])

# after that, we should link with gtest_main
```

Poging tot converteren van deze voorbeeld `Makefile` - supplied bij de gtest sources:

```
# A sample Makefile for building Google Test and using it in user
# tests.  Please tweak it to suit your environment and project.  You
# may want to move it to your project's root directory.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR = ..

# Where to find user code.
USER_DIR = ../samples

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS = sample1_unittest

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h <br/>
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : $(TESTS)

clean :
    rm -f $(TESTS) gtest.a gtest_main.a *.o

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
gtest-all.o : $(GTEST_SRCS_)
    $(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c <br/>
            $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
    $(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c <br/>
            $(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
    $(AR) $(ARFLAGS) $@ $^

gtest_main.a : gtest-all.o gtest_main.o
    $(AR) $(ARFLAGS) $@ $^

# Builds a sample test.  A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.

sample1.o : $(USER_DIR)/sample1.cc $(USER_DIR)/sample1.h $(GTEST_HEADERS)
    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/sample1.cc

sample1_unittest.o : $(USER_DIR)/sample1_unittest.cc <br/>
                     $(USER_DIR)/sample1.h $(GTEST_HEADERS)
    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/sample1_unittest.cc

sample1_unittest : sample1.o sample1_unittest.o gtest_main.a
    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@
```
