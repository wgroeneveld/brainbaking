---
title: 'Unit testing in Legacy Projects: VB6'
subtitle: 'Even older 4GL languages have unit testing capabilities'
date: '2016-12-27'
aliases:
    - /post/vb6-unit-testing/
tags: [ 'unit testing', 'VB6' ]
---

Thanks to the [Postmodern VB6](https://ihadthisideaonce.com/2015/05/13/postmodern-vb6-a-quick-start-with-simplyvbunit/) article I've found on the internetz, I decided to give [SimplyVBUnit](simplyvbunit.sourceforge.net) a try. My job requires sporadic visual basic 6 code changes in the big legacy project we're converting to C#. It's an administrative system bound to Belgium laws so as you can imagine they change every few months and the old software still has to be complaint to those crazy new rules. As a result, we sometimes dabble in VB6 code. It feels more like drowning, really. 

Unit testing is what keeps me from rage-quitting on every project. The SimplyVBUnit syntax is quite nice if you're used to writing NUnit tests: they also work with `Assert.That` for instance:

```vb
Public Sub MyTestMethod_WithSomeArg_ShouldReturn45
  Dim isType As Boolean
  isType = MyTestMethod(arg1)

  Assert.That isType, Iz.EqualTo(45)
End Sub
```

![simply vb unit screenshot](/img/simplyvbunit.png)


The test code is very readable thanks to the [NUnit](https://nunit.org/index.php?p=documentation) influence on SimplyVBUnit. The package is very easy to install, but there are a few gotcha's. 
You need to create a separate VBP file (Visual Basic Project) which acts as your UnitTest project with a reference to the SimplyVBUnit package. That's easy enough, but it's a project. That means it can't reference other projects! Our software is basically one large project with heaps of muddy code. Compiling the EXE and referencing that one is not an option for us. That leaves us with a few alternatives:

- Package the test runner and the dependency in your production code. (Hmmm...)
- Create a DLL project and move the test code to the DLL. This requires another build step in our already-too-long-manual-deployment procedure. Nope.
- Create a group (vbg), include both projects, and include modules/forms/class modules to be tested in the unit test project as an existing file. This means both projects will include the same source files. SourceSafe actually notices this if you have a file checked out and will ask you to update the "other" file in the second project. 

The group makes it possible to open everything at once. Unit tests live in a subfolder. This is our vbg file:

```
VBGROUP 5.0
Project=program.vbp
StartupProject=UnitTests\UnitTests.vbp
```

Utilizing two projects in one group means switching between both as a startup project. One could use the group to develop and start tests but the vbps for debugging or so. It's all still fairly new for us so we'll see where this will end. 
Unit tests are useless if they aren't run (automatically). At this moment we try to avoid coding anything in VB6 at all. If we do, we run the tests manually. At least some parts of the code are tested without bootstrapping the whole application and plowing through various forms to get to the part where you actually changed something... 

