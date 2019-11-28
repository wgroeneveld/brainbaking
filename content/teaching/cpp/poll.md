---
title: 'Poll: Ben ik klaar voor mijn examen?'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Ga naar [pollev.com/woutergroene532](https://pollev.com/woutergroene532) om mee te doen. De mogelijke antwoorden zijn voor elke snippet hetzelfde:

1. Compileert **NIET**. (Fouten bij `gcc` commando)
2. Compileert, maar runtime **ERROR**. (Fouten bij uitvoeren: segfaults e.d.)
3. Runt, maar **ONGEWENST** gedrag. (Geen fouten maar bugs in gedrag)
4. **WERKT** zoals verwacht.

Includes en namespaces worden buiten beschouwing gelaten.

Klik op de snippet headers om de snippet te tonen.

#### Snippet 1

<pre class="snip snip1">
class Student;

class Teacher {
private:
    std::vector&lt;Student*&gt; students;
public:
    Teacher() {
        students.push_back(new Student());
    }
};
</pre>

Antwoord: **Compile fout**; forward definition van `Student` klasse kan, maar `new()` niet.

#### Snippet 2

<pre class="snip snip2">
class Student;

class Teacher {
private:
    std::vector&lt;Student*&gt; students;
public:
    Teacher() {
        students.push_back(NULL);
    }
};
</pre>

Antwoord: **Werkt**. `NULL` toevoegen werkt omdat het een pointer naar 'niets' is.

#### Snippet 3

<pre class="snip snip3">
void maths(int* x) {
    x++;
}
int main() {
    int one = 0;
    maths(&one);
    return one == 1;
}
</pre>

Antwoord: **Onverwacht gedrag**. `x++` verhoogt het adres van de pointer, niet de eigenlijke waarde: we moeten hier nog _dereferencen_.

#### Snippet 4

<pre class="snip snip4">
void swap(int* x, int* y) {
    int z = *x;
    *x = *y;
    *y = z;
}
int main() {
    int two = 1, one = 2;
    swap(&one, &two);
}
</pre>

Antwoord: **Werkt**. Tekstboek voorbeeld van waardes swappen.

#### Snippet 5

<pre class="snip snip5">
class X {
public:
    int i;
    X(int i) : i(i) {}
};

bool setToOne(const X& x) {
    x.i = 1;
    return x.i == 1;
}
int main() {
    X x(2);
    std::cout << setToOne(x);
}
</pre>

Antwoord: **Compile fout**. `const` betekent dat de waarde van x niet kan wijzigen, dus `x.i = 1` geeft een fout.

#### Snippet 6

<pre class="snip snip6">
struct dinges {
    void* x;
    void* y;
};
int main() {
    int *a;
    dinges iets = { (void*) a, (void*) a };
    delete a;
    std::cout << iets.x;
}    
</pre>

Antwoord: **Runtime error**. Na de `delete` de pointer 'volgen' geeft (onverwachte) problemen. 

#### Snippet 7

<pre class="snip snip7">
template&lt;typename T&gt; class Punt {
  private:
   T x, y;
  public:
   Punt(T theX, T theY) : x(theX), y(theY) {}
};
int main() {
    Punt&lt;double&gt; pt(1.2, 3.4);
    Punt&lt;int&gt; pt2(3, 5);
}    
</pre>

Antwoord: **Werkt**. Een voorbeeld template klasse. 

#### Snippet 8

<pre class="snip snip8">
// in punt.h
template&lt;typename T&gt; class Punt {
private:
    T x, y;
public:
  Punt(T theX, T theY);
  T getX() { return x; };
};

// in punt.cpp
Punt&lt;T&gt;::Punt(T theX, T theY) : x(theX), y(theY) {
}
int main() {
    Punt&lt;int&gt; x(1, 2);
    std::cout << x.getX();
}
</pre>

Antwoord: **Compile fout**. `T` herhalen in punt.cpp vereist opnieuw de definitie van de template: `template<typename T>`.

#### Snippet 9

<pre class="snip snip9">
int main() {
    int hoeveel = 0;
    scanf("%d", hoeveel);
    printf("echt zoveel? %d\n", hoeveel);
}
</pre>

Antwoord: **Runtime error**. `scanf()` verwacht een correct adres, niet de waarde 0, dat buiten het bereik van het programma valt. 

#### Snippet 10

<pre class="snip snip10">
class Inception {};
int main() {
    vector&lt;Inception**&gt; *v;
    Inception *x = new Inception();
    v = new vector&lt;Inception**&gt;();

    Inception** y = new Inception*[10];
    y[1] = x;
    v->push_back(y);
}
</pre>

Antwoord: **Werkt**. Dubbele pointers zijn Arrays van pointers. Vectoren van dubbele pointers zijn tweedimensionele arrays. 
