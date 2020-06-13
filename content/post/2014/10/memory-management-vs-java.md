---
title: .NET Memory management VS JVM Memory management
date: '2014-10-24'
aliases:
    - /post/memory-management-vs-java/
subtitle: Increasing your maximum heap size in .NET? Tough luck.
categories:
    - programming
tags: [ 'memory management', 'CLR', '.NET', 'JVM' ]
---
Memory management is something to keep in mind when deploying and running applications on top of the JVM. Parameters like `Xmx` and `Xms` are things to juggle with when it comes to finding the perfect balance between too much memory hogging (at app startup) and too little, especially if you're working with heavy duty entity mapping frameworks like Hibernate (and you're not so good at writing fast HQL). 
When we bumped into an `OutOfMemoryException` in .NET, I got an Xmx flashback and started searching on how to do the same with the CLR. 

Turns out you can't. 

You can't set max heap size in .Net unless you host the CLR yourself in a process. ([source](http://stackoverflow.com/questions/301393/can-i-and-do-i-ever-want-to-set-the-maximum-heap-size-in-net))
To control the memory allocations of CLR including the max heap size, you need to use the hosting api to host the clr and specifically use the "Memory manager interfaces", some starter info can be found here [MSDN Magazine, column CLR Inside Out : CLR Hosting APIs](http://msdn.microsoft.com/en-us/magazine/cc163567.aspx)

The heap does indeed keep growing until it can't grow any more. (Obviously this is "after attempting to recover memory through GC, grow the heap".) Basically there isn't nearly as much tuning available in the .NET GC as in Java. You can choose the server GC or the client one, and I think there's an option for turning on/off the concurrent GC (I'll find links in a minute) but that's basically it.

See also: 
  - [Choosing the right garbage collector for your .NET Application](http://www.atalasoft.com/cs/blogs/rickm/archive/2008/05/14/choosing-the-right-garbage-collector-settings-for-your-application-net-memory-management-part-4.aspx)
