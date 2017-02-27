+++
title = "preprocessing"
draft = false
tags = [
    "code",
    "c",
    "preprocessing"
]
date = "2013-12-02"
+++
# Preprocessing 

## Handige macro's 

##### Exception/Debug informatie expanden 

```c++
#define _ERROR_STR2(a) #a
#define _ERROR_STR(a) _ERROR_STR2(a)
#define ERROR_INFO(fn) _T(_ERROR_STR(__FILE__" line: "__LINE__" function: "fn))
```

Te gebruiken als `someFn(ERROR_INFO("bla"))`. Merk op dat `__FUNCTION__` of `__FUNC__` ook gebruikt kan worden, afhankelijk van de C++ compiler, maar dit is geen deel van de standaard (vanaf C++ v11).

De `#a` notatie wordt gebruikt om iets te [stringifyen](http://gcc.gnu.org/onlinedocs/cpp/Stringification.html) in de preprocessor, vandaar de delegate:

> Sometimes you may want to convert a macro argument into a string constant. Parameters are not replaced inside string constants, but you can use the ‘#’ preprocessing operator instead. When a macro parameter is used with a leading ‘#’, the preprocessor replaces it with the literal text of the actual argument, converted to a string constant. Unlike normal parameter replacement, the argument is not macro-expanded first. This is called stringification.