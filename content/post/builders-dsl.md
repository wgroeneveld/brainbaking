---
title: Enhancing the builder pattern with closures
date: '2013-11-14'
bigimg: /img/Enhancing the builder pattern with closures.jpg
subtitle: the trainwreck/builder/chaining pattern can be dangerous and here's why
tags:
  - closures
  - groovy
  - 'C#'
  - javascript
  - java
  - functional programming
published: true
---

This post is inspired by Venkat Subramaniam's [Devoxx 2013 talk Thinking Functional Style](http://www.devoxx.be/dv13-venkat-subramaniam.html). See downloads at [agiledeveloper.com](http://www.agiledeveloper.com/downloads.html) which has a rather cool Groovy example. 

### Classic builders

For years, I've been using the builder pattern to quickly create new objects to be inserted into the database or to inject our domain objects with the required data. We started with so called "Object Mothers", static methods which simply create and fill up an object, passing in a huge amount of parameters. That quickly became very cumbersome to work with. Most of the time, the code will  look like this, whether it's C# or Java doesn't really matter:

    public class UserBuilder
    {
        private UserType_V1_0 type = UserType_V1_0.Administrator;
        private string code = "code";

        public User_V1_0 Build()
        {
            User_V1_0 user = new User_V1_0(code, "name", type, "id", "campusId", true);
            return user;
        }

        public UserBuilder WithCode(string code)
        {
            this.code = code;
            return this;
        }

        public UserBuilder WithType(UserType_V1_0 type)
        {
            this.type = type;
            return this;
        }
    }

Used this way:

      var user = new UserBuilder()
        .withCode("AB")
        .Build();

Okay, what's happening here?

  - Builder objects have `withX()` methods, returning `this` to be able to chain, to fill up every required variable
  - default values are provided, so we're not obliged to call every method if we're only interested in one field. 
  - At the end of the chain, we call `Build()`, which returns our object. 

### Enhanced builders

I've never given it much thought, but yes, there are some problems with this implementation (as with everything). The most important one being, can you reuse your instantiated builder? No? Yes? We never assign it, but we **could** if we really wanted to. Since we're **mutating the builder**, you are definatly getting into trouble. 
  
Using a lambda to pass in the work on our builder might solve this:

    public class UserBuilder
    {
        private UserType_V1_0 type = UserType_V1_0.Administrator;
        private string code = "code";

        private UserBuilder()
        {
        }

        private User_V1_0 Build()
        {
            return new User_V1_0(code, "name", type, "id", "campusId", true);
        }

        public static User_V1_0 Build(Func<UserBuilder, UserBuilder> block)
        {
            var builder = new UserBuilder();
            block(builder);
            return builder.Build();
        }

        public UserBuilder WithCode(string code)
        {
            this.code = code;
            return this;
        }

        public UserBuilder WithType(UserType_V1_0 type)
        {
            this.type = type;
            return this;
        }
    }

Used this way:

      var user = UserBuilder.Build(_ =>
        _.WithCode("AB")
    		   .withType(UserType_V1_0.NursingStaff));

Notice that using the character `_` is a convention if there's only one parameter for the lambda, it could also be called "builder" but we still need to use this, as `block(builder)` passes in the temp created builder. What did we solve? 

  - The actual builder instance is bound within the `Build()` scope. You'll never be able to assign it when using the static method. 
  - One might say, we reduced some redundancy in the implementation by eliminating the need to call the final `Build()` method, but it's simply being moved. 

### Supercharged builders

In Groovy (the devoxx example), we can cleverly use the `.delegate` mechanism to eliminate the need to chain at all. Groovy also reduces the syntax noise a bit (brackets, semicolons). We could create a `Build` method like this:

      public static User_V1_0 Build(block) {
        new UserBuilder().with block;
        // does the same as cloning the block, assigning it with .delegate and executing it. 
      }

Used this way:

      UserBuilder.Build {
    	 Code "AB" // Same as Code("AB");
    	 Type UserType_V1_0.NursingStaff
      }
  
How does this work?

  - The `Code()` method does not exist in our block closure, but we assign a delegate to it: our temp lexically scoped `UserBuilder` instance - that's where the method lives. When the code is executed, Groovy first looks for a method within the block, and then tries to fetch it via the delegate. 

For more information on groovy delegates, see the [Groovy documentation: Delegation Pattern](http://groovy.codehaus.org/Delegation+Pattern). This works thanks to the late binding of the language and won't statically typed languages such as C#. You might be able to come close using `LINQ` expression trees, but that requires a lot of effort to write a simple DSL.

### Leveraging this principle to DSLs

In Javascript, you can also manage to do something like that using `.prototype` and [prototypal inheritance](http://brainbaking.com/wiki/code/javascript/inheritance) and `apply()` to dynamically bind the `this` context (see [Function.prototype.apply MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply)).

Of course, builders are completely redundant in JS. Just create a `JSON` object using `{ key: value }`. Done. But this principle might be interesting for things like creating a "mailer" - as in the devoxx 2013 example:

    var mailerPrototype = {
        from: function() { console.log("from"); },
        to: function() { console.log("to"); },
        sub: function() { console.log("sub"); },
        body: function() { console.log("body"); },
        send: function() { console.log("sending..."); }
    };

    var mailer = function() {};
    mailer.mail = function(block) {
        // .prototype magic happens inside Object.create()
        block.apply(Object.create(mailerPrototype));
    }

    // this still sucks, I don't want to use 'this.', can use chaining... 
    mailer.mail(function() {
        this.from("me@gmail.com");
        this.to("you@gmail.com");
        this.sub("this is my subject");
        this.body("hello");
        this.send();
    });

You'll still need `this.`, sadly. This is not needed in Groovy:

    mailer.mail {
        from "me@gmail.com"
        to "you@gmail.com"
        sub "this is my subject"
        body "hello"
        send()
    }

Now **that** looks readable. To be able to create something like that, a language has to:

  - have functions as first-class citizens.
  - have a clean syntax, to be able to reduce a lot of noise (CoffeeScript can get this done for JS for instance)
  - have late binding or duck typing

That said, going back to Java 7 is going to be a major pain in the ass. No, I do not want to create usesless interfaces! (Tip: use `Function` and `Predicate` from [Google Guava](https://code.google.com/p/guava-libraries/)).
