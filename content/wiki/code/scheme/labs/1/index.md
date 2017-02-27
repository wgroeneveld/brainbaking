+++
title = "home"
draft = false
tags = [
    "code",
    "scheme",
    "labs",
    "1",
    "home"
]
date = "2013-03-12"
+++
# Labs: Chapter 1 

#### Section 1 

##### 1.1 

```scheme
(define (- a b)
  (+ a b))

(- 4 3)

(define (een-of-twee een twee)
  (if (= een 1)
      een
      twee))

(define bla
  (een-of-twee 3 5))

(een-of-twee 2 3)

(define a 6)
(define b (+ 3 3))
(= a b)

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))

```

##### 1.2 

```scheme
(+ 5 (+ 4 (- 2 (- 3 (+ 6 4/5)))))
```

##### 1.3 

```scheme
(define (sq a)
  (* a a))

(define (sum-sq a b)
  (+ (sq a) (sq b)))

(define (sum-sq-largest a b c)
  (if (> b c)
      (sum-sq a b)
      (sum-sq a c)))

(define (sum-squares-two-largest a b c)
  (if (> a b)
      (sum-sq-largest a b c)
      (sum-sq-largest b a c)))
```

##### 1.3: tests 

```scheme
(load "./test-manager/load.scm")
(load "./ex_1_003.scm")

(in-test-group sum-squares-two-largest
 (define-test (last-two-largest)
   (assert-equals (sum-squares-two-largest 1 2 3) 13))
 (define-test (first-two-largest)
   (assert-equals (sum-squares-two-largest 3 2 1) 13))
 (define-test (first-and-last-largest)
   (assert-equals (sum-squares-two-largest 3 1 2) 13))
 (define-test (all-zeros)
   (assert-equals (sum-squares-two-largest 0 0 0) 0)))

(run-registered-tests)
```

##### 1.5 

**Oefening:**

```scheme
(define (p) (p))

(define (test x y)
 (if (= x 0)
     0
	 y))
	 
(test 0 (p))
```

Hoe wordt dit door de interpreter geëvalueerd in applicative-order evaluation? 

(evaluate the arguments and then apply)
`(test 0 (p))` ######> `(if ( 0 0) 0 (p))` ######> 0 aangezien `( 0 0)` naar true evalueert en bijgevolg dus (p) nooit geëvalueerd wordt! 

Hoe wordt dit door de interpreter geëvalueerd in normal-order evaluation? 

(fully expand and then reduce)
`(test 0 (p))` ######> `(if ( 0 0) 0 (p))` ######> `(if ( 0 0) 0 (p))` => ... (oneindige lus, constant (p) vervangen door implementatie die zelf (p) is)

##### 1.6 

```scheme
#|

wat loopt er mis nu ->
(define (sqrt-iter guess x)
  (cond
   ((good-enough? guess x) guess)
   (sqrt-iter (improve guess x) x)))

opnieuw invullen:
(define (sqrt-iter guess x)
  (cond
   ((good-enough? guess x) guess)
   (cond
    ((good-enough? guess x) guess)
    (sqrt-iter...

Bouwt zo een oneindige lus met condition en terug sqrt-iter...

|#

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
		 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (new-if clause iftrue iffalse)
  (cond (clause iftrue)
	(else iffalse)))

(sqrt 2)
```

##### 1.7 

```scheme
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

; de square van een klein getal is kleiner! 0.01x0.01 = 0.001 wat al in bovenstaande conditie staat
; dit wil zeggen dat good-enough heel snel true gaat retourneren, zodat onze square root definitie stopt
; met berekenen. 

; de wortel van een groot getal kan nooit accuraat genoeg zijn omdat we stoppen op 0.001 na de komma.
; daardoor stopt good-enough? ook weer te vroeg. we hebben dus een andere implementatie nodig. 


(define (sqrt-iter guess x)
  (if (good-enough? guess x)
  guess
  (sqrt-iter (improve guess x) x)))

(define (better-sqrt-iter guess previous-guess x)
  (if (better-enough? guess previous-guess)
      guess
      (better-sqrt-iter (improve guess x) guess x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (better-enough? guess previous-guess)
  (and (not (= guess previous-guess))
  (< (/ (abs (- guess previous-guess)) previous-guess) 0.00001)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (better-sqrt x)
  (better-sqrt-iter 1.0 1.0 x))

(better-sqrt 23945890000)
(sqrt 23945890000)
```

