---
title: Domain Driven Design in C
bigimg: Faking domain logic.jpg
date: '2018-08-03'
aliases:
  - /post/domain-driven-design-in-c/
subtitle: Who says imperative languages don't do DDD?
tags: ['domain driven design', 'C', 'C++' ]
published: true
---

As old as the language C may be, it took other languages a long time to catch up with something as mundane as a pointer. Pointers are the bread and butter of any C program and are widely regarded as a horrifying thing to work with. It might be a drag and require some plumbing (as with any language) but the payoff is extreme flexibility and control. 

An address can point to anything - that includes functions. Function pointers are mostly used as callbacks but in combination with structures, they become dynamic class members! That might be a little bit exaggerated.

Let's take a look at simple concepts: a person has a certain age. 

{{<mermaid>}}
graph LR;
    A{Person}
    B[Age]
    C[Is Old?]
    A --> B
    A -.-> C
{{< /mermaid >}}

I can ask the person if he's old, and depending on the age the response will be yes (`true`) or no (`false`). Sounds almost too simple to implement in an object-oriented language like C#:

```C#
class Person {
    public Person(int age) { this.Age = age; }
    public int Age { get; private set; }
    public bool IsOld => Age > 60;
}
Person george = new Person(65);
Debug.WriteLine(george.IsOld);      // true
```

Thinking about the `class` concept in OO nets you the `struct` concept in C that will hold the age field nicely, but problems arise when we try to tackle the `Is Old?` piece of the domain model:

```C
struct Person {
    int age;
}
int is_old(Person* p) {
    return p->age > 60;
}
typedef struct Person Person;
Person* george = malloc(sizeof(Person));
george->age = 65;
prinf("%d", is_old(george));        // 1
```

A couple of remarks:

1. C has no `bool`. 
2. If you want to use your structure as a class, `typedef` is pretty much required.
3. This introduces a memory leak if you don't `free(george)`.

And of course, our main concern is the absence of any link between `struct Person` and `int is_old`. If the function is defined in a random header, the programmer has to remember it's location and it's name. It only sounds logical that it should be an integral part of the structure.

And it shall be - function pointers to the rescue!

```C
struct Person {
    int age;
    int (*is_old)();
}
```

That makes expressions as `george->is_old()` legal, but they won't be bind to anything. The pointer doesn't point to anything and we can't define the function within the structure. It needs to be **defined** somewhere else, and **rewired** to the pointer:

```C
struct Person {
    int age;
    int (*is_old)();
}
int person_is_old(Person* p) {
    return p->age > 60;
}
typedef struct Person Person;
Person* george = malloc(sizeof(Person));
george->is_old = &person_is_old;
george->age = 65;
prinf("%d", is_old(george));        // 1
```

Isn't that beautiful? 

It's rather cumbersome indeed, because the creation of a new person requires you to manually wire up the function to the function pointer of the struct instance and that hurts - a lot. That's the price to pay for emulating member functions on structures as classes... 

Our last cleanup action would be to group every person-related thing into `person.h` and `person.c`, and lastly create a nice factory method for allocation of a new person:

```C
Person* newPerson(int age) {
    Person* p = malloc(sizeof(Person));
    p->age = age;
    p->is_old = &person_is_old;
    return p;
}
```

### What about C++?

Are you wondering what the ++ in C++ might stand for? The addition of "real" classes is a revelation to old-time C programmers that tried aiming for readability in a "domain"[^2]. The above example implemented in C++ is trivial:

```C
class Person {
private:
  int age;
public:
  Person(int age) : age(age) {}
  bool isOld() { return age > 60 ? true : false; }
};
```

The `isOld` member function of Person is a one-liner that can be an `inline` function - if it's defined within the class definition structure that usually lives in the header file. Otherwise; `bool Person::isOld() {}` has to be present in some cpp source file. 

### But... C's function pointer is _dynamic_!

That's right! That means it's much more than an emulated member function of a structure. You can rewire it at any time - it works just like a callback. Of course that is clearly not what we want here. Also notice the complete lack of any accessor modifiers in C: any function can fuck up our passed Person:

```C
void haxx(Person* p) {
    p->is_old = 0;   // whoops
}
```

Fixed using C's pass-by-value system by leaving out the pointer `*` in the argument list. But you really don't want to do that with a structure as copying something like that requires quite a bit of memory overhead and beats the whole purpose of using C in the first place... 

Remember Java fan-boys, we had to wait until Java 8 in 2014 for the language to catch up with C using lambda's. Take a look at what function pointers are really for:

```C
int addOne(int g) { return g + 1; }
int multiplyTwo(int g) { return g * 2; }

int main() {
    int (*op)(int) = &addOne;
    printf("%d", op(5));  // prints 6
    return 0;
}
```

Can you imagine doing that in Java 7? With anonymous inner classes and a lot of interface clumsiness, maybe. It's a much less worse now with v8's lambda's and the new function reference operator `::`:

```Java
class Stuff {
  private static int addOne(int g) { return g + 1; }
  private static int multiplyTwo(int g) { return g * 2; }

  public static void main(String[] args) {
    Function<Integer, Integer> op = Stuff::addOne;
    System.out.println(op.apply(5) + ""); // prints 6
  }
}
```

That leaves us to conclude that if you're still writing C on some embedded hardware, don't forget that it is possible to group functions using structures but requires some plumbing that you may or may not like. 

The C++ language is continually evolving while the ANSI C standard is "done"[^1] - the C++11 standard eased a lot of the mystical syntax pain. So if you can migrate from `gcc` to `g++`, I don't see why not. 

[^1]: Well, not completely, [C11](https://en.wikipedia.org/wiki/ANSI_C#C11) introduced an cross-platform multi-threading API.
[^2]: DDD practices can't be implemented without proper use of an object model - within that context I'm calling that "domain" driven.