---
title: 'Labo 5: Weg met C, Hallo C++'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++ met Qt](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## Dingen die opvallen: wel in C++, niet in C

- `bool`
- los van `std::string` (bovenop `char`) en `std::wstring` (bovenop `wchar_t`), Extra Integral types:
  - `wchar_t`, `char16_t`, `char32_t`
- [Zelf te definiëren operaties](https://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B):
  - [scope resolutie](https://en.wikipedia.org/wiki/Scope_resolution_operator) `::` en namespaces
  - `<<`, `>>` bitshifts, of "streams" zoals in C++ 
- `class` en alles wat daar mee te maken heeft
  - `new`, `delete`
- `nullptr` in plaats van `NULL` vanaf C++11

## Classes in C++

### Terug naar de isOud opgave, maar dan in C++

Het is tijd om `malloc()` en `struct` achterwege te laten:

```C++
#include <iostream>

class Persoon {
private:
    int leeftijd;
public:
    Persoon(int leeftijd);
    bool isOud() const { 
        std::cout << "checking leeftijd van persoon " << leeftijd << std::endl;
        return leeftijd > 60;
    }
    int getLeeftijd() const { return leeftijd; }
};

Persoon::Persoon(int leeftijd) {
    this->leeftijd = leeftijd;
} 

int main() {
    auto jaak = new Persoon(70);
    std::cout << "is jaak oud? " << jaak->isOud() << std::endl;
}
```

Dat ziet er al heel wat properder uit:

- We hebben een constructor gebruikt om een persoon aan te maken met leeftijd, zoals we kennen vanuit Java. De `this` pointer verwijst naar de huidige instance van de klasse.
- We hebben methodes (inline) gedeclareerd in de klasse Persoon.
- Jaak aanmaken hoeft geen type definitie als `Persoon *` met C++11's `auto` keyword. Leer auto goed kennen en gebruiken: [overtuig jezelf](http://www.acodersjourney.com/2016/02/c-11-auto/)!

## De C++ Standard Library

De Standard Template Library [STL](https://en.wikipedia.org/wiki/Standard_Template_Library) is een bibliotheek die meegeleverd wordt bij de meeste moderne C++ compilers. Deze implementeert de nieuwe standaarden, zoals C++11. Compilers vragen soms wel een flag om te kiezen met welke library er gelinkt wordt: `g++ -std=c++11`.

STL bevat een hoop dingen die je het leven makkelijker maakt: strings (gek genoeg nog steeds geen deel van de taal zelf), collecties, streams, IO, ... Bekijk het als de .NET library voor de C# taal of de meegebakken `java.*` klassen en methodes voor Java. "Part II: The C++ Library (p. 307)" behandelt deze zaken in het handboek. 

Includes van STL worden zonder ".h" gedaan: `#include <iosteram>`. Laat het maar aan de compiler over om de systeembestanden te zoeken tijdens het linken. 

## Smart pointers in C++11

https://en.wikipedia.org/wiki/Smart_pointer#unique_ptr