##### 1.8 

```scheme
(define (cube-iter guess x)
  (if (good-enough? guess x)
  guess
  (cube-iter (improve guess x) x)))

(define (cube x)
  (* x x x))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x)) 0.001))

(define (improve guess x)
  (display " improve ")
  (display guess)
  (display " - ")
  (display x)
  (/ (+ (/ x (square guess))
	(* 2 guess))
     3))

(define (cube-root x)
  (cube-iter 1.0 x))

(cube-root 16)
```

##### 1.9 


**eerste + define**

```
(define (+ a b)
  (if (= a 0)
   b
   (inc (+ (dec a) b))))

(+ 4 5) ######> (if ( 4 0) 5 (inc (+ (dec 4) 5))) 
		######> (if ( 4 0) 5 (inc ((if (= (dec 4) 0) 5 (inc (+ (dec (dec 4)) 5))))))
		######> (if ( 4 0) 5 (inc ((if (###### (dec 4) 0) 5 (inc ((if ( (dec (dec 4)) 0) 5 (inc (+ (dec (dec (dec 4))) 5)))))))))
		=> .. (wordt altijd maar langer, en dan op een bepaald moment minder, dus dit is duidelijk liniair recursief
```
   
**tweede + define**

```
(define (+ a b)
  (if (= a 0)
   b
   (+ (dec a) (inc b))))
   
(+ 4 5) ######> (if ( 4 0) 5 (+ (dec 4) (inc b)))
		######> (if ( 4 0) 5 ((if (= (dec 4) 0) (inc b) (+ (dec (dec 4)) (inc (inc b))))))
		######> (if ( 4 0) 5 ((if (###### (dec 4) 0) (inc b) ((if ( (dec (dec 4)) 0) (inc (inc b)) (+ (dec (dec 4)) (inc (inc b))))))))
		=> .. Hetzelfde dus. 
```

##### 1.10 

Algoritme:

```scheme
(define (A x y)
  (cond ((= y 0) 0)
		((= x 0) (* 2 y))
		((= y 1) 2)
		(else (A (- x 1)
			(A x (- y 1))))))

(A 2 4)
```


Oplossen met variabelen:
			
**#1: (A 1 10)**

```
  (cond ((= 10 0) 0)
		((= 1 0) (* 2 10))
		((= 10 1) 2)
		(else (A (- 1 1)
			(A 1 (- 10 1))))))

		=> (A 0 (A 1 9))
waarbij (A 1 9) = 

  (cond ((= 9 0) 0)
		((= 1 0) (* 2 9))
		((= 9 1) 2)
		(else (A (- 1 1)
			(A 1 (- 9 1))))))
		=> (A 0 (A 1 8) etc

waarbij (A 1 1) = 2
		
dus (A 1 10) = (A 0 (A 1 9))
			 = (A 0 (A 0 (A 1 8)))
			 = ...
			 = (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 1))))))))))
			 = (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 2)))))))))
			 = (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 4))))))))
			 = (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 8)))))))
			 = (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 16))))))
			 = (A 0 (A 0 (A 0 (A 0 (A 0 32)))))
			 = (A 0 (A 0 (A 0 (A 0 64))))
			 = (A 0 (A 0 (A 0 128)))
			 = (A 0 (A 0 (A 0 128)))
			 = (A 0 (A 0 256))
			 = (A 0 512)
			 = 1024
```

mathematische definities:

```
fn ###### (A 0 n)  2n
gn ###### (A 1 n)  2^n
```

##### 1.10: tests 

```scheme
(load "./test-manager/load.scm")
(load "./ex_1_010.scm")

(in-test-group ackermann
 (define-test (a-1-10)
   (assert-equals (A 1 10) 1024)))

(run-registered-tests) 
```

##### 1.11 

