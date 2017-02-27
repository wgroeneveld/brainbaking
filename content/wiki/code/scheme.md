+++
title = "scheme"
draft = false
tags = [
    "code",
    "scheme"
]
date = "2013-03-12"
+++
# code >> Scheme 

:exclamation: **Exercices** [chapter 1]({{< relref "wiki/code/scheme/labs/1/index.md" >}})

<img style='' src='/img/indexmenu>code/scheme|js'>

### Variable arguments 

Bron: http://www.cs.utexas.edu/ftp/garbage/cs345/schintro-v14/schintro_68.html

```scheme
(define (stack . args)
  (display args))

(define (plus a b)
  (stack a b)
  (+ a b))
  
(plus 1 2)
```

Print in een lijst `(1 2)` af. In scheme is het mogelijk om args op te splitsen, alles dat na de "." komt, wordt samengenomen als een lijst in een speciale variabele die de rest van de argumenten binnen pakt. Je kan dus ook x aantal argumenten "vast" zetten en de rest laten opvangen door een lijst. `display` print alles in lijst vorm af. 

### Conditional Expressions and Predicates 

##### Debugging purposes 

  * `(display arg)` print argument in de `*scheme*` buffer af. (pakt een **lijst** binnen: bvb `(display '("bezig met afdrukken van " arg1 arg2))`
  * `(newline)` maakt een nieuwe lijn in diezelfde buffer.

##### de 'undefined' variabele 

Een conditional operator die door alle gevallen heen valt (zoals een switch zonder default), retourneert de variabele **unspecific**. Dit is een reserved keyword:

```scheme
(load "./test-manager/load.scm")

(in-test-group conditionals
 (define x 0)
 (define-test (case-fall-through-returns-undefined)
   (assert-equals unspecific
		  (cond ((< x 0) 1)
			((> x 0) 1)))
   ))

(run-registered-tests)
```

Het is niet mogelijk om die variabele te overschrijven met `(define unspecific 8934)`, volgende fout wordt dan gegenereerd: "Premature reference to reserved name: unspecific."

### Implementaties 

:exclamation: Shortucts voor Emacs geïntegreerd in MIT-Scheme: zie [code/scheme/edwin-shortcuts]({{< relref "wiki/code/scheme/edwin-shortcuts.md" >}})

  * MIT-Scheme: http://www.gnu.org/s/mit-scheme/ -> ingebouwde emacs evaluator
  * Racket: http://racket-lang.org/

### Testen schrijven 

Testing framework: Zie http://web.mit.edu/~axch/www/testing-1.2.html

Inladen test-manager & testen definen en kunnen wrappen in elkaar à-la Jasmine in JS:

```scheme
(load "./test-manager/load.scm")

(in-test-group my-first-tests

  (in-test-group getallekes
    
	 (define-test (add-simple-numbers)
	   (assert-equals (my-add 1 2) 3)))
	   
	(in-test-group meer-getallekes
	 (define-test (add-more-complex-numbers)
	   (assert-equals (my-add 3 7) 10))))

(run-registered-tests)
```

Achteraf altijd **`run-registered-tests`** evalueren, in de default scheme editor wordt dan de test output getoond. (Default editor = **scheme***, gewoon enter drukken bij open doen nieuwe editor)