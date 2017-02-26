+++
title = "reflectie"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "ruby",
    "reflectie"
]
date = "2014-03-11"
+++
# Metaprogrammeren: Ruby Reflectie 

### Methods accessen 

Dit kan op twee manieren: op een object **instance** of op een **class**, met `.method` of `.static_method`, zie [Ruby Method doc](http://www.ruby-doc.org/core-2.1.1/Method.html).

```ruby
1.method(:+).call 2 # output: 3
Fixnum.static_method(:+).bind(1).call 2 # output: 3
1.method("+").unbind().bind(1).call(2) # output: 3
```

Object Methods zijn al gebind en kan je dus losmaken van hun reference indien gewenst - zelfde effect als de `static_method` call. Je kan blijkbaar zowel een string als een ref meegeven om de naam van de method te resolven.

##### Ik wil meer 

`1.methods.each{|x| puts x}`

of `.static_methods` natuurlijk. Enkel public of protected, ook van subklassen.