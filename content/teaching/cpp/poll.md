---
title: 'Poll: Ben ik klaar voor mijn examen?'
accent: "#008eb3"
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>

Ga naar [pollev.com/woutergroene532](pollev.com/woutergroene532) om mee te doen. De mogelijke antwoorden zijn voor elke snippet hetzelfde:

1. Compileert **NIET**.
2. Compileert, maar runtime **ERROR**.
3. Runt, maar **ONGEWENST** gedrag.
4. **WERKT** zoals verwacht.

Includes en namespaces worden buiten beschouwing gelaten.

#### Snippet 1

<pre>
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

#### Snippet 2

<pre>
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


#### Snippet 3

<pre>
void maths(int* x) {
    x++;
}
int main() {
    int one = 0;
    maths(one);
    return one == 1;
}
</pre>

#### Snippet 4

<pre>
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

#### Snippet 5

<pre>
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

#### Snippet 6

<pre>
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

#### Snippet 7

<pre>
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

#### Snippet 8

<pre>
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

#### Snippet 9

<pre>
int main() {
    int hoeveel = 0;
    scanf("%d", hoeveel);
    printf("echt zoveel? %d\n", hoeveel);
}
</pre>

#### Snippet 10

<pre>
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

