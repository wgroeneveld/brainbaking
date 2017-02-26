+++
title = "classes"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "ruby",
    "classes"
]
date = "2014-03-11"
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