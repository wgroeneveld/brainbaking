---
title: Death to pseudocode?
date: '2018-04-06'
bigimg: /img/btrees.png
subtitle: Clean code, pseudocode or real code?
tags:
  - tech
  - java
  - functional programming
published: true
---

Coming across pseudocode isn't something that might happen every day except if you're used to browsing through the more theoretical and academic oriented "computer science" handbooks. We, the practical "software engineers" of nowadays, usually stop searching for something after our browser hits Stackoverflow. Stack is loaded with technical samples, gists of code, and lot's of won't-ever-compile-wrongly-copy-pasted code. Real code. If you're working in Java, you probably end up with articles full of Java snippets. 

That got me wondering. Why would one go into the trouble of putting together pseudocode to present to the reader? He or she has to make the translation into the language he or she is currently working with. Yes, it's obnoxious but it also gives everyone the opportunity to implement the example in their own language, whether it's functional or not. Does this positive outweigh the negative? It sometimes does not.

Consider for example a more theoretical example. In [Introduction to Algorithms](https://www.goodreads.com/book/show/108986.Introduction_to_Algorithms?ac=1), a proportion of the chapters is dedicated to different sorting algorithms. The following pseudocode describes the partitioning subroutine of quick sort:

    /**
     * partition list so that each element of A[p..q-1] <= A[q] <= A[q + 1 .. r]
     * x <- A[r]
     * i <- p - 1
     * for j <- p to r - 1
     *      do if A[j] <= x
     *          then i <- i + 1
     *              exchange A[i] with A[j]
     * exchange A[i + 1] with A[r]
     * return i + 1
     * @param list A
     * @param oneBasedStartIndex p
     * @param oneBasedEndIndex r
     * @return i + 1 (partition index)
     */

It's javadoc wrapped around the method `protected int partition(List<Integer> list, int oneBasedStartIndex, int oneBasedEndIndex) {`. I'd like to point out a few things about this pseudocode:

1. variable assignment (line 1, 2) is exactly the same as in real code.
2. The same applies for a loop, given you're not writing in Scala.
3. Then, we hit a roadblock. What does "exchange A[i] with A[j]" mean?

Then, it hit me. Real code should reflect pseudocode. Not only reflect it, but literally read like it. I'm thinking about clean code now, and [hiding the complexity in methods](/post/hiding-complexity/). Rob Cameron knows exactly what I mean, he calls hit "[Make Your Pseudocode Your Real Code](https://dev.to/cannikin/make-your-pseudocode-your-real-code-96n)". He shows a crystal clear example from some pseudocode in Ruby on Rails to his first effort in implementing it. But it doesn't stop there: with some clever method extractions, you can get pretty close to the original pseudocode. Human readable code. Ubiquitous. 

This is my implementation of the partition method:

```java
        int x = list.get(oneBasedEndIndex - 1);
        int i = oneBasedStartIndex - 1;

        for(int j = oneBasedStartIndex; j <= oneBasedEndIndex - 1; j++) {
            if(list.get(j - 1) <= x) {
                i++;
                Lists.exchangeIndexes(list, i, j);
            }
        }

        Lists.exchangeIndexes(list, i + 1, oneBasedEndIndex);
        return i + 1;
```

Instead of doing the swapping in 3 lines, two times repeated, they're simply hidden:

        int temp = list.get(oneBasedA - 1);
        list.set(oneBasedA - 1, list.get(oneBasedB - 1));
        list.set(oneBasedB - 1, temp);

Pseudocode makes it possible to understand what an algorithm should do, even in technical terms, closely related to real code. Without the clutter of your favorite language. "Exchange indexes" is still not the same as "exchange x with y". We're entering the realm of **Domain Specific Languages** (DSL) here. After sleeping over it for a few days, I refactored the above code to:

```java 
exchange(i).with(j).in(list);
```

What a difference. Exchange act as a [builder pattern](/post/builders-dsl) and wraps oneBasedA in a new class that gets mutated by oneBasedBy. The final act, `in(list)`, redirects to the actual implementation. 

At first, I wasn't really convinced, because it does require quite a bit of work to translate it into actual code - based on the target language. If a book like "introduction to algorithms" would present elementary algorithms in plain "old" Python, it would require students to have some knowledge of it. But then again, would that be a bad thing? That will reduce the overhead required to comprehend what's going on. 

I'm still not really fond of presenting pseudocode in an academic book. I want to focus on comprehension, not on syntax translation after I know what I have to do. I still often swear while trying out a certain algorithm in a textbook because one line of pseudocode contains so much **hidden assumptions**:

- You'd almost need to write mutable code, even if you don't want to.
- It's mostly not really suited for extreme object-oriented programming if it's not designed for that. That doesn't mean it's not possible, but simply that it's more work to do the translation. 
- It's mostly not really suited for functional programming if it's not designed for that. That doesn't mean it's not possible, but simply that it's more work to do the translation. 

On the other hand, I certainly agree with Rob: pseudocode is extremely useful to **make things clear**. For designing new parts together with colleagues, for rapid architecture design and for [talking to the duck](/post/serendipitous-creativity/). When it comes to **clear code**, there's nothing better than a shared understanding, independent of any programming language. Given you can translate any pseudocode to clear "pseudo/real" code, I'd rather come across something like that, where a part of the heavy language lifting has been done for me. 

What else can accompany pseudocode? Clear unit tests:

```java
    @Test
    public void bucketSort() {
        simpleTestCaseFor(new BucketSort());
    }

    @Test
    public void quickSort() {
        simpleTestCaseFor(new QuickSort());
    }

    @Test
    public void heapSort() {
        simpleTestCaseFor(new HeapSort());
    }

    @Test
    public void insertionSort() {
        simpleTestCaseFor(new InsertionSort());
    }

    private void simpleTestCaseFor(Sortable sorter) {
        List<Integer> result = sorter.sort(Arrays.asList(4, 2, 3, 1, 6, 5));

        Assertions.assertArrayEquals(Arrays.asList(1, 2, 3, 4, 5, 6).toArray(), result.toArray());
    }
```

What's missing? These are integration tests that verify the whole algorithm. For quicksort, the partitioning is a substantial part of the sorting process that deserves it's own test cases, tucked away in `QuickSortTest.java`:

```java
    @Test
    public void partition_accordingToR() {
        QuickSort sort = new QuickSort();
        List<Integer> toPartition = Arrays.asList(2, 8, 7, 1, 3, 5, 6, 4);
        List<Integer> partitioned = new ArrayList<>(toPartition);

        sort.partition(partitioned, 1, toPartition.size());

        Assertions.assertArrayEquals(partitioned.toArray(), Arrays.asList(2, 1, 3, 4, 7, 5, 6, 8).toArray());
    }
```

It's usually not that hard to extract unit tests from books like Introduction to Algorithms: they provide a lot of visual examples to clear up any misunderstandings. Each partitioning step of quicksort can be drawn separately using the current partitioned array so you can see what's going on with each instructive cycle. Simply use these examples: throw them in a test case and you're all set. 

And yet, a part of me wished for a deeper integration of unit testing and clear code as a blueprint to take on those nasty mathematical problems, instead of the separate (too) abstract pseudocodes of "subroutines" (That word alone says enough.) I've seen books like "growing object-oriented software guided by tests" and books like "introduction to the theory of computation", but I've yet to see a book that manages to combine theory with (clear code and) tests...