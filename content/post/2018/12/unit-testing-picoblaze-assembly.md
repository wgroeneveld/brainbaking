---
title: Unit Testing PicoBlaze Assembly files
bigimg: Unit Testing Stored Procedures.jpg
date: '2018-12-05'
aliases:
  - /post/unit-testing-picoblaze-assembly/
subtitle: Writing Psm Assembly test-first, because why wouldn't you?
categories:
  - programming
tags: [ 'unit testing', 'assembly', 'picoblaze']
---

To continue our [unit testing tradition](/tags/unit-testing/), each time I land on a new language or piece of technology, I carefully assess whether it's possible to write tests first. Unsurprisingly, even in Assembly it's possible. My recent foray into the digital electronics world has let me to write instructions for the [Xilinx PicoBlaze](https://www.xilinx.com/products/intellectual-property/picoblaze.html) 6 FPGA microcontroller. This Assembly dialect, written in "Psm(4)" files, is destined for a different architecture. That means linking and leaning on Google Test using C++ isn't possible. 

As any good software developer does, I decided to reinvent the wheel and create an [Open PicoBlaze Assembler Unit Test package](https://github.com/wgroeneveld/opbtest) myself, written in Python 3. It uses the open `opbasm` and `opbsim` cross-platform assembler and simulator to compile your written Assembly, and then leverages Python's `unittest` package to execute assertions. Take a look at the [github repository](https://github.com/wgroeneveld/opbtest) README file an in-depth technical background. 

Say, I write a procedure that adds two registers and stores it in a third. This procedure lives in a `.psm4` file, together with a bunch of other procedures. What if I want to test only that "method"? 

> **What are the basic needs of a unit test framework?**

As a developer, I want to be able to:

1. test a single method, individually, separate from the rest of the source.
2. test an entire file, as an integration test. 
2. stub/mock out methods I am currently not interested in.
3. assert state after execution. (registers, input, output)
4. set up state before execution. (registers, input, output)

The problem with Assembly is, there's no such thing as a "method", except blocks separated by jumps and labels. For instance:

```llvm
jump main
proc add_registers(s0 is one, s1 is two, s5 is result) {
  load result, 0
  loop1:
    add result, 1
    sub one, 1
    jump NZ, loop1
  loop2:
    add result, 1
    sub two, 1
    jump NZ, loop2
}
main:
  ; this should not be executed
  load s5, 42
```

I used M4 Macro extensions on a PicoBlaze 6 board. The `proc` macro gets expanded to labels in a `.gen.psm` file using `opbasm`. What if I only want to test the `add_registers` "method"? Below the main label, the result register (`s5`) gets loaded with `42` (hex). 

This will be my Python 3 test case for the above Assembly:

```python
from opbtest import OpbTestCase

class MyTestCase(OpbTestCase):
    def test_add_registers_counts_reg1_and_reg2_into_reg3(self):
        assert_that = self.load_file("functions.psm4")\
            .testproc("add_registers")\
            .setregs({"s0": 1, "s1": 2})\
            .execute()
        assert_that.reg("s5").contains(3)
```

Tested a single method? Check. <br/>
Setup registers before execution? Check.<br/>
Assert state after execution? Check.

As you can see, I've been inspired by other well-known C#/Javascript frameworks that are able to chain setup calls together. The actual assertion(s) are separate to emphasize the typical **given-when-then** behavioral scenario in "modern" testing frameworks. 

Assertions like `reg`, `scratchpad`, `port` verify the correct end state of your Assembly file. Seeing a red or green test in your favorite IDE or in the console is a _huge_ improvement over this:

![](../picoblaze_sim.png "Simulating hardware in a testbench")

Inspecting a wave form after simulating your hardware configuration in tools like Vivado is a huge pain compared to writing separate test cases in software. I know the Test Bench tooling can be used to write test for your synthesis, but when uploading a bitstream into an FPGA, you never know whether it's the HDL that's incorrect, or the Assembly loaded into it. 

My `opbtest` package comes with one serious downside (more of a disguised upside): it requires you to write your tests in another language, namely Python 3. I am aware of possibilities like embedded Assembly testing [such as this](http://blog.code-cop.org/2015/08/how-to-unit-test-assembly.html), but it's implementation lacks the ability to mock out statements I don't want to evaluate. 

For instance, if you use a generated PRNG using the M4 macro, somewhere a `call random` generates a random 8-bit value into a register. Randomness is difficult to test, so is typically "frozen" in test setup. `opbtest` makes that very easy: `.replace("call random", "load s0, s0")`. It uses string manipulation to scan the source file, modify the needed lines, and then recompile & evaluate it with `opbasm` and `opbsim`. `testproc()` uses the same trick: inject a `jump [methodname]` at the beginning, inject a `jump [programend]` at the end of the proc. 

Another advantage of using Python is, surprise, readability - at least compared to your Assembly to test! It's also non-intrusive: you don't need to modify your source code or include other files. And it's easily integrated into your CI build using `python -m unittest`. 

If you have a feature request, want to contribute, or report a bug, feel free to [open up a new issue](https://github.com/wgroeneveld/opbtest/issues) on Github! As we'll continue to use the package, I'll be sure to make changes here and there. 