```scheme
; f(n) = n if n < 3
; f(n) ###### f(n - 1) + 2f(n - 2) + 3f(n - 3) if n > 3
; write a program that defines f recursively and iteratively

(define (fn n)
  (cond
   ((< n 3) n)
   (else (+ (+ (fn (- n 1)) (* 2 (fn (- n 2)))) (* 3 (fn (- n 3)))))
   ))

(define (fn-it n)
  (define (fn-it-loop fn1 fn2 fn3 count)
    (if (= count n)
    fn3
    (fn-it-loop (+ fn1 (* 2 fn2) (* 3 fn3))
		fn1
		fn2
		(+ count 1))))
  (fn-it-loop 2 1 0 0))

(load "./test-manager/load.scm")

; this should be refactored into passing the function as a pointer
; and only calling all assertions once...
; todo after the tests pass!

(in-test-group
 fn-functie
 (define (define-tests-fn fnfunc)
   (define-each-test
     (check (= (fnfunc 0) 0) "fn0<3 should be 0"))
   (define-each-test
     (check (= (fnfunc 2) 2) "fn2<3 should be 2"))
   (define-each-test
     (check (= (fnfunc 3) 4) "fn3 should be 4"))
   (define-each-test
     (check (= (fnfunc 4) 11) "fn4 should be 11"))
   (define-each-test
     (assert-equals (fnfunc 5) 25))
   (define-each-test
     (assert-equals (fnfunc 0) 0)))
 (define-tests-fn fn)
 (define-tests-fn fn-it))

(run-registered-tests)
```

##### 1.12 

```scheme

(define (pascal entry row)
  (cond ((= 0 entry) 0)
	((and (###### 0 row) ( 1 entry)) 1)
	((= 0 row) 0)
	(else (+ (pascal (- entry 1) (- row 1)) (pascal entry (- row 1))))))


(load "./test-manager/load.scm")

(in-test-group
 pascal
 (define-test (first-row-is-one)
   (assert-equals (pascal 1 0) 1))
 (define-test (zero-entry-is-always-zero)
   (assert-equals (pascal 0 234) 0)
   (assert-equals (pascal 0 23) 0)
   (assert-equals (pascal 0 0) 0))
 (define-test (pascal-row1)
   (assert-equals (pascal 1 1) 1)
   (assert-equals (pascal 2 1) 1))
 (define-test (pascal-row2)
   (assert-equals (pascal 1 2) 1)
   (assert-equals (pascal 2 2) 2)
   (assert-equals (pascal 3 2) 1))
 (define-test (pascal-row4)
   (assert-equals (pascal 1 4) 1)
   (assert-equals (pascal 2 4) 4)
   (assert-equals (pascal 3 4) 6)
   (assert-equals (pascal 4 4) 4)
   (assert-equals (pascal 5 4) 1))
 (define-test (pascal-row3)
   (assert-equals (pascal 1 3) 1)
   (assert-equals (pascal 2 3) 3)
   (assert-equals (pascal 3 3) 3)
   (assert-equals (pascal 4 3) 1)))
	       
(run-registered-tests)
```

##### 1.14 

```

(count-change 11)
-----------------

= (cc 11 5) (amount, kinds-of-coins)
= (+ (cc 11 4) (cc -39 5))
###### (+ (+ (cc 11 3) (cc -14 4)) 0) > amount < 0? altijd 0 vanaf nu
= (+ (cc 11 2) (cc 1 3))
= (+ (+ (cc 11 1) (cc 6 2)) (cc 1 2))
= ... 
Opgezet in boom vorm:

cc(11, 5)
    |
   11,4
    |
   11,3
    |
   1,3    --    11,2
    |             | 
   0,2 			 6,2     --     11,1
				  | 			 |
				1,2  --  6,1	11,0    --  10,1
											 |
											10,0   --  9,1
														|
														9,0    --  8,1
																    |
																	8,0 -- 7,1
...
```
voor `cc(x, 1)` worden er telkens 2 branches gemaakt waarvan er 1 aftakt: `cc(x-1, 1)` en `cc(x, 0) = 0`
voor `cc(x, 5)` wordt er naar rechts afgetakt voor elke "kind of coin": op 2 en 1 

