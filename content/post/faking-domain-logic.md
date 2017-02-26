---
title: Faking domain logic
bigimg: /img/Faking domain logic.jpg
date: '2014-09-23'
subtitle: Using C# extensions to create the illusion of domain logic
tags: ['domain driven design', 'C#', 'code smells' ]
---

Sometimes, life is just a little bit more difficult than you imagined the day before. Sometimes, you have to work on a legacy codebase with custom frameworks rooted so deeply you're having lot's of trouble trying to build around them. To make it a bit more concrete, here's an example: imagine a separate DLL for interfaces and a separate DLL for the implementation. This decision was made because we use NHibernate as a data mapper and not to write beautiful domain driven design code. As a result, writing domain logic methods on our "domain" objects is impossible because we have three implementations. 

There are a few solutions. The first would be the classic solution, called a "service layer" where you simply dump random "domain" logic. Done.

Then there's a slightly better solution involving abstract classes. But it makes things more complicated, and it's not always allowed to inherit from those classes. Besides, in which DLL should you put them? Dependency Entanglement. Welcome to hotel Cali--- erm, DLL Hell. 

So, option number three: use extensions on those interfaces.

        public interface IVacancy
        {
            public string Description { get; set; }
        }

would have these implementations:

        public class FulltimeVacancy : IVacancy
        {
            public string Description { get { // ... }; set { field = value; }}
        }
        public class HalftimeVacancy : IVacancy
        {
            public string Description { get { // ... }; set { field = value; }}
        }

If I'd want to implement something like `RetrieveLocation()` based on for example google maps and other properties, I can place the entry point in an extension class:

        public static class IVacancyExtensions
        {
            public static string RetrieveLocation(this IVacancy vacancy)
            {
                // do your thing
            }
        }

Using the right namespace imports, I'm able to call the above method on any concrete implementation of `IVacancy`, regardless of it's (DLL) location. Now, why would I want to keep code like this as close to the original object as possible? this has multiple reasons:

  - It makes code easier to read & refactor.
  - It reduces the chance of duplication in another service layer, as people often hit "CTRL+SPACE" to find a method from an object or a piece of logic, and don't go looking in service classes.
  - It makes code easier to discuss (since it's also easier to read). 
  - It's isolated and thus easier to test.
  - It avoids a lot of [other code smells](http://martinfowler.com/bliki/CodeSmell.html) (deserves it's own article).
