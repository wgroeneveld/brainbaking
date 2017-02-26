---
title: Code Sample
subtitle: Using Pygments or Highlight.js
date: 2016-03-08
---

The following are two code samples using syntax highlighting.

<!--more-->

The following is a code sample using the "highlight" shortcode provided in Hugo. This is server side highlighting and requires Python and Pygments to be installed.

{{< highlight javascript >}}
    var num1, num2, sum
    num1 = prompt("Enter first number")
    num2 = prompt("Enter second number")
    sum = parseInt(num1) + parseInt(num2) // "+" means "add"
    alert("Sum = " + sum)  // "+" means combine into a string
{{</ highlight >}}


The following is a code sample using triple backticks ( ``` ) code fencing provided in Hugo. This is client side highlighting and does not require any special installation.

```javascript
    var num1, num2, sum
    num1 = prompt("Enter first number")
    num2 = prompt("Enter second number")
    sum = parseInt(num1) + parseInt(num2) // "+" means "add"
    alert("Sum = " + sum)  // "+" means combine into a string
```