Software ontwerp in C/C++: #2
=============================

<img src="/img/kul.svg" style="height: 80px;" />
<img src="/img/uhasselt.svg" style="width: 165px; height: 80px;"/>

---

## Wat is een "pointer"?

<img src="/slides/cpp/img/pointer.jpg" width="40%" />

Euhm...

___

#### Het "Sterretje" en de "Ampersand"

```C
int jong = 10;
int oud = 80;
int *leeftijd = &jong;
leeftijd = &oud;
```

<div class="mermaid" align="center" >
graph LR;
    A[*leeftijd] -->|na regel 3| B[jong<br/>10]
    A --> |na regel 4| C[oud<br/>80]
</div>    

___

### Reference types

`int &geslacht = other_variable;`

* Verwijst naar hetzelfde adres in geheugen
* Andere naam voor zelfde variabele
* Constante!

```C
int other_variable = 11;
int &geslacht = other_variable;
other_variable = 10;
// waarde van geslacht?
```

___

### Pointer types 

`char *string = "bla blie";`

* Verwijst naar dynamisch geheugen, **muteerbaar**
* `string++` = volgend gealloceerde `char`
* Geheugenadres op stack, variabele op heap

___

### Pointers naar pointers naar ...

```C
int val = 5;
int* ptr = val;          // compiler error
int* ptr = &val;         // ok
int** ptr_to_ptr = ptr;  // compiler error
int** ptr_to_ptr = &ptr; // ok
```

<img src="/slides/cpp/img/we-need-to-go-deeper.jpg"/>

---

## Werken met pointers

___

### Waarde uit pointer halen

= "**Dereferencen**" van pointer:

```C
int val = 5;
int* ptr = &val;
printf("%d\n", ptr);  // 345847647? WTF
printf("%d\n", *ptr); // 5
```

Raw value = rechstreeks geheugenadres!

___

### Address-of VS reference type

* `int *int_ptr = &other_int;` = get address of
* `int &int_ref = other_int;` = declare reference of

___

### Arrays VS Pointers

```C
char string[10] = "sup";
void print(char* s) { // hoe? geen []!
  printf("%s", s);
}
```

* Array = veredelde pointer, vaste hoeveelheid geheugen
* Arrays doorgeven in functies = auto-pointer

Hint: <br/>
"`char string[]`" in C,<br/>
"`char[] string`" in Java 

___

### Voorbeeld: string afdrukken

```C
void print(char* string) {
  char* curr;
  for(curr = string; *curr != '\0'; curr++) {
    printf("%c", *curr);
  }
}
print("hey");
```

<div class="mermaid" align="center" >
graph LR;
    Z{string}
    Y{curr}
    A['h']
    B['e']
    C['y']
    D['\0']
    Y --> Z
    Z -.-> A
    Y -.-> |na 1x|B
    Y -.-> |na 2x|C
    Y -.-> |na 3x|D
    A --> B
    B --> C
    C --> D
</div> 

___

## Voorbeeld: snel swappen

```C
void swap(int *px, int *py) {
    int temp;
    temp = *px;
    *px = *py;
    *py = temp;
}
int x = 10, y = 20;
swap(&x, &y);
```

Onmogelijk in Java:

```Java
int x = 10, y = 20;
int temp = x;   // can't do this in method
x = y;
y = temp;
```

Waarom? 

1. Snelheid
2. Geheugen besparen

---

## C's pass-by-value systeem

```C
struct SomeClass { }; // geen Classes, remember
typedef struct SomeClass SomeClass;
void call_me_with(SomeClass someClass) {
  printf("%d\n", &someClass);
}
SomeClass instance;
call_me_with(instance); // oops! struct copied?
```

___

## Java's pass-by-reference systeem

```Java
void callMeWith(SomeClass someClass) {
  System.out.println(System.identityHashCode(someClass));
}
SomeClass instance = new SomeClass(5);
callMeWith(instance); // in method: ptr to instance
```

Verrassing, object refs zijn pointers!

___

## There, I fixed it

```C
struct SomeClass { };
typedef struct SomeClass SomeClass;
void call_me_with(SomeClass* someClass) { // use pointer
  printf("%d\n", someClass);
}
SomeClass instance;
call_me_with(&instance); // send address instead
```

---

## Lambda's in C? Al van 1972!

Met **functie pointers** natuurlijk.

```C
int verhoog(int getal) { return getal + 1; }

int main() {
    int (*op)(int) = &verhoog;
    printf("%d", op(5));  // prints 6
}
```

___

### In Java meer "moeite":

```Java
class Stuff {
  private static int verhoog(int getal) { return getal + 1; }

  public static void main(String[] args) {
    Function<Integer, Integer> op = Stuff::verhoog;
    System.out.println(op.apply(5) + ""); // prints 6
  }
}
```

Pas vanaf Java 8 (2014!)

--- 

## Gebruik van keyword "new"

* Auto-allocates geheugen.
* Gebruik `->` als `(*var).` vervanger

```C
struct SomeStruct {
  int x;
};
typedef struct SomeStruct SomeStruct;
SomeStruct instance = new SomeStruct();
instance-> x = 5;
```
___

### Maar... With great power... 

Geheugen gebruikt? **Zelf opkuisen**!

```C
void some_function() {
  SomeStruct instance = new SomeStruct();
}
// oeps: memory leak! geen manier meer om te verwijderen
```

`delete instance;`

Java heeft **garbage collection**, C/C++ niet.

---

## C++11: dynamische pointers

- `std::unique_ptr`
- `std::shared_ptr`
- e.a.

Beheert het geheugen voor u:

```C
void someFunction() {
  auto instance = std::unique_ptr<SomeStruct>(new SomeStruct());
}
// ok: destructor van unique_ptr kuist mijn new op
```

___

### Wanneer in C++ new gebruiken?

Zo **weinig mogelijk**!<br/>
 Altijd proberen references ipv pointers te gebruiken:

```C
void passSomeRef(SomeStruct& struct) {
  struct.doSuff();
}
int main() {
  SomeStruct struct;    // op de stack in main
  passSomeRef(struct);  // pass-by-ref, geen kopie, ok
}
```

VS

```C
void passSomePtr(SomeStruct* struct) {
  struct->doSuff();
}
int main() {
  auto struct = std::unique_ptr<SomeStruct>(new SomeStruct());
  passSomeRef(struct.get());  // pass-by-pointer ref, geen kopie, ok
}
```

---

<!-- .slide: data-background="#008eb3" -->
## Oef... Iets geleerd?

> "_Zijt maar zeker_" - student X
