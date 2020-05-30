+++
title = "Ruby Class structures basics"
subtitle = "A look at ruby's lambda's"
draft = false
archived = true
tags = [
    "ruby",
    "classes"
]
date = "2013-10-01"
+++
# Ruby Classes 

### Closures and lambda's 

Weer 4 verschillende mogelijkheden in Ruby, zie [Proc and Lambda in Ruby](http://techspry.com/ruby_and_rails/proc-and-lambda-in-ruby/)

##### Native "blocks" aanmaken 

Is niet mogelijk. `a = { puts "hello" }` geeft een Syntax error; dit moet effectief met `Proc.new` gebeuren.

##### Lambdas aanmaken 

Kan ook weer op twee manieren:

```ruby
a = lambda { puts "hello" }
b = -> { puts "hello" }
```

##### Blocks als argumenten doorgeven 

Wordt slechts één aanvaard, `Proc`s zijn objecten en kan dus op eender welke manier. Een block is eerder deel van de taal als syntax. (zoals bij `do`)

##### Een lambda is een Proc 

Met twee grote verschillen (zie [What is the difference between a block, a proc and a lambda in ruby?](http://awaxman11.github.io/blog/2013/08/05/what-is-the-difference-between-a-block/)):

  1. een `lambda` controleert argumenten, een `Proc` kan het niet schelen. 
  2. een `return` statement in een `lambda` stopt slechts de closure. In een `Proc` stopt het de hele enclosing method :exclamation:

```ruby
def proc_test
  proc = Proc.new { return }
  proc.call
  puts "Hello world"
end

proc_test                 # calling proc_test prints nothing
```

### Class methods 

Zie [Class and instance methods in Ruby](http://www.railstips.org/blog/archives/2009/05/11/class-and-instance-methods-in-ruby/). Er zijn verschillende manieren om een class method te maken in ruby:

```ruby
# Way 1
class Foo
  def self.bar
    puts 'class method'
  end
end

Foo.bar # "class method"

# Way 2
class Foo
  class << self
    def bar
      puts 'class method'
    end
  end
end

Foo.bar # "class method"

# Way 3
class Foo; end
def Foo.bar
  puts 'class method'
end

Foo.bar # "class method"
```

Instance methods worden met `def name` gedefiniëerd, zoals men intuïtief zou aannemen (wow).


### "Reflectie": Methods accessen 

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