Dus de recusie diepte is O(n) aangezien voor een hoger getal er één extra branch aangemaakt wordt. 
Het geheugengebruik (space) hangt af van de kind of coins parameter. O(n^kinds-of-coins)

##### 1.15 

```
(sine 12.15)
= (p (sine 4.05))
= (p (p (sine (1.35))))
= (p (p (p (sine (0.45)))))
= (p (p (p (p (sine (0.15))))))
= (p (p (p (p (p (sine (0.05)))))))
```

Stopconditie gaat af, laatste sine = 0.05 zelf. P werd dus 5x uitgevoerd.

Om de tijdscomplexiteit te berekenen, proberen we eens met een groter getal:
  1. (sine 100) -> 7x sine uitvoeren
  1. (sine 255555) -> 12x sine uitvoeren
Het aantal stappen neemt bijna niet toe maar is wel proportioneel aan a zelf. 

Aangezien we altijd delen door 3, en stoppen indien < 0.01, wordt het probleem voor extreem grote getallen nog snel opgelost. Dus:<br/><br/>
######> **`O(a)  3log(a)`**

Gegeven dat de cube en p functies in tijd en geheugen een complexiteit van O(1) hebben. <br/><br/>
(Geen recursie, altijd dezelfde calls en geheugengebruik voor eender welke input n)

##### 1.16 

```scheme
; ab^n = cte
; (b^n/2)^2 = (b^2)^n/2 en de originele formule:
; b^n = (b^n/2)^2 indien n even
; b^n = b*b^n-1   indien n oneven

(define (exp b n)
  (define (even? n)
    (= (remainder n 2) 0))

  (define (exp-it b n a)
    (display "exp it ")
    (display b)
    (display " ")
    (display n)
    (display " ")
    (display a)
    (newline)
    (cond
     ((= n 0) a)
     ((even? n)
      (exp-it (square b) (/ n 2) a))
     (else (exp-it b (- n 1) (* b a)))))
	    
  (exp-it b n 1))


(load "./test-manager/load.scm")

(in-test-group
 fast-exp
 (define-test (exp-of-something-zero-is-one)
   (assert-equals (exp 103 0) 1))
 (define-test (exp-of-ten-to-one-is-ten)
   (assert-equals (exp 10 1) 10))
 (define-test (exp-random-numbers)
   (assert-equals (exp 4 3) 64)
   (assert-equals (exp 10 2) 100)
   (assert-equals (exp 3 6) 729)))

(run-registered-tests)
```

##### 1.17 

```scheme
(define (slow-multi a b)
  (if (= b 0)
      0
      (+ a (slow-multi a (- b 1)))))

(define (double a)
  (* a 2))
(define (halve a)
  (/ a 2))

(define (multi a b)
  (cond
   ((= b 0) 0)
   ((even? b) (double (multi a (halve b))))
   (else (+ a (multi a (- b 1))))))


(load "./test-manager/load.scm")

(in-test-group
 fast-multiplications
 (define-test (boundary-conditions)
   (assert-equals (multi 45 0) 0)
   (assert-equals (multi 45 1) 45))
 (define-test (simple-multiplications)
   (assert-equals (multi 2 2) 4)
   (assert-equals (multi 3 4) 12)
   (assert-equals (multi 10 5) 50)))

(run-registered-tests)
```

##### 1.18 
```scheme
(define (stack . args)
  (display args)
  (newline))

(define (multi a b)

  (define (double a)
    (* a 2))
  (define (halve a)
    (/ a 2))

  (define (multi-it a b product)
    (stack "multi-it" a b product)  
    (cond
     ((= b 0) product)
     ((even? b) (multi-it (double a) (halve b) product))
     (else (multi-it a (- b 1) (+ a product)))))

  (multi-it a b 0))

(load "./test-manager/load.scm")

(in-test-group
 multi
 (define-test (checking-them-bounds-dawg)
   (assert-equals (multi 2 0) 0)
   (assert-equals (multi 2 1) 2))
 (define-test (checking-them-simple-numbers-yo)
   (assert-equals (multi 2 2) 4)
   (assert-equals (multi 5 10) 50)
   (assert-equals (multi 3 4) 12)))

(run-registered-tests)
```